package WAF;

use strict;
use warnings;
use Data::Dumper;

use Exporter::Lite;
our @EXPORT = qw(get post any waf);

use Router::Simple;
our $router = Router::Simple->new();

use WAF::Context;
use WAF::View;
use WAF::Request;
use WAF::Response;

sub as_psgi {
    my $class = shift;
    return sub {
        my $env = shift;
        #print Dumper $env;
        #return $class->run($env);
        return run($env);
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
    #  return my $app = sub {
        my $env = shift;

        print "run this now\n";

        my $context = WAF::Context->new(
            env          => $env,
        );

        if (my $p = $router->match($env)) {
            $p->{action}->($context);
            return $context->res->finalize;
        }
        else {
            [404, [], ['not found']];
        }
        #};
}

1;

