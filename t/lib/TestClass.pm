package TestClass;

use strict;
use warnings;

use Moose;

has blob => ( isa => "Any", is => "rw" );

sub parse {

    my $self = shift;
    local $/;
    my $fh = $self->fh;
    $self->blob( <$fh> );

}

with "File::Parser::Role";
