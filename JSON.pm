package Plugins::SpotifyMika::JSON;

use strict;
use JSON::XS::VersionOneAndTwo;
use Slim::Utils::Log;

my $log = logger('plugin.spotifymika');

sub from_json_spotify {
    my $json = shift;
    $log->debug("Original:");
    $log->debug("$json");
    $json =~ s/("spotify):/\1mika:/g;
    $log->debug("Modified:");
    $log->debug("$json");
    my $result = from_json($json);
    $log->debug("Result:");
    $log->debug($result);
    return $result;
}

1;
