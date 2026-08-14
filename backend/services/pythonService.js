const { spawn } = require("child_process");
const path = require("path");

const processNotice = (filePath) => {
  return new Promise((resolve, reject) => {
    const pythonFile = path.join(__dirname, "../../process_notice.py");

    //const python = spawn("py", [pythonFile, filePath]);
    const pythonCommand = process.env.PYTHON_COMMAND || "py";
const python = spawn(pythonCommand, [pythonFile, filePath]);

    let result = "";
    let errorOutput = "";

    python.stdout.on("data", (data) => {
      result += data.toString();
    });

    python.stderr.on("data", (data) => {
      errorOutput += data.toString();
    });

    python.on("close", (code) => {
      if (code !== 0) {
        return reject(errorOutput);
      }

      try {
        resolve(JSON.parse(result));
      } catch (error) {
        reject(error);
      }
    });
  });
};

module.exports = { processNotice };
