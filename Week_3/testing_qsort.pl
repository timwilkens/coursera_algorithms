#!/usr/bin/perl

use strict;
use warnings;

use DijkstraThree;
use QuickSort;

use Benchmark;

############################################################################################
# For the dupe array:                                                                      #
# Dijkstra:  4 wallclock secs ( 3.95 usr +  0.00 sys =  3.95 CPU) @ 253.16/s (n=1000)      #
# Traditional: 70 wallclock secs (69.28 usr +  0.05 sys = 69.33 CPU) @ 14.42/s (n=1000)    #
#  The 'traditional' method also illicited lots of "deep recursion" complaints....         #
############################################################################################

sub One {
  my $nums = make_nondupe_array();
  DijkstraThree::quicksort($nums, 0, (scalar(@$nums) - 1));
}

sub Two {
  my $nums = make_nondupe_array();
  QuickSort::quicksort($nums, 0, (scalar(@$nums) -1));
}

sub make_nondupe_array {
  my @nums;
  for (1 .. 1000) {
    push @nums, $_;
  }
  return \@nums;
}

sub make_dupe_array {
  my @nums;
  for my $num (reverse(1 .. 10)) {
    for (1 .. 100) {
      push @nums, $num;
    }
  }
  return \@nums;
}

timethese (
  100,
  {'Dijkstra' => '&One',
   'Traditional' => '&Two'}
);
