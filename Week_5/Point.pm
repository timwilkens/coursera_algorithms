package Point;

use strict;
use warnings;

sub new {
  my ($class, $x, $y, $axis) = @_;

  my %self;
  $self{x} = $x;
  $self{y} = $y;
  $self{left} = undef;
  $self{right} = undef;
  $self{seen} = undef;

  return bless \%self, $class;
}

sub right {shift->{right};}
sub left  {shift->{left};}
sub x   {shift->{x};}
sub y {shift->{y};}
sub seen{shift->{seen};}

1;

