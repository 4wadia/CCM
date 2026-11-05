package app.creditcardmanager

import android.content.Context
import android.content.SharedPreferences
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.GeneralSecurityException
import java.security.KeyStore
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * Supplies the database key, wrapped by a non-exportable Android Keystore key.
 *
 * The raw key is generated on first launch and returned to Dart only to open the
 * database. The persisted form is AES-GCM ciphertext in app-private preferences.
 *
 * Failure policy: if wrapped material exists but cannot be unwrapped, this
 * channel fails. It never silently generates a replacement key, which would
 * point the app at a new, empty database and strand existing data.
 */
internal class SecurityChannel(context: Context) : MethodChannel.MethodCallHandler {
    companion object {
        private const val CHANNEL = "app.creditcardmanager/security"
        private const val KEY_ALIAS = "ccm_database_key_wrapping_key"
        private const val PREFS_NAME = "ccm_security"
        private const val PREF_WRAPPED_KEY = "wrapped_database_key"
        private const val KEY_SIZE_BYTES = 32
        private const val GCM_IV_BYTES = 12
        private const val GCM_TAG_BITS = 128
    }

    private val preferences: SharedPreferences =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    fun register(messenger: BinaryMessenger) {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "getOrCreateDatabaseKey" -> result.success(getOrCreateDatabaseKey())
                "deleteDatabaseKey" -> {
                    deleteDatabaseKey()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        } catch (_: Exception) {
            // Never include the exception message: it can reference internal
            // key-store state. Dart maps this code to a typed failure.
            result.error("KEYSTORE_ERROR", "Secure key operation failed", null)
        }
    }

    private fun getOrCreateDatabaseKey(): String {
        val wrapped = preferences.getString(PREF_WRAPPED_KEY, null)
        if (wrapped != null) {
            return unwrap(wrapped)
        }

        val raw = ByteArray(KEY_SIZE_BYTES)
        SecureRandom().nextBytes(raw)
        try {
            val encoded = wrap(raw)
            val committed = preferences.edit().putString(PREF_WRAPPED_KEY, encoded).commit()
            if (!committed) {
                throw GeneralSecurityException("Unable to persist wrapped key")
            }
            return Base64.encodeToString(raw, Base64.NO_WRAP)
        } finally {
            raw.fill(0)
        }
    }

    private fun wrap(raw: ByteArray): String {
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, getOrCreateWrappingKey())
        val ciphertext = cipher.doFinal(raw)
        return Base64.encodeToString(cipher.iv + ciphertext, Base64.NO_WRAP)
    }

    private fun unwrap(wrapped: String): String {
        val combined = Base64.decode(wrapped, Base64.NO_WRAP)
        if (combined.size <= GCM_IV_BYTES) {
            throw GeneralSecurityException("Wrapped key is truncated")
        }

        val iv = combined.copyOfRange(0, GCM_IV_BYTES)
        val ciphertext = combined.copyOfRange(GCM_IV_BYTES, combined.size)

        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(
            Cipher.DECRYPT_MODE,
            getOrCreateWrappingKey(),
            GCMParameterSpec(GCM_TAG_BITS, iv),
        )

        val raw = cipher.doFinal(ciphertext)
        try {
            if (raw.size != KEY_SIZE_BYTES) {
                throw GeneralSecurityException("Unwrapped key has an invalid length")
            }
            return Base64.encodeToString(raw, Base64.NO_WRAP)
        } finally {
            raw.fill(0)
        }
    }

    private fun getOrCreateWrappingKey(): SecretKey {
        val keyStore = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        val existing = keyStore.getEntry(KEY_ALIAS, null) as? KeyStore.SecretKeyEntry
        if (existing != null) {
            return existing.secretKey
        }

        val generator = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES,
            "AndroidKeyStore",
        )
        generator.init(
            KeyGenParameterSpec.Builder(
                KEY_ALIAS,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
            )
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .setUserAuthenticationRequired(false)
                .build(),
        )
        return generator.generateKey()
    }

    private fun deleteDatabaseKey() {
        preferences.edit().remove(PREF_WRAPPED_KEY).commit()
        val keyStore = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        keyStore.deleteEntry(KEY_ALIAS)
    }
}
