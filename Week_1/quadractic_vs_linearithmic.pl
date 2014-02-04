#!/usr/bin/perl

use strict;
use warnings;
use Benchmark;

# Searching for every number in a large set, in another large set
# Normal implementation involves a double loop - this is quadratic (N^2)
# Better algorithm uses binary search  - this is linearithmic (N * log(N))

# Just 5 loops on these 'relatively' large sets yields these results
#     Binary Search:  3 wallclock secs ( 3.28 usr +  0.00 sys =  3.28 CPU) @  1.52/s (n=5)
#     Two Loop: 89 wallclock secs (88.54 usr +  0.03 sys = 88.57 CPU) @  0.06/s (n=5)


my @a = (1 .. 100000);
my @b = sort { $a <=> $b } grep { not $_ % 6 } (1 .. 20000);

timethese (
  5,
  {'Two Loop' => '&two_loop',
   'Binary Search' => '&binary'}
);

sub two_loop {
  my $count = 0;
  for my $p (@a) {
    for my $q (@b) {
      if ($p == $q) {
        $count++;
      }
    }
  }
  print "$count\n";
}

sub binary {
  my $count = 0;
  for my $p (@a) {
    if (binary_find(\@b, $p)) {
      $count++;
    }
  }
  print "$count\n";
}

sub binary_find {
  my ($array, $n) = @_;

  my $low = 0;
  my $high = (scalar @$array) - 1;

  while ($low <= $high) {
    my $mid = int(($low + $high) / 2);

    if ($array->[$mid] > $n) {
      $high = $mid - 1;
    } elsif ($array->[$mid] < $n) {
      $low = $mid + 1;
    } else {
      return 1;    # Found
    }
  }
  return 0;
}
