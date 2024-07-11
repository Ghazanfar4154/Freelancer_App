import 'package:flutter/material.dart';
import 'package:untitled/projects/projects_api.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String projectId;

  const ProjectDetailsScreen({Key? key, required this.projectId})
      : super(key: key);

  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  Project? project;

  @override
  void initState() {
    super.initState();
    _loadProjectDetails();
  }

  Future<void> _loadProjectDetails() async {
    Project? loadedProject =
    await ApiHandler.getProjectDetails(widget.projectId);
    setState(() {
      project = loadedProject;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
      ),
      body: project == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${project!.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Task Details: ${project!.taskDetails}'),
            SizedBox(height: 10),
            Text('Budget: \$${project!.budget.toString()}'),
            SizedBox(height: 10),
            Text('Job Type: ${project!.jobType}'),
            SizedBox(height: 10),
            Text('Job Time: ${project!.jobTime}'),
          ],
        ),
      ),
    );
  }
}
