const express = require('express');
const User = require('../models/user_model');

const authRouter = express.Router();

authRouter.post('/signup', async (req, res) => {
    try {
        // get the posted user data from the request body
        const { name, email, profilePic } = req.body;
        console.log(req.body);

        // check if user already exists
        let user = await User.findOne({ email: email });

        // if user does not exist, create a new user
        if (!user) {
            user = new User({ name, email, profilePic });
            user = await user.save();
        }

        // send the user data to the client
        res.json({ user });

    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err.message });
    }
});

authRouter.get('/get-data', async (req, res) => {

})

module.exports = authRouter;

