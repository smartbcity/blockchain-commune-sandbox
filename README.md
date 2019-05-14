# Network configuration: bclan-it

Network with a generatied crypto to reproduce test environement

# Start

```
docker-compose -f docker-compose-it.yaml up -d
```

# Down

```
docker-compose -f docker-compose-it.yaml down
```


# Release
make build tag-latest -e VERSION=0.3.1