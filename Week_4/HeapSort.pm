package HeapSort;

use strict;
use warnings;
use POSIX qw(floor);

sub new {
  my ($class, @nums) = @_;
  my %self;
  $self{heap} = \@nums;
  $self{size} = scalar(@nums);
  
  return bless \%self, $class;
}

sub heapsort {
  my $self = shift;

  $self->_heapify();
  $self->_sortdown();

  return @{$self->{heap}};
}

sub _heapify {
  my $self = shift;
  my $n = $self->size();

  for (my $k = $n/2; $k >= 1; $k--) {
    $self->_sink($k);
  }
}

sub _sortdown {
  my $self = shift;

  while ($self->{size} > 1) {
    $self->_swap(1, $self->{size}--);
    $self->_sink(1, $self->{size});
  }
}

sub insert {
  my ($self, $item) = @_;

  push @{$self->{heap}}, $item;
  $self->_swim(($self->size() - 1));
}

sub delete_max {
  my $self = shift;

  $self->_swap(1, ($self->size() - 1));
  my $max = pop @{$self->{heap}};
  $self->_sink(1);
  return $max;
}

sub is_empty {
  my $self = shift;
  return (scalar(@$self) == 0);
}

sub size {
  return shift->{size};
}

sub _sink {
  my ($self, $k) = @_;
  my $n = $self->size();

  while ((2 * $k) <= $n) {    # don't go off the end of the heap
    my $j = (2 * $k);

    if ((($j - 1) < ($n - 1)) && ($self->{heap}[($j - 1)] < $self->{heap}[$j])) {
      $j++;
    }

    if ($self->{heap}[($k - 1)] > $self->{heap}[($j - 1)]) {
      last;
    }

    $self->_swap($j, $k);
    $k = $j;
  }
}

sub _swim {
  my ($self, $k) = @_;

  while (($k > 1) && ($self->{heap}[($k - 1)] > $self->{heap}[(floor($k / 2) - 1)])) {
    $self-> _swap($k, int($k / 2));
    $k = floor($k / 2);
  }
}


sub _swap {
  my ($self, $i, $j) = @_;

  my $temp = $self->{heap}[($i - 1)];
  $self->{heap}[($i - 1)] = $self->{heap}[($j - 1)];
  $self->{heap}[($j - 1)] = $temp;
}


1;

