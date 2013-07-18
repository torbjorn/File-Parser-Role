use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'MooseX::FileBased',
    license             => 'perl',
    dist_author         => 'Torbjørn Lindahl <torbjorn.lindahl@diagenic.com>',
    dist_version_from   => 'lib/MooseX/FileBased.pm',
    requires => {
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
    add_to_cleanup      => [ 'MooseX-FileBased-*' ],
);

$builder->create_build_script();
