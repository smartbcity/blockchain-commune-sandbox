# Network configuration: bclan-it

Hyperledger Fabric Network with a generated crypto and ssm chaincode installed

## Use
 * Copy [docker-coompose-it.yaml](docker-coompose-it.yaml) in your project
 * Start compose:
```
docker-compose -f docker-compose-it.yaml up -d
```
 * Copy configuration
```
mkdir -p infra
docker cp  cli-bclan-network-it:/opt/commune-sandbox/ ./infra/dev
```


## Release
make build tag-latest -e VERSION=0.3.1
