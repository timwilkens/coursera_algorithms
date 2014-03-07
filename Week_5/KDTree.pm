package KDTree;

use strict;
use warnings;
no warnings 'recursion';

use Point;
use POSIX qw(floor);

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

  my $median = _find_median($axis, $points);
  my $point = Point->new($points->[$median][0],$points->[$median][1]);

  $axis = ($axis + 1) % 2;
  $point->{left} = _construct_kd_tree($axis,[@$points[0 .. ($median - 1)]]);
  $point->{right} = _construct_kd_tree($axis, [@$points[($median + 1) .. (scalar(@$points) - 1)]]);
  return $point;
}

sub _find_median {
  my ($axis, $points) = @_;

  _sort_points_by_axis($axis, $points);

  my $median = floor(scalar(@$points) / 2);

  if ($axis) {

    if ($points->[$median][0] < $points->[0][0]) {
      return $median++;
    }
  } else {
    if ($points->[$median][1] < $points->[0][1]) {
      return $median++;
    }
  }
  return $median;
}

sub _sort_points_by_axis {
  my ($axis, $points) = @_;

  if ((@$points == 1) || (@$points == 0)) {return;}  

  if ($axis) {
    @$points = sort { $a->[0] <=> $b->[0] } @$points;
  } else {
    @$points = sort { $a->[1] <=> $b->[1] } @$points;
  }
}

sub insert {
  my ($self, $x, $y) = @_;

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

sub find_neighbor {
  my ($self, $x, $y) = @_;

  return _nearest_neighbor($self->{root}, $x, $y, 0);
}

sub _nearest_neighbor {
  my ($point, $x, $y, $axis) = @_;

  my $current_point_distance = _distance($x, $y, $point->x, $point->y);

  if (!$point->left && !$point->right) { # Leaf case
    return ($point, $current_point_distance);
  }

  my $point_value = $axis ? $point->x : $point->y;
  my $seeking_value = $axis ? $x : $y;

  my $other_child;
  my $next_child;

  if ($point_value < $seeking_value) {
    $other_child = $point->right;
    if ($point->left) {
      $next_child = $point->left;          # Go left
    }
  } else {
    $other_child = $point->left;
    if ($point->right) {
      $next_child = $point->right;    # Go right
    }
  }

  my $return_point;
  my $best_distance;

  if ($next_child) {
    ($return_point, $best_distance) = _nearest_neighbor($next_child, $x, $y, (($axis + 1) % 2));
  }

  if ((!$return_point && !$best_distance) || ($current_point_distance < $best_distance)) {
    $return_point = $point;
    $best_distance = $current_point_distance;
  }


  if ((abs($point_value - $seeking_value) < $best_distance) && $other_child) {  # Closer point could be on the other branch
    my ($contender, $contender_distance) = _nearest_neighbor($other_child, $x, $y, (($axis + 1) % 2));
    if ($contender_distance < $best_distance) {
      $return_point = $contender;
      $best_distance = $contender_distance;
    }
  }

  return ($return_point, $best_distance);
}

sub _distance {
  my ($x1, $y1, $x2, $y2) = @_;

  return sqrt((($x1-$x2)**2) + (($y1-$y2)**2));
}

1;
