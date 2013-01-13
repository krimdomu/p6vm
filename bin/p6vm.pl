#!/usr/bin/env perl

#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
use strict;
use warnings;

use App::p6vm;

use Getopt::Long;
use Data::Dumper;

$|++;

my $p6vm = App::p6vm->new;

GetOptions(
   help         => sub { __help__() },
   list         => sub { print_array($p6vm->list); },
   "list-local" => sub { print_array($p6vm->list_local); },
   "install=s"  => sub { $p6vm->install(@_) },
);

sub print_array {
   my (@array) = @_;

   my $i=0;
   for (@array) {
      $i++;
      printf " %2i. %5s\n", $i, $_;
   }
}

sub __help__ {

   print "================================================================================\n";
   print " Perl 6 Version Manager\n";
   print "================================================================================\n";
   print "A small utility that will manage perl6 rakudo installations on your system.\n\n";
   
   printf " %-15s %s\n", "--help", "Display this help message";
   printf " %-15s %s\n", "--list", "List all available rakudo star versions";

   exit 0;
}
