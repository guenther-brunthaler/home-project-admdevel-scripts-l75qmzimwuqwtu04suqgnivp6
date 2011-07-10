#! /usr/bin/perl
@p= qw/x x x M M/;
for ($n= 1;;) {
   for ($i= $#p;; --$i) {
      if ($p[$i] eq 'x') {
         $p[$i]= 'M';
         last;
      }
      else {
         $p[$i]= 'x';
         exit if $i == 0;
      }
   }
   if (grep(/M/, @p) >= 2) {
      printf "%2u: %s\n", $n++, join '', @p;
   }
}
