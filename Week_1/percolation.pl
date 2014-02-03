#!/usr/bin/perl

use strict;
use warnings;
use WQUPC;

my @results;
my $grid_size = 20;

for (1 .. 100) {
  my $result = run_simulation($grid_size);
  push @results, $result;
}

my $total = 0;
for my $i (@results) {
  $total += $i;
}

my $average = $total / (scalar @results);
print $average / ($grid_size * $grid_size) . "\n";


sub run_simulation {
  my $grid_size = shift;
  my $grid = WQUPC->new($grid_size);
  my %done;

  while (1) {
    my $n = int(rand(($grid_size * $grid_size) - 1)) + 1;  # Between 1 and grid_size squared
    next if (exists $done{$n});
    $done{$n}++;

    $grid->open_node($n);
    
    # To the left
    if ($n != 1 && $grid->is_open($n - 1) && ((($n % $grid_size) - 1) != 0)) {
      $grid->union($n, ($n - 1));
    } 
  
    # To the right
    if ($n != ($grid_size * $grid_size) && $grid->is_open($n + 1) && (($n % $grid_size) != 0)) {
      $grid->union($n, ($n + 1));
    }
  
    # Above
    if ($grid->is_open($n - $grid_size) && ($n > $grid_size)) {
      $grid->union($n, ($n - $grid_size));
    }
  
    # Below
    if ($grid->is_open($n + $grid_size) && ($n <= (($grid_size * $grid_size) - $grid_size))) {
      $grid->union($n, ($n + $grid_size));
    }

    for ((($grid_size * $grid_size) - $grid_size) .. ($grid_size * $grid_size)) {
      if ($grid->connected(0, $_)) {
        $grid->display_open($grid_size);
        return $grid->total_open;
      }
    }
  }
}
