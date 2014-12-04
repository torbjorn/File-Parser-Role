package TestClassWithBuild;

use strict;
use warnings;

use Moose;
use File::Slurp;

has blob => ( isa => "Any", is => "rw" );

sub parse {

    my $self = shift;
    $self->blob( read_file( $self->fh ));

}

sub BUILD {
    my $self = shift;
    print $self->filename, "\n";
}

with "Parser::Moosey";

1;
