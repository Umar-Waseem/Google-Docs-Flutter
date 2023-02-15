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

documentRouter.delete("/doc/:id", auth, async (req, res) => {
    try {
        const doc = await Document.findByIdAndDelete(req.params.id);
        res.json(doc);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
})

documentRouter.post("/doc/title", auth, async (req, res) => {
    try {
        const { id, title } = req.body;
        const document = await Document.findByIdAndUpdate(id, { title: title });

        res.json(document);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
})

documentRouter.get("/doc/:id", auth, async (req, res) => {
    try {
        const doc = await Document.findById({ uid: req.params.id });

        res.json(doc);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
})

module.exports = documentRouter;