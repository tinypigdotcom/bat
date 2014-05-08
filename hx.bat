@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -w -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -w -x -S "%0" %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
goto endofperl
#!perl
# HX.PL

use vars qw(
   $bound $buff $count $i $item $j $jbound $junk $line $o $ymax
);
use strict;
use diagnostics;

sub mor {
   if ($line++>=$ymax) {
      print "--more--";
      $junk=<STDIN>;
      $line=0;
   }
}

$bound=16;
$jbound=2;
$ymax=24;

foreach $item (@ARGV) {
   print "$item\n" and mor;
   open(INFILE, $item) or die "Can't open $item";
   $count=0;
   
   binmode(INFILE);
   
   while (read(INFILE, $buff, $bound)) {
      printf("%08x: ",$count);
      for ($i=0; $i<$bound; $i++) {
         if ($i>=length($buff)) {
            print "   ";
         }
         else {
            printf("%02x ",ord(substr($buff,$i,1)));
         }
         print "- " if $i==7;
         $count++;
      }
      for ($i=0; $i<length($buff); $i++) {
         $o=ord(substr($buff,$i,1));
         if ($o>=32) {
            printf("%s",substr($buff,$i,1));
         }
         else {
            print ".";
         }
         
      }
      print "\n" and mor;
   }
   close INFILE;
}

print "Press Enter to exit.";
$junk=<STDIN>;
__END__
:endofperl
