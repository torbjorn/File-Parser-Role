use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'File::Parser::Role',
    AUTHOR              => 'Torbjørn Lindahl <torbjorn.lindahl@diagenic.com>',
    VERSION_FROM        => 'lib/File/Parser/Role.pm',
    ABSTRACT_FROM       => 'lib/File/Parser/Role.pm',
    PL_FILES            => {},
    PREREQ_PM => {
                  'File::Slurp'          => '9999.19',
                  'IO::String'           => '1.08',
                  'Pod::Coverage::Moose' => '0.02',
                  'Test::Most'           => '0.25',
                  'Test::Perl::Critic'   => '1.02',
                  'Test::Pod'            => '1.45',
                  'Test::Pod::Coverage'  => '1.08',
                  'Moose'                => '2.0802',
                  'Moose::Role'          => '2.0802',
                  'Test::Output'         => '1.01',
                 },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'MooseX-FileBased-*' },
);
