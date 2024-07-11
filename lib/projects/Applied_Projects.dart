import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/projects/projects_api.dart';

import '../animation.dart';

class AppliedProjectsScreen extends StatefulWidget {
  @override
  _AppliedProjectsScreenState createState() => _AppliedProjectsScreenState();
}

class _AppliedProjectsScreenState extends State<AppliedProjectsScreen> {
  List<Project> appliedProjects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppliedProjects();
  }

  Future<void> _loadAppliedProjects() async {
    List<Project> loadedAppliedProjects = await ApiHandler.getAllJobs();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    // Filter out projects that the user has not applied for
    List<Project> filteredProjects =
    loadedAppliedProjects.where((project) => project.applicants.contains(userId)).toList();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        appliedProjects = filteredProjects;
        isLoading = false;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Applied Projects'),
        backgroundColor: Colors.teal, // Apply cyan color to the app bar
      ),
      body: isLoading
          ? loadingAnimation
          : appliedProjects.isEmpty
          ? noDataAnimation
          : buildProjectsLists(),
    );
  }

  ListView buildProjectsLists() {
    return ListView.builder(
      itemCount: appliedProjects.length,
      itemBuilder: (context, index) {
        return buildProjectCard(appliedProjects[index]);
      },
    );
  }

  Card buildProjectCard(Project project) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4, // Add elevation to the card for a raised appearance
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Apply rounded corners to the card
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  project.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Already Applied',
                  style: TextStyle(color: Colors.teal), // Apply teal color to the text
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(project.taskDetails),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Job Type: ${project.jobType}',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'Time: ${project.jobTime}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Text(
              'Salary: \$${project.budget}',
              style: TextStyle(fontSize: 14),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () {
                  // Handle message to client action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Messaging ${project.clientId}...'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Apply teal color to the button
                ),
                child: Text('Message Client',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
