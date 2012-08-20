#!/bin/bash

if [ "$1" == "" ]; then
  echo "\n\033[0;31mPlease provide a web app name!!!!\033[0m\n";
  exit 1;
else
  echo "\n\033[0;36mSetting up your awesome new webapp, $1\033[0m...\n";
fi

npm install socket.io express
express --sessions --css less --ejs $1
cd $1 && npm install

cd public/javascripts
curl -O http://code.jquery.com/jquery-1.8.0.min.js
curl -O http://cloud.github.com/downloads/daleharvey/pouchdb/pouch.alpha.min.js

cd ..
curl -O http://cloud.github.com/downloads/zencoder/video-js/video-js-3.2.0.zip
unzip video-js-3.2.0.zip

curl -O http://kolber.github.com/audiojs/audiojs.zip
unzip audiojs.zip

mkdir jquery-ui
cd jquery-ui
curl -O http://jqueryui.com/download/jquery-ui-1.8.23.custom.zip
unzip jquery-ui-1.8.23.custom.zip

cd ..
cd ..
cd views
rm index.ejs

echo '<!DOCTYPE html>
<html>
  <head>
    <title><%= title %></title>
    <link rel="stylesheet" href="/stylesheets/style.css" />
    <link rel="stylesheet" href="/video-js/video-js.css" />
    <link rel="stylesheet" href="/jquery-ui/css/smoothness/jquery-ui-1.8.23.custom.css" />
    <script src="/javascripts/jquery-1.8.0.min.js"></script>
    <script src="/javascripts/pouch.alpha.min.js"></script>
    <script src="/jquery-ui/js/jquery-ui-1.8.23.custom.min.js"></script>
    <script src="/video-js/video.js"></script>
    <script src="/audiojs/audio.min.js"></script>
    <script src="/socket.io/socket.io.js"></script>
    <script>
      var socket = io.connect("http://localhost");
      socket.on("news", function (data) {
        console.log(data);
        socket.emit("my other event", { my: "data" });
      });
    </script>
  </head>
  <body>
    <h1><%= title %></h1>
    <p>Welcome to <%= title %></p>
  </body>
</html>' > index.ejs

cd ..
rm app.js

echo "
var express = require('express')
  , app = express()
  , http = require('http')
  , server = http.createServer(app)
  , io = require('socket.io').listen(server)
  , routes = require('./routes')
  , path = require('path')

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'ejs');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser('your secret here'));
  app.use(express.session());
  app.use(app.router);
  app.use(require('less-middleware')({ src: __dirname + '/public' }));
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/', routes.index);

server.listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});" > app.js

echo "\n\033[0;32mWe have done all the things, your app '$1' is ready.. \033[0m\n";
echo "\n\033[0;32m'cd $1', then 'node app.js'.\033[0m\n";
