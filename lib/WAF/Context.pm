package WAF::Context;

use utf8;
use Moo;
use Try::Tiny;
use WAF::Config;

has env => (
    is => 'rw', 
    required => 1
);

has route => (
    is => 'ro',
    lazy => 1,
    builder => '_build_route'
);

sub _build_route {
    my $self = shift;
    return WAF::Config->router->match($self->env);
}

#sub data_section {
#    my $self = shift;
#    return $self->{data_section};
#}

sub req {
    my $self = shift;
    return $self->{_req} ||= WAF::Request->new($self->env);
}

sub res {
    my $self = shift;
    return $self->{_res} ||= $self->req->new_response(200);
}

sub render {
    my ($self, $tmpl_name, $args) = @_;
    #my $str  = $self->data_section->get_data_section($tmpl_name);
    my $str  = "hogehoge"; 
    my $body = WAF::View->render_string($str, $args);
    return $self->res->body($body);
}

1;
