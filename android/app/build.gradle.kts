plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "app.creditcardmanager"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "app.creditcardmanager"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // flutter_appauth still contributes an Android redirect receiver even
        // though Gmail on Android now uses Google Play services authorization.
        // Keep a valid placeholder so the merged manifest builds. Override it
        // with GMAIL_REDIRECT_SCHEME or -PappAuthRedirectScheme if needed.
        val configuredAppAuthRedirectScheme =
            System.getenv("GMAIL_REDIRECT_SCHEME")
                ?: (project.findProperty("appAuthRedirectScheme") as String?)
        manifestPlaceholders["appAuthRedirectScheme"] =
            configuredAppAuthRedirectScheme ?: "app.creditcardmanager"
    }

    signingConfigs {
        create("sideload") {
            // Stable sideload key introduced in 0.3.1. Keeping this key in the
            // repository (instead of relying on ~/.android/debug.keystore)
            // makes every future APK upgrade in place. This is a public debug
            // key for sideloading only; use a private Play signing key before
            // publishing to a store.
            storeFile = file("onyx-sideload.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }

    buildTypes {
        // Keep debug, profile and release builds on the same certificate so a
        // locally-run build can also be updated by a downloaded APK.
        debug {
            signingConfig = signingConfigs.getByName("sideload")
        }
        release {
            signingConfig = signingConfigs.getByName("sideload")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Android Gmail authorization uses Google Play services AuthorizationClient.
    // Google no longer accepts custom URI redirect schemes on Android.
    implementation("com.google.android.gms:play-services-auth:21.2.0")
}
