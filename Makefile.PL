use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'File::Parser::Role',
    AUTHOR              => 'Torbjørn Lindahl <torbjorn.lindahl@gmail.com>',
    VERSION_FROM        => 'lib/File/Parser/Role.pm',
    ABSTRACT_FROM       => 'lib/File/Parser/Role.pm',
    PL_FILES            => {},
    PREREQ_PM => {
                  'IO::String'           => '1.08',
                  'Pod::Coverage::Moose' => '0.02',
                  'Test::Most'           => '0.25',
                  'Test::Perl::Critic'   => '1.02',
                  'Test::Pod'            => '1.45',
                  'Test::Pod::Coverage'  => '1.08',
                  'Test::Output'         => '1.01',
                 },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'File-Parser-Role-*' },
);
