package Plugins::SpotifyMika::JSON;

use strict;
use JSON::XS::VersionOneAndTwo;
# use Slim::Utils::Log;

# my $log = logger('plugin.spotifymika');

sub from_json_spotify {
    my $json = shift;
    #$log->debug("Original:");
    #$log->debug("$json");
    $json =~ s/("spotify):/\1mika:/g;
    #$log->debug("Modified:");
    #$log->debug("$json");
    return from_json($json);
}

1;
