#!/bin/bash
echo "Enter new folder name:"
read foldername
mkdir ../$foldername
find -maxdepth 50 -type d -exec mkdir ../$foldername/{\} \;
