#!/bin/bash
rm -rf `ls |egrep -v '(sync.sh)'`
echo "Input target folder name:"
read foldername
cp -Rnv ../chapter/$foldername/* ./
cp -Rnv ../linux/* ./
