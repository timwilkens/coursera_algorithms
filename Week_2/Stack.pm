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
  push @$self, $item;
}

sub pop {
  my $self = shift;
  die "Stack is empty!\n" if ($self->is_empty());
  return pop @$self;
}

sub is_empty {
  my $self = shift;
  return not defined $self->[0];
}

sub peek {
  my $self = shift;
  my $index = (scalar @$self - 1);
  return $self->[$index];
}

1;

