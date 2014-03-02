#!/usr/bin/perl

use strict;
use warnings;
use BiSearchTable;

# Not confident this works exactly as I expect it too
# May come back if I have time
my $table = BiSearchTable->new(4,'four',1,'one',6,'six',2,'two',3,'three',5,'five',10,'ten');

for (1 .. 10) {
  if (my $letter = $table->get($_)) {
    print "$_  =>  $letter\n";
  }
}
