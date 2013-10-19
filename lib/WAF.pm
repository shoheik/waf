package WAF;

use strict;
use warnings;
use Data::Dumper;
use Moo;

use Class::Load qw(load_class);

#use Exporter::Lite;
#our @EXPORT = qw(get post any waf);
use Router::Simple;
our $router = Router::Simple->new();

use WAF::Context;
use WAF::View;
use WAF::Request;
use WAF::Response;

sub as_psgi {
    my $self = shift;
    return sub {
        my $env = shift;
        return $self->run($env);
    };
}

# ----- Controller -----

sub get {
    my ($url, $action) = @_;
    any($url, $action, ['GET']);
}

sub post {
    my ($url, $action) = @_;
    any($url, $action, ['POST']);
}

sub any {
    my ($url, $action, $methods) = @_;
    my $opts = {};
    $opts->{method} = $methods if $methods;
    $router->connect($url, { action => $action }, $opts);
}

sub run {
    my ($self, $env) = @_;

    #print Dumper $env;
    #print "run this now\n";
    my $context = new WAF::Context(env => $env);
    my $dispatch;
    my $route = $context->route;
    #print Dumper $route;

    my $engine = join '::', __PACKAGE__, 'Engine', $route->{engine};
    my $action = $route->{action} || 'default';
    $dispatch = "$engine#$action";

    #print Dumper $engine;
    load_class $engine;

    $self->before_dispatch($context);

    my $handler = $engine->can($action);
    #print Dumper $handler;
    $engine->$handler($context);
    

    #try {

    #};
    #catch {
    #    my $e = $_;
    #};
    #finally{
    #    print "Finally!!";
    #};

    #if (my $p = $router->match($env)) {
    #    $p->{action}->($context);
    #    return $context->res->finalize;
    #}
    #else {
    #    [404, [], ['not found']];
    #}

    $context->res->headers->header(X_Dispatch => $dispatch);
    return $context->res->finalize;
}


sub before_dispatch {
    my ($class, $c) = @_;
    # -------- csrfのための何らかの処理が欲しい -----
    # if ($c->req->method eq 'POST') {
    #     if ($c->user) {
    #         my $rkm = $c->req->parameter(body => 'rkm') or die 400;
    #         my $rkc = $c->req->parameter(body => 'rkc') or die 400;
    #         if ($rkm ne $c->user->rkm || $rkc ne $c->user->rkc) {
    #             die 400;
    #         }
    #     } else {
    #         die 400;
    #     }
    # }
}

sub after_dispatch {
    my ($class, $c) = @_;
}

1;

