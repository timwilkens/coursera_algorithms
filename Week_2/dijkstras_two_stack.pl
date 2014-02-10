#!/usr/bin/perl

use strict;
use warnings;
use Stack;
use Queue;

# Good test case: (10 * ((1 - 5) / 2))  
# Current limitations: can't read in negative numbers (will always be treated as subtraction)
#                      if we are missing outer parenthesis this won't produce the right answer (one less computation than required)

my $values = Stack->new();
my $operators = Stack->new();
my $numbers = Queue->new();   # Maintain a queue so we can recreate multi-digit numbers

while (my $expression = <STDIN>) {
  chomp($expression);

  my @items = split(//, $expression);
  if ($items[0] ne '(') {    # Fix single line computations that come in without parenthesis
    unshift @items, '(';
    push @items, ')';
  }

  ITEM: for my $item (@items) {
    if ($item =~ /[0-9]/) {
      $numbers->enqueue($item);
      next ITEM;
    } 
    # We have to assume multi-digit numbers are not separated by spaces

    if (!$numbers->is_empty()) {
      my @number; 
      while (not $numbers->is_empty) {
        push @number, $numbers->dequeue();
      }
      my $number = join("", @number);
      $values->push($number);
    }
   
    next if ($item eq '(');
  
    if ($item eq '+' || $item eq '*' || $item eq '/' || $item eq '-') {
      $operators->push($item);
    } elsif ($item eq ')') {
      my $operator = $operators->pop();
      if ($operator eq '+') {
        $values->push(($values->pop() + $values->pop()));
      } elsif ($operator eq '*') {
        $values->push(($values->pop() * $values->pop()));
      } elsif ($operator eq '/') {
        my $divisor = $values->pop();       # Respect ordering
        $values->push(($values->pop() / $divisor));
      } elsif ($operator eq '-') {
        my $subtractor = $values->pop();     # Respect ordering
        $values->push(($values->pop() - $subtractor));
      }
    }
  }
  print $values->pop() . "\n";
}
