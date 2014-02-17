#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(shuffle);
use POSIX;

my @nums = shuffle(1 .. 500);
print "@nums\n";
shellsort(\@nums);
print "@nums\n";


sub shellsort {
  my $nums = shift;
  my $size = scalar @nums;

  my $h = 1;
  while ($h < ($size / 3)) { # don't start higher than 1/3 of N
    $h = ((3 * $h) + 1); # set up the start of our increment
  }

  while ($h >= 1) {
    for my $index ($h .. ($size - 1)) {  # don't look at elements below our h size
      for (my $j = $index; $j >= $h; $j -= $h) { 
        if ($nums->[$j] < $nums->[($j - $h)]) {
          swap($nums,$j,($j - $h));
        }
      }
    }
    $h = floor($h/3);
  }
}

sub swap {
  my ($nums, $i, $j) = @_;

  my $temp = $nums->[$i];
  $nums->[$i] = $nums->[$j];
  $nums->[$j] = $temp;
}
