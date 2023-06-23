# Quarkus + Cryostat

This demo uses the Quarkus Hibernate ORM Quickstart as a sample workload application, deploys it with Docker Compose
using Podman as the engine in both JVM mode and native image mode, and also deploys Cryostat alongside the sample
application. This is intended to act as a showcase both for how to set up Cryostat using Docker Compose, and more
importantly how Cryostat can be used to connect to JVM and native Quarkus applications for monitoring and profiling.

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

