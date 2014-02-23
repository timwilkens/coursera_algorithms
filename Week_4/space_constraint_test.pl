#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw( shuffle );
use Benchmark;
use DijkstraThree;
use PQ;
use Data::Dumper;

################################################################################################################
#        Keeping 100 lowest elements in a set of 10000
#  Binary Heap:  2 wallclock secs ( 1.88 usr +  0.00 sys =  1.88 CPU) @  5.32/s (n=10)
#  Dijkstra: 110 wallclock secs (110.77 usr +  0.04 sys = 110.81 CPU) @  0.09/s (n=10)
#  Linear:  2 wallclock secs ( 1.44 usr +  0.00 sys =  1.44 CPU) @  6.94/s (n=10)
#
#   It is just a horrible idea to use sorting to solve this problem. Quicksort is quadratic (N * (N log N))
#   Linear is actually faster when the number of items kept is very small ( e.g. 5)
#
#     BUT, when M (number kept) gets larger, priority queue KILLS linear
#     Testing with N of 1,000,000 and M of 1,000
#  Benchmark: timing 2 iterations of Binary Heap, Linear...
#  Binary Heap: 55 wallclock secs (54.97 usr +  0.02 sys = 54.99 CPU) @  0.04/s (n=2)
#              (warning: too few iterations for a reliable count)
#  Linear: 282 wallclock secs (280.63 usr +  0.29 sys = 280.92 CPU) @  0.01/s (n=2)
#
#    Reasoning: linear search will M*N compares
#                priority queue will do N(1 + log(M)) compares => N + N log M
#
#          When M > N log M => use priority queue , else use linear search
###############################################################################################################

sub One {
  my @nums;

  for (shuffle(1 .. 1000000)) {
    push @nums, $_;
    DijkstraThree::quicksort(\@nums, 0, (scalar(@nums) - 1));
    if (scalar(@nums) > 1000) {
      pop @nums;
    }
  }
}

sub Two {
  my $pq = PQ->new();
  for (shuffle(1 .. 1000000)) {
    $pq->insert($_);
    if ($pq->size > 1000) {
      $pq->delete_max();
    }
  }
  print "heap\n";
}

sub Three {
  my @nums;

  for (shuffle(1 .. 1000000)) {
    push @nums, $_;

    if (scalar(@nums) > 1000) {
      my $max = 0;
      for my $i (1 .. scalar(@nums) - 1) {
        if ($nums[$i] > $nums[$max]) {
          $max = $i;
        }
      }
      splice(@nums, $max, 1);
    }
  }
  print "linear\n";
}

timethese (
  2,
  {
   'Dijkstra' => '&One',
   'Binary Heap' => '&Two',
   'Linear' => '&Three'
  }
);
