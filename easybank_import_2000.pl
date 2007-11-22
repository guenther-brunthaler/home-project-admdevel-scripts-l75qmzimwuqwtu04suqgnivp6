# Easybank year 2000 import.


use locale;
use Lib::CSV_bz2d9x40wnlfxlpt9chgq5982;


format=
^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @>>>>>>>>> @>>>>> @#######.## @<<
@f
^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<~~
$f[0]
.


open IN, '<', "easy 2000.txt" or die;
open OUT, '>', 'W:\EASYBANK_Umsatzsuche.csv' or die;
while (defined($_= <IN>)) {
 die unless ($buch, $text, $valuta, $betrag)= /
  \d+ \s+
  (\d\d\.\d\d\.) \s+
  (.*?) \s+
  (\d\d\.\d\d\.) \s+
  ( [-+]? [.\d]+ , \d\d )
 /x;
 $buch.= '2000';
 $betrag =~ s/^(?=\d)/+/;
 $cur= "ATS";
 @f= ($text, $buch, $valuta, $betrag, $cur);
 $f[-2] =~ tr/.//d;
 $f[-2] =~ tr/,/./;
 write;
 print OUT Lib::list2csv(
  @{['20010033030', $text, $buch, $valuta, $betrag, $cur]}
  , -separator => ';'
 )
 , "\n"
 ;
}
close OUT or die;
close IN or die;
