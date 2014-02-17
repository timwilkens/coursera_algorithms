package Point;

use strict;
use warnings;

sub new {
  my ($class,$x,$y) = @_;

  die "You must provide x and y\n" unless (defined $x && defined $y);
  
  my %self = ( x => $x, y => $y );
  return bless \%self, $class;
}

sub x { return $_[0]->{x}; }
sub y { return $_[0]->{y}; }

sub set_x { $_[0]->{x} = $_[1] }
sub set_y { $_[0]->{y} = $_[1] }

1;

