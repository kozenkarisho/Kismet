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
}
subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            try {
                val androidExt = project.extensions.getByName("android")
                val getNamespace = androidExt.javaClass.getMethod("getNamespace")
                val namespace = getNamespace.invoke(androidExt)
                
                if (namespace == null) {
                    val setNamespace = androidExt.javaClass.getMethod("setNamespace", String::class.java)
                    if (project.name == "isar_flutter_libs") {
                        setNamespace.invoke(androidExt, "io.isar.isar_flutter_libs")
                    } else {
                        setNamespace.invoke(androidExt, project.group.toString())
                    }
                }
            } catch (e: Exception) {
                println("Could not set namespace for ${project.name}")
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            try {
                val androidExt = project.extensions.getByName("android")
                val compileOptions = androidExt.javaClass.getMethod("getCompileOptions").invoke(androidExt)
                val setSourceCompatibility = compileOptions.javaClass.getMethod("setSourceCompatibility", JavaVersion::class.java)
                val setTargetCompatibility = compileOptions.javaClass.getMethod("setTargetCompatibility", JavaVersion::class.java)
                setSourceCompatibility.invoke(compileOptions, JavaVersion.VERSION_17)
                setTargetCompatibility.invoke(compileOptions, JavaVersion.VERSION_17)
            } catch (e: Exception) {
                // Ignore
            }
        }
        
        tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile::class).configureEach {
            compilerOptions {
                jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
            }
        }
    }
}
