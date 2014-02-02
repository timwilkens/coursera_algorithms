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

sub is_connected {
  my ($ids, $p, $q) = @_;

  return ($ids->[$p] == $ids->[$q]);
}

sub union {
  my ($ids, $p, $q) = @_;
  my $pid = $ids->[$p];
  my $qid = $ids->[$q];

  for (0 .. (scalar @$ids - 1)) {
    if ($ids->[$_] == $pid) {
      $ids->[$_] = $qid;
    }
  }
}

my @struct = new(10);
union(\@struct,1,2);
union(\@struct,2,3);
union(\@struct,3,4);
print "Connected\n" if (is_connected(\@struct,1,4));
