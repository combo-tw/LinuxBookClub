#!/bin/bash
echo "Enter new folder name:"
read foldername
mkdir ../chapter/$foldername
find -maxdepth 50 -type d -exec mkdir ../$foldername/{\} \;
