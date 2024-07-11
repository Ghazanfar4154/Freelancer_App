const { ProjectModel } = require('../models/project.model');

exports.createProject = async (req, res, next) => {
    try {
        const { name, taskDetails, budget, jobTime, category, type} = req.body;
        const userId = req.userId;
        const project = new ProjectModel({ name, taskDetails, clientContact:userId, budget, jobTime, category,type });
        await project.save();
        res.json({ status: true, success: 'Project created successfully', project });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};

exports.createJob = async (req, res, next) => {
    try {
        const { name, taskDetails, budget, category, jobTime, jobType,type } = req.body;
        const userId = req.userId;
        const project = new ProjectModel({ name, taskDetails, clientContact: userId, budget, category, jobTime, jobType,type });
        await project.save();
        res.json({ status: true, success: 'Job created successfully', project });
    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
};

exports.getAllProjects = async (req, res, next) => {
    try {
        const  data  = req.query;  // Get category from query parameters
        const projects = await ProjectModel.find( data );
        res.status(200).json({ status: true, projects });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
};

exports.applyForProject = async (req, res, next) => {
    try {
        const { id } = req.params;
        const userId = req.userId;
        const project = await ProjectModel.findById(id);
        if (!project) {
            return res.status(404).json({ status: false, message: 'Project not found' });
        }
        if (project.applicants.includes(userId)) {
            return res.status(400).json({ status: false, message: 'Already applied' });
        }
        project.applicants.push(userId);
        await project.save();
        res.status(200).json({ status: true, message: 'Successfully applied for project' });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
};

exports.getProjectDetails = async (req, res, next) => {
    try {
        const { id } = req.params;
        const userId = req.userId; // Get user ID from token
        const project = await ProjectModel.findById(id).populate('applicants');
        if (!project) {
            throw new Error('Project not found');
        }
        const alreadyApplied = project.applicants.some(applicant => applicant.equals(userId));
        res.status(200).json({ status: true, project, alreadyApplied });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
};






