#!/bin/bash

run_script(){
    if [[  -f "$INIT_SCRIPT"  ]]; then
        echo "Waiting for daemon to come online";
        wget --retry-connrefused --tries=100 -q --wait=3 --spider localhost:58683
        echo "Running script $INIT_SCRIPT";
        eval $INIT_SCRIPT;
    fi
}

cd /data

#Download bootstrap
if [[ ! -f "blk0001.dat" ]] 
then
    echo Downloading bootstrap file;
    wget https://www.vericoin.info/downloads/bootstrap.zip;
    unzip bootstrap.zip;

    #if vericoin.conf exists dont overwrite it
    if [[ -f "vericoin.conf" ]]; then
        rm bootstrap/vericoin.conf;  
    fi

    mv bootstrap/* .;
    rm bootstrap.zip;
fi

#Edit vericoin.conf
if ! grep -q "rpcuser" vericoin.conf ;then
    echo "Adding rpcuser in vericoin.conf";
    echo "rpcuser=vericoinrpc" >> vericoin.conf;
fi
if ! grep -q "rpcpassword" vericoin.conf ;then
    echo "Adding rpcpassword in vericoin.conf";
    PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
    echo "rpcpassword=$PASS" >> vericoin.conf;
fi
if ! grep -q "server" vericoin.conf ;then
    echo "Adding server in vericoin.conf";
    echo "server=1" >> vericoin.conf;
fi
if ! grep -q "rpcallowip" vericoin.conf ;then
    echo "Adding rpcallowip in vericoin.conf";
    echo "rpcallowip=*.*.*.*" >> vericoin.conf;
fi

run_script &

echo "Starting vericoind";
vericoind -datadir=/data -conf=/data/vericoin.conf -printtoconsole

