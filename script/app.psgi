use strict;
use warnings;
use utf8;

use Data::Dumper;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use Plack::Builder;

use WAF;
use WAF::Config;

my $app = WAF->as_psgi;
my $root = config->root;

builder {
    enable 'Static', path => qr<^/(?:images|js|css|)/>, root => './public/';
    enable 'Static', path => qr<^/favicon\.ico$>,      root => './public/images';
    $app;
};

