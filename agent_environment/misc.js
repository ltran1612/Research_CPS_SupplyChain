const fs = require("fs");

exports.loadConfig = () => {
    if (process.argv.length > 2) {
        const configPath = process.argv[2];
        const text = fs.readFileSync(configPath);
        const config = JSON.parse(text);
        return config;
    } // end if
    return defaultConfig; 
} // end loadConfig

exports.showConfig = (config) => {
    console.log(`Address to connect is ${config.brokerAddress}`)
    if (config.id) {
        console.log(`Agent with id ${config.id}`);
    } else {
       console.log(`Environment with these pairs set up: ${JSON.stringify(config.pairs)}`) 
    } // end else
} // end showConfig

const defaultConfig = {
    "brokerAddress": "mqtt://localhost:1883",
} // end defaultConfig
 
