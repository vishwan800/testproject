#!/usr/bin/env perl

use strict;
use warnings;

use ZOOM;
use feature 'say';

my $host = 'z3950.bnf.fr';
my $port = '2211';
my $db = 'TOUT-UTF8';

eval {
    my $level = ZOOM::Log::mask_str("zoom,myapp,debug");
    ZOOM::Log::init_level($level);
    my $user = ZOOM::Options->new();
    $user->option(user => "Z3950");
    my $pass = ZOOM::Options->new();
    $pass->option(password => "Z3950_BNF");
    my $options = ZOOM::Options->new($user, $pass);
    my $conn = ZOOM::Connection->create($options);
    $conn->connect($host, $port, databaseName => $db );
    $conn->option( preferredRecordSyntax => 'unimarc' );

    my $qq = shift;
    say "Our query: ", $qq;
    my $rs = $conn->search_pqf( $qq );
    $rs->option( elementSetName => 'F' );

    my $n  = $rs->size();
    say "We have $n records.";
    for my $i (1 .. $n) {
        my $rec = $rs->record($i-1);
        say $rec->render("charset=utf8");
    }
};
if ($@) {
    say "Error ", $@->code(), ": ", $@->message(), "\n";
}
