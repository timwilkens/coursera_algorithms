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
#    Reasoning: linear search will do M*N compares
#                priority queue will do N(1 + log(M)) compares => N + N log M
#
#          When M*N > N + N log M => use priority queue , else use linear search
#
#           But, this simplifies to M > 1 + log(M)   which will always be true
#         Conclusion then it should be that linear will never beat priority queue
#           Perhaps an artifact of using Perl's objects to do the priority queue rather than direct array access
#
#          It seems to be the case that once N gets large (> 10000) priority queues basically always win
###################################################################################################################

my $M;
my $N = 10000;

my %data;

for (my $i = 1000; $i < 1500; $i += 10000) {
  $M = $i;
  print "Starting test on $M\n";
  my $results = timethese (
    5,
    {
  #   'Dijkstra' => '&One',
     'Binary_Heap' => '&Two',
     'Linear' => '&Three'
    },
     'none'
  );

  $data{$M}{B} = $results->{Binary_Heap}[0];
  $data{$M}{L} = $results->{Linear}[0];
}

print "VALUE\tBINARY\tLINEAR\n";
for my $m_value (sort { $a <=> $b } keys %data) {
  print join("\t", $m_value, $data{$M}{B}, $data{$M}{L}); 
  print "\n";
}

sub One {
  my @nums;

  for (shuffle(1 .. $N)) {
    push @nums, $_;
    DijkstraThree::quicksort(\@nums, 0, (scalar(@nums) - 1));
    if (scalar(@nums) > $M) {
      pop @nums;
    }
  }
}

sub Two {
  my $pq = PQ->new();
  for (shuffle(1 .. $N)) {
    $pq->insert($_);
    if ($pq->size > $M) {
      $pq->delete_max();
    }
  }
}

sub Three {
  my @nums;

  for (shuffle(1 .. $N)) {
    push @nums, $_;

    if (scalar(@nums) > $M) {
      my $max = 0;
      for my $i (1 .. scalar(@nums) - 1) {
        if ($nums[$i] > $nums[$max]) {
          $max = $i;
        }
      }
      splice(@nums, $max, 1);
    }
  }
}

