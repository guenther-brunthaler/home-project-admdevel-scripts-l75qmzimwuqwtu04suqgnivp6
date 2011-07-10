#! /usr/bin/perl
# ESC Wikipedia table songlist dumper.


sub fmt(\@$) {
   my($f, $st)= @_;
   my($tbl, $row, $col, $txt)= @$f;
   our @t;
   @t= () if $col == 0;
   if ($col == 2) {
      die unless $txt =~ s/"(.*)"/$1/;
   }
   $t[$col]= $txt;
   if ($col == 3) {
      print "$t[1] - $t[2] ($t[0] - $t[3], 2005 Eurovision Song Contest $st)\n";
   }
}


while (<>) {
   chomp;
   @f= split /\t/, $_, 4;
   if ($f[0] && $f[1] > 0) {
      fmt @f, "Semi-Finalist" if $f[0] == 2;
      fmt @f, "Finalist" if $f[0] == 3;
   }
}
