#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( shuffle );

my @test = shuffle(1 .. 1000);
mergesort(\@test);
print "@test\n";

sub mergesort {
  my ($nums, $high, $low) = @_;

  if (!$high && !$low) {   # more convenient API for initial call
    $high = scalar @$nums - 1;
    $low = 0;
  }

  if ($high <= $low + 6) { # if we are looking at six or less items
    insertion_sort($nums, $low, $high); # insertion sort to save time
    return;
  }

  my $mid = int(($high + $low) / 2);

  mergesort($nums, $mid, $low);
  mergesort($nums, $high, $mid + 1);
  merge($nums, $high, $mid, $low);
}

sub merge {
  my ($nums, $high, $mid, $low) = @_;

  my @copy;
    for (0 .. (scalar @$nums - 1)) {  # make a copy so we can sort in place
      $copy[$_] = $nums->[$_];
    }

  my $i = $low;  # pointer to start of low subarray
  my $j = $mid + 1;  # pointer to start of high subarray

  for (my $k = $low; $k <= $high; $k++) {   # go through the whole list
    if ($i > $mid) {   # low is exhausted. only do high
      $nums->[$k] = $copy[$j++];
    } elsif ($j > $high) {  # high is empty. only do low
      $nums->[$k] = $copy[$i++];
    } elsif ($copy[$j] < $copy[$i]) {  # high subarray has the lower first element
      $nums->[$k] = $copy[$j++];
    } else {  # low subarray has the lower first element (or they are the same - stable sort)
      $nums->[$k] = $copy[$i++];
    }
  }
}

sub insertion_sort {
  my ($nums, $low, $high) = @_;

  for my $index ($low .. $high) {  # go from the second element to the end
    for (my $j = $index; $j > $low; $j--) { # check every item to the left of our index
      if ($nums->[$j] < $nums->[($j - 1)]) { # are they out of order?
        swap($nums,$j,($j - 1));
      }
    }
  }
}

sub swap {
  my ($nums, $i, $j) = @_;

  my $temp = $nums->[$i];
  $nums->[$i] = $nums->[$j];
  $nums->[$j] = $temp;
}
