const db = require('../config/db');
const mongoose = require('mongoose');
const { Schema } = mongoose;

const projectSchema = new Schema({
    name: {
        type: String,
        required: true,
    },
    taskDetails: {
        type: String,
        required: true,
    },
    clientContact: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true,
    },
    budget: {
        type: Number,
        required: true,
    },
    category: {
        type: String,
        required: true,
    },
    type: {
        type: String,
        required: true,
    },
    jobType: {
        type: String,
        required: false,
    },
    jobTime: {
        type: String,
        required: false,
    },
    applicants: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
    }]
}, { timestamps: true });

const ProjectModel = db.model('project', projectSchema);

module.exports = { ProjectModel };
