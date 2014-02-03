package WQUPC;

use strict;
use warnings;

sub new {
  my ($class, $side_length) = @_;

  my $total_nodes = ($side_length * $side_length);
  my %self;

  # Not doing the virtual node on the bottom for now.
  # Unsure how to implement it
  $self{0}{size} = $side_length + 1;
  $self{0}{root} = 0;

  for my $node (1 .. $total_nodes) {
    $self{$node}{size} = 1;
    $self{$node}{"open"} = 0;

    if ($node < $side_length) {  
      $self{$node}{root} = 0;
    } else {
      $self{$node}{root} = $node;
    }
  }
  return bless \%self, $class;
}

sub root {
  my ($self, $node) = @_;

  my @in_path_nodes;

  while ($node != $self->{$node}{root}) {
    push @in_path_nodes, $node;
    $node = $self->{$node}{root};
  }
  for my $n (@in_path_nodes) {
    $self->{$n}{root} = $node;
  }
  return $node;
}

sub connected {
  my ($self, $node1, $node2) = @_;
  
  return ($self->root($node1) == $self->root($node2));
}

sub union {
  my ($self, $node1, $node2) = @_;

  return if ($self->connected($node1,$node2));

  my $root1 = $self->root($node1);
  my $root2 = $self->root($node2);


  if ($self->{$root1}{size} > $self->{$root2}{size}) {
    $self->{$root2}{root} = $root1;
    $self->{$root1}{size} += $self->{$root2}{size};
  } else {
    $self->{$root1}{root} = $root2;
    $self->{$root2}{size} += $self->{$root1}{size};
  }
}

sub open_node {
  my ($self, $node) = @_;

  $self->{$node}{"open"} = 1;
}

sub is_open {
  my ($self, $node) = @_;
 
  return $self->{$node}{"open"};
}

sub total_open {
  my $self = shift;

  my $open = 0;

  for my $node (keys %$self) {
    if ($self->is_open($node)) {
      $open++;
    }
  }
  return $open;
}

sub display_open {
  my ($self, $grid_size) = @_;

  for my $node (1 .. ($grid_size * $grid_size)) {
    if ($self->is_open($node)) {
      print " #";
    } else {
      print " .";
    }
    print "\n" if ($node % $grid_size == 0);
  }
  print "\n";
}

1;

