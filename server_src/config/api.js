const { exec } = require("child_process");

module.exports = function (app) {
    app.route('/run_example').get(runExample)    
}

function runExample(req, res) {
 

  exec("cd ../bin && java webserver.Run", (error, stdout, stderr) => {
      if (error) {
          console.log(`error: ${error.message}`);
          return;
      }
      if (stderr) {
          console.log(`stderr: ${stderr}`);
          return;
      }
      console.log(`stdout: ${stdout}`);
      stdout = stdout.replace("\n", "<br>");
      stdout = stdout.replace("\t", "    ");
      res.set('Content-Type', 'text/html');
      res.send(`${stdout}`);
  });
}