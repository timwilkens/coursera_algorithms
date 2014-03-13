#!/usr/bin/perl

use strict;
use warnings;
use KDTree;
use Point;

my @points = ([32.947414, -117.241739],  # Eventful
              [51.3, 0.5],               # London
              [33.152555, -117.341824]   # Carlsbad Pizza Port
             );
                      
my $tree = KDTree->new(@points);

# Carlsbad
my $lat = 33.158093;
my $long = -117.350594;

print "**Within 35 miles**\n";
my @close = $tree->radius_search($lat, $long, 35);
for (@close) { 
  print "(" . $_->y . "," . $_->x . ")\n";
}

print "**Closest**\n";
my ($nearest, $distance) = $tree->find_neighbor($lat, $long);
print "(" . $nearest->y . "," . $nearest->x . ") : $distance\n";

print "**All**\n";
my @closest = $tree->find_neighbors($lat, $long, 1, 10);
for (@closest) {
  print "(" . $_->y . "," . $_->x . ")\n";
}
