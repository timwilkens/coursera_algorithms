#!/usr/bin/perl

use strict;
use warnings;

use RedBlackBST;
use Data::Dumper;
use List::Util qw(shuffle);

my $tree = RedBlackBST->new();
my $roots = RedBlackBST->new();

for (shuffle(1 .. 10000)) {
  if ($_ == 999) {
    $tree->insert($_,"WINNER");
    next;
  }
  $tree->insert($_,$_);
  $roots->insert($tree->root->key, ($tree->root->value + 1));
}

print $tree->find(999) . "\n";

my @keys = $roots->get_keys;
print "@keys\n";
