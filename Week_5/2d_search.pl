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

# Ten rounds with 100,000 points and range of 10,000
# Benchmark: timing 10 iterations of 2d-Tree, Brute Force, Neighbor Rank...
#    2d-Tree:  0 wallclock secs ( 0.00 usr +  0.00 sys =  0.00 CPU)
#             (warning: too few iterations for a reliable count)
# Brute Force:  4 wallclock secs ( 3.51 usr +  0.00 sys =  3.51 CPU) @  2.85/s (n=10)
# Neighbor Rank:  0 wallclock secs ( 0.23 usr +  0.00 sys =  0.23 CPU) @ 43.48/s (n=10)
#             (warning: too few iterations for a reliable count)
# Neighbor rank searching for the top 50 closest points. WAY faster than brute forcing 
# for just the closest point

my @points;
                      
for (1 .. 100_000) {
  push @points, [int(rand(10000)), int(rand(10000))];
}

my $tree = KDTree->new(@points);

my $x = int(rand(10000));
my $y = int(rand(10000));

print "Looking for closest to ($x, $y)\n";


sub One {
  my ($nearest, $distance) = $tree->find_neighbor($x,$y);
#  print "(" . $nearest->x . "," . $nearest->y . ") : $distance\n";
}

sub Two {
  my ($nearest, $distance) = $tree->brute_force_search($x, $y);
#  print "(" . $nearest->x . "," . $nearest->y . ") : $distance\n";
}

sub Three {
  my @closest = $tree->find_neighbors($x, $y, 1, 50);

#  for (@closest) {
#    print "(" . $_->x . "," . $_->y . ")\n";
#  }
}

timethese (
  10,
  {'2d-Tree' => '&One',
   'Brute Force' => '&Two',
   'Neighbor Rank' => '&Three',}
);
