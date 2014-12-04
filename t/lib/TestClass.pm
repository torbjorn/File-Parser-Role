package TestClass;

use strict;
use warnings;

use Moose;
use File::Slurp;

has blob => ( isa => "Any", is => "rw" );

sub parse {

    my $self = shift;
    $self->blob( read_file( $self->fh ));

}

with "Parser::Moosey";
