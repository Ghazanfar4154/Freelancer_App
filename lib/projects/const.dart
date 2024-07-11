
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/animation.dart';

import '../chats/ChatApiHandler.dart';
import '../chats/ChatScreen.dart';
import 'projects_api.dart';

class ProjectConstants{
  
  static  Future<List<Project>> loadProjects({
    required isJob,
    bool? projectsByCategory ,
    String? categoryName,
    bool? projectsByName ,
    String? projectName,
  }) async {
    List<String> bookmarkedProjectIds = [];
    List<Project> loadedProjects;
    if(projectsByCategory==true && categoryName != null){
      loadedProjects = await ApiHandler.getAllProjectsByCategoryName(categoryName);
    }
    else if(projectsByName == true && projectName != null){
      loadedProjects = await ApiHandler.getAllProjects();
      loadedProjects.removeWhere((project) => !project.name.toLowerCase().contains(projectName.toLowerCase()));

    }
    else if(isJob==true){
      loadedProjects= await ApiHandler.getAllJobs();
    }
    else{
       loadedProjects = await ApiHandler.getAllProjects();
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    List<Project> bookmarkedProjects = await ApiHandler.getBookmarkedProjects();
    bookmarkedProjectIds = bookmarkedProjects.map((p) => p.id).toList();

    loadedProjects.removeWhere((project) => project.applicants.contains(userId));
    loadedProjects.removeWhere((project) => project.clientId.contains(userId!));


    List<Project> projects = [];

      projects = loadedProjects.map((project) {
        project.bookmarked = bookmarkedProjectIds.contains(project.id);
        return project;
      }).toList();

      return projects;
  }

  static Future<List<Project>> loadBookmarkedProjects() async {
    List<Project> loadedBookmarkedProjects = await ApiHandler.getBookmarkedProjects();


    return loadedBookmarkedProjects;
  }

  static Future<void> _toggleBookmark(String projectId,List<Project> bookmarkedProjects ,BuildContext context ,Function setStateCallBack,bool canRemove) async {
    bool success;
    Project project = bookmarkedProjects.firstWhere((proj) => proj.id == projectId);

    if (project.bookmarked) {
      success = await ApiHandler.unbookmarkProject(projectId);
    } else {
      success = await ApiHandler.bookmarkProject(projectId);
    }

    if (success) {
        setStateCallBack((){
          project.bookmarked = !project.bookmarked;
          if (!project.bookmarked && canRemove) {
            bookmarkedProjects.remove(project);
          }
        });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update bookmark status'),
        ),
      );
    }
  }

  static Future<void> _applyForProject(String projectId,BuildContext context) async {
    bool applied = await ApiHandler.applyForProject(projectId);
    if (applied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Applied successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to apply for project'),
        ),
      );
    }
  }

  static ListView buildProjectsLists({required List<Project> projects,required BuildContext context,required Function setStateCallback,bool canRemove= false,ScrollPhysics? physics, bool? isJob }) {
    return ListView.builder(
      physics: physics!=null ? physics : null,
      itemCount: projects.length,
      itemBuilder: (context, index) {
        if(isJob==null){
          return buildProjectCard(
              project: projects[index],
              projects: projects,
              context: context,
              function: setStateCallback,
              canRemove: canRemove);
        }
        else {
          return buildProjectCard(
              project: projects[index],
              projects: projects,
              context: context,
              function: setStateCallback,
              canRemove: canRemove,
              isJob: true
          );
        }
      },
    );
  }

  static Future<void> _openChat(String clientId,BuildContext context) async {
    String? chatId = await ChatApiHandler.openOrCreateChat(clientId);
    if (chatId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen(chatId: chatId,otherUserId: clientId,)),
      );
    } else {
      print('Failed to open or create chat');
    }
  }

  static Card buildProjectCard({required Project project,required List<Project> projects,required BuildContext context,required Function function,required bool canRemove, bool? isJob}) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    project.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _toggleBookmark(project.id,projects,context,function,canRemove);
                  },
                  icon: Icon(
                    project.bookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: project.bookmarked ? Colors.teal : Colors.grey, // Adjust bookmark icon color
                  ),
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
                  isJob!=null?"Salary": 'Budget: \$${project.budget.toInt()}',
                  style: TextStyle(fontSize: 14),
                ),
                if(isJob!=null)
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _applyForProject(project.id,context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Apply cyan color to the button
                  ),
                  child: Text('Apply',style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 10), // Add space between buttons
                ElevatedButton(
                  onPressed: () {

                    _openChat(project.clientId,context);
                    // Handle message to client action
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Messaging ${project.clientId}...'),
                      ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Apply cyan color to the button
                  ),
                  child: Text('Message Client',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}