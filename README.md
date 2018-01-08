# docker-vericoind

Docker image of vericoin daemon.  VeriCoin is a Proof-of-Stake-Time cryptocurrency.

## Getting Started

The easiest way to get started is using docker compose.

```yaml
version: "3"


services:
  vericoind:
    image: buluba89/vericoind:latest
    volumes:
      #Mount a local folder for vericoin data.This folder will be used 
      #for storing the blockchain as well as vericoin.conf and your wallet. 
      - /path/to/data:/data
      #You can copy your wallet in data folder or mount it like this:
      - /path/to/wallet.dat:/data/wallet.dat
    #This is needed for upnp to work
    network_mode: host
    #Forwarding ports is needed when using swarm mode or not settin 'network_mode:host'
    ports:
     - "58683:58683"
    environment:
      #A script that runs after vericoind has started, for example to unlock your wallet for staking
      #You can copy it in the data volume or mount it in volumes
      INIT_SCRIPT: "/data/script.sh"
```

and run
```bash
docker-compose up -d
```

In the first run will generate a vericoin.conf with  rpcuser=vericoinrpc, a random rpcpassword and allow all ip for rpc. You can edit these later.

The image is using  /data  folder for vericoin's data (storing blockchain, vericoin.conf and wallet.dat). You must copy or mount you wallet there and/or edit vericoin.conf.


### INIT_SCRIPT

Optionally you can add a script to run after vericoind start. It's usefull for unlocking your wallet for staking.
For example:

```bash
#!/bin/bash

vericoind walletpassphrase mysupersecurepass 9999999 true;

```

will unlock your wallet for 115 days.


