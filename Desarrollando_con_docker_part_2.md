# Desarrollando con Docker, Parte 2

En esta segunda parte nos centraremos en la práctica de los conceptos teóricos introducidos en la primera parte. Para ello crearemos de cero un entorno de desarrollo que comúnmente se denomina *LAMP*. Es decir, vamos a configurar un servidor, que será un Apache, una base de datos y utilizaremos el lenguaje de programación PHP.

Antes de comenzar con la configuración del entorno *LAMP* veamos las distintas opciones que nos proporcionan los **volúmenes** y las **redes**.

## Características de los volúmenes

Como ya sabemos, los volúmenes nos permiten la persistencia de datos. A su vez, sabemos que existen dos tipos de volúmenes, los de *host* y los de *datos*.

### Parámetros en Docker Compose

#### Sintaxis corta

Opcionalmente podemos especificar en el *PATH* el método de acceso a los datos. Así tenemos que por defecto escribimos (`HOST:CONTAINER`), si queremos especificar el método de acceso añadimos al final lo siguiente: (`HOST:CONTAINER:ro`). 

```{yml}
volumes:
  # Especificamos un path y dejamos que Docker cree un volumen
  - /var/lib/mysql

  # También podemos especifiar una ruta completa, tanto del host como del contenedor
  - /opt/data:/var/lib/mysql

  # Ruta relativa al fichero que contiene el .yml, y absoluta dentro del contenedor
  - ./cache:/tmp/cache

  # User-relative path
  - ~/configs:/etc/configs/:ro

  # Nombre del volumen de datos ya existente
  - datavolume:/var/lib/mysql
```

#### Sintaxis larga

La sintaxis larga consiste en añadir parámetros que nos permita un mayor control sobre los volúmenes que vamos a crear. A continuación dejo una lista de casi todos los parámetros que podemos añadir.

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

Para entender la utilización de redes, vamos a crear una red y conectaremos dos contenedores distintos dejando un tercero sin conexión. Con ello veremos claramente el funcionamiento.

El siguiente comando nos permitirá crear una red del tipo *bridge* que servirá para hacer conjuntos de contenedores que pertenezcan a la misma *subred*. Estos contenedores tendrán asociado automáticamente un servicio **DNS**, con lo cual resultará mucho más sencillo la comunicación entre servicios o contenedores.

Creamos la red de la siguiente forma:

```{bash}
docker network create probando
````

Ahora creamos tres contenedores distintos que con **alpine**. A la vez vamos a especificar un parámetro nuevo, `--net`. Este parámetro nos permite conectar el contenedor que vamos a lanzar con una red específica.

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

Output:
```
"Containers": {
            "32ab091ffad77a1a38f066cf9d2d296d0fec9494a809b52d8c6e9ac7e719c722": {
                "Name": "prueba1",
                "EndpointID": "e8144c1780eb224f455d9d70d441736edf2cee0d49ab7b3e64fb10b235e8e264",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            },
            "836e197d05df1ce553c1f6c7d3cd6eb12815831f20c9518514ee8169d0db68d7": {
                "Name": "prueba2",
                "EndpointID": "51ca050e689fcee216525afa05c0912687bf803dd12585783703f41b6a3bdd88",
                "MacAddress": "02:42:ac:12:00:03",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            }
        }
```

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

Output:
```
PING prueba2 (172.18.0.3): 56 data bytes
64 bytes from 172.18.0.3: seq=0 ttl=64 time=0.089 ms
64 bytes from 172.18.0.3: seq=1 ttl=64 time=0.102 ms
64 bytes from 172.18.0.3: seq=2 ttl=64 time=0.102 ms
```

Sin embargo, si realizamos `ping` al tercer contenedor que no estaba en la misma red, obtenemos lo siguiente:

Output:
```
/ # ping prueba2
ping: bad address 'prueba2'
/ # ping prueba1
ping: bad address 'prueba1'
```

Hemos comprabado que efectivamente los contenedores están aislados a menos que indiquemos lo contrario.

Pero estos parámetros sirven para la comunicación entre contenedores, si queremos que exista comunicación entre algún contenedor y la máquina *Host* de la misma manera o con el mismo método, deberemos de usar la red ya existente del tipo **host**. Si no existe, podemos crearla, pero solo nos dejará tener una sola red de este tipo.

Para crearla hacemos lo siguiente
```{bash}
docker network create mynet -d host
```

Si ya la tenemos creada, que es lo normal, simplemente tenemos que especificar dicha red al lanzar el contenedor, o como es nuestro caso en el cual ya tenemos 3 contenedores funcionando, podemos conectar el tercer contenedor a dicha red **host** ejecutando lo siguiente:
