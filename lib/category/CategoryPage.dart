import 'package:flutter/material.dart';
import 'package:untitled/animation.dart';

import 'Category.dart';
// Define the CategoryPage widget
class CategoryPage extends StatelessWidget {
  final List<Category> categories;

  CategoryPage({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: CategoriesGrid(categories: categories),
      ),
    );
  }
}
