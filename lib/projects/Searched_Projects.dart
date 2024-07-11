import 'package:flutter/material.dart';
import 'package:untitled/projects/const.dart';

import '../animation.dart';
import '../projects/projects_api.dart';

class SearchedProjects extends StatefulWidget {
  String projectName ;

  SearchedProjects({Key? key, required this.projectName}) : super(key: key);

  @override
  State<SearchedProjects> createState() => _SearchedProjectsState();
}

class _SearchedProjectsState extends State<SearchedProjects> {

  List<Project> projects = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    ProjectConstants.loadProjects(isJob: false,projectsByName: true,projectName: widget.projectName).then((value){
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          projects = value;
          isLoading = false;
        });
      });

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Searched Projects'),
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


