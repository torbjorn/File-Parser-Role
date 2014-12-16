package File::Parser::Role;

use warnings;
use strict;
use utf8;
use Carp;
use IO::File;
use IO::String;

use version; our $VERSION = qv('0.0.2');
use Moo::Role;
use MooX::Aliases;

# File things
has file     =>  ( is => "ro", alias => [qw/path filepath uri url/] );
has size     =>  ( is => "ro" );
has filename =>  ( is => "ro" );
has encoding =>  ( is => "ro"   );
has fh       =>  ( is => "lazy" );

requires "parse";

sub _build_fh {

    my $self = shift;

    ## If stringified input is a readable file, treat it like that
    if ( -r "${\ $self->file }" ) {

        my $fh = IO::File->new( $self->file, "r" );

        ## set it to the (possibly) specified encoding
        if ( defined $self->encoding ) {
            binmode $fh, sprintf(":encoding(%s)", $self->encoding) or confess $!;
        }
        return $fh;

    }

    ## A scalar reference is assumed to be content to be parsed
    elsif ( ref $self->file eq "SCALAR" ) {
        return IO::String->new( $self->file );
    }

    ## If it's any kind of object, assume it can be <read> from
    elsif ( ref $self->file ) {

        ## assume its something that can be read from as a file handle
        ## set encoding and use it
        if ( defined $self->encoding ) {
            binmode $self->file, sprintf(":encoding(%s)", $self->encoding) or confess $!;
        }
        return $self->file;

    }

    ## can't grok it
    else {
        confess "Cannot work with input file - its neither a readable path nor a reference";
    }

}

around BUILDARGS => sub {

    my ($orig, $class) = (shift, shift);

    my @args = @_;

    if ( @args == 1 and (ref( $args[0])||'') ne 'HASH' ) {
        @args = ({ file => $args[0] });
    }

    if ( not exists $args[0]->{file} and defined $args[0]->{filename} ) {
        ## filename gets deleted for now and only re-inserted later on
        ## if proven to be a valid filename
        $args[0]->{file} = delete $args[0]->{filename};
    }

    ## capture the aliases this way
    my $obj = $class->$orig(@args);
    my $f = $obj->{file};

    ## test if it seems to be a path to a file
    if ( defined $f and -e "$f" ) {

        ## size (most likely) and filename can now be set

        ## only sets/overrides size if it isn't already set
        $obj->{size} = -s "$f" unless exists $obj->{size};

        ## set filename if not already set
        $obj->{filename} = "$f" unless defined $obj->{filename};

    }

    return $obj;

};

sub BUILD {
    my $self = shift;
    $self->parse;
};

1; # Magic true value required at end of module
__END__

=encoding utf8

=head1 NAME

File::Parser::Role - Read and prepare parsing of file (or glob) data
from some source

=head1 VERSION

This document describes File::Parser::Role version 0.0.2. This is a
Moo::Role for reading (and then parsing) single data files. It makes
the constructor support 3 kinds of file sources:

=over

=item a path to a readable file

=item a file handle or anything that can be read like one

=item a scalar references to content

=back

It also provides a method "fh" that gives an at least readable file
handle to the contents of the file.

=head1 SYNOPSIS

package MyClassThatDoesStuffToAFile;

sub parse {
    my $self = shift;

    # ... do stuff, $self->fh available
}

with "File::Parser::Role";

## ... and in some nearby code:

my $obj = MyClassThatDoesStuffToAFile->new("some_file.txt");
# or #
my $obj = MyClassThatDoesStuffToAFile->new(file => "some_file.txt");
## optinally:

my $obj = MyClassThatDoesStuffToAFile->new( file => "some_file.txt", encoding => "utf8" );
## encoding can be anything that binmode's encoding() can understand.

print $obj->filename; # "some_file.txt"
print $obj->size;     # size of some_file.txt

## - OR -

my $fh = IO::File->new( "< some_file.txt" );
## you are now responsible for encoding on this handle!

my $obj = MyClassThatDoesStuffToAFile->new( file => $fh );

## no filename nor file size available

## - OR -

my $file_content = read_file( "some_file.txt" );
my $obj = MyClassThatDoesStuffToAFile->new( file => \$file_content );

## you are also responsible for encoding on this data
## no file name nor file size available

=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.

=head2 fh

returns ro filehandle (IO::File) to the contents of the file

=head2 parse

a required method that you must write!

=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Cannot work with input file >>

The file argument is neither a readable file, an object nor a
reference to content

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.

File::Parser::Role requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-file-parser-role@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Torbjørn Lindahl  C<< <torbjorn.lindahl@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2012, Torbjørn Lindahl C<<
<torbjorn.lindahl@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
