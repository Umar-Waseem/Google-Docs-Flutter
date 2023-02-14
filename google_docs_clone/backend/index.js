const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());
app.use(authRouter);


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

const PORT = 3001 || process.env.PORT;
app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server is connected on port ${PORT}`);
    console.log(`http://localhost:${PORT}`);
});