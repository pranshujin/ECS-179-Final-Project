const net = require("net");

const PORT = 9000;
let godotSocket = null;
let cifSocket = null;

// Buffer per client
const buffers = new Map();

const server = net.createServer((socket) => {
    console.log("New client connected.");
    buffers.set(socket, "");   // Track partial data

    socket.on("data", (data) => {
        // Accumulate data into the buffer
        let buffer = buffers.get(socket) + data.toString();
        
        // Split into complete messages (delimited by newline)
        const messages = buffer.split("\n");

        // Save last partial message back into buffer
        buffers.set(socket, messages.pop());

        for (const raw of messages) {
            const msg = raw.trim();
            if (msg.length === 0) continue;

            console.log("Received:", msg);

            // -------------------------
            // IDENTIFICATION MESSAGES
            // -------------------------
            if (msg === "GODOT") {
                console.log("Godot identified.");
                godotSocket = socket;
                continue;
            }

            if (msg === "CIF") {
                console.log("CiF identified.");
                cifSocket = socket;
                continue;
            }

            // -------------------------
            // RELAY MESSAGES
            // -------------------------
            if (socket === godotSocket && cifSocket) {
                console.log("Forwarding to CiF:", msg);
                cifSocket.write(msg + "\n");
            }

            if (socket === cifSocket && godotSocket) {
                console.log("Forwarding to Godot:", msg);
                godotSocket.write(msg + "\n");
            }
        }
    });

    socket.on("end", () => {
        console.log("Client disconnected.");

        if (socket === godotSocket) godotSocket = null;
        if (socket === cifSocket) cifSocket = null;

        buffers.delete(socket);
    });
});

server.listen(PORT, () => {
    console.log("TCP Server listening on port", PORT);
});
