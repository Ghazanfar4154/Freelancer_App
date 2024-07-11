const { UserModel } = require('../models/user.model');
const { ProjectModel } = require('../models/project.model');

const jwt = require('jsonwebtoken');
const bcrypt = require("bcrypt");

exports.register = async (req, res, next) => {
    try {
        const { email, password, username, gender, dateOfBirth, phoneNumber, address, educationDetails, skills, image } = req.body;
        const duplicate = await UserModel.findOne({ email });
        if (duplicate) {
            throw new Error(`UserName ${email}, Already Registered`);
        }
        const user = new UserModel({ email, password, username, gender, dateOfBirth, phoneNumber, address, educationDetails, skills, image });
        await user.save();

        const tokenData = { _id: user._id, email: user.email };
        const token = jwt.sign(tokenData, "secret", { expiresIn: "1h" });
        
        res.json({ status: true, success: 'User registered successfully',token: token, userId: user._id });
    } catch (err) {
        next(err);
    }
};

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            throw new Error('Parameter are not correct');
        }
        const user = await UserModel.findOne({ email });
        if (!user) {
            throw new Error('User does not exist');
        }

        const isPasswordCorrect = await bcrypt.compare(password, user.password);
        if (!isPasswordCorrect) {
            throw new Error(`Username or Password does not match`);
        }

        const tokenData = { _id: user._id, email: user.email };
        const token = jwt.sign(tokenData, "secret", { expiresIn: "1h" });

        res.status(200).json({ status: true, success: "sendData", token: token, userId: user._id });
    } catch (error) {
        next(error);
    }
};

exports.loginWithGoogle = async (req, res, next) => {
    try {
        const { email } = req.body;
        if (!email ) {
            throw new Error('Parameter are not correct');
        }
        const user = await UserModel.findOne({ email });
        if (!user) {
            throw new Error('User does not exist');
        }

        const tokenData = { _id: user._id, email: user.email };
        const token = jwt.sign(tokenData, "secret", { expiresIn: "1h" });

        res.status(200).json({ status: true, success: "sendData", token: token, userId: user._id });
    } catch (error) {
        next(error);
    }
};


exports.getUserDetailsById = async (req, res, next) => {
    try {
        const userId = req.params.userId;
        const user = await UserModel.findById(userId).select('-password').populate('bookmarks');
        if (!user) {
            throw new Error('User not found');
        }
        res.status(200).json({ status: true, user });
    } catch (error) {
        next(error);
    }
};


exports.getUserDetails = async (req, res, next) => {
    try {
        const userId = req.userId;
        const user = await UserModel.findById(userId).select('-password').populate('bookmarks');
        if (!user) {
            throw new Error('User not found');
        }
        res.status(200).json({ status: true, user });
    } catch (error) {
        next(error);
    }
};

exports.checkUser = async (req, res, next) => {
    try {
        const { email } = req.query;
        const user = await UserModel.findOne({ email });
        res.json({ status: !!user });
    } catch (error) {
        next(error);
    }
};

exports.bookmarkProject = async (req, res, next) => {
    try {
        const userId = req.userId;
        const { projectId } = req.params;
        const user = await UserModel.findById(userId);
        if (!user.bookmarks.includes(projectId)) {
            user.bookmarks.push(projectId);
            await user.save();
        }
        res.status(200).json({ status: true, message: 'Project bookmarked successfully' });
    } catch (error) {
        next(error);
    }
};

exports.getBookmarkedProjects = async (req, res, next) => {
    try {
        const userId = req.userId;
        const user = await UserModel.findById(userId).populate('bookmarks');
        if (!user) {
            throw new Error('User not found');
        }
        res.status(200).json({ status: true, bookmarks: user.bookmarks });
    } catch (error) {
        next(error);
    }
};

exports.unbookmarkProject = async (req, res, next) => {
    try {
        const userId = req.userId;
        const { projectId } = req.params;
        const user = await UserModel.findById(userId);
        const index = user.bookmarks.indexOf(projectId);
        if (index > -1) {
            user.bookmarks.splice(index, 1);
            await user.save();
        }
        res.status(200).json({ status: true, message: 'Project unbookmarked successfully' });
    } catch (error) {
        next(error);
    }
};

exports.changePassword = async (req, res, next) => {
    try {
        const userId = req.userId;
        const { currentPassword, newPassword } = req.body;

        if (!currentPassword || !newPassword) {
            throw new Error('Current password and new password are required');
        }

        const user = await UserModel.findById(userId);
        if (!user) {
            throw new Error('User not found');
        }

        const isPasswordCorrect = await bcrypt.compare(currentPassword, user.password);
        if (!isPasswordCorrect) {
            throw new Error('Current password is incorrect');
        }

        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(newPassword, salt);
        user.password = hash;
        await user.save();

        res.status(200).json({ status: true, message: 'Password changed successfully' });
    } catch (error) {
        next(error);
    }
};

exports.setNewPassword = async (req, res, next) => {
    try {
        const { email, newPassword } = req.body;

        if (!email || !newPassword) {
            throw new Error('Email and new password are required');
        }

        const user = await UserModel.findOne({ email });
        if (!user) {
            throw new Error('User not found');
        }

        user.password = newPassword; // No need to hash here, pre-save hook will handle it
        await user.save();

        res.status(200).json({ status: true, message: 'Password reset successfully' });
    } catch (error) {
        next(error);
    }
};


