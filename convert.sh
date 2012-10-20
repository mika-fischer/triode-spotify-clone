#!/bin/bash

VERSION=2.2.9

rm -rf Spotify SpotifyMika
if ! [ -e Spotify-linux-v${VERSION}.zip ]; then
    wget http://xdevtriodeplugins.xpdev-hosted.com/Spotify-linux-v${VERSION}.zip
fi
unzip -q Spotify-linux-v${VERSION}.zip
cp -a Spotify SpotifyMika

find SpotifyMika -type f -name '*.pm' -or -name '*.xml'  | xargs sed -i 's/Plugins::Spotify/Plugins::SpotifyMika/g'
find SpotifyMika -type f                                 | xargs sed -i 's#plugins/Spotify#plugins/SpotifyMika#g'
find SpotifyMika -type f -name '*.pm' -or -name '*.xml'  | xargs sed -i 's/Spotifyd/SpotifydMika/g'
find SpotifyMika -type f                                 | xargs sed -i 's/PLUGIN_SPOTIFY/PLUGIN_SPOTIFYMIKA/g'
find SpotifyMika -type f                                 | xargs sed -i 's/plugin.spotify/plugin.spotifymika/g'
find SpotifyMika -type f -name '*.pm' -or -name '*.html' | xargs sed -i 's/spotify/spotifymika/g'
find SpotifyMika -type f -name '*.pm' -or -name '*.txt'  | xargs sed -i 's/9005/9006/g'
find SpotifyMika -type f -name '*.pm'                    | xargs sed -i 's/JSON::XS::VersionOneAndTwo/Plugins::SpotifyMika::JSON/g'
find SpotifyMika -type f -name '*.pm'                    | xargs sed -i 's/from_json/Plugins::SpotifyMika::JSON::from_json_spotify/g'
find SpotifyMika -type f -name '*.pm'                    | xargs sed -i 's/Ogg Vorbis (Spotify)/Ogg Vorbis (SpotifyMika)/g'

# Correct some mistakes
find SpotifyMika -type f                                 | xargs sed -i 's/spotifymikamika/spotifymika/g'
find SpotifyMika -type f                                 | xargs sed -i 's/libspotifymika/libspotify/g'
sed -i 's/spotifymikalogi/spotifylogi/g'       SpotifyMika/Plugin.pm
sed -i 's/spotifymika com/spotify com/g'       SpotifyMika/Plugin.pm
sed -i 's/spotifymika\.com/spotify\.com/g'     SpotifyMika/Plugin.pm
sed -i 's/spotifymika\\\.com/spotify\\\.com/g' SpotifyMika/Plugin.pm
sed -i '2c\\tEN\tSpotifyMika'                  SpotifyMika/strings.txt

# Make sure spotifyd actually gets spotify: uris, not spotifymika:
sed -i "s#my \$suffix = shift .. '';#my \$suffix = shift || ''; \$suffix =~ s/spotifymika/spotify/;#" SpotifyMika/Spotifyd.pm
sed -i "s#^\(.*\$trackuri =~.*\)\$#\1    \$trackuri =~ s/spotifymika/spotify/;#" SpotifyMika/ProtocolHandlerSpotifyd.pm

# Rename files
mv SpotifyMika/Spotifyd.pm SpotifyMika/SpotifydMika.pm
mv SpotifyMika/ProtocolHandlerSpotifyd.pm SpotifyMika/ProtocolHandlerSpotifydMika.pm
mv SpotifyMika/HTML/EN/plugins/Spotify SpotifyMika/HTML/EN/plugins/SpotifyMika
(cd SpotifyMika/Bin/i386-linux && for i in spotifyd*; do mv $i spotifymikad${i#spotifyd}; done)
cp JSON.pm SpotifyMika

rm -rf SpotifyMika-linux-v${VERSION}.zip
zip -rq SpotifyMika-linux-v${VERSION}.zip SpotifyMika

SHASUM=$(shasum SpotifyMika-linux-v${VERSION}.zip | awk '{ print $1 }')
sed -e "s/SHASUM/$SHASUM/" -e "s/VERSION/$VERSION/g" <repo.xml.in >repo.xml
