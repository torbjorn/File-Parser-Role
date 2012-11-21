use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'MooseX::FileBased',
    license             => 'perl',
    dist_author         => 'Torbjørn Lindahl <torbjorn.lindahl@diagenic.com>',
    dist_version_from   => 'lib/MooseX/FileBased.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'MooseX-FileBased-*' ],
);

$builder->create_build_script();
