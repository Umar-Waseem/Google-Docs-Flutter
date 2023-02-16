const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const http = require('http');
const authRouter = require('./routes/auth');
const documentRouter = require('./routes/document');
const Document = require('./models/document_model');


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

app.get('/', (req, res) => {
    res.send('You real slick boi, you made it to the backend, but there is nothing here 🥸');
})

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
    socket.on("typing", (data) => {
        socket.broadcast.to(data.room).emit("changes", data);
        console.log("Typing")
    });

    socket.on("save", (data) => {
        saveData(data);
        console.log("Saved")
    });


});

const saveData = async (data) => {
    let document = await Document.findById(data.room);
    document.content = data.delta;
    document = await document.save();
};

const PORT = 3001 || process.env.PORT;
server.listen(PORT, "0.0.0.0", () => {
    console.log(`Server is connected on port ${PORT}`);
    console.log(`http://localhost:${PORT}`);
});