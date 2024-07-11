// models/notification.model.js
const mongoose = require('mongoose');
const db = require('../config/db');
const { Schema } = mongoose;

const notificationSchema = new Schema({
    title: {
        type: String,
        required: true
    },
    description: {
        type: String,
        required: true
    },
    timestamp: {
        type: Date,
        default: Date.now,
        required: true
    }
}, { timestamps: true });

const NotificationModel = db.model('notification', notificationSchema);

module.exports = { NotificationModel };
