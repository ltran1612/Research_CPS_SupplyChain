// import packages
const express = require('express')

// import the IP and port number
const hostname = '127.0.0.1';
const port = 3000;

// create the app
const app = express()

// import the routes
require('./config/routes')(app)

// import the api 
require('./config/api')(app)

// start the server
app.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
