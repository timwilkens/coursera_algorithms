#!/usr/bin/perl

use strict;
use warnings;
use Stack;
use Queue;

my $stack = Stack->new();
my $queue = Queue->new();

while (my $line = <STDIN>) {
  chomp($line);
  if ($line eq '-') {
    print "STACK " . $stack->pop() . "\n";
    print "QUEUE " . $queue->dequeue() . "\n";
    print "====================\n";
  } else {
    $stack->push($line);
    $queue->enqueue($line);
  }
}
