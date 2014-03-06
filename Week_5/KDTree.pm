package KDTree;

use strict;
use warnings;

use Point;
use POSIX qw(floor);
use Data::Dumper;

sub new {
  my ($class, %points ) = @_;

  my @points = map { [$_, $points{$_}] } keys %points;
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

  my ($point, $distance) = _nearest_neighbor($self->{root}, $x, $y, 0);
  print _distance($x,$y,$point->x,$point->y) . "\n";
  return $point;
}

sub _nearest_neighbor {
  my ($point, $x, $y, $axis) = @_;

  return if (!$point);

  my $distance = _distance($x, $y, $point->x, $point->y);

  if (!$point->left && !$point->right) { # Leaf case
    return ($point, $distance);
  }
  my $test_value = $axis ? $point->x : $point->y;
  my $comparison_value = $axis ? $x : $y;

  my $other_point;
  my $go_down_point;

  if ($comparison_value < $test_value) {
    $other_point = $point->right;
    if ($point->left) {
      $go_down_point = $point->left;          # Go left
    } else {
      return ($point, $distance);
    }
  } else {
    $other_point = $point->left;
    if ($point->right) {
      $go_down_point = $point->right;    # Go right
    } else {
      return ($point, $distance);
    }
  }

  my ($point1, $point1_distance) = _nearest_neighbor($go_down_point, $x, $y, (($axis + 1) % 2));

  if (($distance < $point1_distance)) {
    if ($other_point) {
      my $v = $axis ? $point->x : $point->y;
      if (1) {
        my ($point2, $point2_distance) = _nearest_neighbor($other_point, $x, $y, (($axis + 1) % 2));
        if ($point2_distance < $distance) {
          return ($point2, $point2_distance);
        }
      }
    }
    return ($point, $distance);
  } else { 
    if ($other_point) {
      my $v = $axis ? $point1->x : $point1->y;
      if (1) {
        my ($point2, $point2_distance) = _nearest_neighbor($other_point, $x, $y, (($axis + 1) % 2));
        if ($point2_distance < $point1_distance) {
          return ($point2, $point2_distance);
        }
      }
    }   
    return ($point1, $point1_distance);
  }
}

sub _distance {
  my ($x1, $y1, $x2, $y2) = @_;

  return sqrt((($x1-$x2)**2) + (($y1-$y2)**2));
}

1;
