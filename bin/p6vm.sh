#!/bin/bash

#
# source this file in your .bashrc
#

export PATH=$HOME/perl6/p6vm/bin:$HOME/perl6/p6vm/perls/active/bin:$PATH
export PERL5LIB=$HOME/perl6/p6vm/lib:$PERL5LIB

function p6vm() {
   
   case "$1" in
      help)
         _p6vm_help
         ;;

      current)
         _p6vm_current_active
         ;;

      list)
         p6vm.pl --list
         ;;

      list-local)
         p6vm.pl --list-local
         ;;

      install)
         p6vm.pl --install=$2
         ;;
      switch)
         _p6vm_switch_to $2
         ;;
      run)
         shift
         _p6vm_run_with $*
         ;;
      *)
         _p6vm_help
         ;;
   esac

}

function _p6vm_run_with() {

   local version=$1
   shift

   PATH=$HOME/perl6/p6vm/perls/$version/bin:$PATH $*

}

function _p6vm_switch_to() {

   echo Switching to $1
   ln -snf $1 $HOME/perl6/p6vm/perls/active
   hash -r

}

function _p6vm_current_active() {

   local cur_active=$(readlink $HOME/perl6/p6vm/perls/active)
   echo $cur_active

}

function _p6vm_help() {

   echo "================================================================================"
   echo " Perl 6 Verison Manager - for Rakudo"
   echo "================================================================================"
   echo
   echo " help                display this help message"
   echo " list                display available versions"
   echo " list-local          list local version"
   echo " current             display current active version"
   echo " switch <version>     switch to <version>"
   echo " install <version>   download, build and install <verison>"
   echo " run <version> <cmd> run a special command with <version>"
   echo

}

