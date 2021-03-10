# kubectl-image

```
docker build \
  --build-arg KUBECTL_VERSION=v1.18.16 \
  --build-arg AWS_CLI_VERSION=1.18.54 \
  -t zillownyc/kubectl:1.18.16 \
  -t zillownyc/kubectl:1.18 \
  -t zillownyc/kubectl:latest .
```
