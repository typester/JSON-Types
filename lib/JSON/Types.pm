package JSON::Types;
use strict;
use warnings;
use parent 'Exporter';

our $VERSION = '0.05';
our @EXPORT  = qw/number string bool/;

sub number($) {
    return undef unless defined $_[0];
    $_[0] + 0;
}

sub string($) {
    return undef unless defined $_[0];
    $_[0] . '';
}

sub bool($) {
    $_[0] ? \1 : \0;
}

1;

__END__

=head1 NAME

JSON::Types - variable type utility for JSON encoding

=head1 SYNOPSIS

    # Export type functions by default
    use JSON;
    use JSON::Types;
    
    print encode_json({
        number => number "123",
        string => string 123,
        bool   => bool "True value",
    });
    # => {"number":123,"string":"123","bool":true}
    
    
    # Non export interface
    use JSON::Types ();
    
    print encode_json({
        number => JSON::Types::number "123",
        string => JSON::Types::string 123,
        bool   => JSON::Types::bool "True value",
    });

=head1 DESCRIPTION

The type mappings between JSON and Perl is annoying things. For example,

    use JSON;
    
    my $number = 123;
    
    warn "[DEBUG] number:$number\n" if $ENV{DEBUG};
    
    print encode_json([ $number ]);

Output of this code depends on whether DEBUG environment is set or not.
If set, result is C<[123]>. If not to set, result is C<["123"]>.
This is normal behaviour on Perl though, it sometimes causes unexpected JSON results.

There is a solution about this:

    print encode_json([ $number + 0 ]);

This code always outputs C<[123]>.
But the code is a bit ugly and not readable at all.

This module provides some functions to fix this variable types issue:

    number $foo;  # is always number
    string $foo;  # is always string
    bool   $foo;  # is always bool

You can fix above code by using this module like this:

    use JSON;
    use JSON::Types;
    
    my $number = 123;
    
    warn "[DEBUG] number:$number\n" if $ENV{DEBUG};
    
    print encode_json([ number $number ]);


=head1 FUNCTIONS

There are three functions and all functions are exported by default.

If you don't want any exported functions, pass an empty list to the use line:

    use JSON::Types ();

You should specify full function name in that case, like C<JSON::Types::number $foo> etc.

=head2 string

=head2 number

=head2 bool

=head1 BEHAVIOURS ON UNEXPECTED ARGS

=head2 string(undef), number(undef) returns undef, bool(undef) returns false.

Passing an undefined variable to string and number function returns undef.
If you don't prefer this, you have to treat it like the following example:

    number $undef_possible_value // 0

This code returns 0 if variable is undef.

=head2 number($string)

Passing a non-numeric variable to number function returns 0, but a warning will be issued.

=head1 BOOLEAN BEHAVIOUR

    my $var = bool 0
    if ($var) {
        # this is run, because $var is true in a perl perspective
    }

Boolean values converted by C<bool> are actually scalar references, and are therefore always
evaluated to true in perl. So, be careful when you use C<bool $var> and then do further
processing in perl before converting it to JSON. If you need a representation that is correct in perl,
but also results in a boolean value in JSON, an alternative could be

    use JSON;
    $var = $var ? JSON::true : JSON::false

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2012 Daisuke Murase. All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
