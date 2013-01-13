#!/bin/bash

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
curl https://github.com/krimdomu/p6vm/archive/master.zip | tar xzf -

echo "   Installing"
cp -R lib/* $HOME/perl6/p6vm/lib
cp bin/{p6vm.sh,p6vm.pl} $HOME/perl6/p6vm/bin

cd ..
rm -rf install


echo "done."

echo
echo "Now please add $HOME/perl6/p6vm/bin/p6vm.sh to your .bashrc and reload your shell."
echo
echo "source $HOME/perl6/p6vm/bin/p6vm.sh"
echo

