/*
 * This Kotlin source file was generated by the Gradle "init" task.
 */
package xhtml.validate

import org.dom4j.io.XMLWriter
import org.dom4j.io.SAXReader
import org.dom4j.io.OutputFormat
import java.io.FileWriter

fun main() {
  val reader = SAXReader()
  val document = reader.read("chemistry.formatted.html")
  val root = document.getRootElement()

  val selfClosingTags = arrayOf("area",
                                "base",
                                "br",
                                "col",
                                "command",
                                "embed",
                                "hr",
                                "img",
                                "input",
                                "keygen",
                                "link",
                                "meta",
                                "param",
                                "source",
                                "track",
                                "wbr")
  selfClosingTags.forEach { tag ->
    val search = "//*[local-name()='${tag}' and namespace-uri()='http://www.w3.org/1999/xhtml']"
    val nodes = document.selectNodes(search)
    nodes.forEach { node ->
      node.detach()
    }
  }

  val fileWriter = FileWriter("chemistry.formatted.patched.html")
  val format = OutputFormat()
  format.setExpandEmptyElements(true)
  val writer = XMLWriter(fileWriter, format)
  writer.write(root)
  writer.close()
}

