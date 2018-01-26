#!/bin/perl

my $level = 18;
my $current_exp = 1382521;
my $showlevel = 3;
my $numargs = $#ARGV+1;

@exp_needed = (0, 340200, 356800, 373700, 390800, 408200, 437600, 467500, 498000, 529000, 864000, 1058400, 1267200, 1555200, 1872000, 2217600, 2592000, 2995200, 3427200, 3888000);

@exp_gained = (0, 207000, 211140, 215280, 219420, 223560, 232650, 236880, 251370, 255780, 324000, 340200, 356400, 388800, 421200, 453600, 486000, 691200, 734400, 734400);

if ($numargs == 1) {
    if ($ARGV[0] < 40){
        $showlevel = $ARGV[0];
    }
    else {
        $showlevel = $ARGV[0] - 40;
    }
    print "start at level $showlevel\n";
}
if ($numargs == 2) {
    $level = $ARGV[0] - 40;
    $current_exp = $ARGV[1];

    $file = "potd.pl";
    open (IN, $file) || die "cannot open file for read";
    @lines = <IN>;
    close IN;

    open (OUT, ">", $file) || die "Cannot open file for write";
    foreach $line (@lines) {
        my $lvl = $level - 40;
        $line =~ s/my \$level = \d{1,2}/my \$level = $level/;
        $line =~ s/my \$current_exp = \d{1,8}/my \$current_exp = $current_exp/;
        print OUT $line;
    }
    close OUT;
}


my $num=1;
while ($level < 20) {
    $current_exp += $exp_gained[$level];
    $lvl = 40+$level;
    if ($level >= $showlevel) {
        printf ("%02d: level $lvl, floor #%2d. Exp :  %7d / %-7d ", $num, $lvl, $current_exp, $exp_needed[$level]);
            $num++;
    }

    if ( $current_exp > $exp_needed[$level]){
        $current_exp -= $exp_needed[$level];
        $level++;
        $lvl = 40+$level;
        if ($lvl == 60){
            print "\n-- CONGRATS --"
        }
        elsif ($level >= $showlevel) {
            print "  LEVEL UP : level $lvl ($current_exp/$exp_needed[$level]) ";
        }
    }
    if ($level >= $showlevel) {
        print "\n";
    }
}


print "total number of floors = $num\n";
