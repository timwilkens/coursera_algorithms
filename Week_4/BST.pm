package BST;

use strict;
use warnings;

use Node;
use Storable qw(dclone);
use Data::Dumper;

sub new {
  my ($class, $key, $value) = @_;

  die "Provide key and value for root element\n" unless ($key && $value);

  my $root = Node->new($key, $value);

  my %self;
  $self{root} = $root;

  return bless \%self, $class;
}

sub set_root {$_[0]->{root} = $_[1];}

sub root {shift->{root};}

sub delete {
  my ($self, $key) = @_;
  my $root = $self->root;
  
  $root = $self->_delete($root, $key);
  $self->set_root($root);
}

sub _delete {
  my ($self, $node, $key) = @_;

  if (!$node) {return undef;}    # Node has no children

  if ($key < $node->key) {
    $node->set_left($self->_delete($node->left, $key));
  } elsif ($key > $node->key) {
    $node->set_right($self->_delete($node->right, $key));
  } else {
    if (!$node->right) {return $node->left;}  # Node has 1 child
    if (!$node->left) {return $node->right;}  # Node has 1 child

    my $temp = dclone($node);
    $node = $self->_min_helper($temp->right);   # Get the smallest node in the right subtree
    $node->set_right($self->_delete_min($temp->right));  # Remove the min and replace
    $node->set_left($temp->left);
  }
  return $node;
}

sub remove_min {
  my $self = shift;  
  $self->_delete_min($self->root);
}

sub _delete_min {
  my ($self, $node) = @_;

  if (!$node->left) {return $node->right;}
  
  $node->set_left($self->_delete_min($node->left));
  return $node;
}

sub min {
  my $self = shift;
  my $root = $self->root;

  my $min = $self->_min_helper($root);
  return $min->key;
}

sub _min_helper {
  my ($self, $node) = @_;

  if (!$node->left) {
    return $node;
  }
  return $self->_min_helper($node->left);
}

# Max could be implemented in exactly the same way as min but going to the right

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
  return undef;   # not found
}

sub insert {
  my ($self, $key, $value) = @_;
  
  my $new_root = $self->_put($self->root, $key, $value);
  if ($new_root) {
    $self->set_root($new_root);
  }  
}

sub _put {
  my ($self, $node, $key, $value) = @_;

  if (!$node) {
    return Node->new($key, $value);
  }

  if ($node->key > $key) {
    $node->set_left($self->_put($node->left, $key, $value));
  } elsif ($node->key < $key) {
    $node->set_right($self->_put($node->right, $key, $value));
  } else {
    $node->set_value($value);
  }
  return $node;
}
 
1;

