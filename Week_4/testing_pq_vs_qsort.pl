#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw( shuffle );
use Benchmark;
use DijkstraThree;
use PQ;

######################################################################################################
#Benchmark: timing 100 iterations of Binary Heap, Dijkstra, Linear...                                #
#Binary Heap:  4 wallclock secs ( 3.24 usr +  0.01 sys =  3.25 CPU) @ 30.77/s (n=100)                #
#  Dijkstra: 14 wallclock secs (14.03 usr +  0.00 sys = 14.03 CPU) @  7.13/s (n=100)                 #
#    Linear:  0 wallclock secs ( 0.21 usr +  0.00 sys =  0.21 CPU) @ 476.19/s (n=100)                #
#            (warning: too few iterations for a reliable count)                                      #
# Binary heap kills using quicksort with a 3-way partition                                           #
# BUT, doing a single pass search for the max beats both by a LOT                                    #
# Conclusion: if you don't have space as a constraint, a single pass on the unordered array is best  #
######################################################################################################

sub One {
  my @nums;

  for (shuffle(1 .. 10000)) {
    push @nums, $_;
  }
  DijkstraThree::quicksort(\@nums, 0, (scalar(@nums) - 1));
  my $max = pop(@nums);
}

sub Two {
  my $pq = PQ->new();
  for (shuffle(1 .. 10000)) {
    $pq->insert($_);
  }
  my $max = $pq->delete_max();
}

sub Three {
  my @nums;

  for (shuffle(1 .. 10000)) {
    push @nums, $_;
  }

  my $max = $nums[0];
  for my $i (1 .. scalar(@nums) - 1) {
    if ($nums[$i] > $max) {
      $max = $nums[$i];
    }
  }
}

timethese (
  100,
  {'Dijkstra' => '&One',
   'Binary Heap' => '&Two',
   'Linear' => '&Three'}
);
