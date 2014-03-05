#include <stdio.h>
#include <stdlib.h>

struct Node;
struct Tree;

struct Tree* new_tree ();
static struct Node* new_node (int key, int value, int color);

int is_red (struct Node *node);

struct Node* search (struct Tree *tree, int key);

void insert (struct Tree *tree, int key, int value);
static struct Node* put (struct Node *node, int key, int value);
static struct Node* rotate_left (struct Node *node);
static struct Node* rotate_right (struct Node *node);
static void color_flip (struct Node *node);

struct Node* find_min (struct Tree *tree);
static struct Node* unroll_min (struct Node *node);

struct Node* find_max (struct Tree *tree);
static struct Node* unroll_max (struct Node *node);

void print_tree_keys (struct Tree *tree);
static void unroll_tree (struct Node *node);

void destroy_tree (struct Tree *tree);
void free_node (struct Node *node);

struct Node
{
  int color; // Let Red be 1 to allow easy color checking via is_red
  int key;
  int value;
  struct Node *left;
  struct Node *right;
};

struct Tree
{
  struct Node *root;
};

int main (void)
{
  struct Tree *tree = new_tree();

  int i;
  for (i = 0; i <= 50; i++) {
    insert(tree, i, i + 1);
  }

  print_tree_keys(tree);

  struct Node *min = find_min(tree);
  printf("Min key in tree is %d\n", min->key);

  struct Node *max = find_max(tree);
  printf("Max key in tree is %d\n", max->key);

  printf("Root in tree is %d\n", tree->root->key);

  destroy_tree(tree);

  return 0;
}

struct Tree* new_tree ()
{
  return malloc(sizeof(struct Tree));
}

static struct Node* new_node (int key, int value, int color)
{
  struct Node *node = malloc(sizeof(struct Node));
  node->key = key;
  node->value = value;
  node->color = color;
  node->left = NULL;
  node->right = NULL;
  return node;
}

int is_red (struct Node *node)
{
  if (node == NULL)
    return 0;

  return node->color;
}

struct Node* search (struct Tree *tree, int key)
{
  struct Node *node = tree->root;

  while (node != NULL) {
    if (key < node->key) {
      node = node->left;
    } else if (key > node->key) {
      node = node->right;
    } else {
      return node;
    }
  }
  return NULL;
}

void insert (struct Tree *tree, int key, int value)
{
  tree->root = put(tree->root, key, value);
}

static struct Node* put (struct Node *node, int key, int value)
{
  if (node == NULL) {
    return new_node(key, value, 1);
  }

  if (node->key > key) {
    node->left = put(node->left, key, value);
  } else if (node->key < key) {
    node->right = put(node->right, key, value);
  } else {
    node->value = value;
  }

  if (is_red(node->right) && !is_red(node->left))
    node = rotate_left(node);

  if (is_red(node->left) && is_red(node->left->left))
    node = rotate_right(node);

  if (is_red(node->right) && is_red(node->left))
    color_flip(node);

  return node;
}

static struct Node* rotate_left (struct Node *node)
{
  struct Node *clone = node->right;

  node->right = clone->left;
  clone->left = node;
  clone->color = node->color;
  node->color = 1;
  return clone;
}

static struct Node* rotate_right (struct Node *node)
{
  struct Node *clone = node->left;

  node->left = clone->right;
  clone->right = node;
  clone->color = node->color;
  node->color = 1;
  return clone;
}

static void color_flip (struct Node *node)
{
  node->color = 1;
  node->left->color = 0;
  node->right->color = 0;
}

struct Node* find_min (struct Tree *tree)
{
  return unroll_min(tree->root);
}

static struct Node* unroll_min (struct Node *node)
{
  if (node->left == NULL)
    return node;

  return unroll_min(node->left);
}

struct Node* find_max (struct Tree *tree)
{
  return unroll_max(tree->root);
}

static struct Node* unroll_max (struct Node *node)
{
  if (node->right == NULL)
    return node;

  return unroll_max(node->right);
}

void print_tree_keys (struct Tree *tree)
{
  unroll_tree(tree->root);
  printf("\n");
}

static void unroll_tree (struct Node *node)
{
  if (node == NULL)
    return;

  unroll_tree(node->left);
  printf("%d ", node->key);
  unroll_tree(node->right);
}

void destroy_tree (struct Tree *tree)
{
  free_node(tree->root);
  free(tree);
}

void free_node (struct Node *node)
{
  if (node == NULL)
    return;

  free_node(node->left);
  free_node(node->right);
  free(node);
}
