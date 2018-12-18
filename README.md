# charts
Helm Charts

## How it works

GitHub Pages is pointed to the docs folder. A typical workflow from creating to publishing a chart is described below.

``` shell
helm create mychart # Create a new chart
helm package mychart # Turn a chart into a versioned chart archive file
mv mychart-0.1.0.tgz docs
helm repo index docs --url https://overture-stack.github.io/charts # Generate an index file in docs folder
```
