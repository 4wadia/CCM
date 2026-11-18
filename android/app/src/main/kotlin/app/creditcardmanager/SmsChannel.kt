package app.creditcardmanager

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Permission-gated read-only access to the Android SMS inbox.
 *
 * Message bodies are returned to Dart only for local parsing. This class must
 * never log message content, sender addresses, or transaction details.
 */
class SmsChannel(private val activity: Activity) : MethodChannel.MethodCallHandler {
    private var pendingPermissionResult: MethodChannel.Result? = null
    private var pendingNotificationResult: MethodChannel.Result? = null

    fun register(binaryMessenger: io.flutter.plugin.common.BinaryMessenger) {
        MethodChannel(binaryMessenger, CHANNEL).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isSupported" -> result.success(true)
            "hasPermission" -> result.success(hasPermission())
            "requestPermission" -> requestPermission(result)
            "hasNotificationPermission" -> result.success(hasNotificationPermission())
            "requestNotificationPermission" -> requestNotificationPermission(result)
            "readMessages" -> readMessages(call, result)
            else -> result.notImplemented()
        }
    }

    fun onRequestPermissionsResult(
        requestCode: Int,
        grantResults: IntArray,
    ) {
        if (requestCode == REQUEST_CODE) {
            val granted = grantResults.isNotEmpty() &&
                grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingPermissionResult?.success(granted)
            pendingPermissionResult = null
        } else if (requestCode == REQUEST_CODE_NOTIFICATION) {
            val granted = grantResults.isNotEmpty() &&
                grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingNotificationResult?.success(granted)
            pendingNotificationResult = null
        }
    }

    private fun hasPermission(): Boolean =
        ContextCompat.checkSelfPermission(
            activity,
            Manifest.permission.READ_SMS,
        ) == PackageManager.PERMISSION_GRANTED

    private fun requestPermission(result: MethodChannel.Result) {
        if (hasPermission()) {
            result.success(true)
            return
        }
        if (pendingPermissionResult != null) {
            result.error("CCM-SMS-BUSY", "A permission request is already active.", null)
            return
        }
        pendingPermissionResult = result
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(Manifest.permission.READ_SMS),
            REQUEST_CODE,
        )
    }

    private fun hasNotificationPermission(): Boolean {
        return if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(
                activity,
                "android.permission.POST_NOTIFICATIONS",
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        if (hasNotificationPermission()) {
            result.success(true)
            return
        }
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.TIRAMISU) {
            if (pendingNotificationResult != null) {
                result.error("CCM-NOTIF-BUSY", "A notification permission request is active.", null)
                return
            }
            pendingNotificationResult = result
            ActivityCompat.requestPermissions(
                activity,
                arrayOf("android.permission.POST_NOTIFICATIONS"),
                REQUEST_CODE_NOTIFICATION,
            )
        } else {
            result.success(true)
        }
    }

    private fun readMessages(call: MethodCall, result: MethodChannel.Result) {
        if (!hasPermission()) {
            result.error("CCM-SMS-PERMISSION", "SMS permission is not granted.", null)
            return
        }
        val fromMillis = (call.argument<Number>("fromMillis") ?: 0).toLong()
        val toMillis = (call.argument<Number>("toMillis") ?: System.currentTimeMillis()).toLong()
        val limit = ((call.argument<Number>("limit") ?: 500).toInt()).coerceIn(1, 2_000)

        Thread {
            val rows = ArrayList<Map<String, Any?>>()
            try {
                val projection = arrayOf("_id", "address", "body", "date")
                val selection = "date >= ? AND date <= ?"
                val selectionArgs = arrayOf(fromMillis.toString(), toMillis.toString())
                activity.contentResolver.query(
                    Uri.parse("content://sms/inbox"),
                    projection,
                    selection,
                    selectionArgs,
                    "date DESC",
                )?.use { cursor ->
                    val idIndex = cursor.getColumnIndexOrThrow("_id")
                    val addressIndex = cursor.getColumnIndexOrThrow("address")
                    val bodyIndex = cursor.getColumnIndexOrThrow("body")
                    val dateIndex = cursor.getColumnIndexOrThrow("date")
                    while (cursor.moveToNext() && rows.size < limit) {
                        rows.add(
                            mapOf(
                                "id" to cursor.getLong(idIndex).toString(),
                                "sender" to (cursor.getString(addressIndex) ?: ""),
                                "body" to (cursor.getString(bodyIndex) ?: ""),
                                "receivedAtMillis" to cursor.getLong(dateIndex),
                            ),
                        )
                    }
                }
                rows.reverse()
                Handler(Looper.getMainLooper()).post { result.success(rows) }
            } catch (error: SecurityException) {
                Handler(Looper.getMainLooper()).post {
                    result.error("CCM-SMS-PERMISSION", "SMS permission is not granted.", null)
                }
            } catch (error: Exception) {
                Handler(Looper.getMainLooper()).post {
                    result.error("CCM-SMS-READ", "SMS messages could not be read.", null)
                }
            }
        }.start()
    }

    companion object {
        private const val CHANNEL = "app.creditcardmanager/sms"
        private const val REQUEST_CODE = 0x534D
        private const val REQUEST_CODE_NOTIFICATION = 0x534E
    }
}
