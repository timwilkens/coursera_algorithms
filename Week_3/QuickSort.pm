package QuickSort;

use strict; 
use warnings;
no warnings 'recursion';
use List::Util qw(shuffle);

sub quicksort {
  my $nums = shift;

  shuffle($nums);
  qsort($nums, 0 , (scalar(@$nums) - 1))
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

1;

