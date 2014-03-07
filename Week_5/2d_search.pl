#!/usr/bin/perl

use strict;
use warnings;
use KDTree;
use Benchmark;

# One round with 1,000,000 points in the tree and a range of 10,000
# Benchmark: timing 1 iterations of 2d-Tree, Brute Force...
#   2d-Tree:  0 wallclock secs ( 0.00 usr +  0.00 sys =  0.00 CPU)
#            (warning: too few iterations for a reliable count)
# Brute Force:  4 wallclock secs ( 3.55 usr +  0.01 sys =  3.56 CPU) @  0.28/s (n=1)
#            (warning: too few iterations for a reliable count)

# Ten rounds with 1,000,000 points and range of 10,000
# Benchmark: timing 10 iterations of 2d-Tree, Brute Force...
#   2d-Tree:  0 wallclock secs ( 0.00 usr +  0.00 sys =  0.00 CPU)
#            (warning: too few iterations for a reliable count)
# Brute Force: 37 wallclock secs (37.42 usr +  0.09 sys = 37.51 CPU) @  0.27/s (n=10)

my @points;
                      
for (1 .. 1_000_000) {
  push @points, [int(rand(1000)), int(rand(1000))];
}

my $tree = KDTree->new(@points);

my $x = int(rand(1000));
my $y = int(rand(1000));

print "Looking for closest to ($x, $y)\n";

sub One {
  my ($nearest, $distance) = $tree->find_neighbor($x,$y);
#  print "(" . $nearest->x . "," . $nearest->y . ") : $distance\n";
}

sub Two {
  my ($nearest, $distance) = $tree->brute_force_search($x, $y);
#  print "(" . $nearest->x . "," . $nearest->y . ") : $distance\n";
}

timethese (
  1,
  {'2d-Tree' => '&One',
   'Brute Force' => '&Two'}
);
