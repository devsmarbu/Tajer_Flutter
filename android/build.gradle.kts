// Top-level build.gradle.kts (project level)

plugins {
    // ✅ Required for Firebase / Google Sign-In
    id("com.google.gms.google-services") version "4.4.2" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven("https://jitpack.io")
    }
}

// ✅ (Keep Flutter’s default build directory structure)
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// ✅ Add a clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
