#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(shuffle);

my @nums = shuffle(1 .. 500);
print "@nums\n";
insertion_sort(\@nums);
print "@nums\n";


sub insertion_sort {
  my $nums = shift;
  my $size = scalar @nums;

  for my $index (1 .. ($size - 1)) {  # go from the second element to the end
    for (my $j = $index; $j > 0; $j--) { # check every item to the left of our index
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
