#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SIZE 25

void merge_sort(int nums[], int length, int low, int high);
static void swap(int *x, int *y);
static void insertion_sort(int nums[], int low, int high);
static void merge (int nums[], int length, int low, int mid, int high);
static void print_nums (int nums[], int length);

int main(void)
{

  time_t t;
  srand((unsigned) time(&t));

  int nums[SIZE], i;
  for (i = 0; i < SIZE; i++) {
    nums[i] = rand() % 100;
  }

  int length = sizeof(nums) / sizeof(nums[0]);

  print_nums(nums, length);
  merge_sort(nums, length, 0, (length - 1));
  print_nums(nums, length);

  return 0;
}

void merge_sort (int nums[], int length, int low, int high)
{
  if (high <= low + 5) {
    insertion_sort(nums, low, high);
    return;
  }

  int mid = low + ((high - low) / 2);

  merge_sort(nums, length, low, mid);
  merge_sort(nums, length, (mid + 1), high);

  merge(nums, length, low, mid, high);

}

static void merge (int nums[], int length, int low, int mid, int high)
{

  int copy[length], i;

  for (i = 0; i < length; i++) {
    copy[i] = nums[i];
  }

  int first = low;
  int second = mid + 1;
  int k;

  for (k = low; k <= high; k++) {
    if (first > mid) {
      nums[k] = copy[second++];
    } else if (second > high) {
      nums[k] = copy[first++];
    } else if (copy[second] < copy[first]) {
      nums[k] = copy[second++];
    } else {
      nums[k] = copy[first++];
    }
  }
}

static void insertion_sort (int nums[], int low, int high)
{
  int i, j;

  for (i = low; i <= high; i++) {
    for (j = i; j > 0; j--) {
      if (nums[j] < nums[j - 1]) {
        swap(&(nums[j]), &(nums[j - 1]));
      }
    }
  }
}

static void swap (int *x, int *y)
{
  int temp = *x;
  *x = *y;
  *y = temp;
}

static void print_nums (int nums[], int length)
{
  int i;

  for (i = 0; i < length; i++) {
    printf("%d ", nums[i]);
  }
  printf("\n");
}
