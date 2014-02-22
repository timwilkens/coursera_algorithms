#!/usr/bin/perl

use strict; 
use warnings;

my @nums = qw(1 2 2 2 4 5 6 7 8 8 9 9);

my $found = quick_select(\@nums, 2);
print "$found\n";

sub quick_select {
  my ($nums, $k) = @_;

  shuffle($nums);

  my $low = 0;
  my $high = scalar(@$nums) - 1;

  if ($k > $high) {
    die "Search index beyond bounds of aray.\n";
  }

  while ($high > $low) {
    my $j = partition($nums, $low, $high);
    if ($j < $k) {
      $low = ($j + 1);
    } elsif ($j > $k) {
      $high = ($j - 1);
    } else {
      return $nums->[$k];
    }
  }
  return $nums->[$k];
}

sub shuffle {
  my $nums = shift;

  for my $i (1 .. (scalar(@$nums) - 1)) {
    my $rand = int(rand(($i + 1)));
    swap($nums, $i, $rand)
  }
}

sub swap {
  my ($nums, $i, $j) = @_;

  my $temp = $nums->[$i];
  $nums->[$i] = $nums->[$j];
  $nums->[$j] = $temp;
}

sub partition {
  my ($nums, $low, $high) = @_;

  my $pivot = $nums->[$low];
  my $i = ($low + 1);
  my $j = $high;


  while (1) {
    while ($nums->[$i] <= $pivot) {
      $i++;
      if ($i >= $high) {
        last;
      }
    }

    while ($nums->[$j] >= $pivot) {
      $j--;
      if ($j <= $low) {
        last;
      }
    }

    if ($i >= $j) {
      last;
    }
    swap($nums, $i, $j);  
  }
  swap($nums, $low, $j);
  return $j;
}
