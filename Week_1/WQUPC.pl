#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

sub new {
  my $n = shift;
  
  my @size;
  my @id;
  for (0 .. $n) {
    $id[$_] = $_;
    $size[$_] = 1;
  }
  return \@id, \@size;
}

sub root {
  my ($ids, $element) = @_;
  
  my @in_path;

  while ($element != $ids->[$element]) {
    push @in_path, $element;
    $element = $ids->[$element];
  }
  for my $node (@in_path) {
    $ids->[$node] = $element;
  }

  return $element;
}

sub is_connected {
  my ($ids, $p, $q) = @_;

  return (root($ids,$p) == root($ids,$q));
}

sub union {
  my ($ids, $size, $p, $q) = @_;

  my $p_root = root($ids,$p);
  my $q_root = root($ids,$q);

  if ($size->[$p_root] > $size->[$q_root]) {
    $size->[$p_root] += $size->[$q_root];
    $ids->[$q_root] = $p_root;
  } else {
    $size->[$q_root] += $size->[$p_root];
    $ids->[$p_root] = $q_root;

  }
}

my ($struct, $size) = new(20);

union($struct,$size, 0, 1);
union($struct,$size, 1, 2);
union($struct,$size, 2, 3);
print "0 and 1 - Connected\n" if (is_connected($struct, 0, 1));
print "0 and 3 - Connected\n" if (is_connected($struct, 1, 2));
print "1 and 15 - Connected\n" if (is_connected($struct, 1, 15));
