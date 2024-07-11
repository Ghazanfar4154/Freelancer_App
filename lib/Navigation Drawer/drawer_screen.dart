import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:untitled/Navigation%20Drawer/invite_friends_screen.dart';
import 'package:untitled/animation.dart';
import 'package:untitled/category/CategoryPage.dart';
import 'package:untitled/companies/Company.dart';
import 'package:untitled/login_screen/login_screen.dart';
import 'package:untitled/login_screen/signup.dart';
import 'package:untitled/projects/Applied_Projects.dart';
import 'package:untitled/projects/BookmarkProjects.dart';
import '../category/Category.dart';
import '../companies/CompanyListScreen.dart';
import '../login_screen/LoginApiHandler.dart';
import '../notifications/Notification Screen.dart';
import 'myprofile_screen.dart';
import '../projects/viewProjects_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late Map<String, dynamic> userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  _fetchUserDetails() async {
    var details = await LoginApiHandler.getUserDetails();
    setState(() {
      userDetails = details!;
      isLoading = false;
    });
  }

  Widget buildProfileImage() {
    if (isLoading) {
      return loadingAnimation;
    } else {
      String base64Image = userDetails['image']; // Assuming 'image' is the key for the base64 image
      Uint8List bytes = base64Decode(base64Image);
      return CircleAvatar(
        radius: 30,
        backgroundImage: MemoryImage(bytes),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: isLoading?loadingAnimation: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            currentAccountPicture: buildProfileImage(),
            accountName: isLoading ? Text('Loading...') : Text(userDetails['username']),
            accountEmail: isLoading ? Text('Loading...') : Text(userDetails['email']),
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined, color: Colors.blue),
            title: Text('View Profile'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.category_outlined, color: Colors.green),
            title: Text('Categories'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(categories:Category.categories)));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.orange),
            title: Text('Notifications'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.business, color: Colors.purple),
            title: Text('Companies Jobs'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyListScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark, color: Colors.red),
            title: Text('Bookmark'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarkedProjectsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.work, color: Colors.teal),
            title: Text('View Projects'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectList()));
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment, color: Colors.pink),
            title: Text('Applied Jobs'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AppliedProjectsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_invitation, color: Colors.brown),
            title: Text('Invite friends'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => InvitationScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.grey),
            title: Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text("Do you want to logout"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          LoginApiHandler.logout();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: Text("Yes",style: TextStyle(color: Colors.teal),),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No",style: TextStyle(color: Colors.teal),),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
