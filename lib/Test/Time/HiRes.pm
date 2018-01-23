package Test::Time::HiRes;

use strict;
use warnings;

use Test::More;
use Test::Time;
use Time::HiRes ();

our $VERSION      = '0.01';

our $time;    # epoch in microseconds
our $seconds;         # i.e. standard epoch

my $in_effect = 1;

sub in_effect {
    $in_effect;
}

# assume time only goes forwards
# take the highest as current epoch time
sub _synchronise_times {
    if ( $seconds < $Test::Time::time ) {
        my $microseconds = _microseconds();    # part after DP
        $seconds = $Test::Time::time;
        $time    = ( $seconds * 1_000_000 ) + $microseconds;
    }
}

sub _time {
    _synchronise_times();
    return $time;
}

sub _seconds {
    _synchronise_times();
    return $seconds;
}

sub _microseconds {
    return $time - ( $seconds * 1_000_000 );
}

sub import {
    my ( $class, %opts ) = @_;

    my $tmp = $opts{time} if defined $opts{time};

    $Test::Time::time = $seconds = int($tmp);
    $time = $tmp * 1_000_000;

    no warnings 'redefine';

    my $sub_time         = *Time::HiRes::time;
    my $sub_usleep       = *Time::HiRes::usleep;
    my $sub_gettimeofday = *Time::HiRes::gettimeofday;

    *Time::HiRes::time = sub() {
        if (in_effect) {
            my $t = _time() / 1_000_000;
            return sprintf( "%.6f", $t );
        }
        else {
            return $sub_time->();
        }
    };

    *Time::HiRes::usleep = sub($) {

        unless (@_) {
            return $sub_usleep->();    # always give "no argument" error
        }

        if (in_effect) {
            my $sleep = shift;

            return 0 unless $sleep;

            $time    = _time() + $sleep;
            $seconds = int($time / 1_000_000 );

            # update Test::Time to keep our $time's in sync
            if ( $seconds > $Test::Time::time ) {
                $Test::Time::time = $seconds;
            }

            note "sleep $sleep";

            return $sleep;
        }
        else {
            return $sub_usleep->(shift);
        }
    };

    *Time::HiRes::gettimeofday = sub() {
        if (in_effect) {
            return ( _seconds(), _microseconds() );
        }
        else {
            return $sub_gettimeofday->();
        }
    };
}

1;

__END__

