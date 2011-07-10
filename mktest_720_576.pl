#! /usr/bin/perl
# Creates a raw 8-bit gray test bitmap (colors 0 and 0xff only)
# consisting of a 720 x 576 image that can be used to test
# raster line integrity when converting video formats.


sub draw($$) {
 my($c, $v)= @_;
 return if $c == 0;
 print OUT chr($v ? 0xff : 0) x $c;
}


use strict;
open OUT, '>test.raw' or die;
binmode OUT or die;
my($x, $y, $x0, $x1, $x2, $x3, $x4, $x5, $x6, $x7, $x8);
my($t)= (16);
($x0, $x7, $x8)= (0, 720, 0);
$x= $x0 + $x7 >> 1;
($x3, $x4)= ($x - ($t >> 1), $x + ($t - ($t >> 1)));
for ($y= 0; $y < 576; ++$y) {
 $x= ($y >> 1) % ($x3 - $x0 - $t - 2);
 $x2= ($x1= $x0 + $x + 1) + $t;
 $x5= ($x6= $x7 - $x - 1) - $t;
 draw $x0, 0;
 if ($y % 2 == 0) {
  draw $x1 - $x0, 1;
  draw $x2 - $x1, 0;
  draw $x3 - $x2, 1;
 }
 else {
  draw $x3 - $x0, 0;
 }
 draw $x4 - $x3, 0;
 if ($y % 2 == 0) {
  draw $x7 - $x4, 0;
 }
 else {
  draw $x5 - $x4, 1;
  draw $x6 - $x5, 0;
  draw $x7 - $x6, 1;
 }
 draw $x8, 0;
}
close OUT or die;
