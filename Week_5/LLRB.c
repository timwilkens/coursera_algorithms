#include <stdio.h>
#include <stdlib.h>

// This is just a BST for now, with no rebalancing

struct Node;
struct RedBlack;

int isRed (struct Node *node);
struct RedBlack* new_tree (); 
static struct Node* new_node (int key, int value, int color);
void insert (struct RedBlack *tree, int key, int value);
static struct Node* put (struct Node *node, int key, int value);

struct Node
{
  int color;  // Let Red be 1 to allow easy color checking via isRed
  int key;
  int value;
  struct Node *left;
  struct Node *right;
};

struct RedBlack
{
  struct Node *root;
};

int main (void)
{
  struct RedBlack *tree = new_tree();
  insert(tree, 2, 100);
  insert(tree, 5, 5);
  insert(tree, 7, 7);
  insert(tree, 1, -100);
  printf("Second right child key: %d and value: %d\n", tree->root->right->right->key, tree->root->right->right->value);
  printf("First left child key: %d and value: %d\n", tree->root->left->key, tree->root->left->value);
  return 0;
}

struct RedBlack* new_tree () 
{
  struct RedBlack *tree = malloc(sizeof(struct RedBlack));
  return tree;
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

int isRed (struct Node *node)
{
  return node->color;
}

void insert (struct RedBlack *tree, int key, int value)
{
  tree->root = put(tree->root, key, value);
}

static struct Node* put (struct Node *node, int key, int value)
{
  if (node == NULL) {
    struct Node *temp_node = new_node(key, value, 1);
    return temp_node;
  }

  if (node->key > key) {
    node->left = put(node->left, key, value);
  } else if (node->key < key) {
    node->right = put(node->right, key, value);
  } else {
    node->value = value;
  }
  return node;
}
