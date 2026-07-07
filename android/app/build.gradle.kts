plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Firebase plugin
}

// gardle
android {
    namespace = "com.tajershops.tajer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

        // REQUIRED for flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.tajershops.tajer"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = 184
        versionName = "7.8.6"
    }

    signingConfigs {
        create("release") {
            keyAlias = "leza solutions"
            keyPassword = "Inov@2020"
            storeFile = file("../tajer.jks")
            storePassword = "Inov@2020"
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BOM handles versioning
    implementation(platform("com.google.firebase:firebase-bom:33.5.1"))
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-messaging")
    implementation("com.google.android.gms:play-services-auth:21.2.0")

    // REQUIRED FIX for flutter_local_notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")

    implementation("com.github.tiktok:tiktok-business-android-sdk:1.4.0")

    implementation("com.android.installreferrer:installreferrer:2.2")
    // Google Play Billing required for IAP tracking
//    implementation "com.android.billingclient:billing:6.0.1"
// or if 1.4.0 still fails, try:
 //   implementation("com.github.tiktok:tiktok-business-android-sdk:1.3.3")

}

