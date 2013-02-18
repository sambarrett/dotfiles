#!/bin/sh

NAME=clang+llvm-3.2-x86_64-linux-ubuntu-12.04
TARNAME=$NAME.tar.gz

wget http://llvm.org/releases/3.2/$TARNAME
tar -zxvf $TARNAME
mv $NAME ~/apps/llvm
rm $TARNAME
