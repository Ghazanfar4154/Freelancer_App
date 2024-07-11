import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import the lottie package
import 'package:untitled/animation.dart';
import 'package:untitled/projects/const.dart';

import 'projects_api.dart';

class BookmarkedProjectsScreen extends StatefulWidget {
  @override
  _BookmarkedProjectsScreenState createState() => _BookmarkedProjectsScreenState();
}

class _BookmarkedProjectsScreenState extends State<BookmarkedProjectsScreen> {
  List<Project> bookmarkedProjects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ProjectConstants.loadBookmarkedProjects().then((value) {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          bookmarkedProjects = value;
          isLoading = false; // Update loading state once projects are loaded
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Projects'),
        backgroundColor: Colors.teal, // Apply cyan color to the app bar
      ),
      body: isLoading
          ? loadingAnimation
          : bookmarkedProjects.isEmpty
          ?noDataAnimation
          : ProjectConstants.buildProjectsLists(
        projects: bookmarkedProjects,
        context: context,
        setStateCallback: setState,
        canRemove: true,
      ),
    );
  }
}
