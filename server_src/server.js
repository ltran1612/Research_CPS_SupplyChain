// import environment variables
require("dotenv").config();
// import packages
const express = require("express");
const cors = require('cors')

// import the IP and port number
const hostname = "127.0.0.1";
const port = 9000;

// create the app
const app = express();
// enable cors on all routes
app.use(cors())

// import the routes
require("./config/routes")(app);

// import the api
require("./config/api")(app);

// start the server
app.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
