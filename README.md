# Network configuration: bclan-it

Hyperledger Fabric Network with a generated crypto and ssm chaincode installed

## Use
 * Copy [docker-coompose-it.yaml](docker-compose-it-simple.yaml) in your project
 * Start compose:
```
docker-compose -f docker-compose-it.yaml up -d
```
 * Copy configuration
```
mkdir -p infra
docker cp  cli-init-bclan-network-it:/opt/commune-sandbox/ ./infra/dev
```


## Configuration

docker run -it smartbcity/commune-sandbox-cli:latest /bin/bash
find /opt/commune-sandbox/
```
├── fabric                -> fabric configuration
├── user                  -> SSM User crypto
│   ├── bob
│   ├── bob.pub
│   ├── sam
│   ├── sam.pub
│   ├── ssm-admin
│   ├── ssm-admin.pub
├── util                  -> Start mobilite.eco api    
```

docker run -d  my_image service nginx start

## Release
 * Update ssm_version in .env

 * Tag branch
 ```
git tag -a 0.1.0 -m 'version 0.1.0'
git push origin 0.1.0
```


### Build and deploy docker
```
make package push push-latest -e VERSION=2.3.0-0.8.1
```
