package Node;

use strict;
use warnings;

sub new {
  my ($class, $key, $value) = @_;

  my %self;
  $self{key} = $key;
  $self{value} = $value;
  $self{left} = undef;
  $self{right} = undef;

  return bless \%self, $class;
}

sub set_right {$_[0]->{right} = $_[1];}
sub set_left  {$_[0]->{left} = $_[1];}
sub set_key   {$_[0]->{key} = $_[1];}
sub set_value {$_[0]->{value} = $_[1];}

sub right {shift->{right};}
sub left  {shift->{left};}
sub key   {shift->{key};}
sub value {shift->{value};}

1;

