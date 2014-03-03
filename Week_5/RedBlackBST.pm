package RedBlackBST;

use strict;
use warnings;
no warnings 'recursion';

use Node;
use Storable qw(dclone);
use Data::Dumper;

sub new {
  my ($class, $key, $value) = @_;

  my $root;
  if ($key && $value) {
    $root = Node->new($key, $value);
  }

  my %self;
  $self{root} = $root;

  return bless \%self, $class;
}

sub set_root {$_[0]->{root} = $_[1];}

sub root {shift->{root};}

sub find {
  my ($self, $key) = @_;
  my $node = $self->root;

  while ($node) {
    if ($key < $node->key) {
      $node = $node->left;
    } elsif ($key > $node->key) {
      $node = $node->right;
    } else {
      return $node->value;
    }
  }
  return undef;
}

sub insert {
  my ($self, $key, $value) = @_;

  if (!$self->root) {
    my $root = Node->new($key, $value);
    $self->set_root($root);
    return;
  }
  
  my $new_root = $self->_put($self->root, $key, $value);
  if ($new_root) {
    $self->set_root($new_root);
  }
}

sub _put {
  my ($self, $node, $key, $value) = @_;

  if (!$node) {
    return Node->new($key, $value, 'RED');
  }

  if ($node->key > $key) {
    my $left = $self->_put($node->left, $key, $value);
    $node->set_left($left);
  } elsif ($node->key < $key) {
    my $right = $self->_put($node->right, $key, $value);
    $node->set_right($right);
  } else {
    $node->set_value($value);
  }

  if (($node->right && $node->right->is_red) && (!$node->left || !$node->left->is_red)) {
    $node = $self->_rotate_left($node); 
  }
   
  if ($node->left && $node->left->left) {
    if ($node->left->is_red && $node->left->left->is_red) {
      $node = $self->_rotate_right($node);
    }
  }
   
  if ($node->right && $node->left) { 
    if ($node->left->is_red && $node->right->is_red) {
      $self->_color_flip($node);
    }
  }
  return $node;
}

sub _rotate_left {
  my ($self, $node) = @_;

  my $clone = dclone($node->right);
  $node->set_right($clone->left);
  $clone->set_left($node);
  $clone->set_color($node->color);
  $node->set_color('RED');
  return $clone;
}

sub _rotate_right {
  my ($self, $node) = @_;

  my $clone = dclone($node->left);
  $node->set_left($clone->right);
  $clone->set_right($node);
  $clone->set_color($node->color);
  $node->set_color('RED');
  return $clone;
}

sub _color_flip {
  my ($self, $node) = @_;

  $node->set_color('RED');
  $node->left->set_color('BLACK');
  $node->right->set_color('BLACK');
}

sub get_keys {   # Returns keys in ascending order
  my $self = shift;
  my @keys;
  $self->_add_on_keys($self->root, \@keys);

  return @keys;
}

sub _add_on_keys {
  my ($self, $node, $keys) = @_;

  if (!$node) {
    return;    # end of a branch
  }

  $self->_add_on_keys($node->left, $keys);
  push @$keys, $node->key;    # switch to unshift and get them in reverse order
  $self->_add_on_keys($node->right, $keys);
}

1;

