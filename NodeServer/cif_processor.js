const net = require("net");
const client = new net.Socket();

client.connect(9000, "127.0.0.1", () => {
    console.log("CiF Processor connected.");
    client.write("CIF\n");  
});


client.on("data", (data) => {
    const msg = data.toString().trim();
    console.log("CiF received:", msg);

    if (msg.startsWith("INTERACT")) {
        const npc_id = parseInt(msg.split(":")[1]);


        const social_state = {
            npc: npc_id,
            mood: ["happy", "angry", "neutral", "curious"][npc_id % 4],
            trust: Math.floor(Math.random() * 100)
        };

        client.write(JSON.stringify(social_state) + "\n");
        console.log("CiF sent:", social_state);
    }
});
