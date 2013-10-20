use Test::More;
use lib 'lib';

BEGIN { 
    use_ok( 'WAF' ); 
    use_ok( 'WAF::Response' ); 
    use_ok( 'WAF::Request' ); 
    use_ok( 'WAF::Context' ); 
    use_ok( 'WAF::Config' ); 
    use_ok( 'WAF::Config::Route' ); 
    use_ok( 'WAF::View::Xslate' ); 
    use_ok( 'WAF::Engine::Index' ); 
    use_ok( 'WAF::DBI' ); 
    use_ok( 'WAF::DBI::Factory' ); 
    use_ok( 'WAF::Util' ); 
    use_ok( 'WAF::Model::User' ); 
    use_ok( 'WAF::Service::User' ); 
}
done_testing();

1;
