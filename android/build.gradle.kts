allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Solusi otomatis untuk Namespace & Manifest Library (Isar, dll)
    plugins.withType<com.android.build.gradle.api.AndroidBasePlugin> {
        configure<com.android.build.gradle.BaseExtension> {
            if (namespace == null) {
                namespace = "com.example.${project.name.replace("-", ".")}"
            }
        }
        
        // Menghapus atribut package yang dilarang di Android Studio/Gradle baru
        val removePackageAttr = tasks.register("removePackageAttr") {
            val manifestFile = file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                val content = manifestFile.readText()
                if (content.contains("package=")) {
                    val updated = content.replace(Regex("""package="[^"]*""""), "")
                    manifestFile.writeText(updated)
                }
            }
        }
        tasks.named("preBuild") { dependsOn(removePackageAttr) }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}