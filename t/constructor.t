#!/usr/bin/perl

use strict;
use warnings;

use Test::Most;
use File::Slurp;
use IO::File;

use lib 't/lib';
use TestClass;

use Encode;

my $builder = Test::More->builder;
binmode $builder->output, ":utf8";
binmode $builder->failure_output, ":utf8";
binmode $builder->todo_output, ":utf8";

my $latin1_test_file = "t/test_data/some_file_latin1.txt";
my $utf8_test_file = "t/test_data/some_file_utf8.txt";
my $binary_file = "t/test_data/some_file_binary.data";

plan tests => 9*3 + 2*3;

sub test_files {

    my @files = @_;

    ## test from filename:
    note( "latin1 file tests" );
    my $f1 = TestClass->new({file => $files[0] });
    isa_ok( $f1, "TestClass" );
    is( -s $latin1_test_file, length $f1->blob, "file size matches contents length" );
    is( read_file($latin1_test_file), $f1->blob, "read data matches file content");

    if ( not ref $files[0] ) {
        is( $f1->filename, $latin1_test_file, "file name picked up" );
        is( $f1->size, length $f1->blob, "stored file size matches contents length" );
    }

    note( "utf8 file tests" );
    my $f2 = TestClass->new({file => $files[1], encoding => "utf8" });
    isa_ok( $f2, "TestClass" );
    is( $f1->blob, $f2->blob, "latin1 and utf8 content identical" );

    is( read_file($utf8_test_file, { binmode => ":utf8" } ),
        $f2->blob, "read data matches file content");

    if ( not ref $files[0] ) {
        is( $f2->filename, $utf8_test_file, "file name picked up" );
        is( $f2->size, length encode( "UTF-8", $f2->blob ),
            "stored file size matches contents length" );
    }

    note( "binary file tests" );
    my $f3 = TestClass->new({file => $files[2] });
    isa_ok( $f3, "TestClass" );
    is( -s $binary_file, length $f3->blob, "file size matches contents length" );
    is( read_file($binary_file), $f3->blob, "read data matches file content");

    if ( not ref $files[0] ) {
        is( $f3->filename, $binary_file, "file name picked up" );
        is( $f3->size, length $f3->blob, "stored file size matches contents length" );
    }

}

## test on file names

note("Testing on file names");
test_files( $latin1_test_file, $utf8_test_file, $binary_file );


note("Testing on IO::File's");
my @io_files = (
                IO::File->new( "< $latin1_test_file" ),
                IO::File->new( "< $utf8_test_file" ),
                IO::File->new( "< $binary_file" ),
               );
binmode $io_files[1], ":utf8";
test_files( @io_files );


note("Testing on scalar references");
test_files(
           \read_file( "$latin1_test_file" ),
           \read_file( "$utf8_test_file", { binmode => ":utf8" } ),
           \read_file( "$binary_file" ),
          );

done_testing;
