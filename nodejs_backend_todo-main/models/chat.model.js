const mongoose = require('mongoose');
const db = require('../config/db');
const { Schema } = mongoose;

const chatSchema = new Schema({
    users: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true
    }],
    messages: [{
        sender: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'user',
            required: true
        },
        message: {
            type: String,
            required: true
        },
        timestamp: {
            type: Date,
            default: Date.now
        }
    }]
}, { timestamps: true });


const ChatModel = db.model('chat', chatSchema);


module.exports = { ChatModel };
