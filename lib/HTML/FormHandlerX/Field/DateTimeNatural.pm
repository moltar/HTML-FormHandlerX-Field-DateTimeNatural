package HTML::FormHandlerX::Field::DateTimeNatural;

use Moose;
use MooseX::Types::DateTime;
extends 'HTML::FormHandler::Field::Text';

use DateTime::Format::Natural;

use version; our $VERSION = version->declare("v0.1.0");

has 'datetime_format_natural' => (
    is         => 'ro',
    isa        => 'DateTime::Format::Natural',
    lazy_build => 1,
    required   => 1,
);

has 'datetime' => (
    is         => 'rw',
    isa        => 'DateTime',
    lazy_build => 1,
);

has 'lang' => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has 'format' => (
    is         => 'rw',
    isa        => 'Str',
    lazy_build => 1,
);

has 'prefer_future' => (
    is         => 'rw',
    isa        => 'Bool',
    lazy_build => 1,
);

has 'time_zone' => (
    is         => 'rw',
    isa        => 'DateTime::TimeZone',
    lazy_build => 1,
    coerce     => 1,
);

has 'daytime' => (
    is         => 'rw',
    isa        => 'HashRef',
    lazy_build => 1,
);


our $class_messages = {
    'date_invalid' => 'Date is invalid.',
};

sub get_class_messages {
    my $self = shift;
    return {
        %{$self->next::method},
        %{$class_messages},
    };
}

sub validate {
    my $self = shift;
    my $value = $self->value;
    
    ## if no value then return right away or DT::F::N might fail
    return 0 unless $value;

    ## validate
    my $parser = $self->datetime_format_natural;
    my $dt = $parser->parse_datetime($value);

    ## update to inflated value or set error
    if ($parser->success) {
        $self->_set_value($dt);
    } else {
        $self->add_error($self->get_message('date_invalid'));
    }

    ## return
    return $parser->success;
}

sub _build_datetime_format_natural {
    my $self = shift;

    my %attributes;
    foreach my $attr (qw/datetime lang format prefer_future daytime/) {
        my $predicate = "has_$attr";
        if ($self->$predicate) {
            $attributes{$attr} = $self->$attr;
        }
    }
    
    ## Fix time_zone if set, because DT::F::N can only accept time zone
    ## names and not objects, at the time of writing this module.
    if ($self->has_time_zone) {
        $attributes{time_zone} = $self->time_zone->name;
    }

    return DateTime::Format::Natural->new(%attributes);
}

__PACKAGE__->meta->make_immutable;
use namespace::autoclean;
1;

__END__
=pod

=head1 NAME

HTML::FormHandlerX::Field::DateTimeNatural - a datetime field with natural
language parsing.

=head1 VERSION

0.1.0

=head1 SYNOPSIS

This field is a simple text input field type, but it understands natural
language and dates. Most of the functionality is inherited from
L<DateTime::Format::Natural>. To see a list of dates it can understand see
L<DateTime::Format::Natural::Lang::EN>.

  has_field 'date' => (
    type      => 'DateTimeNatural',
    time_zone => 'UTC', # optional
  );

=head1 METHODS

This field supports all of the methods inherited from
L<HTML::FormHandler::Field::Text>, as well as all of the parameters offered by
L<DateTime::Format::Natural>, all of which are optional.

Here is the list of the methods, please refer to original module for
their description:

=over 4

=item time_zone

=item datetime

=item lang

=item format

=item prefer_future

=item daytime

=back

=head1 SEE ALSO

=over 4

=item L<HTML::FormHandler>

=item L<HTML::FormHandler::Field::Text>

=item L<DateTime::Format::Natural>

=item L<DateTime::Format::Natural::Lang::EN>

=back

=head1 AUTHOR

 Roman F.
 romanf@cpan.org

=head1 COPYRIGHT

Copyright (c) 2011 Roman F.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

