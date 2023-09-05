const util = require("util");
const exec = util.promisify(require("child_process").exec);

const path = require("path");
const fs = require("fs");
const fsp = fs.promises;

const tmp = require("tmp");
tmp.setGracefulCleanup();

const formidable = require("formidable");

const CONFIG = require("./config");

module.exports = function (app) {
  app.route("/run_example").get(runExample);
  app.route("/reasoning").post(reasoning).get(runExample);
}; // end function

async function reasoning(req, res, next) {
  //https://everything.curl.dev/http/multipart
  const form = formidable({ multiples: true });

  let ASPFileName = "";
  let solver = -1;
  form.parse(req, async (err, fields, files) => {
    if (err) {
      next(err);
      return;
    } // end if

    let ASPFileName = fields.aspName;
    let solver = fields.solver;

    const tmpDir = tmp.dirSync({ mode: 0o766 });

    // copy the ontology from the base folder to here.
    // copyOWL(BASE_CORE_DIR, tmpDir);
    // copyOWL(exampleDir, tmpDir);
    let fileList = [];
    for (let file in files) {
      file = files[file].toJSON();
      // src path
      let srcPath = file.filepath;

      // dst path
      let dstPath = tmpDir.name;
      let dstName = file.originalFilename;
      dstPath = path.join(dstPath, dstName);

      // copy file store the promise
      fileList.push(fsp.copyFile(srcPath, dstPath));
    } // end for

    // waiting for file copy to be done
    try {
      await Promise.all(fileList);
    } catch (e) {
      console.error(e);
    } // end catch

    //files = await fsp.readdir(tmpDir.name);

    // await query
    let result = await query(tmpDir, ASPFileName, solver);
    res.set("Content-Type", "text/html");
    res.send(`${result}`);
  });
} // end test

// runExample
async function runExample(req, res) {
  const BASE_CORE_DIR = "../src/asklab/querypicker/QUERIES/BASE";
  const exampleDir = "../src/asklab/querypicker/QUERIES/EX4-sr-elevator";
  const exampleASP = "FULL-SR-ER-01-ELE-01-00.txt";
  const solver = 3;

  const tmpDir = tmp.dirSync({ mode: 0o766 });

  // copy the ontology from the base folder to here.
  // copyOWL(BASE_CORE_DIR, tmpDir);
  // copyOWL(exampleDir, tmpDir);
  await Promise.all([
    copyDir(BASE_CORE_DIR, tmpDir.name, (suffix = ".owl")),
    copyDir(exampleDir, tmpDir.name),
  ]);

  files = await fsp.readdir(tmpDir.name);
  files.forEach((file) => {
    console.log("file: " + file);
  }); // end readir operation

  // await query
  let result = await query(tmpDir, exampleASP, solver);
  res.set("Content-Type", "text/html");
  res.send(`${result}`);
} // runExample

async function copyDir(src, dst, suffix = "") {
  files = await fsp.readdir(src);
  let mylist = [];
  files.forEach((file) => {
    if (suffix != "" && !file.endsWith(suffix)) return;
    mylist.push(fsp.copyFile(path.join(src, file), path.join(dst, file)));
  }); // end readir operation

  promise = Promise.all(mylist);
  return promise;
} // end copyFiles

// query
async function query(directory, ASPFileName, solver) {
  const directoryPath = directory.name;

  javaBinPath = path.join("..", "bin");
  command = `cd ${javaBinPath} && java webserver.Run "${directoryPath}" "${ASPFileName}" "${solver}"`;
  console.log(command);
  let { stdout, stderr } = await exec(command);

  console.log(`stderr: ${stderr}`);
  console.log(`stdout: ${stdout}`);
  stdout = stdout.replace("\n", "<br>");
  stdout = `<span>${stdout}</span>`;
  return stdout;
} // end test
