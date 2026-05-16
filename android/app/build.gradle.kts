plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("com.google.firebase.firebase-perf")
    id("com.google.firebase.crashlytics")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.anotnix_flutter_boilerplate"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
    
    defaultConfig {
        applicationId = "com.example.anotnix_flutter_boilerplate"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // KOTLIN SYNTAX - use = instead of space
        multiDexEnabled = true
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            // KOTLIN SYNTAX - use = instead of space
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

// ADD THIS SECTION
dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
}