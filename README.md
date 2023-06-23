# Quarkus demo: Hibernate ORM and RESTEasy

This is a minimal CRUD service exposing a couple of endpoints over REST,
with a front-end based on Angular so you can play with it from your browser.

While the code is surprisingly simple, under the hood this is using:
 - RESTEasy to expose the REST endpoints
 - Hibernate ORM to perform the CRUD operations on the database
 - A PostgreSQL database; see below to run one via Docker
 - ArC, the CDI inspired dependency injection tool with zero overhead
 - The high performance Agroal connection pool
 - Infinispan based caching
 - All safely coordinated by the Narayana Transaction Manager

## Requirements

To compile and run this demo you will need:

- JDK 11+
- GraalVM

In addition, you will need either a PostgreSQL database, or Docker to run one.

### Configuring GraalVM and JDK 11+

Make sure that both the `GRAALVM_HOME` and `JAVA_HOME` environment variables have
been set, and that a JDK 11+ `java` command is on the path.

[Mandrel 23+](https://github.com/graalvm/mandrel/releases) is recommended as the GraalVM implementation for this demo.

See the [Building a Native Executable guide](https://quarkus.io/guides/building-native-image)
for help setting up your environment.

## Building the demo

Launch the Maven build on the checked out sources of this demo:

> ./mvnw package

## Running the demo

### Live coding with Quarkus

The Maven Quarkus plugin provides a development mode that supports
live coding. To try this out:

> ./mvnw quarkus:dev

In this mode you can make changes to the code and have the changes immediately applied, by just refreshing your browser.

Hot reload works even when modifying your JPA entities.
Try it! Even the database schema will be updated on the fly.

### Run Quarkus in JVM mode

When you're done iterating in developer mode, you can run the application as a
conventional jar file.

First compile it:

> ./mvnw package

Next we need to make sure you have a PostgreSQL instance running (Quarkus automatically starts one for dev and test mode). To set up a PostgreSQL database with Docker:

> docker run --rm=true --name quarkus_test -e POSTGRES_USER=quarkus_test -e POSTGRES_PASSWORD=quarkus_test -e POSTGRES_DB=quarkus_test -p 5432:5432 postgres:13.3

Connection properties for the Agroal datasource are defined in the standard Quarkus configuration file,
`src/main/resources/application.properties`.

Then run it:

> java -jar ./target/quarkus-app/quarkus-run.jar

Have a look at how fast it boots.
Or measure total native memory consumption...

### Run Quarkus as a native application

You can also create a native executable from this application without making any
source code changes. A native executable removes the dependency on the JVM:
everything needed to run the application on the target platform is included in
the executable, allowing the application to run with minimal resource overhead.

Compiling a native executable takes a bit longer, as GraalVM performs additional
steps to remove unnecessary codepaths. Use the  `native` profile to compile a
native executable:

> ./mvnw package -Dnative

After getting a cup of coffee, you'll be able to run this binary directly:

> ./target/hibernate-orm-quickstart-1.0.0-SNAPSHOT-runner

Please brace yourself: don't choke on that fresh cup of coffee you just got.
    
Now observe the time it took to boot, and remember: that time was mostly spent to generate the tables in your database and import the initial data.
    
Next, maybe you're ready to measure how much memory this service is consuming.

N.B. This implies all dependencies have been compiled to native;
that's a whole lot of stuff: from the bytecode enhancements that Hibernate ORM
applies to your entities, to the lower level essential components such as the PostgreSQL JDBC driver, the Undertow webserver.

## See the demo in your browser

Navigate to:

<http://localhost:8080/index.html>

Have fun, and join the team of contributors!

## Running the demo in Compose

Ensure that the container images are prepared:
```bash
$ sh build-images.sh
```

Then run the demo:
```bash
$ bash demo.bash
```

This demo setup assumes the following:
- `podman` `v.4.5.0+` is on `$PATH`
- `docker-compose` `v1.29.2+` is on `$PATH`
- rootless `podman` is configured and there is a `"${XDG_RUNTIME_DIR}/podman/podman.sock"`
- `DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/podman/podman.sock` is set in the environment, so `docker-compose` talks to `podman` as the container engine

Open `http://localhost:8080` and `http://localhost:8081` in your browser to visit the JVM and native-mode instances, respectively.
Open `http://localhost:8181` to visit Cryostat.

For `View in Grafana` features to work, you will either need [userhosts](https://github.com/figiel/hosts) or to
otherwise configure the `compose-grafana.yml` and `compose-cryostat.yml` somehow so that the Grafana dashboard
container has a hostname or domain name that can be resolved both by the Cryostat container and by your host machine.
