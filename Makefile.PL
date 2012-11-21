use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'MooseX::FileBased',
    AUTHOR              => 'Torbjørn Lindahl <torbjorn.lindahl@diagenic.com>',
    VERSION_FROM        => 'lib/MooseX/FileBased.pm',
    ABSTRACT_FROM       => 'lib/MooseX/FileBased.pm',
    PL_FILES            => {},
    PREREQ_PM => {
                  'Test::More' => 0,
                  'version'    => 0,
                  'IO::String' => 0,
                  'Moose'      => 0,
                  'Carp'       => 0,
                  'IO::File'   => 0,
                  'Test::Most' => 0,
                  'Encode'     => 0,
                  'Pod::Coverage::Moose' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'MooseX-FileBased-*' },
);
