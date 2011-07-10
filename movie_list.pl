#! /usr/bin/perl
# List movies.
# $Id: /trunk/Org/SysAdmin/Crossplatform/scripts/movie_list.pl 2645 2006-08-26T07:36:02.660558Z gb  $


# Reformat numeric string using '.' thousands separators.
sub fmt($) {
   return join '.', split /(?= (?: .{3} )+ $ ) /x, shift;
}


use constant list_file
   => $ENV{ALLUSERSPROFILE} . '\\Dokumente\\Offline\\Archives\\GBR-20470017.dir'
;
use constant out_file
   => 'W:\\OUTBOUND\\movie_list_'
   . do {
      my($y, $m, $d)= (localtime)[5, 4, 3];
      sprintf '%04u-%02u-%02u', $y + 1900, $m + 1, $d;
   }
   . '.txt'
;
use constant sort_column => 25;


open IN, '<', list_file or die "cannot open '" . list_file . "': $!";
$st= 0;
while (<IN>) {
   if ($st == 0 && /^Space-Saving Movies\\/) {
      $st= 1;
   }
   elsif (/\\/) {
      $st= 0;
   }
   next unless $st == 1;
   next unless ($avi, $s, $y, $m, $d)= /^(.+?.divx.avi)\s+(\d+)\s+(\d+)\.(\d+)\.(\d+)/;
   push @f, sprintf "%04u-%02u-%02u %13s %s", $y, $m, $d, fmt $s, $avi;
}
close IN or die;
open OUT, '>', out_file or die "Cannot create '" . out_file . "': $!";
print OUT <<"END";
Die folgenden Filme sind schon fertig.
Das Datum ist das Datum der Konvertierung.
Die Längenangabe ist in Bytes.

LISTE NACH DATUM
================

Der neueste Film ist der erste in der Liste.

END
foreach (sort {$b cmp $a} @f) {
   print OUT "$_\n";
}
print OUT <<"END";


ALPHABETISCHE LISTE
===================

END
foreach (sort {substr($a, sort_column) cmp substr($b, sort_column)} @f) {
   print OUT "$_\n";
}
close OUT or die $!;
