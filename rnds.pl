#!/usr/bin/perl

 
use strict;
use warnings;
 
 
 
use Moo;
 
 
use Types::Standard qw/Any Int Str/;
 
use Try::Tiny;
 
use X500::DN::Marpa::Actions;
 
has bnf =>
(
        default  => sub{return ''},
        is       => 'rw',
        isa      => Any,
        required => 0,
);
 
has error_message =>
(
        default  => sub{return ''},
        is       => 'rw',
        isa      => Str,
        required => 0,
);
 
has error_number =>
(
        default  => sub{return 0},
        is       => 'rw',
        isa      => Int,
        required => 0,
);
 
has grammar =>
(
        default  => sub {return ''},
        is       => 'rw',
        isa      => Any,
        required => 0,
);
 
has options =>
(
        default  => sub{return 0},
        is       => 'rw',
        isa      => Int,
        required => 0,
);
 
has recce =>
(
        default  => sub{return ''},
        is       => 'rw',
        isa      => Any,
        required => 0,
);
 
# The default value of $self -> stack is set to Set::Array -> new, so that if anyone
# accesses $self -> stack before calling $self -> parse, gets a meaningful result.
# This is despite the fact the parser() resets the stack at the start of each call.
 
has stack =>
(
        default  => sub{return Set::Array -> new},
        is       => 'rw',
        isa      => Any,
        required => 0,
);
 
has text =>
(
        default  => sub{return ''},
        is       => 'rw',
        isa      => Str,
        required => 0,
);
 
my(%descriptors) =
(
        cn     => 'commonName',
        c      => 'countryName',
        dc     => 'domainComponent',
        l      => 'localityName',
        ou     => 'organizationalUnitName',
        o      => 'organizationName',
        st     => 'stateOrProvinceName',
        street => 'streetAddress',
        uid    => 'userId',
);
 
our $VERSION = '1.00';
 
# ------------------------------------------------
 
sub BUILD
{
        my($self) = @_;
 
        # Policy: Event names are always the same as the name of the corresponding lexeme.
        #
        # References:
        # o https://www.ietf.org/rfc/rfc4512.txt (secondary)
        #       - Lightweight Directory Access Protocol (LDAP): Directory Information Models
        # o https://www.ietf.org/rfc/rfc4514.txt (primary)
        #   - Lightweight Directory Access Protocol (LDAP): String Representation of Distinguished Names
        # o https://www.ietf.org/rfc/rfc4517.txt
        #       - Lightweight Directory Access Protocol (LDAP): Syntaxes and Matching Rules
        # o https://www.ietf.org/rfc/rfc4234.txt
        #       - Augmented BNF for Syntax Specifications: ABNF
        # o https://www.ietf.org/rfc/rfc3629.txt
        #       - UTF-8, a transformation format of ISO 10646
 
        my($bnf) = <<'END_OF_GRAMMAR';
 
:default                        ::= action => [values]
 
lexeme default          = latm => 1
 
:start                          ::= dn
 
# dn.
 
dn                                      ::=
dn                                      ::= rdn
                                                | rdn separators dn
 
separators                      ::= separator+
 
separator                       ::= comma
                                                | space
 
rdn                                     ::= attribute_pair                                                              rank => 1
                                                | attribute_pair spacer plus spacer rdn         rank => 2
 
attribute_pair          ::= attribute_type spacer equals spacer attribute_value
 
spacer                          ::= space*
 
# attribute_type.
 
attribute_type          ::= description                         action => attribute_type
                                                | numeric_oid                   action => attribute_type
 
description                     ::= description_prefix description_suffix
 
description_prefix      ::= alpha
 
description_suffix      ::= description_tail*
 
description_tail        ::= alpha
                                                | digit
                                                | hyphen
 
numeric_oid                     ::= number oid_suffix
 
number                          ::= digit
                                                | digit_sequence
 
digit_sequence          ::= non_zero_digit digit_suffix
 
digit_suffix            ::= digit+
 
oid_suffix                      ::= oid_sequence+
 
oid_sequence            ::= dot number
 
# attribute_value.
 
attribute_value         ::= string                                      action => attribute_value
                                                | hex_string                    action => attribute_value
 
string                          ::=
string                          ::= string_prefix string_suffix
 
string_prefix           ::= lutf1
                                                | utfmb
                                                | pair
 
utfmb                           ::= utf2
                                                | utf3
                                                | utf4
 
utf2                            ::= utf2_prefix utf2_suffix
 
utf3                            ::= utf3_prefix_1 utf3_suffix_1
                                                | utf3_prefix_2 utf3_suffix_2
                                                | utf3_prefix_3 utf3_suffix_3
                                                | utf3_prefix_4 utf3_suffix_4
 
utf4                            ::= utf4_prefix_1 utf4_suffix_1
                                                | utf4_prefix_2 utf4_suffix_2
                                                | utf4_prefix_3 utf4_suffix_3
 
pair                            ::= escape_char escaped_char
 
escaped_char            ::= escape_char
                                                | special_char
                                                | hex_pair
 
string_suffix           ::=
string_suffix           ::= string_suffix_1 string_suffix_2
 
string_suffix_1         ::= string_suffix_1_1*
 
string_suffix_1_1       ::= sutf1
                                                | utfmb
                                                | pair
 
string_suffix_2         ::= tutf1
                                                | utfmb
                                                | pair
 
hex_string                      ::= sharp hex_suffix
 
hex_suffix                      ::= hex_pair+
 
hex_pair                        ::= hex_digit hex_digit
 
# Lexemes in alphabetical order.
 
alpha                           ~ [A-Za-z]              # [\x41-\x5a\x61-\x7a].
 
comma                           ~ ','                   # [\x2c].
 
digit                           ~ [0-9]                 # [\x30-\x39].
 
dot                                     ~ '.'                   # [\x2e].
 
equals                          ~ '='                   # [\x3d].
 
escape_char                     ~ '\'                   # [\x5c]. Use ' in comment for UltraEdit syntax hiliter.
 
hex_digit                       ~ [0-9A-Fa-f]   # [\x30-\x39\x41-\x46\x61-\x66].
 
hyphen                          ~ '-'
 
# \x01-\x1f: All control chars except the first (^@). Skip [ ] = [\x20].
# \x21:      !. Skip ["#] = [\x22\x23].
# \x24-\x2a: $%&'()*. Skip: [+,] = [\x2b\x2c].
# \x2d-\x3a: -./0123456789:. Skip [;<] = [\x3b\x3c].
# \x3d:      =.
# \x3f-\x5b: ?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[.
# \x5d-\x7f: ]^_`abcdefghijklmnopqrstuvwxyz{|}~ and DEL.
 
lutf1                           ~ [\x01-\x1f\x21\x24-\x2a\x2d-\x3a\x3d\x3f-\x5b\x5d-\x7f]
 
non_zero_digit          ~ [1-9]                 # [\x31-\x39].
 
plus                            ~ '+'                   # [\x2b].
 
sharp                           ~ '#'                   # [\x23].
 
space                           ~ ' '                   # [\x20].
 
special_char            ~ ["+,;<> #=]     # Use " in comment for UltraEdit syntax hiliter.
 
sutf1                           ~ [\x01-\x21\x23-\x2a\x2d-\x3a\x3d\x3f-\x5b\x5d-\x7f]
 
tutf1                           ~ [\x01-\x1f\x21\x23-\x2a\x2d-\x3a\x3d\x3f-\x5b\x5d-\x7f]
 
utf0                            ~ [\x80-\xbf]
 
utf2_prefix                     ~ [\xc2-\xdf]
 
utf2_suffix                     ~ utf0
 
utf3_prefix_1           ~ [\xe0\xa0-\xbf]
 
utf3_suffix_1           ~ utf0
 
utf3_prefix_2           ~ [\xe1-\xec]
 
utf3_suffix_2           ~ utf0 utf0
 
utf3_prefix_3           ~ [\xed\x80-\x9f]
 
utf3_suffix_3           ~ utf0
 
utf3_prefix_4           ~ [\xee-\xef]
 
utf3_suffix_4           ~ utf0 utf0
 
utf4_prefix_1           ~ [\xf0\x90-\xbf]
 
utf4_suffix_1           ~ utf0 utf0
 
utf4_prefix_2           ~ [\xf1-\xf3]
 
utf4_suffix_2           ~ utf0 utf0 utf0
 
utf4_prefix_3           ~ [\xf4\x80-\x8f]
 
utf4_suffix_3           ~ utf0 utf0
 
END_OF_GRAMMAR
 
        $self -> bnf($bnf);
        $self -> grammar
        (
                Marpa::R2::Scanless::G -> new
                ({
                        source => \$self -> bnf
                })
        );
 
} # End of BUILD.
 
# ------------------------------------------------
 
sub decode_result
{
        my($self, $result) = @_;
        my(@worklist) = $result;
 
        my($obj);
        my($ref_type);
        my(@stack);
 
        do
        {
                $obj      = shift @worklist;
                $ref_type = ref $obj;
 
                if ($ref_type eq 'ARRAY')
                {
                        unshift @worklist, @$obj;
                }
                elsif ($ref_type eq 'HASH')
                {
                        push @stack, {%$obj};
                }
                elsif ($ref_type)
                {
                        die "Unsupported object type $ref_type\n";
                }
                else
                {
                        push @stack, $obj;
                }
 
        } while (@worklist);
 
        return [@stack];
 
} # End of decode_result.
 
# ------------------------------------------------
 
sub _combine
{
        my($self)        = @_;
        my(@temp)        = $self -> stack -> print;
        my($multivalued) = 0;
 
        my(@dn);
 
        for (my $i = 0; $i <= $#temp; $i++)
        {
                # The 'multivalued' key is use for temporary storage. See parse().
                # 'count' holds the count of RDNs within this stack element.
 
                if ($temp[$i]{multivalued})
                {
                        $multivalued = 1;
                }
                elsif ($multivalued)
                {
                        $multivalued     =  0;
                        $dn[$#dn]{count} += 1;
                        $dn[$#dn]{value} .= "+$temp[$i]{type}=$temp[$i]{value}";
                }
                else
                {
                        # Zap 'multivalued' so it does not end up in the stack.
 
                        undef $temp[$i]{multivalued};
 
                        push @dn, $temp[$i];
                }
        }
 
        $self -> stack(Set::Array -> new(@dn) );
 
} # End of _combine.
 
# ------------------------------------------------
 
sub dn
{
        my($self) = @_;
 
        return join(',', map{"$$_{type}=$$_{value}"} reverse @{$self -> stack});
 
} # End of dn.
 
# ------------------------------------------------
 
sub openssl_dn
{
        my($self) = @_;
 
        return join('+', map{"$$_{type}=$$_{value}"} @{$self -> stack});
 
} # End of openssl_dn.
 
# ------------------------------------------------
 

