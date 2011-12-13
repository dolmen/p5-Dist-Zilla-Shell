#!perl

use 5.006;
use utf8;
use strict;
use warnings;
use Test::More tests => 3;

SKIP: {
    ok(-f 'META.json', 'META.json exists')
	or skip "Missing META.json", 2;

    require_ok('JSON')
	or skip "Can't load JSON", 1;
    my $meta = do {
	local $/;
	open my $f, '<:utf8', 'META.json' or skip "Can't open META.json", 1;
	my $json = <$f>;
	JSON::decode_json($json);
    };
    my $version = $meta->{version};

    open my $f, '<:utf8', 'Changes'
	or do {
	    fail "Can't open 'Changes'";
	    last;
	};
    <$f> for 1..2; # Skip the 2 first lines
    my $line = <$f>;
    chomp $line;
    like $line, qr/^$version    \d{4}-\d{2}-\d{2}    Olivier Mengué \(DOLMEN\)$/;
}

done_testing;
