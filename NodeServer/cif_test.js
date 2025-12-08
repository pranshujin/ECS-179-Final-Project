const net = require("net");
const client = new net.Socket();

client.connect(9000, "127.0.0.1", () => {
    console.log("CiF Test Client connected.");
    client.write("CIF\n");  // Identify as CiF

    setTimeout(() => {
        console.log("Sending message to Node...");
        client.write("Hello from CiF!\n");
    }, 5000);   
    
});

client.on("data", (data) => {
    console.log("Received in CiF Test:", data.toString());
});
