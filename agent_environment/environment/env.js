const mqtt = require("mqtt");
const { loadConfig, showConfig} = require("../misc")

// load config object based on command-line arguments
const config = loadConfig();
showConfig(config);

const client = mqtt.connect(config.brokerAddress, {
  clientId: "env"
});
const pairs = config.pairs;
// precondition: the pairs object has a pair for each agent participating 
const agents = Object.keys(pairs);

client.on("connect", () => {
  client.subscribe("env/+", (err) => {
  });
});

client.on("message", (topic, message) => {
  for (const agent of agents) {
    if (topic.match(new RegExp(`.*${agent}.*`))) {
      for (const dest of pairs[agent]) {
        console.log(`publish to ${dest}`)
        client.publish(`for/${dest}`, message.toString(), {
          qos: 2,
          retain: false 
        }) // end publish
      } // end for
    } // end if
  } // end for
  // message is Buffer
  console.log(message.toString());
});
