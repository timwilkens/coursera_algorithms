package PQ;

use strict;
use warnings;
use POSIX qw(floor);

sub new {
  my $class = shift;
  my @self;
  $self[0] = undef;  # Don't use index 0
  
  return bless \@self, $class;
}

sub insert {
  my ($self, $item) = @_;

  push @$self, $item;
  $self->_swim((scalar(@$self) - 1));
}

sub delete_max {
  my $self = shift;

  $self->_swap(1, (scalar(@$self) - 1));
  my $max = pop @$self;
  $self->_sink(1);
  return $max;
}

sub is_empty {
  my $self = shift;
  return (scalar(@$self) == 1);   # don't touch index 0
}

sub size {
  my $self = shift;
  return scalar(@$self) - 1;
}

sub _sink {
  my ($self, $k) = @_;
  my $n = scalar(@$self) - 1;

  while ((2 * $k) <= $n) {    # don't go off the end of the heap
    my $j = (2 * $k);

    if (($j < $n) && ($self->[$j] < $self->[$j+1])) {
      $j++;
    }

    if ($self->[$k] > $self->[$j]) {
      last;
    }

    $self->_swap($j, $k);
    $k = $j
  }
}

sub _swim {
  my ($self, $k) = @_;

  while (($k > 1) && ($self->[$k] > $self->[floor($k / 2)])) {
    $self-> _swap($k, int($k / 2));
    $k = floor($k / 2);
  }
}


sub _swap {
  my ($self, $i, $j) = @_;

  my $temp = $self->[$i];
  $self->[$i] = $self->[$j];
  $self->[$j] = $temp;
}


1;

