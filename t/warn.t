use strict;
use warnings;
use Test::More;

use JSON::Types;

is number undef, undef, 'number undef returns undef ok';
is string undef, undef, 'string undef returns undef ok';

my %param = (
    foo => number undef,
    bar => string undef,
);
is_deeply \%param, { foo => undef, bar => undef }, 'hash is not shrinks ok';

my $b = bool undef;
ok ref($b) eq 'SCALAR' && $$b == 0, 'bool undef returns false ok';

{
    open my $stderr, '>', \my $out;
    local *STDERR = $stderr;

    my $n = number 'foo';
    like $out, qr{^Argument "foo" isn't numeric in addition \(\+\)}, 'warnings ok';
    is $n, 0, 'warnings but returns 0 ok';

    close $stderr;
}

for my $inf (qw(inf +inf -inf Inf +Inf -Inf infxxx)) {
    open my $stderr, '>', \my $out;
    local *STDERR = $stderr;

    my $n;
    is eval { $n = number $inf; 1; }, undef, 'infinite num is not allowed ok';
    like $@, qr{^"\Q$inf\E" is disallowed in JSON}, 'croak ok';
    is $n, undef, 'return undef ok';

    if ($inf eq 'infxxx') {
        like $out, qr{^Argument "\Q$inf\E" isn't numeric in addition \(\+\)}, 'warnings ok';
    }

    close $stderr;
}

for my $nan (sin('inf')) {
    my $n;
    is eval { $n = number $nan; 1; }, undef, 'NaN is not allowed ok';
    like $@, qr{^"\Q$nan\E" is disallowed in JSON}, 'croak ok';
    is $n, undef, 'return undef ok';
}

done_testing;
