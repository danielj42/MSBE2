import express from 'express';
import bodyParser from 'body-parser';
import path from 'path';
import mongodb from 'mongodb';

const ObjectID = mongodb.ObjectID;
const MongoClient = mongodb.MongoClient;
var app = express();
app.use(bodyParser.json());
var database;

MongoClient.connect('mongodb://localhost:27017/media',
  function(error, database_) {
    if (error) {
      console.error("Failed to connect to server!");
      console.log(error);
    } else {
      console.log("Connected to server!");
      database = database_;
    }
});

//MEDIA
app.use(express.static(path.join(path.resolve(),'media')));

app.get('/api/media', function (request, response) {
 database.collection('media').find().toArray(function	(error,	result)	{
   if	(error)	{
     response.status(500).send(error);
     return;
   }
   response.send({
     length:	result.length,
     items:	result
   });
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
      response.send({
        length:	result.length,
        items:	result
      });
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
        "filename" : request.query.filename
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

app.listen(3000, function () {
  console.log('The service is running!');
});
