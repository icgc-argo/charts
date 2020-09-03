# charts

Helm Charts

## How it works

GitHub Pages is pointed to the docs folder. A typical workflow from creating to publishing a chart is described below.

```shell
$ helm3 create mychart # Create a new chart
$ helm3 package mychart # Turn a chart into a versioned chart archive file
$ mv mychart-0.1.0.tgz docs
$ make 
OR
$ helm3 repo index docs --url https://icgc-argo.github.io/charts/ # Generate an index file in docs folder
```

## Add repository

```shell
helm3 repo add icgcargo https://icgc-argo.github.io/charts/

```
