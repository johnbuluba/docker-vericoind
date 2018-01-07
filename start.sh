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

if [[ ! -f "blk0001.dat" ]] 
then
    echo Downloading bootstrap file;
    wget https://www.vericoin.info/downloads/bootstrap.zip;
    unzip bootstrap.zip;
    mv bootstrap/* .;
    rm bootstrap.zip;
fi
run_script &

echo "Starting vericoind";
vericoind -datadir=/data -conf=/data/vericoin.conf -printtoconsole

