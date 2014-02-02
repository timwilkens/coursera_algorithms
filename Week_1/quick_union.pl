#!/usr/bin/perl

use strict;
use warnings;

sub new {
  my $size = shift;

  my @id;
  for (0 .. $size) {
    $id[$_] = $_;
  }
  return @id;
}

sub root {
  my ($ids, $element) = @_;
  
  while ($element != $ids->[$element]) {
    $element = $ids->[$element];
  }
  return $element;
}

sub is_connected {
  my ($ids, $p, $q) = @_;

  return (root($ids,$p) == root($ids,$q));
}

sub union {
  my ($ids, $p, $q) = @_;

  my $p_root = root($ids,$p);
  my $q_root = root($ids,$q);

  $ids->[$p_root] = $q_root;
}

my @struct = new(10);
union(\@struct,1,9);
union(\@struct,2,3);
union(\@struct,2,5);
union(\@struct,3,9);

print "Connected\n" if (is_connected(\@struct,5,1));
