package app.creditcardmanager

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private var smsChannel: SmsChannel? = null
    private var googleAuthChannel: GoogleAuthChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        SecurityChannel(applicationContext)
            .register(flutterEngine.dartExecutor.binaryMessenger)
        smsChannel = SmsChannel(this).also {
            it.register(flutterEngine.dartExecutor.binaryMessenger)
        }
        googleAuthChannel = GoogleAuthChannel(this).also {
            it.register(flutterEngine.dartExecutor.binaryMessenger)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        smsChannel?.onRequestPermissionsResult(requestCode, grantResults)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        googleAuthChannel?.onActivityResult(requestCode, resultCode, data)
    }
}
