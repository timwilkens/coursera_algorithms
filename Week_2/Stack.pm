package Stack;

use strict;
use warnings;

sub new {
  my $class = shift;
  my @self;

  return bless \@self, $class;
}

sub push {
  my ($self, $item) = @_;
  unshift @$self, $item;
}

sub pop {
  my $self = shift;
  die "Stack is empty!\n" if ($self->is_empty());
  return shift @$self;
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

