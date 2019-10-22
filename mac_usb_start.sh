#!/bin/bash -l
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

project_path=$(pwd)
itnl_path=$project_path/tools/phone/itnl/
echo $itnl_path
cd $itnl_path

echo "- - - - - - - - - - - - -"
echo " 开始映射...."
echo "- - - - - - - - - - - - -"

./itnl --iport 22 --lport 10010

echo "- - - - - - - - - - - - -"
echo " 结束映射"
echo "- - - - - - - - - - - - -"
