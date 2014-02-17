#!/usr/bin/perl

use strict;
use warnings;

use Point;
use Stack;
use Math::Trig ':radial';

use Data::Dumper;

my $hull = Stack->new;

my @points;
push @points, Point->new(0,0);
push @points, Point->new(4,4);
push @points, Point->new(2,6);
push @points, Point->new(0,8);
push @points, Point->new(-2,6);
push @points, Point->new(-4,4);
push @points, Point->new(-2,2);
push @points, Point->new(0,5);

my $p_index = find_p(\@points);  # lowest point on the y axis
my ($xshift, $yshift) = normalize_points($p_index, \@points); # shift all so p is at 0,0

@points = order_points(@points); # get array of points ordered by polar angle

$hull->push($points[0]);   # this is the first point in our trace. goes on the stack
$hull->push($points[1]);   # this point has to go on our stack

# This does not handle linear points well. 
# If the first three points form a line with a positive slope,
# it will fail the counter clockwise test, and try to remove an element from our hull
# which then results in testing on undefined values => death.


for (my $i = 2; $i < scalar @points; $i++) {
  my $top = $hull->pop();
  while (is_ctrclockwise_turn($hull->peek(), $top, $points[$i]) <= 0) {
    $top = $hull->pop();
  }
  $hull->push($top);   # put our test back in
  $hull->push($points[$i]);  # put the successful element in
}

show_hull($hull);

sub show_hull {
  my $hull = shift;
  my @points;

  while (!$hull->is_empty) {
    unshift @points, $hull->pop(); # quadratic time
  }
  for my $point (@points) {
    my $x = $point->x - $xshift;
    my $y = $point->y - $yshift;
    print "($x , $y)\n";
  }
}

sub is_ctrclockwise_turn {
  my ($a, $b, $c) = @_;

  my $area = (($b->x - $a->x) * ($c->y - $a->y)) - (($b->y - $a->y) * ($c->x - $a->x));

  if ($area < 0) {
    return -1;
  } elsif ($area > 0) {
    return 1;
  } else {
    return 0;
  }
}

sub order_points { # return new array sorted by polar angle relative to p point
  my @points = @_;
  my %angles;

  for (0 .. (scalar @points - 1)) {
    $angles{$_} = polar_angle($points[$_]);
  }

  my @ordered = sort { $angles{$a} <=> $angles{$b} } keys %angles;
  for (0 .. $#ordered) {
    my $point_location = $ordered[$_];
    $ordered[$_] = $points[$point_location];
  }
  return @ordered;
}

sub polar_angle {
  my $point = shift;

  my $x = $point->x;
  my $y = $point->y;

  my (undef, $angle, undef) = cartesian_to_spherical($x, $y, 0);
  return $angle;
}

sub normalize_points {
  my ($p_index, $points) = @_;
  my $point = $points->[$p_index];

  my $x = $point->x;
  my $y = $point->y;
  return (0,0) if ($x == 0 && $y == 0);

  $x -= (2 * $x); # our translation
  $y -= (2 * $y);

  for (@$points) {
    my $this_x = $_->x;
    my $this_y = $_->y;

    $this_x += $x;
    $this_y += $y;
  
    $_->set_x($this_x);
    $_->set_y($this_y);
  }
  return $x,$y;
}

sub find_p { # returns the index of the point with the smallest y value
  my $points = shift;

  my $min = 0;

  for (0 .. (scalar @$points - 1)) {
    $min = $_ if (($points->[$_]->y <= $points->[$min]->y) && $points->[$_]-> x < $points->[$min]->y);
  }
  return $min;
}
