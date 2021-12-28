#!/usr/bin/env bash

pushd `dirname $0` > /dev/null
DIR=`pwd -P`
popd > /dev/null

UNAME_STR=`uname`

if [ ! -d $DIR/nextpnr ]; then
	echo "Checking out nextpnr..."
	git clone https://github.com/YosysHQ/nextpnr $DIR/nextpnr
else
	cd $DIR/nextpnr
	echo "Updating nextpnr..."
	git pull origin master || exit 1
fi

cd $DIR/nextpnr

echo "Building nextpnr ..."
cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local .
make 

echo "Installing arachne-pnr..."
if [[ "$UNAME_STR" == "Darwin" ]]; then
	make install
fi
if [[ "$UNAME_STR" == "Linux" ]]; then
	sudo make install
fi
