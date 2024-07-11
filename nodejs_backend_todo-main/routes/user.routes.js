const router = require("express").Router();
const UserController = require('../controller/user.controller');
const { verifyToken } = require('../models/user.model');

router.post("/register", UserController.register);
router.post("/login", UserController.login);
router.post("/loginWithGoogle", UserController.loginWithGoogle);

router.get("/check-user", UserController.checkUser);
router.get("/user-details", verifyToken, UserController.getUserDetails);
router.get("/user-details/:userId", verifyToken, UserController.getUserDetailsById); // New route to fetch user details by ID

router.post("/bookmark/:projectId", verifyToken, UserController.bookmarkProject);
router.post("/unbookmark/:projectId", verifyToken, UserController.unbookmarkProject);
router.get("/bookmarks", verifyToken, UserController.getBookmarkedProjects);

router.post("/change-password", verifyToken, UserController.changePassword);
router.post("/set-new-password", UserController.setNewPassword);

module.exports = router;
