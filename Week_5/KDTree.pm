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
  print Dumper($points);

  if (@$points == 0) {return;}

  if (scalar(@$points) == 1) {
    return Point->new($points->[0][0], $points->[0][1]);
  }

  my $point;
  my $median = _find_median($axis, $points);

  $point->{x} = $points->[$median][0];
  $point->{y} = $points->[$median][1];

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

  if ($axis) {  # Vertical. Sort by x.
    @$points = sort { $a->[0] <=> $b->[0] } @$points;
  } else {
    @$points = sort { $a->[1] <=> $b->[1] } @$points;
  }
  print Dumper($points);
}

1;
