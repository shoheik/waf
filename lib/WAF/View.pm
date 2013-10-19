package WAF::View;

use Text::Xslate;

our $tx = Text::Xslate->new(
    syntax => 'TTerse',
    module => [ qw(Text::Xslate::Bridge::TT2Like) ],
);

sub render_string {
    my ($class, $str, $args) = @_;
    return $tx->render_string($str, $args);
}

1;
