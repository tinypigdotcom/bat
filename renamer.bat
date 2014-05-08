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
# RENAMER.PL

use strict;

my %file;
my $directory = $ARGV[0];
my $ymax=23;
my $line = 0;
my $delete = 0;

sub more_print {
    my @output = split /\n/, $_[0];
    for(@output) {
        print "$_\n";
        if ($line++>=$ymax) {
            print "--more--";
#            my $junk=<STDIN>;
            $line=0;
        }
    }
}

sub dye {
    print @_,"\n";
    print "Press Enter to exit.";
    my $foo=<STDIN>;
    die;
}

print "Enter command: ";
my $command = <STDIN>;
chomp($command);
if($command eq 'num') {
    $command = 's/^[^0-9]*//';
}

if($command =~ s/^d(.)/$1/) {
    my $separator = $1;
    my $postfix = '';
    $delete++;
    if($command =~ s/(.*$separator)(.+)/$1/) {
        $postfix = $2;
    }
    $command = "s$command$separator$postfix";
    print "command is $command\n";
}

opendir(my $dh, $directory) || dye "can't opendir $directory: $!";
my @dots = grep { -f "$directory/$_" } readdir($dh);
closedir $dh;

my $output = '';
my $prefix = '---';

for (@dots) {
    my $first = $_;
    my $second = $first;
    eval "\$second =~ $command";
    if($first ne $second) {
        if($delete) {
            $second = 'DELETE';
        }
        $file{$first}=$second;
        $output .= "$prefix$first\n$prefix$second\n";
        if($prefix eq '---') {
            $prefix = '   ';
        }
        else {
            $prefix = '---';
        }
    }
}

more_print($output);

print "Proceed (y/[n]) ? ";
my $junk=<STDIN>;
chomp($junk);

if($junk eq 'y') {
    for(keys %file) {
        if($delete) {
            unlink($_);
        }
        else {
            rename($_,$file{$_});
        }
    }
}

__END__
:endofperl
