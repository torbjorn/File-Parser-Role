package MooseX::FileBased;

use warnings;
use strict;
use Carp;
use IO::String;

use version; our $VERSION = qv('1.0.1');
use Moose::Role;

# Module implementation here

# File things
has file     =>  ( isa => "Any",   is => "rw"   );
has size     =>  ( isa => "Int",   is => "rw"   );
has filename =>  ( isa => "Str",   is => "rw"   );
has encoding =>  ( isa => "Str",   is => "rw"   );

requires "parse";

sub fh {

    my $self = shift;

    if ( ref $self->file eq "SCALAR" ) {
        ## encoding won't be an issue as content already exists
        return IO::String->new( $self->file );
    }
    elsif ( ref $self->file ) {
        ## assume its something that can be read from as a file handle
        ## - the source of this is in charge of encoding for now
        return $self->file;
    }
    elsif ( -r $self->file ) {
        my $fh = IO::File->new( $self->file, "r" );
        ## set it to the (possibly) specified encoding
        if ( defined $self->encoding ) {
            binmode $fh, sprintf(":encoding(%s)", $self->encoding) or croak $!;
        }
        return $fh;
    }
    else {
        confess "Cannot work with input file";
    }

}

sub BUILD {

    my $self = shift;

    if ( not ref $self->file and -r $self->file ) { ## should now be a filename that can be read
        $self->size( -s $self->file );
        $self->filename( $self->file );
    }

    $self->parse;

}

1; # Magic true value required at end of module
__END__

=encoding utf8

=head1 NAME

MooseX::FileBased - [One line description of module's purpose here]


=head1 VERSION

This document describes MooseX::FileBased version 1.0.1. This is a
Moose::Role for moose objects centered around reading (and parsing)
single data files. It adds 3 kinds of constructors:

=over

=item file names

=item IO::Handle's

=item scalar references to content

=back

It also provides a method "fh" that gives a file handle to the
contents of the file.

=head1 SYNOPSIS

    package MyFileObject;

    sub parse {
        my $self = shift;

        # ... do stuff, $self->fh available
    }

    with "MooseX::FileBased";

    ## ... and in some nearby code:

    my $fo = MyFileObject->new({ file => "some_file.txt" });
    ## optinally:

    my $fo = MyFileObject->new({ file => "some_file.txt", encoding => "utf8" });
    ## encoding can be anything that binmode's encoding() can understand.

    print $fo->filename; # "some_file.txt"
    print $fo->size; # size of some_file.txt

    ## - OR -

    my $fh = IO::File->new( "< some_file.txt" );
    ## you are now responsible for encoding on this handle!

    my $fo = MyFileObject->new({ file => $fh });

    ## no filename nor file size available

    ## - OR -

    my $file_content = read_file( "some_file.txt" );
    my $fo = MyFileObject->new({ file => \$file_content });

    ## you are now responsible for encoding on this data

    ## no file name nor file size available

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.


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

=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.

MooseX::FileBased requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


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
C<bug-moosex-filebased@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Torbjørn Lindahl  C<< <torbjorn.lindahl@diagenic.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2012, Torbjørn Lindahl C<< <torbjorn.lindahl@diagenic.com> >>. All rights reserved.

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
