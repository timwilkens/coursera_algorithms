#!/usr/bin/perl

use strict;
use warnings;
use KDTree;
use Data::Dumper;

my $tree = KDTree->new(1 => 2,
                       2 => 3,
                       3 => 4,
                       4 => 5,);
                      

print Dumper($tree);
