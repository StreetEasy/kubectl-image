# kubectl-image

```
docker build \
  --build-arg KUBECTL_VERSION=v1.17.6 \
  --build-arg AWS_CLI_VERSION=1.18.54 \
  -t zillownyc/kubectl:1.17.6 \
  -t zillownyc/kubectl:1.17 \
  -t zillownyc/kubectl:latest .
```
