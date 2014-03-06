#!/usr/bin/perl

use strict;
use warnings;
use KDTree;
use Data::Dumper;

my $tree = KDTree->new();
                      

for (1 .. 3) {
  $tree->insert(int(rand(100)), int(rand(100)));
}

my $x = int(rand(100));
my $y = int(rand(100));

print Dumper($tree);

print "Looking for closest to ($x,$y)\n";
my $nearest = $tree->find_neighbor($x,$y);
print "(" . $nearest->x . "," . $nearest->y . ")\n";

