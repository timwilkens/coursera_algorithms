#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw(shuffle);

my @nums = shuffle(1 .. 500);
print "@nums\n";
selection_sort(\@nums);
print "@nums\n";


sub selection_sort {
  my $nums = shift;
  my $size = scalar @nums;

  for my $index (0 .. ($size - 2)) {  # don't need to look at the last element
    my $min = $index;  # initialize min to our current index
    for (my $j = ($index + 1); $j < $size; $j++) {   # look right from our current point
      if ($nums->[$j] < $nums->[$min]) {
        $min = $j;   # change index of minimum element
      }
    }
    swap($nums,$index,$min);
  }
}

sub swap {
  my ($nums, $i, $j) = @_;

  my $temp = $nums->[$i];
  $nums->[$i] = $nums->[$j];
  $nums->[$j] = $temp;
}
