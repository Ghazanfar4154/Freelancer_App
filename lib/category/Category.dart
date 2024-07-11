import 'package:flutter/material.dart';
import 'package:untitled/animation.dart';
import 'package:untitled/category/ShowProjectByCategory.dart';

// Define the Category class
class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});

  // Sample categories list
  static final List<Category> categories = [
    Category(name: 'Developer', icon: Icons.code),
    Category(name: 'Technology', icon: Icons.devices),
    Category(name: 'Accounting', icon: Icons.account_balance),
    Category(name: 'Human Resource', icon: Icons.people),
    Category(name: 'Design', icon: Icons.brush),
    Category(name: 'Marketing', icon: Icons.campaign),
    Category(name: 'Writing', icon: Icons.edit),
    Category(name: 'Data Entry', icon: Icons.assignment),
    Category(name: 'Translation', icon: Icons.translate),
    Category(name: 'Customer Support', icon: Icons.headset_mic),
    Category(name: 'Sales', icon: Icons.attach_money),
    Category(name: 'Project Management', icon: Icons.timeline),
    Category(name: 'Social Media', icon: Icons.group),
    Category(name: 'Video Production', icon: Icons.videocam),
    Category(name: 'Photography', icon: Icons.camera_alt),
  ];
}

// Define the CategoryBox widget
class CategoryBox extends StatelessWidget {
  final Category category;

  Color boxColor = Colors.white;
  Color itemsColor = Colors.teal;

  CategoryBox({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(category.icon, size: 40, color: Colors.teal),
          SizedBox(height: 8.0),
          Flexible(
            child: Text(
              category.name,
              style: TextStyle(color: Colors.teal, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Define the CategoriesGrid widget
class CategoriesGrid extends StatelessWidget {
  List<Category> categories;
  ScrollPhysics? physics;

  CategoriesGrid({required this.categories,this.physics});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: physics!=null ?physics:null,
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        mainAxisSpacing: 0, // Space between rows
        crossAxisSpacing: 0, // Space between columns
        childAspectRatio: 0.9, // Aspect ratio of each item
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (_){
              return ShowProjectByCategory(categoryName: categories[index].name);
            }));
          },
            child: CategoryBox(category: categories[index])
        );
      },
    );
  }
}

// Define the ScrollCategory widget
class ScrollCategory extends StatelessWidget {
  final List<Category> categories;
  final ScrollPhysics? physics;

  ScrollCategory({required this.categories, this.physics});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Adjust the height based on your design
      child: ListView.builder(
        physics: physics != null ? physics : null,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) {
                  return ShowProjectByCategory(categoryName: categories[index].name);
                }),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 3, // Ensuring each item has the same width
              child: CategoryBox(category: categories[index]),
            ),
          );
        },
      ),
    );
  }
}