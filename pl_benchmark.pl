#! /usr/bin/perl
# Benchmark.


use strict;


sub rstr($) {
   return pack 'C*', map int rand 1 << 8, 1 .. shift;
}


my $n= 1e4;
my($s0, $s1, $s2);
srand 42;
my $f1= rstr 3;
my $f2= rstr 3;
my $r11= join '|', 'AAA' .. 'MMM';
my $r12= join '|', 'NNN' .. 'ZZZ';
my $r21= qr/$r11/;
my $r22= qr/$r12/;
$s0= time;
for (1 .. $n) {
   die if $f1 =~ /$r11/;
   die if $f2 =~ /$r12/;
}
$s1= time;
for (1 .. $n) {
   die if $f1 =~ /$r21/;
   die if $f2 =~ /$r22/;
}
$s2= time;
printf "r1: %u\nr2: %u\n", $s1 - $s0, $s2 - $s1;
