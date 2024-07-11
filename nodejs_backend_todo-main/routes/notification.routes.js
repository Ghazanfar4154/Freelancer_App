// routes/notification.routes.js
const router = require('express').Router();
const NotificationController = require('../controller/notification.controller');
const { verifyToken } = require('../models/user.model');

router.post('/notifications', verifyToken, NotificationController.createNotification);
router.get('/notifications', verifyToken, NotificationController.getNotifications);

module.exports = router;
