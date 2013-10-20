package WAF::Model::User;

use Moo;
use utf8;
use JSON::Types qw();
use WAF::Util;

has user_id => (
    is => 'ro',
);

has name => (
    is => 'ro',
);

sub created {
    my ($self) = @_;
    $self->{_created} ||= eval {
        WAF::Util::datetime_from_db($self->{created});
    };
}

sub json_hash {
    my ($self) = @_;
    return {
        user_id => JSON::Types::number $self->user_id,
        name    => JSON::Types::string $self->name,
        created => JSON::Types::string $self->created,
    };
}

1;
