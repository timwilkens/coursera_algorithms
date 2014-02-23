#include <stdio.h>

static void swap (int nums[], int i, int j);
static void prettyPrint (int nums[], int length);
static void shuffle (int nums[], int length);
static void sort (int nums[], int low, int high);
static void insertion_sort (int nums[], int low, int high);

void quicksort (int nums[], int length);

int main (void)
{
  int nums[] = { 100, 3983, 839, 93, 738, 9230, 993, 2, 4, 23, 43, 53, 10, 9, 8, 7, 5, 5, 10, 9, 3, 4, 5, 6, 6, 5, 4, 3, 2, 1 };
  int length = sizeof(nums) / sizeof(nums[0]);

  prettyPrint(nums, length);
  quicksort(nums, length);
  prettyPrint(nums, length);

  return 0;
}

void quicksort (int nums[], int length)
{
  shuffle(nums, length);
  sort(nums, 0, (length - 1));
}

static void sort (int nums[], int low, int high)
{

  if (high <= (low + 10)) {
    insertion_sort(nums, low, high);
    return;
  }

  int first = low;
  int second = high;
  int pivot = nums[low];
  int i = low;

  while (i <= second) {
    if (nums[i] < pivot) {
      swap(nums, i++, first++);
    } else if (nums[i] > pivot) {
      swap(nums, i, second--);
    } else {
      i++;
    }
  }
  sort(nums, low, (first - 1));
  sort(nums, (second + 1), high);
}

static void shuffle (int nums[], int length) 
{
  srand(time(NULL));

  int i;
  for (i = 1; i <= (length - 1); i++) {
    int r = rand();
    r = (r % (i + 1));
    swap(nums, r, i);
  }
}

static void insertion_sort (int nums[], int low, int high)
{
  int i, j;

  for (i = low; i <= high; i++) {
    for (j = i; j > 0; j--) {
      if (nums[j] < nums[j - 1]) {
        swap(nums, j, (j - 1));
      }
    }
  }
}

static void swap (int nums[], int i, int j) 
{
  int temp = nums[i];
  nums[i] = nums[j];
  nums[j] = temp;
}

static void prettyPrint (int nums[], int length)
{
  int i;
  for (i = 0; i < length; i++) {
    printf("%d ", nums[i]);
  }
  printf("\n");
}
