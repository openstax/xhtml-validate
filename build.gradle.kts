import org.gradle.jvm.tasks.Jar

plugins {
  kotlin("jvm") version "1.3.61"
  application
}

repositories {
  mavenCentral()
}

dependencies {
  implementation(kotlin("stdlib-jdk8"))
  implementation("org.dom4j:dom4j:2.1.1")
  implementation("jaxen:jaxen:1.2.0")
}

application {
  mainClassName = "xhtml.validate.AppKt"
}

task("fullJar", type = Jar::class) {
  archiveBaseName.set("${project.name}")
  manifest {
    attributes["Main-Class"] = "xhtml.validate.AppKt"
  }
  from(configurations.runtimeClasspath.get().map({ if (it.isDirectory) it else zipTree(it) }))
  with(tasks.jar.get() as CopySpec)
}
