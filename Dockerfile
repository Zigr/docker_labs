# syntax=docker/dockerfile:1

# [Postgres Docker.Hub images](https://hub.docker.com/_/postgres)
## Actually **alpine:3.21** is used for [**postgres:15-alpine**](https://github.com/docker-library/postgres/blob/cc254e85ed86e1f8c9052f9cbf0e3320324f0421/15/alpine3.21/Dockerfile)
### Synonym tags: 15.12-alpine3.21, 15-alpine3.21, 15.12-alpine, 15-alpine

# "" | "-march=native"
# To compile for portability, leave empty
ARG PGVECTOR_OPTFLAGS=""
FROM postgres:15-alpine AS pg-ext-builder
ARG PGVECTOR_OPTFLAGS
# Install necessary packages and pgvector extension
RUN set -eux; \
    apk add --no-cache \

    build-base \
    clang19 \
    llvm19-dev \ 
    llvm19 \
    git ;

WORKDIR /home
RUN git clone --branch v0.8.0 --depth 1 https://github.com/pgvector/pgvector.git 
WORKDIR /home/pgvector

RUN <<EOT  
make clean && \
  make OPTFLAGS=${PGVECTOR_OPTFLAGS} && \
  make install;
EOT

# Set default PostgreSQL configuration (optional)
ENV POSTGRES_DB=test
ENV POSTGRES_USER=test
ENV POSTGRES_PASSWORD=!ChangeMe!

# PostgreSQL port exposed in the base image already
# EXPOSE 5432

FROM postgres:15-alpine
COPY --from=pg-ext-builder /usr/local/lib/postgresql/bitcode/vector.index.bc /usr/local/lib/postgresql/bitcode/vector.index.bc
COPY --from=pg-ext-builder /usr/local/lib/postgresql/vector.so /usr/local/lib/postgresql/vector.so
COPY --from=pg-ext-builder /usr/local/share/postgresql/extension /usr/local/share/postgresql/extension

# Copy custom scripts or configuration files from your host to the container
COPY ./scripts/ /docker-entrypoint-initdb.d/

# Introduced in the base image
# CMD ["postgres"]
