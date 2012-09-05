use strict;
use warnings;
use Test::More;

use JSON::Types;

is number undef, undef, 'number undef returns undef ok';
is string undef, undef, 'string undef returns undef ok';
is bool undef, undef, 'bool undef returns undef ok';

{
    open my $stderr, '>', \my $out;
    local *STDERR = $stderr;

    my $n = number 'foo';
    like $out, qr{^Argument "foo" isn't numeric in addition \(\+\)}, 'warnings ok';
    is $n, 0, 'warnings but returns 0 ok';

    close $stderr;
}

done_testing;
