# Desarrollando con Docker, Parte 2

En esta segunda parte nos centraremos en la práctica de los conceptos teóricos introducidos en la primera parte. Para ello crearemos de cero un entorno de desarrollo que comúnmente se denomina *LAMP*. Es decir, vamos a configurar un servidor, que será un Apache, una base de datos y utilizaremos el lenguaje de programación PHP.

Antes de comenzar con la configuración del entorno *LAMP* veamos las distintas opciones que nos proporcionan los **volúmenes** y las **redes**.

## Características de los volúmenes

Como ya sabemos, los volúmenes nos permiten la persistencia de datos. A su vez, sabemos que existen dos tipos de volúmenes, los de *host* y los de *datos*.

### Parámetros en Docker Compose

#### Sintaxis corta

Optionally specify a path on the host machine (`HOST:CONTAINER`), or an access mode (`HOST:CONTAINER:ro`).

You can mount a relative path on the host, that expands relative to the directory of the Compose configuration file being used. Relative paths should always begin with `.` or `...`

```{yml}
volumes:
  # Just specify a path and let the Engine create a volume
  - /var/lib/mysql

  # Specify an absolute path mapping
  - /opt/data:/var/lib/mysql

  # Path on the host, relative to the Compose file
  - ./cache:/tmp/cache

  # User-relative path
  - ~/configs:/etc/configs/:ro

  # Named volume
  - datavolume:/var/lib/mysql
```

#### Sintaxis larga

The long form syntax allows the configuration of additional fields that can’t be expressed in the short form.

* `type`: the mount type `volume`, `bind` or `tmpfs`
* `source`: the source of the mount, a path on the host for a bind mount, or the name of a volume defined in the top-level volumes key. Not applicable for a tmpfs mount.
* `target`: the path in the container where the volume is mounted
* `read_only`: flag to set the volume as read-only
* `bind`: configure additional bind options
    * `propagation`: the propagation mode used for the bind
* `volume`: configure additional volume options
    * `nocopy`: flag to disable copying of data from a container when a volume is created
* `tmpfs`: configure additional tmpfs options
    * `size`: the size for the tmpfs mount in bytes
* `consistency`: the consistency requirements of the mount, one of consistent (host and container have identical view), cached (read cache, host view is authoritative) or delegated (read-write cache, container’s view is authoritative)
