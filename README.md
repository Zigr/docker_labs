# Docker image of PostgreSQL with vector database extension **pgvector** on Alpine Linux. 

## Goals:

- To build a Docker image which makes a small image-size footprint.
- To make quick installable **docker compose** services, which support both relational and vector databases.

## Versions used:

| **Alpine**     | 3.21  |
|----------------|-------|
| **PostgreSQL** | 15.12 |
| **Pgvector**   | 0.8.0 |

## Requrements:

Docker version > 20.0.0

## Create/build an image

### Usage:  docker build [OPTIONS] PATH | URL | -

### Argument Descripton:

The last parameter **PATH | URL | -**  is called a  [Build Context](https://docs.docker.com/build/concepts/context/)
In case of default repo clone, PATH is relative path, which points to current directory.

### OPTIONS Description:

 **OPTION**       | Description                                    
-----------------|------------------------------------------------
 **-t**          | Name and optionally a tag (format: "name:tag") 
 **-D, --debug** | Enable debug logging                           
 **--no-cache ** | Do not use cache when building the image       
 **--build-arg** | Set build-time variables                       

#### Example:

```shell
$ cd ./docker_alpine-pg-pgvector
$ docker build -t zigr/pg15-pgvector08:alpine3.21 [--build-arg=""] [-D] [--no-cache] .
```
----
## Create and run a new container from an image

### Usage:  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

### Argument Descripton:

 **ARGUMENT** | Description                        
--------------|------------------------------------
 **IMAGE**    | The only required command argument 


### OPTIONS Description:

 **OPTION**        | Description                                 
-------------------|---------------------------------------------
 **--name**        | Assign a name to the container              
 **-p, --publish** | Publish a container's port(s) to the host   
 **--mount**       | Attach a file system mount to the container 
 **-e, --env**     | Set environment variables                   

#### Example:

```shell
$ docker run --name my_pg_pgvector -p 5432:5432 --mount type=volume,src=my_pg_data,dst=/var/lib/postgresql/data,volume-nocopy -e POSTGRES_DB=mydb -e POSTGRES_USER=root -e POSTGRES_PASSWORD=!ChangeMe! -e PGDATA=/var/lib/postgresql/data/pgdata zigr/pg15-pgvector08:alpine3.21
```

---