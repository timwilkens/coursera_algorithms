#!/usr/bin/perl

use strict;
use warnings;
use UnionFind;
use Data::Dumper;

my $structure = UnionFind->new(10);
print "1 and 2 connected\n" if ($structure->is_connected(1,2));
$structure->union(1,2);
print "1 and 2 connected\n" if ($structure->is_connected(1,2));
