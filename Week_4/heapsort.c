#include <stdio.h>

static void swap (int nums[], int i, int j);
static void shuffle (int nums[], int length); 
static void prettyPrint (int nums[], int length);
static void heapify (int nums[], int length);
static void sortdown (int nums[], int length);
static void sink (int nums[], int k, int length);

void heapsort (int nums[], int length);

#define MAX 200

int main (void)
{

  int nums[MAX];
  int i;
  for (i = 0; i < MAX; i++) {
    nums[i] = i;
  }

  int length = sizeof(nums)/sizeof(nums[0]);

  shuffle(nums, length);
 
  heapsort(nums, length);
  prettyPrint(nums, length);

  return 0;
}

void heapsort (int nums[], int length)
{
  heapify(nums, length);
  prettyPrint(nums, length);
  sortdown(nums, length);
}

static void heapify (int nums[], int length) 
{
  int k = length;
  for (k /= 2; k >= 1; k--) {
    sink(nums, k, length);
  }
}

static void sortdown (int nums[], int length)
{
  int temp = length;
  while (length > 1) {
    swap(nums, 1, length--);
    sink(nums, 1, length);
  }
}

static void sink (int nums[], int k, int length)
{
  while ((2 * k) <= length) {
    int j = (2 * k);

    if (((j - 1) < (length - 1)) && (nums[j - 1] < nums[j]))
      j++;   // the right child is larger

    if (nums[k - 1] > nums[j - 1])
      break;

    swap(nums, j, k);
    k = j;
  }
}

static void swap (int nums[], int i, int j)
{
  int temp = nums[(i - 1)];
  nums[(i - 1)] = nums[(j - 1)];
  nums[(j - 1)] = temp;
}

static void shuffle (int nums[], int length) 
{
  srand(time(NULL));

  int i;
  for (i = 1; i <= (length - 1); i++) {
    int r = rand();
    r = (r % (i + 1));
    int temp = nums[i];
    nums[i] = nums[r];
    nums[r] = temp;
  }
}

static void prettyPrint (int nums[], int length)
{
  int i;
  for (i = 0; i < length; i++) {
    printf("%d ", nums[i]);
  }
  printf("\n");
}
