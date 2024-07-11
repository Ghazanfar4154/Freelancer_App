const { ChatModel } = require('../models/chat.model');
const { UserModel } = require('../models/user.model');

exports.getChats = async (req, res, next) => {
    try {
        const userId = req.userId;
        const chats = await ChatModel.find({
            $or: [
                { users: userId },
                { clientId: userId }
            ]
        })
        .populate('users', 'username email')
        .populate('messages.sender', 'username email');

        res.status(200).json({ status: true, chats });
    } catch (error) {
        next(error);
    }
};

exports.sendMessage = async (req, res, next) => {
    try {
        const { chatId, message } = req.body;
        const userId = req.userId;
        const chat = await ChatModel.findById(chatId);

        if (!chat) {
            throw new Error('Chat not found');
        }

        chat.messages.push({ sender: userId, message });
        await chat.save();

        res.status(200).json({ status: true, message: 'Message sent successfully' });
    } catch (error) {
        next(error);
    }
};

exports.openOrCreateChat = async (req, res, next) => {
    try {
        const userId = req.userId; // Decoded from the token
        const { clientId } = req.body;

        let chat = await ChatModel.findOne({
            $or: [
                { users: { $all: [userId, clientId] } },
                { users: { $all: [clientId, userId] } }
            ]
        });

        if (!chat) {
            chat = new ChatModel({ users: [userId, clientId], messages: [] });
            await chat.save();
        }

        res.status(200).json({ status: true, chatId: chat._id });
    } catch (error) {
        next(error);
    }
};

exports.getMessages = async (req, res, next) => {
    try {
        const { chatId } = req.params;
        const chat = await ChatModel.findById(chatId).populate('messages.sender', 'username email');

        if (!chat) {
            throw new Error('Chat not found');
        }

        res.status(200).json({ status: true, messages: chat.messages });
    } catch (error) {
        next(error);
    }
};
