import 'package:flutter/material.dart';
import 'package:untitled/projects/const.dart';

import '../animation.dart';
import '../projects/projects_api.dart';

class ShowProjectByCategory extends StatefulWidget {
  String categoryName ;

  ShowProjectByCategory({Key? key, required this.categoryName}) : super(key: key);

  @override
  State<ShowProjectByCategory> createState() => _ShowProjectByCategoryState();
}

class _ShowProjectByCategoryState extends State<ShowProjectByCategory> {

  List<Project> projects = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    ProjectConstants.loadProjects(isJob: false,projectsByCategory: true,categoryName: widget.categoryName).then((value){
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
        title: Text('${widget.categoryName} Projects'),
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


