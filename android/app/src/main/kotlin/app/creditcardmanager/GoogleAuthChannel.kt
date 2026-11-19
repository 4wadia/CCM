package app.creditcardmanager

import android.app.Activity
import android.content.Intent
import com.google.android.gms.auth.api.identity.AuthorizationRequest
import com.google.android.gms.auth.api.identity.AuthorizationResult
import com.google.android.gms.auth.api.identity.Identity
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.Scope
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Google authorization through Google Play services.
 *
 * The Android OAuth client is identified by the package name and signing
 * certificate registered in Google Cloud. No client secret or refresh token is
 * embedded in the app. The returned access token is short-lived and is stored
 * only in secure storage by the Dart layer.
 */
class GoogleAuthChannel(private val activity: Activity) : MethodChannel.MethodCallHandler {
    companion object {
        private const val CHANNEL = "app.creditcardmanager/googleauth"
        private const val REQUEST_CODE = 4101
        private const val GMAIL_READONLY =
            "https://www.googleapis.com/auth/gmail.readonly"
    }

    private var pendingResult: MethodChannel.Result? = null

    private val client by lazy {
        Identity.getAuthorizationClient(activity)
    }

    fun register(binaryMessenger: BinaryMessenger) {
        MethodChannel(binaryMessenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "authorize" -> authorize(result)
            else -> result.notImplemented()
        }
    }

    private fun authorize(result: MethodChannel.Result) {
        if (pendingResult != null) {
            result.error("in_progress", "Google authorization is already in progress.", null)
            return
        }
        pendingResult = result

        val request = AuthorizationRequest.builder()
            .setRequestedScopes(
                listOf(
                    Scope("openid"),
                    Scope("email"),
                    Scope("profile"),
                    Scope(GMAIL_READONLY),
                ),
            )
            .build()

        try {
            client.authorize(request)
                .addOnSuccessListener { authorizationResult ->
                    if (authorizationResult.hasResolution()) {
                        val pendingIntent = authorizationResult.pendingIntent
                        if (pendingIntent == null) {
                            finishError("no_resolution", "Google authorization could not start.")
                            return@addOnSuccessListener
                        }
                        try {
                            activity.startIntentSenderForResult(
                                pendingIntent.intentSender,
                                REQUEST_CODE,
                                null,
                                0,
                                0,
                                0,
                            )
                        } catch (error: Exception) {
                            finishError(
                                "launch_failed",
                                "Google authorization could not start.",
                                error,
                            )
                        }
                    } else {
                        finishSuccess(authorizationResult)
                    }
                }
                .addOnFailureListener { error ->
                    finishError("authorize_failed", describeError(error), error)
                }
        } catch (error: Exception) {
            finishError("authorize_failed", describeError(error), error)
        }
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != REQUEST_CODE) return false
        if (resultCode != Activity.RESULT_OK || data == null) {
            finishError("cancelled", "Google authorization was cancelled.")
            return true
        }
        try {
            finishSuccess(client.getAuthorizationResultFromIntent(data))
        } catch (error: Exception) {
            finishError("cancelled", "Google authorization was cancelled.", error)
        }
        return true
    }

    private fun finishSuccess(authorizationResult: AuthorizationResult) {
        val grantedScopes = authorizationResult.grantedScopes
        if (!grantedScopes.contains(GMAIL_READONLY)) {
            finishError(
                "scope_denied",
                "Gmail read access was not granted. Enable the Gmail API and " +
                    "approve the Gmail read-only scope during Google sign-in.",
            )
            return
        }
        val token = authorizationResult.accessToken
        if (token.isNullOrBlank()) {
            finishError("no_token", "Google did not return an access token.")
            return
        }
        pendingResult?.success(mapOf("accessToken" to token))
        pendingResult = null
    }

    private fun finishError(code: String, message: String, cause: Throwable? = null) {
        pendingResult?.error(code, message, cause?.message)
        pendingResult = null
    }

    /**
     * Converts Play services status codes into actionable, user-safe messages.
     * The most common failure is DEVELOPER_ERROR (10), which means the Android
     * OAuth client for this package and signing certificate is missing or the
     * Gmail API is not enabled.
     */
    private fun describeError(error: Throwable): String {
        return when ((error as? ApiException)?.statusCode) {
            10 -> "Google sign-in is not configured for this build " +
                "(DEVELOPER_ERROR). Create an Android OAuth client for " +
                "app.creditcardmanager with this APK's SHA-1 and enable the " +
                "Gmail API. Open Profile → Google sign-in setup help."
            12500 -> "Google Play services could not sign you in. Update " +
                "Google Play services and try again."
            12501 -> "Google sign-in was cancelled."
            12502 -> "Google sign-in is already in progress."
            else -> error.message?.takeIf { it.isNotBlank() }
                ?: "Google authorization failed. Open Profile → Google " +
                "sign-in setup help to check the OAuth configuration."
        }
    }
}
