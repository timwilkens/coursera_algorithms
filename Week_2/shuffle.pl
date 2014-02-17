#!/usr/bin/perl

use strict;
use warnings;

for (1 .. 10) {
  my @nums = (1 .. 10);
  shuffle(\@nums);
  print "@nums\n";
}

sub shuffle {
  my $nums = shift;
  my $size = scalar @$nums;

  for (0 .. ($size - 1)) {
    my $random = rand($_ + 1);
    swap($nums,$_,$random);
  }
}

sub swap {
  my ($nums, $i, $j) = @_;

  my $temp = $nums->[$i];
  $nums->[$i] = $nums->[$j];
  $nums->[$j] = $temp;
}
