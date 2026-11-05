package app.creditcardmanager

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        SecurityChannel(applicationContext)
            .register(flutterEngine.dartExecutor.binaryMessenger)
    }
}
