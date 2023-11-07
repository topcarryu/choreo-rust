const { createVLESSServer } = require("@3kmfi6hp/nodejs-proxy");

const port = process.env.PORT || 3001;
const uuid = process.env.UUID || "d342d11e-d424-4583-b36e-524ab1f0afa4";

createVLESSServer(port, uuid);