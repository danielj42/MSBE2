docker run --name media-mongo --publish 27017:27017 --rm -d mongo

docker run -it --link media-mongo:mongo mongo --rm sh -c 'exec mongo "$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/media"'

db.media.insert({ "name": "Clair de Lune", "artist" : "Claude Debussy", "type" : "audio", "filetype" : "mp3", "length" : "3.59", "genre" : "classical", "filename" : "debussy-clair-de-lune.mp3", "plays" : "0" });

db.media.insertMany([{ "name": "Clair de Lune", "artist" : "Claude Debussy", "type" : "audio", "filetype" : "mp3", "length" : "3.59", "genre" : "classical", "filename" : "debussy-clair-de-lune.mp3", "plays" : "0" }, { "name": "Für Elise", "artist" : "Ludvig van Beethoven", "type" : "audio", "filetype" : "mp3", "length" : "2.36", "genre" : "classical", "filename" : "fur-elise.mp3", "plays" : "0" }, { "name": "Toccata and Fugue in D-minor", "artist" : "Johann Sebastian Bach", "type" : "audio", "filetype" : "mp3", "length" : "8.38", "genre" : "classical", "filename" : "Toccata-and-Fugue-Dm.mp3", "plays" : "0" }]);
