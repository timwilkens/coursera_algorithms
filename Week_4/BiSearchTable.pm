package BiSearchTable;

use strict;
use warnings;

sub new {
  my ($class, @args) = @_;

  my %self;
  $self{keys} = [];
  $self{values} = [];

  my $thing = bless \%self, $class;

  if ((scalar(@args) % 2) != 0) {
    die "Mismatched arguments!\n";
  }

  while (@args) {
    my $value = pop @args;
    my $key = pop @args;
    $thing->insert($key, $value);
  }
  return $thing;
}

sub get {
  my ($self, $key) = @_;
 
  if ($self->is_empty){
    return undef;
  }
        
  my $index = $self->_search($key);
  if (($index < scalar @{$self->{keys}}) && ($self->{keys}[$index] == $key)){ 
    return $self->{values}[$index];
  } else { 
    return undef;
  }
}

sub insert { 
  my ($self, $key, $value) = @_;

  if (scalar(@{$self->{keys}} == 0)) {
    $self->{keys}[0] = $key;
    $self->{values}[0] = $value;
    return;
  }
   
  my $i = $self->_search($key);

  splice(@{$self->{keys}}, $i, 0, $key);
  splice(@{$self->{values}}, $i, 0, $value);
}

sub is_empty {!defined shift->{keys}[0];}

sub _search {
  my ($self, $key) = @_;

  if (scalar@{$self->{keys}} == 1) {return 0};

  my $low = 0;
  my $high = scalar(@{$self->{keys}} - 1);

  while ($low <= $high) {
    my $mid = $low + int(($high - $low) / 2);
    if ($self->{keys}[$mid] > $key) {
      $high = $mid - 1;
    } elsif ($self->{keys}[$mid] < $key) {
      $low = $mid + 1;
    } else {
      return $mid;
    }
  }
  return $low;
}

1;

