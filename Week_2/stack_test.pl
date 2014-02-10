#!/usr/bin/perl

use strict;
use warnings;
use Stack;
use OtherStack;
use Benchmark;

###
#  Testing if popping/pushing or shifting/unshifting on arrays is faster. 
#  My theory was that popping/pushing would be faster since it doesn't require re-doing the array every push/pop
#  Testing proved that shifting/unshifting was significantly slower on large inputs
###

timethese (
  10,
  {
   'Push/Pop' => '&push_pop',
   'Shift/Unshift'    => '&shift_unshift'}
);

sub push_pop {
  my $stack = OtherStack->new();

  for (1 .. 100000) {
    $stack->push_it($_);
    if ($_ % 7) {
      $stack->pop_it();
    }
  }
}

sub shift_unshift {
  my $stack = Stack->new();

  for (1 .. 1000000) {
    $stack->push($_);
    if ($_ % 7) {
      $stack->pop();
    }
  }
}
