plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // <--- ADD THIS LINE

}
configurations.all {
    exclude(group = "com.google.firebase", module = "firebase-iid")
}
android {
    namespace = "com.dating.weekendtest"
    // Using 35 as it is the current standard for modern plugins
    compileSdk = 36 
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // --- ADDED FOR NOTIFICATIONS ---
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.dating.weekendtest"
        
        // flutter_local_notifications requires at least 21
        minSdk = flutter.minSdkVersion 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Recommended for desugaring support
        multiDexEnabled = true 
    }

 buildTypes {
        release {
            // Keep your existing signing config
            signingConfig = signingConfigs.getByName("debug")

            // ADD THESE LINES:
            isMinifyEnabled = true
            isShrinkResources = true
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
    // --- ADDED THIS LINE AT THE BOTTOM ---
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
