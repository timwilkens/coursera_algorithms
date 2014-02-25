#!/usr/bin/perl

use strict;
use warnings;
use HeapSort;
use List::Util qw(shuffle);
use Data::Dumper;

my @nums = shuffle(1 .. 100);

my $heap = HeapSort->new(@nums);

my @sorted = $heap->heapsort();
print "@sorted\n";

