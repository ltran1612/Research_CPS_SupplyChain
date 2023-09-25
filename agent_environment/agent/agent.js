const mqtt = require("mqtt")
const { loadConfig, showConfig} = require("../misc")
const state = [];

// load config object based on command-line arguments
const config = loadConfig();
showConfig(config);

const client = mqtt.connect(config.brokerAddress, {
  clientId: config.id,
  clean: false
});
const publishTopic = `env/${config.id}`;
const subscribeTopic = `for/${config.id}`

console.log(`Publish to ${publishTopic}`)
console.log(`Subscribe to ${subscribeTopic}`)

function publish(message) {
    client.publish(publishTopic, message);
} // end message

client.on("connect", () => {
  console.log("client connected")
  publish(`bought(1000) from ${config.id}`);
  client.subscribe(subscribeTopic, (err) => {
  }); // end subscribe
});

client.on("message", (topic, message) => {
  // message is Buffer
  state.push(message.toString());
  console.log(`${message.toString()}`);
}); // end 