#!/bin/bash

function install_dep() {

   echo "Please run as root:"

   if [ -f /etc/debian_version ]; then
      echo
      echo " apt-get install build-essential libicu-dev libreadline5-dev"
      echo
      echo "If you use ubuntu you might replace libreadline5-dev with libreadline6-dev"
      echo
   elif [ -f /etc/redhat-release ]; then
      echo
      echo " yum groupinstall development-tools"
      echo " yum install libicu-devel subversion readline-devel"
      echo
   fi
}

echo "Going to install p6vm"
echo "   InstallPrefix: $HOME/perl6/p6vm"

mkdir -p $HOME/perl6/p6vm
mkdir -p $HOME/perl6/p6vm/{tmp,perls,bin,lib}
mkdir -p $HOME/perl6/p6vm/lib/App

echo "   Created directory structure"

cd $HOME/perl6/p6vm/tmp
mkdir install
cd install

echo "   Downloading package"
curl https://nodeload.github.com/krimdomu/p6vm/zip/master >master.zip 2>/dev/null
unzip master.zip >/dev/null 2>&1

echo "   Installing"
cd p6vm-master
cp -R lib/* $HOME/perl6/p6vm/lib
cp bin/{p6vm.sh,p6vm.pl} $HOME/perl6/p6vm/bin

cd ../..
rm -rf install

install_dep

echo
echo "Now please add $HOME/perl6/p6vm/bin/p6vm.sh to your .bashrc and reload your shell."
echo
echo "source $HOME/perl6/p6vm/bin/p6vm.sh"
echo



