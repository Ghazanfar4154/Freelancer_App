import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../animation.dart';

class Project {
  final String id;
  final String name;
  final String taskDetails;
  final double budget;
  final String category;
  final String type;
  final String? jobTime;
  final String? jobType;
  final List<String> applicants;
  final String clientId;
  bool bookmarked;

  Project({
    required this.id,
    required this.name,
    required this.taskDetails,
    required this.budget,
    required this.category,
    required this.type,
    this.jobTime,
    this.jobType,
    required this.applicants,
    required this.clientId,
    this.bookmarked = false,
  });
}

class ApiHandler {
  static const projectsBaseUrl = baseUrl;

  // Method for creating a project
  static Future<bool> createProject(Map<String, dynamic> projectData) async {
    var url = Uri.parse("${projectsBaseUrl}projects/createProject");
    return _createEntity(url, projectData);
  }

  // Method for creating a job
  static Future<bool> createJob(Map<String, dynamic> jobData) async {
    var url = Uri.parse("${projectsBaseUrl}projects/createJob");
    return _createEntity(url, jobData);
  }

  static Future<bool> _createEntity(Uri url, Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
        body: jsonEncode(data),
      );

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        return responseData['status'] == true;
      } else {
        print("Failed to create entity");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Method for getting project details
  static Future<Project?> getProjectDetails(String projectId) async {
    var url = Uri.parse("${projectsBaseUrl}projects/$projectId");
    return _getEntityDetails(url);
  }

  static Future<Project?> _getEntityDetails(Uri url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final res = await http.get(
        url,
        headers: {'Authorization': token!},
      );

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        if (responseData['status'] == true) {
          var entityData = responseData['project'];
          return Project(
            id: entityData['_id'],
            name: entityData['name'],
            taskDetails: entityData['taskDetails'],
            budget: entityData['budget'].toDouble(),
            category: entityData['category'],
            type: entityData['type'],
            jobTime: entityData['jobTime'],
            applicants: List<String>.from(entityData['applicants']),
            clientId: entityData['clientContact'],
          );
        }
      }
      print("Failed to get entity details");
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Method for getting all projects
  static Future<List<Project>> getAllProjects() async {
    var url = Uri.parse("${projectsBaseUrl}projects");
    return _getAllEntities(url,"type","Project");
  }

  // Method for getting all projects
  static Future<List<Project>> getAllProjectsByCategoryName(String category) async {
    var url = Uri.parse("${projectsBaseUrl}projects");
    return _getAllEntities(url,"category",category);
  }

  // Method for getting all projects
  static Future<List<Project>> getAllProjectsByName(String name) async {
    var url = Uri.parse("${projectsBaseUrl}projects");
    return _getAllEntities(url,"name",name);
  }

  // Method for getting all projects
  static Future<List<Project>> getCompaniesProjects() async {
    var url = Uri.parse("${projectsBaseUrl}projects");
    return _getAllEntities(url,"clientContact","665b872ab9d706bfce76bdbc");
  }

  // Method for getting all jobs
  static Future<List<Project>> getAllJobs() async {
    var url = Uri.parse("${projectsBaseUrl}projects");
    return _getAllEntities(url,"type","Job");
  }

  static Future<List<Project>> getAllJobsandProjects() async {
    var url = Uri.parse("${projectsBaseUrl}projects");
    return _getAllEntities(url,"type","Job",queryType2: "type",queryValue2: "Project");
  }


  static Future<List<Project>> _getAllEntities(Uri url, String queryType,String queryValue,{String? queryType2,String? queryValue2}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      var urlWithCategory;
      if(queryType2==null){
        urlWithCategory = url.replace(queryParameters: {queryType: queryValue}); // Add category to the query parameters
      }
      else{
        urlWithCategory = url.replace(queryParameters: {
          queryType: queryValue,
          queryType2:queryValue2
        }); // Add category to the query parameters

      }

      final res = await http.get(
        urlWithCategory,
        headers: {'Authorization': token!},
      );

      if (res.statusCode == 200) {
        print("Working");
        var responseData = jsonDecode(res.body);
        if (responseData['status'] == true) {
          var entitiesData = responseData['projects'];
          List<Project> entities = entitiesData.map<Project>((entityData) {
            return Project(
              id: entityData['_id'],
              name: entityData['name'],
              taskDetails: entityData['taskDetails'],
              budget: entityData['budget'].toDouble(),
              category: entityData['category'],
              type: entityData['type'],
              jobTime: entityData['jobTime'],
              jobType: entityData['jobType'],
              applicants: List<String>.from(entityData['applicants']),
              clientId: entityData['clientContact'],
            );
          }).toList();

          return entities;
        }
      }
      print("Failed to get all entities");
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Method for applying to a project
  static Future<bool> applyForProject(String projectId) async {
    var url = Uri.parse("${projectsBaseUrl}projects/applyProject/$projectId");
    return _applyForEntity(url);
  }

  static Future<bool> _applyForEntity(Uri url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        return responseData['status'] == true;
      } else {
        print("Failed to apply for entity");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Method for bookmarking a project
  static Future<bool> bookmarkProject(String projectId) async {
    var url = Uri.parse("${projectsBaseUrl}bookmark/$projectId");
    return _bookmarkEntity(url);
  }

  // Method for unbookmarking a project
  static Future<bool> unbookmarkProject(String projectId) async {
    var url = Uri.parse("${projectsBaseUrl}unbookmark/$projectId");
    return _bookmarkEntity(url);
  }

  static Future<bool> _bookmarkEntity(Uri url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token!,
        },
      );

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        return responseData['status'] == true;
      } else {
        print("Failed to bookmark entity");
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Method for getting bookmarked projects
  static Future<List<Project>> getBookmarkedProjects() async {
    var url = Uri.parse("${projectsBaseUrl}bookmarks");
    return _getBookmarkedEntities(url);
  }

  static Future<List<Project>> _getBookmarkedEntities(Uri url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final res = await http.get(
        url,
        headers: {'Authorization': token!},
      );

      if (res.statusCode == 200) {
        var responseData = jsonDecode(res.body);
        if (responseData['status'] == true) {
          var entitiesData = responseData['bookmarks'];
          List<Project> entities = entitiesData.map<Project>((entityData) {
            return Project(
              id: entityData['_id'],
              name: entityData['name'],
              taskDetails: entityData['taskDetails'],
              budget: entityData['budget'].toDouble(),
              category: entityData['category'],
              type: entityData['type'],
              jobTime: entityData['jobTime'],
              applicants: List<String>.from(entityData['applicants']),
              clientId: entityData['clientContact'],
              bookmarked: true,
            );
          }).toList();
          return entities;
        }
      }
      print("Failed to get bookmarked entities");
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
