package WAF::Context;

use utf8;
use Moo;
use Try::Tiny;
use WAF::Config;
use WAF::Request;
use WAF::Error;
use JSON::XS;
use Encode;

has env => (
    is => 'rw', 
    required => 1
);

has route => (
    is => 'ro',
    lazy => 1,
    builder => '_build_route'
);

has request => (
    is => 'ro',
    lazy => 1,
    builder => '_build_request'
);

has response => (
    is => 'rw',
    lazy => 1,
    builder => '_build_response'
);

has stash => (
    is => 'rw',
    default => sub { return +{} },
);


sub _build_route {
    my $self = shift;
    return WAF::Config->router->match($self->env);
}

sub _build_request {
    my $self = shift;
    return undef unless $self->env;
    return WAF::Request->new($self->env);
};

sub _build_response {
    my $self = shift;
    return $self->request->new_response(200);
};

sub render_file {
    my ($self, $file, $args) = @_;
    $args //= {};
    require WAF::View::Xslate;
    my $content = WAF::View::Xslate->render_file($file, {
        c => $self,
        %{ $self->stash },
        %$args
    });
    return $content;
}

sub html {
    my ($self, $file, $args) = @_;
    my $content = $self->render_file($file, $args);
    $self->response->code(200);
    $self->response->content_type('text/html; charset=utf-8');
    $self->response->content(Encode::encode_utf8 $content);
}

sub json {
    my ($self, $hash) = @_;
    require JSON::XS;
    my $json = JSON::XS->new;
    $json->utf8;
    # $json->pretty(1);
    $self->response->code(200);
    $self->response->content_type('application/json; charset=utf-8');
    $self->response->content($json->encode($hash));
}

sub plain_text {
    my ($self, @lines) = @_;
    $self->response->code(200);
    $self->response->content_type('text/plain; charset=utf-8');
    $self->response->content(join "\n", @lines);
}

sub redirect {
    my ($self, $url) = @_;
    $self->response->code(302);
    $self->response->header(Location => $url);
}

sub error {
    my ($self, $code, $message, %opts) = @_;
    WAF::Error->throw($code, $message, %opts);
}

1;
