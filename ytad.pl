#!/usr/bin/perl

# [Y]ou[T]ube [A]lbum [D]isassembler
#   perl implementation of my small shell script to cut a mono-file album
#	into separate files for each song.

use strict;
use 5.010;

# debugging
use Data::Dumper qw(Dumper);
my $dbg = 0;
my $test = 0;

if (scalar @ARGV && $ARGV[0] eq "-d") { 
	say "[Debugging mode]";
	$dbg = 1;
	use warnings;
}
if (scalar @ARGV && $ARGV[0] eq "-t") {
	$test = 1;
}

### INPUT
my @namelist = (
	'title1', 
	'title2',
	'title3',
	'title4',
);
my @timelist = (
	'00:00', # start time
	'01:20',
	'02:45',
	'59:35',
	'01:00:05',
);

# filename of the album
my $file ='artist - album (full album).mp4';

# destination folder
my $album='album';

# song name prefix
my $artist='artist';

### Verification
die "(E) incoherence between times and titles\n" 
	if(scalar @namelist != $#timelist);

die "(E) Unable to create $artist\n" 
	unless(-e "$artist" or mkdir "$artist");	
die "(E) Unable to create $artist/$album\n" 
	unless(-e "$artist/$album" or mkdir "$artist/$album");

for (@timelist) {
	if($_ =~ /^\d{2}:\d{2}$/) {
		$_ = "00:".$_;
	} elsif (! m/^(\d{2}(:|$)){3}/) {
		die "(E) wrong time format: $_";
	}
}
say "timelist : \n\t", Dumper \@timelist if $dbg;

my $i=0;
my $filename;
say "loop :" if $dbg;
for (@namelist) {
	my $tdiff = timediff($timelist[$i],$timelist[$i+1]);

	$filename ="$artist - $namelist[$i]";

	my $out = "../bin/ffmpeg.exe -ss $timelist[$i] -t $ -i \"$file\"".
				" -vn -c:a flac -crf 1".
				" -metadata title=\"$namelist[$i]\"".
				" -metadata track=\"". $i++ .
				" -metadata artist=\"$artist\"".
				" -metadata album=\"$album\"".
				" \"$artist\"/\"$album\"/\"$filename.flac\"";

	say $out;
	if (! $test) {
		system "$out";
	}
}

sub timediff {
	my ($start, $end) = @_;

	my ($hs, $ms, $ss) = $start =~ /\d{2}/g;
	my ($he, $me, $se) = $end =~ /\d{2}/g;
	
	return ($he-$hs)*3600+($me-$ms)*60+($se-$ss);
}