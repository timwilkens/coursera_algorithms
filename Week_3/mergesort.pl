#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( shuffle );

my @test = shuffle(1 .. 10);
mergesort(\@test, (scalar @test - 1), 0);
print "@test\n";

sub mergesort {
  my ($nums, $high, $low) = @_;

  if ($high <= $low) {
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

sub pretty_print {
  my $nums = shift;

  for (@$nums) {
    print "$_ ";
  }
  print "\n";
}
