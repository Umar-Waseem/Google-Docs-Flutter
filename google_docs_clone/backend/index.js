const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const http = require('http');
const authRouter = require('./routes/auth');
const documentRouter = require('./routes/document');


const app = express();
var server = http.createServer(app);
const io = require('socket.io')(server);

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);


const user = "umar-terminator";
const pass = "umar1234";
const DB = `mongodb+srv://${user}:${pass}@docsclonecluster.rqhlxea.mongodb.net/?retryWrites=true&w=majority`;



mongoose
    .connect(DB)
    .then(() =>
        console.log("Connected to the freaking Database"))
    .catch((err) =>
        console.log(err)
    );

io.on('connection', (socket) => {
    console.log('Connected to socket.io');
    socket.on('join', (documentId) => {
        socket.join(documentId);
        console.log('Joined Room', documentId);
    });
});

const PORT = 3001 || process.env.PORT;
server.listen(PORT, "0.0.0.0", () => {
    console.log(`Server is connected on port ${PORT}`);
    console.log(`http://localhost:${PORT}`);
});