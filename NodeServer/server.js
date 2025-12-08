const net = require("net");

const PORT = 9000;

// Store connections
let godotSocket = null;
let cifSocket = null;

const server = net.createServer((socket) => {
    console.log("New client connected.");

    socket.on("data", (data) => {
        console.log("Received:", data.toString());
    });

    socket.on("end", () => {
        console.log("Client disconnected.");
        if (socket === godotSocket) godotSocket = null;
        if (socket === cifSocket) cifSocket = null;
    });
});

server.listen(PORT, () => {
    console.log("TCP Server listening on port", PORT);
});
