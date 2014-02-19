#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( shuffle );

my @test = shuffle(1 .. 100);
mergesort(\@test);
print "@test\n";

sub mergesort {
  my $nums = shift;
  my $length = scalar @$nums;

  for (my $size = 1; $size < $length; $size += $size) {  # executed log N times
    for (my $low = 0; $low < ($length - $size); $low += ($size + $size)) {
      my $new_low = $low + $size + $size - 1;
      if ($new_low < ($length - 1)) {
        merge($nums, $low, ($low + $size - 1), $new_low);
      } else {
        merge($nums, $low, ($low + $size - 1), ($length - 1));
      }
    }
  }
}

sub merge {
  my ($nums, $low, $mid, $high) = @_;

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
