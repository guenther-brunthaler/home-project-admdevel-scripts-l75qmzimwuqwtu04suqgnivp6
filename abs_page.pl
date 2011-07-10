#! /usr/bin/perl
# Reads lines where some start with page numbers from STDIN.
# Adds absolute page numbers to the existing ones,
# which are assumed to be page counts of chapters
# and writes the result to STDOUT.
# $Id: /trunk/Org/SysAdmin/Crossplatform/scripts/abs_page.pl 2645 2006-08-26T07:36:02.660558Z gb  $


$a= 1;
while (defined($_= <>)) {
   s/^(\d+)/$1\t$a/ and $a+= $1 or s/^/\t/;
   print;
}
