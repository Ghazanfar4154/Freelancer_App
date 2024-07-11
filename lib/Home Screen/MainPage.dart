import 'package:flutter/material.dart';
import 'package:untitled/Home%20Screen/home_screen.dart';
import 'package:untitled/animation.dart';
import 'package:untitled/chats/ChatListScreen.dart';
import 'package:untitled/projects/BookmarkProjects.dart';
import '../projects/viewProjects_screen.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    Widget _buildTabBarView() {
      return TabBarView(
        children: [
          HomeScreen(),
          ChatListScreen(),
          BookmarkedProjectsScreen(),
          ProjectList(),
        ],
      );
    }
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: _buildTabBarView(),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home,color: Colors.teal,)),
            Tab(icon: Icon(Icons.message,color: Colors.teal,)),
            Tab(icon: Icon(Icons.bookmark,color: Colors.teal,)),
            Tab(icon: Icon(Icons.work,color: Colors.teal,)),
          ],
          indicatorColor: whiteColor,
        ),
      ),
    );
  }
}
