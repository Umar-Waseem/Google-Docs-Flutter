const express = require('express');
const Document = require('../models/document_model');
const documentRouter = express.Router();
const auth = require('../middlewares/auth_middleware');

documentRouter.post('/doc/create', auth, async (req, res) => {
    try {
        const { createdAt } = req.body;
        let doc = new Document({
            uid: req.user,
            createdAt: createdAt,
            title: "Untitled Document",
        });
        doc = await doc.save();
        res.json(doc);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

documentRouter.get("/doc/me", auth, async (req, res) => {
    try {
        const docs = await Document.find({ uid: req.user });
        res.json(docs);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
})
 
module.exports = documentRouter;