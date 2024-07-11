const db = require('../config/db');
const bcrypt = require("bcrypt");
const mongoose = require('mongoose');
const { Schema } = mongoose;
const jwt = require('jsonwebtoken');

const userSchema = new Schema({
    email: {
        type: String,
        lowercase: true,
        required: [true, "userName can't be empty"],
        match: [
            /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
            "userName format is not correct",
        ],
        unique: true,
    },
    password: {
        type: String,
        required: [true, "password is required"],
    },
    username: String,
    gender: String,
    dateOfBirth: Date,
    phoneNumber: String,
    address: String,
    educationDetails: [
        {
            degree: String,
            major: String,
            graduationYear: String,
            university: String
        }
    ],
    skills: String,
    image: {
        type: String, // This can be a URL or a Base64 string
        default: null,
    },
    bookmarks: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'project'
    }]
}, { timestamps: true });

userSchema.pre("save", async function () {
    var user = this;
    if (!user.isModified("password")) {
        return;
    }
    try {
        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(user.password, salt);
        user.password = hash;
    } catch (err) {
        throw err;
    }
});

userSchema.methods.comparePassword = async function (candidatePassword) {
    try {
        const isMatch = await bcrypt.compare(candidatePassword, this.password);
        return isMatch;
    } catch (error) {
        throw error;
    }
};

const UserModel = db.model('user', userSchema);

const verifyToken = (req, res, next) => {
    const token = req.headers['authorization'];
    if (!token) {
        return res.status(403).send('A token is required for authentication');
    }
    try {
        const decoded = jwt.verify(token, "secret");
        req.userId = decoded._id;
    } catch (err) {
        return res.status(401).send('Invalid Token');
    }
    return next();
};

module.exports = { UserModel, verifyToken };
