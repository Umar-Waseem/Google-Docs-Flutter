const express = require('express');
const User = require('../models/user_model');
const jwt = require('jsonwebtoken');
const auth = require('../middlewares/auth_middleware');
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

        const token = jwt.sign({ id: user._id }, "jwtKey");

        // send the user data to the client
        res.status(200).json({ user, token });

    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err.message });
    }
});

authRouter.get('/get-data', auth, async (req, res) => {
    try {
        const user = await User.findById(req.user);
        res.status(200).json({ user, token: req.token });
    } catch (err) {
        console.log(err);
        res.status(500).json({ error: err.message });
    }
})

module.exports = authRouter;

