package DijkstraThree;

use strict;
use warnings;
use List::Util qw(shuffle);

sub quicksort {
  my ($nums, $low, $high) = @_;

  shuffle($nums);
  qsort($nums, $low, $high);
}

sub qsort {
  my ($nums, $low, $high) = @_;

  if ($high <= $low) {
    return;
  }

  my $pivot = $nums->[$low];

  my $first = $low;
  my $second = $high;

  my $i = $low;

  while ($i <= $second) {
    if ($nums->[$i] < $pivot) {
      swap($nums, $i++, $first++);
    } elsif ($nums->[$i] > $pivot) {
      swap($nums, $i, $second--);
    } else {
      $i++;
    }
  }
  qsort($nums, $low, ($first - 1));
  qsort($nums, ($second + 1), $high);
}


sub swap {
  my ($nums, $i, $j) = @_;

  my $temp = $nums->[$i];
  $nums->[$i] = $nums->[$j];
  $nums->[$j] = $temp;
}

1;

