package KDTree;

use strict;
use warnings;
no warnings 'recursion';

use Point;
use POSIX qw(floor);
use Data::Dumper;
use Math::Trig qw/great_circle_distance deg2rad/;

sub new {
  my ($class, @points) = @_;

  my $tree = _build_tree(@points);
  return bless $tree, $class;
}

sub _build_tree {
  my @points = @_;
  my %tree;

  $tree{root} = _construct_kd_tree(0, \@points);
  return \%tree;
}

sub _construct_kd_tree {
  my ($axis, $points) = @_;

  if (@$points == 0) {return;}

  if (scalar(@$points) == 1) {
    return Point->new($points->[0][0], $points->[0][1]);
  }

  _sort_points($axis, $points);
  my $median = _find_median($axis, $points);
  my $point = Point->new($points->[$median][0], $points->[$median][1]);

  $axis = ($axis + 1) % 2;
  my $end = scalar(@$points) - 1;
  $point->{left} = _construct_kd_tree($axis,[@$points[0 .. ($median - 1)]]);
  $point->{right} = _construct_kd_tree($axis, [@$points[($median + 1) .. $end]]);
  return $point;
}

sub _find_median {
  my ($axis, $points) = @_;

  my $median = floor(scalar(@$points) / 2);

  if ($axis) {  # X axis
    if ($points->[$median][1] < $points->[0][1]) {
      return $median++;
    }
  } else {   # Y axis
    if ($points->[$median][0] < $points->[0][0]) {
      return $median++;
    }
  }
  return $median;
}

sub _sort_points {
  my ($axis, $points) = @_;

  if ($axis) {
    @$points = sort { $a->[1] <=> $b->[1] } @$points;
  } else {
    @$points = sort { $a->[0] <=> $b->[0] } @$points;
  }
}

sub insert {
  my ($self, $y, $x) = @_;

  $self->{root} = $self->_put($self->{root}, $x, $y, 0);
}

sub _put {
  my ($self, $point, $x, $y, $axis) = @_;

  if (!$point) {
    return Point->new($x, $y);
  }

  if ($axis) {
    if ($x < $point->x) {
      $point->{left} = $self->_put($point->left, $x, $y, $axis);
    } else {
      $point->{right} = $self->_put($point->right, $x, $y, $axis);
    }
  } else {
    if ($y < $point->y) {
      $point->{left} = $self->_put($point->left, $x, $y, $axis);
    } else {
      $point->{right} = $self->_put($point->right, $x, $y, $axis);
    }
  }
  return $point;
}

sub radius_search {
  my ($self, $x, $y, $radius) = @_;
  my @points;

  while (1) {
    my ($point, $distance) = _nearest_neighbor($self->{root}, $x, $y, 0);
    if ($distance < $radius) {
      push @points, $point;
      $point->{seen} = 1;
    } else {
      last;
    }
  }

  for my $point (@points) {  # Unmark
    $point->{seen} = undef;
  }
  return @points;
}
    

sub find_neighbors {
  my ($self, $x, $y, $start, $end) = @_;
  my @points;

  for (1 .. $end) {
    my ($point, $distance) = _nearest_neighbor($self->{root}, $x, $y, 0);
      last unless ($point);
    if ($_ >= $start) {
      push @points, $point;
    }
    $point->{seen} = 1;  # Mark
  }

  for my $point (@points) {  # Unmark
    $point->{seen} = undef;
  }

  return @points;
}

sub find_neighbor {
  my ($self, $x, $y) = @_;

  return _nearest_neighbor($self->{root}, $x, $y, 0);
}

sub _nearest_neighbor {
  my ($point, $x, $y, $axis, $best_point, $best_distance) = @_;
  my $current_point_distance = geo_distance($x, $y, $point->y, $point->x);

  if (!$best_point && !$point->seen) {  # Set best to root if we haven't seen it
    $best_point = $point;
    $best_distance = $current_point_distance;
  }

  if (!$point->seen && ($best_distance > $current_point_distance)) {  # Set best to current position if closer
    $best_point = $point;
    $best_distance = $current_point_distance;
  }

  if (!$point->left && !$point->right) {        # Leaf case
    return ($best_point, $best_distance);
  }

  my $point_value = $axis ? $point->x : $point->y;
  my $seeking_value = $axis ? $x : $y;

  my $other_child;     
  my $next_child;     # The most likely place for closer point

  if ($point_value > $seeking_value) {
    $other_child = $point->right;
    if ($point->left) {
      $next_child = $point->left;          # Go left if we can
    }
  } else {
    $other_child = $point->left;
    if ($point->right) {
      $next_child = $point->right;    # Go right if we can
    }
  }

  if ($next_child) {
    my ($next_point, $next_distance) = _nearest_neighbor($next_child, $x, $y, (($axis + 1) % 2), $best_point, $best_distance);
    if ($next_point && !$next_point->seen) {
      $best_point = $next_point;
      $best_distance = $next_distance;
    }
  }

  my $other_check;

  if ($best_distance && (abs($point_value - $seeking_value) < $best_distance) && $other_child) {  # Closer point could be on the other branch
    $other_check = 1;
    my ($contender, $contender_distance) = _nearest_neighbor($other_child, $x, $y, (($axis + 1) % 2), $best_point, $best_distance);
    if (($contender_distance < $best_distance) && !$contender->seen) {
      $best_point = $contender;
      $best_distance = $contender_distance;
    }
  }

  if (!$other_check && !$best_point && $other_child) { # Force going down the other side if we don't have a best
    return _nearest_neighbor($other_child, $x, $y, (($axis + 1) % 2), $best_point, $best_distance);
  }

  return ($best_point, $best_distance);
}

sub NESW { deg2rad($_[0]), deg2rad(90 - $_[1]) }

sub geo_distance {
  my ($lat1, $long1, $lat2, $long2) = @_;

  my @one = NESW($long1, $lat1);
  my @two = NESW($long2, $lat2);

  my $distance = great_circle_distance(@one, @two, 6378);
  return ($distance * 0.621371);
}

1;
