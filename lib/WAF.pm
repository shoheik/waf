package WAF;

# This is for dispatching and error handling

use Moo;
use utf8;
use Data::Dumper;
use Data::Dumper::Concise; # to see sub { DUMMY }
use Class::Load qw(load_class);
use Log::Minimal; 
use Try::Tiny;
use HTTP::Status;

use WAF::Context;
use WAF::Config;
use WAF::Request;
use WAF::Response;
use WAF::Error;

sub as_psgi {
    my $self = shift;
    return sub {
        my $env = shift;
        return $self->run($env);
    };
}

sub run {
    my ($self, $env) = @_;

    my $context = new WAF::Context(env => $env);
    my $dispatch;

    try {
        my $route = $context->route or WAF::Error->throw(404);;
        $route->{engine} or WAF::Error->throw(404);

        my $engine = join '::', __PACKAGE__, 'Engine', $route->{engine};
        my $action = $route->{action} || 'default';
        $dispatch = "$engine#$action";
        infof("Dispatching $dispatch");
        load_class $engine;

        $self->before_dispatch($context);

        my $handler = $engine->can($action) or WAF::Error->throw(501);;
        $engine->$handler($context);
    }
    catch {
        my $e = $_;

        my $res = $context->request->new_response;
        if (eval { $e->isa('WAF::Error') }) {
            my $message = $e->{message} || HTTP::Status::status_message($e->{code});
            $res->code($e->{code});
            $res->header('X-Error-Message' => $message);
            $res->content_type('text/plain');
            $res->content($message);
        }
        else {
            critf "%s", $e;
            my $message = (config->env =~ /production/) ? 'Internal Server Error' : $e;
            $res->code(500);
            $res->content_type('text/plain');
            $res->content($message);
        }
        $context->response($res);
    }
    finally {
        $self->after_dispatch($context);
    };

    $context->response->headers->header(X_Dispatch => $dispatch);
    return $context->response->finalize;
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

