const router = require('express').Router();
const ChatController = require('../controller/chat.controller');
const { verifyToken } = require('../models/user.model');

router.get('/chats', verifyToken, ChatController.getChats);
router.post('/send-message', verifyToken, ChatController.sendMessage);
router.post('/open-chat', verifyToken, ChatController.openOrCreateChat);
router.get('/chats/:chatId/messages', verifyToken, ChatController.getMessages);

module.exports = router;
