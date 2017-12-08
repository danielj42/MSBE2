const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const MongoClient = require('mongodb').MongoClient;
const ObjectID = require('mongodb').ObjectID;
const testFolder = './media/';
const fs = require('fs');
//const mediafile2mongo = require('./mediafile2mongo'); //Nix vi ska inte fylla databasen dynamiskt

const app = express();
var database;

app.use(bodyParser.json());

MongoClient.connect('mongodb://localhost:27017/media',
  function(error, database_) {
    if (error) {
      console.error("Failed to connect to server!");
      console.log(error);
    } else {
      console.log("Connected to server!");
      database = database_;
      cleanDB(refillDB);
    }
});

//MEDIA
app.use(express.static(path.join(path.resolve(),'media')));

//WWW
app.use(express.static(path.join(path.resolve(),'www')));

app.get('/api/media/files', function (request, response) {
  var fileList = [];
  fs.readdir(testFolder, (err, files) => {
    files.forEach(file => {
      fileEnding = file.split(/[. ]+/).pop();
      supportedFileEndings = ["mp3", "flac", "mpg", "mkv", "webm"];
      if (supportedFileEndings.indexOf(fileEnding) > -1) {
        fileList.push(file);

        //ADDERA TILL DB (Nej inte automatiskt, detta ska göras manuellt)
        //mediafile2mongo.persist(file, testFolder);
      }
      //console.log(file);
      //console.log("in method", fileList);
    });
    //console.log("outside method", fileList);
    var fileListJSON = JSON.stringify(fileList);
    response.send(fileListJSON);
  });
});

app.get('/api/media', function (request, response) {
 database.collection('media').find().toArray(function	(error,	result)	{
   if	(error)	{
     response.status(500).send(error);
     return;
   }
   response.send(result);
 });
});

app.get('/api/media/:id', function (request, response) {
  var objectId = new ObjectID(request.params.id);

  database.collection('media').find({ "_id" : objectId })
    .toArray(function	(error,	result)	{
      if	(error)	{
        response.status(500).send(error);
        return;
      }
      response.send(result);
    });
});

app.put('/api/media', function (request, response) {
  var objectId = new ObjectID(request.query.id);

  database.collection('media').update({ "_id" : objectId},
    { "name" : request.query.name,
        "artist" : request.query.artist,
        "type" : request.query.type,
        "filetype" : request.query.filetype,
        "length" : request.query.length,
        "genre" : request.query.genre,
        "filename" : request.query.filename,
        "plays" : request.query.plays
    },
    { upsert: true }, (err, res) => {
      if (err) {
        response.status(500).send(err);
        return;
      }
      response.send({
        length:	res.length,
        items:	res
      });
    });
});

app.delete('/api/media', function (request, response) {
  var objectId = new ObjectID(request.query.id);
  database.collection('media').remove({ "_id" : objectId }, (err, res) => {
    if (err) {
      response.status(500).send(err);
      return;
    }
    response.sendStatus(200);
  });
});

app.post('/api/media', function (request, response) {
  database.collection('media').insert(request.body, (err, res) => {
    if (err) {
      response.status(500).send(err);
      return;
    }
    response.sendStatus(200);
  });
});

app.post('/api/media/addmany', function (request, response) {
  database.collection('media').insertMany(request.body, (err, res) => {
    if (err) {
      response.status(500).send(err);
      return;
    }
    response.sendStatus(200);
  });
});

var cleanDB = function(callback) {

  var collection = database.collection('media');
  collection.drop(function(err, reply) {
    if (err) {
      console.log("Failed to clean DB", err);
      return;
    }
    callback();
  });
};

var refillDB = function() {
  dbItems = [
    {
      name: "Clair de Lune",
      artist : "Claude Debussy",
      type : "audio",
      filetype : "mp3",
      length : "3.59",
      genre : "classical",
      filename : "debussy-clair-de-lune.mp3",
      plays : 0
    },{
      name: "Für Elise",
      artist : "Ludvig van Beethoven",
      type : "audio",
      filetype : "mp3",
      length : "2.36",
      genre : "classical",
      filename : "fur-elise.mp3",
      plays : 0
    },{
      name: "Toccata and Fugue in D-minor",
      artist : "Johann Sebastian Bach",
      type : "audio",
      filetype : "mp3",
      length : "8.38",
      genre : "classical",
      filename : "Toccata-and-Fugue-Dm.mp3",
      plays : 0
    }
  ];
  database.collection('media').insertMany(dbItems, (err, res) => {
    if (err) {
      console.log("Failed to refill DB");
      return;
    }
    console.log("Succeededed to refill DB");
  });
}



app.listen(3000, function () {
  console.log('The service is running!');
});
