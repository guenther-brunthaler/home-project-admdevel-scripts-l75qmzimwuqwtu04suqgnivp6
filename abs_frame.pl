# Reads lines where some start with frame numbers from STDIN.
# Adds absolute frame numbers to the existing ones,
# which are assumed to be sizes of video segments
# and writes the result to STDOUT.
# $Id: /trunk/Org/SysAdmin/Crossplatform/scripts/abs_frame.pl 2645 2006-08-26T07:36:02.660558Z gb  $


$a= 0;
while (defined($_= <>)) {
   s/^(\d+)/$1\t$a/ and $a+= $1 or s/^/\t/;
   print;
}
