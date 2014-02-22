#!/usr/bin/perl

use strict; 
use warnings;

my @nums = (1 .. 100);

quicksort(\@nums);

if (is_sorted(\@nums)) {
  print "@nums\n";
}

sub quicksort {
  my $nums = shift;

  shuffle($nums);
  qsort($nums, 0 , (scalar(@$nums) - 1))
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

sub qsort {
  my ($nums, $low, $high) = @_;

  if ($high <= $low) {
    return;
  }

  my $pivot = partition($nums, $low, $high);
  qsort($nums, $low, ($pivot - 1));
  qsort($nums, ($pivot + 1), $high);
}

sub partition {
  my ($nums, $low, $high) = @_;

  my $pivot = $nums->[$low];
  my $i = ($low + 1);
  my $j = $high;


  while (1) {

    while ($nums->[$i] < $pivot) {
      $i++;
      if ($i >= $high) {
        last;
      }
    }

    while ($nums->[$j] > $pivot) {
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

sub is_sorted {
  my $nums = shift;

  for my $i (0 .. (scalar(@$nums) - 2)) {
    if ($nums->[$i] > $nums->[$i+1]) {
      return 0;
    }
  }
  return 1;
}

sub print_array_ref {
  my $ref = shift;
  my $end = scalar(@$ref) - 1;

  for (0 .. $end) {
    print $ref->[$_] . " ";
  }
  print "\n";
}

