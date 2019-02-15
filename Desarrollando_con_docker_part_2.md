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


## Redes

Para comprobar la utilización de redes, vamos a crear una red y conectaremos tres contenedores distintos. Con ello veremos el funcionamiento.

El siguiente comando nos permitirá crear una red del tipo *bridge* que servirá para hacer conjuntos de contenedores que pertenezcan a la misma *subred*. Estos contenedores tendrán asociado automáticamente un servicio **DNS**, con lo cual resultará mucho más sencillo la comunicación entre servicios o contenedores.

Creamos la red de la siguiente forma:

```{bash}
docker network create probando
````

Ahora creamos tres contenedores distintos que contenien **alpine**. A la vez vamos a especificar un parámetro nuevo, `--net`. Este parámetro nos permite conectar el contenedor que vamos a lanzar con una red específica.

```{bash}
docker run --name prueba1 -dit --net probando alpine sh
````
```{bash}
docker run --name prueba2 -dit --net probando alpine sh
````
```{bash}
docker run --name prueba3 -dit alpine sh
````

La versión *Docker Compose* sería:

```{yaml}
version: '3'
services:
  servicio_1:
    image: alpine
    container_name: prueba1
    networks: 
      - prueba
    tty: true
  servicio_2:
    image: alpine
    container_name: prueba2
    networks:
      -  prueba
    tty: true
  servicio_3:
    image: alpine
    container_name: prueba3
    tty: true
networks:
  prueba:
    external: true
```

Podemos ver la gestión que ha realizado docker mediante el siguiente comando:

```{bash}
docker network inspect prueba
```

# Foto de las distintas redes
![]()

Una vez tenemos ya configurado nuestro entorno podemos pasar a comprobar la teoría.
Repasamos las ideas generales:

* Los contenedores deben de estar en la misma subred menos uno.
* Los contenedores que están en la misma subred, deben de poder *verse* los unos con los otros.
* Podemos realizar `ping` de un contenedor a otro, pero no podemos realizar `ping` desde nuestra máquina *host* a alguno de los contenedores, ni desde el contenedor *aislado* a los contenedores de la subred que hemos creado.

### Accediendo a los contenedores

Para acceder a alguno de los contenedores creados necesitamos hacer uso del *cliente de docker*. Si tuvieramos configurado alguno de los contenedores servidor **SSH**, también podríamos acceder mediante esta herramienta.

```{bash}
docker exec -it prueba1 sh
```

Una vez entramos hacemos `ping`:

```{bash}
ping prueba2
```
# Foto con resultados
![]()