package UnionFind;

use strict;
use warnings;

sub new {
  my ($class, $size) = @_;

  my %self;
  for my $node (1 .. $size) {
    for my $connection (1 .. ($size - 1)) {
      $self{$node}{$connection} = 0;
    }
  }
  return bless \%self, $class;
}

sub is_connected {
  my ($self, $node1, $node2) = @_;

  return 1 if ($self->{$node1}{$node2});
  return 0;
}

sub union {
  my ($self, $node1, $node2) = @_;
  return if ($self->is_connected($node1,$node2));
  
  $self->{$node1}{$node2} = 1;
  $self->{$node2}{$node2} = 1;
}

1;

