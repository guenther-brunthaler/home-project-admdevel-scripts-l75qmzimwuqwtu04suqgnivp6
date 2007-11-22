#!/usr/bin/perl
# $Id: /trunk/Org/SysAdmin/Crossplatform/scripts/eml2mbox.pl 2645 2006-08-26T07:36:02.660558Z gb  $
# Collects the specified eml messages into an automatically created mbox file.


use strict;
use ExpandFilelist_57D9097A_926F_11D6_951B_009027319575;
use FileLinesWindow_590FC250_9D95_11D9_BFF0_00A0C9EF1631;


my($of, $if, @d);
ExpandFilelist(\@ARGV, -expand_globs => 1);
@d= localtime;
$of= sprintf
   "%04u%02u%02u-%02u%02u%02u.mbox"
   , $d[5] + 1900, $d[4] + 1, @d[reverse 0 .. 3]
;
open OUT, '>', $of or die "Cannot create '$of': $!";
binmode OUT or die $!;
local $/= "\012";
warn "No input files specified" unless @ARGV;
foreach my $in (sort {lc($a) cmp lc $b} @ARGV) {
   die "Cannot stat '$in': $!" unless @d= stat $in;
   @d= sort {$a <=> $b} @d[8 .. 10];
   @d= gmtime $d[0];
   printf OUT
      "From - %s %s %02u %02u:%02u:%02u %04u\015\012"
      , ${{qw/0 Sun 1 Mon 2 Tue 3 Wed 4 Thu 5 Fri 6 Sat/}}{$d[6]}
      , ${{
         qw/0 Jan 1 Feb 2 Mar 3 Apr 4 May 5 Jun 6 Jul/
         , qw/7 Aug 8 Sep 9 Oct 10 Nov 11 Dec/
      }}{$d[4]}
      , @d[reverse 0 .. 3], $d[5] + 1900
   ;
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
   while (defined($_= $if->readline)) {
      chop;
      $_= '>' . $_ if /^From\s+/;
      next if $_ eq '' && $if->is_virtual(1);
      print OUT "$_\015\012";
   }
   print OUT "\015\012";
   undef $if;
   close IN or die $!;
}
close OUT or die "Cannot finish writing '$of': $!";
