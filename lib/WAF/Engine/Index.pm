package WAF::Engine::Index;

use utf8;
use Moo;
use Data::Dumper;

sub default {
    my ($self, $context) = @_;

    print Dumper $context;
    $context->render();

    #my $user = $c->user;
    #return $c->html('index.html') unless $user;

    #my $bookmarks = Intern::Bookmark::Service::Bookmark->find_bookmarks_by_user(
    #    $c->db,
    #    { user => $user },
    #);
    #Intern::Bookmark::Service::Bookmark->load_entry_info($c->db, $bookmarks);
    #$c->html('index.html', {
    #    bookmarks => $bookmarks,
    #});
}

1;
