#!/usr/bin/perl

use strict;
use warnings;
use KDTree;
use Data::Dumper;

my @points;
                      
for (1 .. 100000) {
  push @points, [int(rand(1000)), int(rand(1000))];
}

my $tree = KDTree->new(@points);

my $x = int(rand(1000));
my $y = int(rand(1000));

print "Looking for closest to ($x,$y)\n";
my ($nearest, $distance) = $tree->find_neighbor($x,$y);
print "(" . $nearest->x . "," . $nearest->y . ") : $distance\n";

