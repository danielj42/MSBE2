const bodyParser = require('body-parser');
const path = require('path');
const MongoClient = require('mongodb').MongoClient;
const ObjectID = require('mongodb').ObjectID;
const fs = require('fs');
//const NodeID3 = require('node-id3'); //enkel att använda men hittar mindre än ffmetadata
const ffmetadata = require("ffmetadata"); //ok, kräver dock ffmpg men det är ju inte så dumt att ha installerat iaf.
//const nodeID3v2 = require('node-id3v2.4'); // kass hittar väldigt få taggar
//const MediaLibrary = require('media-library'); // deprecated
//const mm = require('musicmetadata'); kräver ett window objekt för att fungera =()
//const jsmediatags = require("jsmediatags"); // helt ok men tillförde inte så mycket kanske kan använda denna om man inte vill installera ffmpg
const none = "n/a";
const baseurl = "http://127.0.0.1:3000/";
var database;
MongoClient.connect('mongodb://localhost:27017/media',
  function(error, database_) {
    if (error) {
      console.error("Failed to connect to server!  (mediafile2mongo.js)");
      console.log(error);
    } else {
      console.log("Connected to server! (mediafile2mongo.js)");
      database = database_;
    }
});

function persist(mediafile, folderPath) {
  console.log("GOT A MISSION TO PERSIST FILE: ", mediafile)

  entity = {
    file: mediafile,
    path: folderPath,
    fullPath: folderPath + mediafile,
    fileType: filetype(mediafile),
    mediaType: type(mediafile),
    nrOfPlays: 0,
    url: baseurl + mediafile
  };
  ifNotCallback = readID3andPersist;
  checkIfAlreadyInDatabase(entity, ifNotCallback);
}

function checkIfAlreadyInDatabase(entity, ifNotCallback) {
  database.collection('media').find({ "fullPath" : entity.fullPath })
    .toArray(function	(error,	result)	{
      if	(error)	{
        console.log('failed to read database');
        return;
      }
      //console.log("result", result);
      if (result.length == 0) {
        console.log("Trying to persist: " + entity.file);
        ifNotCallback(entity);
      } else {
        console.log("Skipping to persist: " + entity.file + " already in db.");
      }
    });
}

function readID3andPersist(entity) {
  ffmetadata.read(entity.fullPath, function(err, data) {
    if (err) console.error("Error reading metadata", err);
    else {
      //console.log("ffmetadata.read:RESULT:", data)
      id3Tags = {
        "name" : mapName(data, entity),
        "artist" : mapArtist(data, entity),
        "album" : mapAlbum(data, entity),
        "genre" : mapGenre(data, entity)
      }
      entity.id3 = id3Tags;
      addMediaObjectToDB(entity);
    };
  });
}

function mapName(tags, entity) {
  name = tags.title == true ? tags.title : tags.TITLE;
  if (name == true) {
    return name;
  }
  return filenameNoExtension(entity.file);
}

function mapArtist(tags, entity) {
  artist = tags.artist == true ? tags.artist : tags.ARTIST;
  if (artist == true) {
    return artist;
  }
  return none;
}

function mapAlbum(tags, entity) {
  album = tags.album == true ? tags.album : tags.ALBUM;
  if (album == true) {
    return album;
  }
  return none;
}

function mapGenre(tags, entity) {
  genre = tags.genre == true ? tags.genre : tags.GENRE;
  if (genre == true) {
    return genre;
  }
  return none;
}

function filenameNoExtension(filename) {
  namelenght = filename.lenght - filetype(filename).lenght;
  name = filename.substring(0, namelenght);
}

function filetype(filename) {
  return filename.split(/[. ]+/).pop();
}

function type(filename) {
  switch(filetype(filename)) {
    case 'mp3':
        return "audio"
    case 'flac':
        return "audio"
    case 'mkv':
        return "video"
    case 'mpg':
        return "video"
    case 'webm':
        return "video"
    default:
        return none;
  }
}

function addMediaObjectToDB(entity) {
  database.collection('media').insert(entity, (err, res) => {
    if (err) {
      console.log('addMediaObjectToDB:Error adding media to Db:', entity.file);
      return;
    }
    console.log('addMediaObjectToDB:Succeededed to add media to Db:', entity.file);
  });
}

module.exports = {
	persist : persist
}
