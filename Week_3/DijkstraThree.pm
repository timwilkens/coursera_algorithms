package DijkstraThree;

use strict;
use warnings;
use List::Util qw(shuffle);

sub quicksort {
  my ($nums, $low, $high) = @_;

  if ($high <= $low) {
    return;
  }
  shuffle($nums);

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
  quicksort($nums, $low, ($first - 1));
  quicksort($nums, ($second + 1), $high);
}


sub swap {
  my ($nums, $i, $j) = @_;

  my $temp = $nums->[$i];
  $nums->[$i] = $nums->[$j];
  $nums->[$j] = $temp;
}

1;

