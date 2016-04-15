#!/bin/sh
DEV=$1
SIZE=1024

if [ $2 ]; then
    SIZE=$2
fi

echo "d
1
d
2
d
3
d
4
n
p
1

+${SIZE}M
n
p
2


a
1
w
" | sudo fdisk ${DEV}
