import 'package:flutter/material.dart';
import 'package:untitled/projects/const.dart';

import '../animation.dart';
import 'projects_api.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  State<ProjectList> createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {

  List<Project> projects = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    ProjectConstants.loadProjects(isJob: false).then((value){
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          projects = value;
          isLoading = false;
        });
      });


      // Future.delayed(Duration(seconds: 2), () {
      //   setState(() {
      //     SharedPreferences.getInstance().then((pref){
      //       String? userId = pref.getString('userId');
      //       value.removeWhere((project) => project.clientId.contains(userId!));
      //       projects = value;
      //       isLoading = false;
      //     });
      //   });
      // });


    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
        backgroundColor: Colors.teal, // Apply cyan color to the app bar
      ),
      body: isLoading
          ? loadingAnimation
          : projects.isEmpty
          ? noDataAnimation
          : ProjectConstants.buildProjectsLists(
        projects: projects,
        context: context,
        setStateCallback: setState,),
    );
  }

}


