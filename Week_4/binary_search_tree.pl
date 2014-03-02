#!/usr/bin/perl

use strict;
use warnings;
use BST;
use List::Util qw(shuffle);
use Data::Dumper;

my $bst = BST->new(7,'seven');

for (shuffle(1 .. 10)) {
  $bst->insert($_, $_);
}

my @keys = $bst->get_keys;
print "@keys\n";
$bst->delete(5);
$bst->remove_min;
$bst->delete(2);
$bst->delete(10);
$bst->delete(7);
@keys = $bst->get_keys;
print "@keys\n";
