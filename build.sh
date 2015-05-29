#!/bin/bash

#could this be a Makefile

cd `dirname $0`

POSIXVALAC="posixvala/posixvalac"
SRCDIR="src"
VALA_SRC_FILES=`find $SRCDIR -type f -name "*.vala"`
VAPI_FILES=`find $SRCDIR -type f -name "*.vapi"`

echo "[CLEAN] Cleaning build directory"

rm -rf out
rm -rf tmp
mkdir out
mkdir out/src
mkdir out/include

echo "[COMPILE] Compiling Vala to C"

$POSIXVALAC -C $VAPI_FILES $VALA_SRC_FILES || exit

C_SRC_FILES=`find $SRCDIR -type f -name "*.c"`

for file in $C_SRC_FILES
do
	new_file="out/$file"
	new_dir=`dirname $new_file`

	mkdir -p $new_dir
	echo "[COMPILE] Moving $file to $new_file"
	mv $file $new_file
done

echo "[RES] Copying build resources"
cp -r build_res/* out/
chmod +x out/build.sh

echo "[RES] Copying posixvalac headers"
cp -r posixvala/include/posixvala/* out/include/

echo "Completed build."