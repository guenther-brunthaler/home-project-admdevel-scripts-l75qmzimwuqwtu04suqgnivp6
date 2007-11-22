#!/usr/bin/perl
# $Id: /caches/xsvn/admdevel/trunk/prj/shared_bin_not_in_path_dlqjwx9prunb58hl2kncy0q0r/mbox-explode.pl 11 2006-11-06T23:14:31.537884Z root(xternal)  $
# Explodes the contents of UNIX mbox files.


use strict;
use Time::Local;
use ExpandFilelist_57D9097A_926F_11D6_951B_009027319575;
use FileLinesWindow_590FC250_9D95_11D9_BFF0_00A0C9EF1631;


my($n, $if, $of, $month, $year, $mtime);
sub finish_output {
   return unless $of;
   close OUT or die "Cannot finish writing '$of': $!";
   utime $mtime, $mtime, $of if $mtime;
   undef $of, $mtime;
}
$n= 1;
ExpandFilelist(\@ARGV, -expand_globs => 1);
warn "No input files specified" unless @ARGV;
local $/= "\012";
foreach my $in (@ARGV) {
   open IN, '<', $in or die "Cannot open '.mbox'-format file '$in': $!";
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
   while (defined($_= $if->readline)) {
      chop;
      next if $_ eq '' && ($if->is_virtual(1) || $if->line(1) =~ /^From\s+/);
      if (/^From\s+/) {
         finish_output;
         if (
            /
               ^ From \s+ .+ # User.
               \s+ [A-Z][a-z]{2} # Weekday.
               \s+ ([A-Z][a-z]{2}) # Month.
               \s+ (\d?\d) # Day of month.
               \s+ (\d?\d):(\d\d):(\d\d) # HMS.
               \s+ ((?:\d\d)?\d\d) # Year.
               \s* $
            /x
            && (
               $month= ${{
                  qw/jan 0 feb 1 mar 2 apr 3 may 4 jun 5 jul 6/
                  , qw/aug 7 sep 8 oct 9 nov 10 dec 11/
               }}{lc $1}
            )
            && (
               $6 >= 1900 && ($year= $6 - 1900, 1)
               || ($year= $6) < 100
            )
         ) {
            $mtime= timegm($5, $4, $3, $2, $month, $year);
         }
         unless (open OUT, '>', ($of= sprintf "%04u.mbox", $n++)) {
            die "Cannot create '$of': $!";
         }
         binmode OUT or die $!;
         next;
      }
      s/^>(>*From\s+)/$2/;
      print OUT $_, "\015\012";
   }
   finish_output;
   undef $if;
   close IN or die $!;
}
