#!/usr/bin/perl

use strict;
use warnings;
use BST;
use List::Util qw(shuffle);

my $bst = BST->new(7,'seven');

for (shuffle(1 .. 100000)) {
  if ($_ == 99450) {
    $bst->insert($_, "WINNER");
    next;
  }
  $bst->insert($_, $_);
}

print $bst->find(5) . "\n";
$bst->insert(5, 1123456789);
print $bst->find(5) . "\n";

print $bst->find(99449) . "\n";
print $bst->find(99450) . "\n";
print $bst->find(99451) . "\n";
