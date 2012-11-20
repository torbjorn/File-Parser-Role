use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Moosex::FileBased',
    license             => 'perl',
    dist_author         => 'Torbjørn Lindahl <torbjorn.lindahl@diagenic.com>',
    dist_version_from   => 'lib/Moosex/FileBased.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Moosex-FileBased-*' ],
);

$builder->create_build_script();
