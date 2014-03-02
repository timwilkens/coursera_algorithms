#!/usr/bin/perl

use strict;
use warnings;
use BST;
use List::Util qw(shuffle);

my $bst = BST->new(7,'seven');

for (shuffle(1 .. 100)) {
  if ($_ == 63) {
    $bst->insert($_, "WINNER");
    next;
  }
  $bst->insert($_, $_);
}
$bst->insert(-100, "Lowest");

my @keys = $bst->get_keys;
print $bst->find($bst->min) . "\n";
