#!/usr/bin/perl
# $Id: /caches/xsvn/admdevel/trunk/prj/shared_bin_not_in_path_dlqjwx9prunb58hl2kncy0q0r/mime-explode.pl 810 2007-06-28T17:05:28.645086Z root  $
# Explodes the contents of a multipart MIME message.


use strict;
use ExpandFilelist_57D9097A_926F_11D6_951B_009027319575;
use FileLinesWindow_590FC250_9D95_11D9_BFF0_00A0C9EF1631;


my($b, $n, $if, $of);
sub chkb($) {
   my $t= shift;
   return length($t) >= length($b) && substr($t, 0, length($b)) eq $b;
}
$n= 1;
ExpandFilelist(\@ARGV, -expand_globs => 1);
warn "No input files specified" unless @ARGV;
local $/= "\012";
foreach my $in (@ARGV) {
   open IN, '<', $in or die "Cannot open '.eml'-format file '$in': $!";
   binmode IN or die $!;
   $if= new Lib::FileLinesWindow(
      -input => sub {
         local $_;
         return undef unless defined($_= <IN>);
         s/\015?\012$//s;
         return $_ . "\n";
      }
      , -after => 1
   );
   for (;;) {
      defined($b= $if->readline) or die;
      if (
         $b =~ /
            ^
            (?:
               Content-Type: \s*  multipart\/ (?:
                  mixed | alternative | related
               ) ;
            )?
            \s+ boundary = "(
               [-[:xdigit:]=:]+
            )"
            $
         /x
      ) {
         $b= "--$1"; last;
      }
   }
   do {
      unless (open OUT, '>', ($of= sprintf "%04u.eml", $n++)) {
         die "Cannot create '$of': $!";
      }
      binmode OUT or die $!;
      do {
         defined($_= $if->readline) or die;
      } until /^$/;
      for (;;) {
         last unless defined($_= $if->readline);
         chop;
         last if chkb $_;
         if (
            $_ eq '' && ($if->is_virtual(1) || chkb $if->line(1))
         ) {next}
         print OUT $_, "\015\012";
      }
      close OUT or die "Cannot finish writing '$of': $!";
   } until length >= length($b) + 2 && substr($_, length($b), 2) eq '--';
   undef $if;
   close IN or die;
}
