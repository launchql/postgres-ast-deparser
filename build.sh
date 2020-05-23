#!/usr/bin/env bash

bak=$(pwd)

for x in $(find packages -name sqitch.plan -exec dirname '{}' \; | grep -v node_modules)
do
 echo running \"$@\" inside of $x
 cd $x
 $@
 cd $bak
done

cd $bak
