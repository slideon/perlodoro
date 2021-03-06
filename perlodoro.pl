#!/usr/bin/perl

use strict;
use warnings;

use Time::HiRes qw (setitimer ITIMER_REAL);
use Term::ANSIColor;
use POSIX qw(pause);

use constant POMO_TIME => 25 * 60;
use constant BREAK_TIME => 5 * 60;
use constant BELL => chr(7);

my $elapsed = 0;
my $infinite = defined $ARGV[0];

clear_screen();
pomo_loop();

sub pomo_loop {
    do {
        timer(POMO_TIME, "Pomo", "red");
        print BELL;
        timer(BREAK_TIME, "Break", "green");
        print BELL;
    } while ($infinite);
}

sub timer {
    my $time = shift;
    my $message = shift;
    my $colour = shift;

    my $show_time = sub {
        print color($colour); 
        printf "$message time remaining: %02d:%02d \n", (gmtime $time - $elapsed)[1, 0];
    };

    # thanks to https://www.febo.com/pages/perl_alarm_code/
    # and to http://www.perlmonks.org/?node_id=101511
    $SIG{ALRM} = \&$show_time;
    setitimer(ITIMER_REAL, 1, 1);

    while ($elapsed < $time) {
        pause;
        clear_screen();
        $elapsed++;
    }

    $elapsed = 0;
    print color("reset");
}

# thanks to http://stackoverflow.com/questions/197933/whats-the-best-way-to-clear-the-screen-in-perl
sub clear_screen {
    print ("\033[2J", "\033[0;0H");
}
