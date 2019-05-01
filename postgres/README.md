# PostgreSQL

[PostgreSQL](https://www.postgresql.org/) is a powerful, open source object-relational database system.

## Introduction

This chart bootstraps a PostgreSQL deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- PV provision support in the underlying infrastructure

## Installing the Chart
To install the chart with the release name `my-release`:

```console
$ helm install --name my-release icgc/postgres
```

The command deploys PostgreSQL on the Kubernetes cluster with the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

# Uninstalling the Chart

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and delete the release.

## Configuration
The following tables lists the configurable parameters of the Postgres chart and their default values.

| Parameters         | Description                                                                                                                                                             | Default        |
|:-------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------|
| `image.repository` | PostgreSQL image name                                                                                                                                                   | `postgres`       |
| `image.tag`        | PostgreSQL image tag                                                                                                                                                    | `VERSION`      |
| `image.pullPolicy` | PostgreSQL image pull policy                                                                                                                                            | `IfNotPresent` |
| `postgresUsername` | Create the specified user with superuser power and a database with the same name.                                                                                       | `postgres`     |
| `postgresPassword` | Set the superuser password for PostgreSQL.                                                                                                                              | `password`     |
| `postgresDb`       | Define a different name for the default database that is created when the image is first started. If it is not specified, then the value of POSTGRES_USER will be used. | `postgres`     |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set postgresqlPassword=secretpassword,postgresDb=my-database \
    icgc/postgres
```

The above command sets the PostgreSQL `postgres` account password to `secretpassword`. Additionally it creates a database named `my-database`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml icgc/postgres
```
