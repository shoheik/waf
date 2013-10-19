use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use WAF;
use Data::Dumper;

my $app = WAF->as_psgi;
#print Dumper WAF::run;

any '/' => sub {
    my $c = shift;
    $c->render('index.tt', { name => 'shiba_yu36' });
};

get '/hoge' => sub {
    my $c = shift;
    $c->render('hoge.tt', { name => 'shiba_yu36' });
};

$app;
#WAF::run;
