const fs = require("fs");
const crypto = require("crypto");
const net = require("net");

function saveFile(filePath, data) {
  fs.writeFileSync(filePath, data);
}

function calculateChecksum(filePath) {
  const data = fs.readFileSync(filePath);
  return crypto.createHash("md5").update(data).digest("hex");
}

const client = net.createConnection({ port: 5000, host: "server" }, () => {
  console.log("Connected to server");

  let fileData = "";
  let checksum = "";

  client.on("data", (data) => {
    if (!checksum) {
      fileData += data.toString();
    } else {
      checksum += data.toString();
    }
  });

  client.on("end", () => {
    const filePath = "/clientdata/random_file.txt";
    saveFile(filePath, fileData);
    const calculatedChecksum = calculateChecksum(filePath);

    if (calculatedChecksum === checksum) {
      console.log("File integrity verified.");
    } else {
      console.log("File integrity check failed.");
    }
  });
});
