package IMDB::TitleID::SearchByTitle;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;
use LWP::Simple;

my $log_dump = Log::ger->get_logger(category => "dump");

our %SPEC;

$SPEC{search_imdb_title_id_by_title} = {
    v => 1.1,
    summary => 'Extract information from an IMDB title page',
    args => {
        title => {
            schema => 'str*',
            pos => 0,
            req => 1,
        },
    },
};
sub search_imdb_title_id_by_title {
    require URI::Escape;

    my %args = @_;

    my $title = $args{title};

    #my $url = "https://www.bing.com/search?q=imdb+".URI::Escape::uri_escape($q)); # returns "No result"
    #my $url = "https://duckduckgo.com/?q=imdb+".URI::Escape::uri_escape($q); # doesn't contain any result, only script sections including boxes
    #my $url = "https://www.google.com/search?q=imdb+".URI::Escape::uri_escape($q); # cannot even connect
    my $url = "https://id.search.yahoo.com/search?p=imdb+".URI::Escape::uri_escape($title); # thank god this still works as of 2019-12-23
    log_trace "IMDB search URL: $url";
    my $html = get $url;
    $log_dump->trace($html);
    $html =~ m!imdb\.com/title/(.+?)/!
        or return [500, "Cannot get IMDB title ID from web search 'imdb $title'"];
    my $tt = $1;

    [200, "OK", $tt];
}

1;
# ABSTRACT:

=head1 SEE ALSO
