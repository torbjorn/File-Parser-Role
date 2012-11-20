use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Moosex::FileBased',
    AUTHOR              => 'Torbjørn Lindahl <torbjorn.lindahl@diagenic.com>',
    VERSION_FROM        => 'lib/Moosex/FileBased.pm',
    ABSTRACT_FROM       => 'lib/Moosex/FileBased.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Moosex-FileBased-*' },
);
