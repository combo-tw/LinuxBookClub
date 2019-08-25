#!/bin/bash
git checkout -- linux
echo "Input target folder name:"
read foldername
cp -Rv ../chapter/$foldername/* ./
