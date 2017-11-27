docker run --name media-mongo --publish 27017:27017 -d mongo

docker run -it --link media-mongo:mongo mongo sh -c 'exec mongo "$MONGO_PORT_27017_TCP_ADDR:$MONGO_PORT_27017_TCP_PORT/media"'

db.media.insert({ "name": "Clair de Lune", "artist" : "Claude Debussy", "type" : "audio", "filetype" : "mp3", "length" : "3.59", "genre" : "classical", "filename" : "debussy-clair-de-lune.mp3" });

db.media.insertMany([{ "name": "Clair de Lune", "artist" : "Claude Debussy", "type" : "audio", "filetype" : "mp3", "length" : "3.59", "genre" : "classical", "filename" : "debussy-clair-de-lune.mp3" }, { "name": "Highway to Hell", "artist" : "AC/DC", "type" : "audio", "filetype" : "mp3", "length" : "6.66", "genre" : "rock", "filename" : "acdc-highway-to-hell.mp3" }, { "name": "Kill 'em All", "artist" : "Metallica", "type" : "audio", "filetype" : "mp3", "length" : "4.20", "genre" : "thrash metal", "filename" : "metallica-kill-em-all.mp3" }]);
