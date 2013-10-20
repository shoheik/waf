package WAF::DBI::Factory;

use Moo;
use utf8;
use Carp ();
use Scope::Container::DBI;
use WAF::Config;

sub dbconfig {
    my ($self, $name) = @_;
    my $dbconfig = config->param('db') // Carp::croak 'required db setting';
    return $dbconfig->{$name} // Carp::croak qq(db config for '$name' does not exist);
}

sub dbh {
    my ($self, $name) = @_;

    my $db_config = $self->dbconfig($name);
    my $user      = $db_config->{user} or Carp::croak qq(user for '$name' does not exist);
    my $password  = $db_config->{password} or Carp::croak qq(password for '$name' does not exist);
    my $dsn       = $db_config->{dsn} or Carp::croak qq(dsn for '$name' does not exist);

    my $dbh = Scope::Container::DBI->connect($dsn, $user, $password, {
        RootClass => 'WAF::DBI',
    });
    return $dbh;
}

sub query_builder {
    my ($self) = @_;

    require SQL::Maker;

    my $builder = SQL::Maker->new(
        driver => 'mysql',
    );
    return $builder;
}

1;
