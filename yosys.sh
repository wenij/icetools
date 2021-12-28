#!/usr/bin/env bash

PYTHONVERSION=$(python3 --version 2>&1 | egrep -o '3\.[0-9]+')

pushd `dirname $0` > /dev/null
DIR=`pwd -P`
popd > /dev/null

UNAME_STR=`uname`

if [ ! -d $DIR/yosys ]; then
	echo "Checking out yosys..."
	git clone -b yosys-0.12 https://github.com/cliffordwolf/yosys.git $DIR/yosys
else
	cd $DIR/yosys
	echo "Updating yosys..."
	git pull origin master || exit 1
fi

cd $DIR/yosys

if [[ "$UNAME_STR" == "Darwin" ]]; then
	OLDPATH=$PATH
	PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
fi

make clean

if [[ ! `uname -a` == *"raspberrypi"* ]]; then
	echo "Building yosys-abc..."
	uname -a
	make yosys-abc
fi

echo "Building yosys..."
if [[ "$UNAME_STR" == "Darwin" ]] && hash brew 2>/dev/null; then
	PYTHONPATH=$(brew --prefix)/lib/python$PYTHONVERSION/site-packages/ make
else
	make
fi

echo "Installing yosys..."
if [[ "$UNAME_STR" == "Darwin" ]] && hash brew 2>/dev/null; then
	PYTHONPATH=$(brew --prefix)/lib/python$PYTHONVERSION/site-packages/ make install
else
	sudo make install
fi

if [[ "$UNAME_STR" == "Darwin" ]]; then
	PATH=$OLDPATH
fi
