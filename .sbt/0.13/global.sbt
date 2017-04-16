import org.ensime.EnsimeKeys._
import org.ensime.EnsimeCoursierKeys._

resolvers += Resolver.sonatypeRepo("snapshots")
resolvers += "Artima Maven Repository" at "http://repo.artima.com/releases"
ensimeJavaFlags in ThisBuild := Seq("-Xss64m", "-Xmx1024m", "-XX:MaxMetaspaceSize=512m")
ensimeServerVersion in ThisBuild := "2.0.0-SNAPSHOT"
