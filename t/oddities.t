#!/usr/bin/perl

use strict;
use warnings;
use Test::Most;
use Test::Warnings;

use Module::Load::Conditional qw/check_install/;

use lib 't/lib';
use TestClass;

use Encode;

my $builder = Test::More->builder;
binmode $builder->output         , ":utf8";
binmode $builder->failure_output , ":utf8";
binmode $builder->todo_output    , ":utf8";

my $latin1_test_file = "t/test_data/some_file_latin1.txt";
my $utf8_test_file   = "t/test_data/some_file_utf8.txt";
my $binary_file      = "t/test_data/some_file_binary.data";

my $f_ref = TestClass->new( $latin1_test_file );
my $cmp = {%$f_ref};
$cmp->{fh} = ignore;
$cmp->{file} = "$cmp->{file}";

if ( check_install( module => "Path::Tiny" ) ) {

    require Path::Tiny;
    Path::Tiny->import("path");

    isa_ok my $f = path($latin1_test_file), "Path::Tiny";
    my $obj = TestClass->new($f);

    delete local $cmp->{filename} unless defined $cmp->{filename};
    delete local $cmp->{size} unless defined $cmp->{size};

    cmp_deeply(
        {%$f_ref},
        $cmp,
        "Path::Tiny"
    );

}

if ( check_install( module => "IO::All" ) ) {

    require IO::All;
    IO::All->import("io");

    isa_ok my $f = io($latin1_test_file), "IO::All";
    my $obj = TestClass->new($f);

    delete local $cmp->{filename} unless defined $cmp->{filename};
    delete local $cmp->{size} unless defined $cmp->{size};

    cmp_deeply(
        {%$f_ref},
        $cmp,
        "IO::All"
    );

}

if ( check_install( module => "Mojo::Path" ) ) {

    require Mojo::Path;

    isa_ok my $f = Mojo::Path->new($latin1_test_file), "Mojo::Path";
    my $obj = TestClass->new($f);

    delete local $cmp->{filename} unless defined $cmp->{filename};
    delete local $cmp->{size} unless defined $cmp->{size};

    cmp_deeply(
        {%$f_ref},
        $cmp,
        "Mojo::Path"
    );

}

## its already tested elsewhere but whattheheck
if ( check_install( module => "IO::File" ) ) {

    require IO::File;

    isa_ok my $f = IO::File->new($latin1_test_file), "IO::File";
    my $obj = TestClass->new($f);

    delete local $cmp->{filename} unless defined $cmp->{filename};
    delete local $cmp->{size} unless defined $cmp->{size};

    cmp_deeply(
        {%$f_ref},
        $cmp,
        "IO::File"
    );

}

done_testing;
