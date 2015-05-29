#!/bin/bash

if [ ! -f one.so ]; then
	echo "[TESTS] one.so not found. Make sure it is in this directory."
	exit 1
fi

PASSED=0
FAILED=0

for binfile in bin/*
do
	echo -n "[TESTS] Testing $binfile - "
	LD_PRELOAD="./one.so" $binfile 
	RETCODE="$?"
	echo ". (retcode: $RETCODE)"
	if [ "$RETCODE" -eq "0" ]
	then
		PASSED=$((PASSED+1))
	else
		FAILED=$((FAILED+1))
	fi
done

echo "[TESTS] Tests finished - $PASSED passed, $FAILED failed."
