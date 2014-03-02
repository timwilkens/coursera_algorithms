package BST;

use strict;
use warnings;

use Node;

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

