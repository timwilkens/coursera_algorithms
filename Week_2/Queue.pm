package Queue;

use strict;
use warnings;

sub new {
  my $class = shift;
  my @self;

  return bless \@self, $class;
}

sub enqueue {
  my ($self, $item) = @_;
  unshift @$self, $item;
}

sub dequeue {
  my $self = shift;
  die "Queue is empty!\n" if ($self->is_empty());
  return pop @$self;
}

sub is_empty {
  my $self = shift;
  if (defined $self->[0]) {
    return 0;
  } else {
    return 1;
  }
}

1;

