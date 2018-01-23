# NAME

Test::Time::HiRes - drop-in replacement for Test::Time to work with Time::HiRes

# SYNOPSIS

    use Test::Time::HiRes time => 123.456789;

    # Freeze time
    my $now       = time();
    my $now_hires = Time::HiRes::time();

    # Increment internal time (returns immediately)
    sleep 1;        # seconds
    usleep 1000;    # microseconds

    # Return internal time incremented by 1.001 s
    my $then       = time();
    my $then_hires = Time::HiRes::time();

# DESCRIPTION

Drop-in replacement for [Test::Time](https://metacpan.org/pod/Test::Time) that also works with the [Time::HiRes](https://metacpan.org/pod/Time::HiRes)
functions `usleep` and `gettimeofday`.

# SEE ALSO

- [Test::Time](https://metacpan.org/pod/Test::Time)

# SUPPORT

## Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at [https://github.com/mjemmeson/Test-Time-HiRes/issues](https://github.com/mjemmeson/Test-Time-HiRes/issues).
You will be notified automatically of any progress on your issue.

## Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

[https://github.com/mjemmeson/Test-Time-HiRes](https://github.com/mjemmeson/Test-Time-HiRes)

    git clone git://github.com/mjemmeson/Test-Time-HiRes.git

# AUTHOR

Michael Jemmeson <mjemmeson@cpan.org>

# COPYRIGHT

Copyright 2018- Michael Jemmeson

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
