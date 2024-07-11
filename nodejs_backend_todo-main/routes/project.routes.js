const router = require('express').Router();
const ProjectController = require('../controller/project.controller');
const { verifyToken } = require('../models/user.model');

router.post('/createProject', verifyToken, ProjectController.createProject);
router.post('/createJob', verifyToken, ProjectController.createJob);
router.get('/:id', verifyToken, ProjectController.getProjectDetails);
router.get('/', verifyToken, ProjectController.getAllProjects);
router.post('/applyProject/:id', verifyToken, ProjectController.applyForProject); // New route for getting job details

module.exports = router;
