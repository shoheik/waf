use Test::More;
use lib 'lib';

BEGIN { 
    use_ok( 'WAF' ); 
    use_ok( 'WAF::View' ); 
    use_ok( 'WAF::Response' ); 
    use_ok( 'WAF::Request' ); 
    use_ok( 'WAF::Context' ); 
    use_ok( 'WAF::Config' ); 
    use_ok( 'WAF::Config::Route' ); 
}
done_testing();

1;
