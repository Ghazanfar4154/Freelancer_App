// controller/notification.controller.js
const { NotificationModel } = require('../models/notification.model');

exports.createNotification = async (req, res, next) => {
    try {
        const { title, description } = req.body;
        const notification = new NotificationModel({ title, description });

        await notification.save();

        res.status(201).json({ status: true, notification });
    } catch (error) {
        next(error);
    }
};

exports.getNotifications = async (req, res, next) => {
    try {
        const notifications = await NotificationModel.find().sort({ timestamp: -1 });

        res.status(200).json({ status: true, notifications });
    } catch (error) {
        next(error);
    }
};
