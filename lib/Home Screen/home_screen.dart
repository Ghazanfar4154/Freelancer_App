import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/Navigation%20Drawer/drawer_screen.dart';
import 'package:untitled/animation.dart';
import 'package:untitled/category/CategoryPage.dart';
import 'package:untitled/companies/CompanyDetailScreen.dart';
import 'package:untitled/companies/CompanyListScreen.dart';
import 'package:untitled/projects/Searched_Projects.dart';
import 'package:untitled/projects/viewProjects_screen.dart';
import 'package:untitled/sliders/Image_Slider.dart';
import 'package:untitled/sliders/Slider_Const.dart';

import '../category/Category.dart';
import '../companies/Company.dart';
import '../login_screen/LoginApiHandler.dart';
import '../login_screen/login_screen.dart';
import '../projects/const.dart';
import '../projects/projects_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Project> projects = [];

  List<Category> categories = [];

  List<Company> companies = [];
  bool isLoading = true;

  bool canSearch = false;

  TextEditingController searchedController = TextEditingController();

  void getCategories() {
    if (Category.categories.length > 5) {
      categories.add(Category.categories[0]);
      categories.add(Category.categories[1]);
      categories.add(Category.categories[2]);
      categories.add(Category.categories[3]);
      categories.add(Category.categories[4]);
    } else {
      categories = Category.categories;
    }
  }

  void getCompanies() {
    if (Company.companies.length > 5) {
      companies.add(Company.companies[0]);
      companies.add(Company.companies[1]);
      companies.add(Company.companies[2]);
      companies.add(Company.companies[3]);
      companies.add(Company.companies[4]);
    } else {
      companies = Company.companies;
    }
  }

  void toggleSearch() {
    canSearch = !canSearch;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ProjectConstants.loadProjects(isJob: false).then((value) {
      getCategories();
      getCompanies();
      if (value.length > 2) {
        projects.add(value[0]);
        projects.add(value[1]);
      } else {
        projects = value;
      }
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !canSearch
            ? Text('Home')
            : Expanded(
          child: TextField(
            controller: searchedController,
            decoration: InputDecoration(
              hintText: "Search for projects",
              border: InputBorder.none,
            ),
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
              onPressed: () {
                if (canSearch && searchedController.text.isNotEmpty) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return SearchedProjects(
                        projectName: searchedController.text.trim());
                  }));
                } else {
                  searchedController.clear();
                }
                toggleSearch();
              },
              icon: Icon(Icons.search)),
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Facebook"),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: Text("contact us"),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Privacy Policy"),
                  ),
                ),
                PopupMenuItem(
                  child:TextButton(
                      onPressed:() {
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
              } ,
                      child: Text("Logout"))
                )
              ];
            },
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: isLoading
          ? loadingAnimation
          : SingleChildScrollView(
        child: Column(
          children: [
            ImageSlider(imagePaths: upperSliderImages),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Categories',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CategoryPage(categories: Category.categories)),
                      );
                    },
                    child: Text('See All',style: TextStyle(color: Colors.teal),),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 130,
                child: GestureDetector(
                    child: ScrollCategory(categories: categories))),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Projects',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProjectList()),
                      );
                    },
                    child: Text('See All',style: TextStyle(color: Colors.teal),),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 450,
              child: ProjectConstants.buildProjectsLists(
                projects: projects,
                context: context,
                setStateCallback: setState,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Companies',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanyListScreen()),
                      );
                    },
                    child: Text('See All',style: TextStyle(color: Colors.teal),),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: Company.companies.take(3).map((company) {
                return Flexible(
                  flex: 1,
                  child: GestureDetector(
                    child: CompanyCard(company: company),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) {
                            return CompanyDetailScreen(company: company);
                          }));
                    },
                  ),
                );
              }).toList(),
            ),
            ImageSlider(imagePaths: lowerSliderImages),
            SizedBox(
              height: 300,  // Adjust height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    UserProfileCard(
                      profilePicture: 'assets/images/p1.jpeg',
                      name: 'Raquel',
                      expertise: 'Software Engineer',
                      reviews: '4.8/5 (200 reviews)',
                      location: 'Rome,Italy',
                      rate: '\$100/hr',
                    ),
                    UserProfileCard(
                      profilePicture: 'assets/images/p2.jpeg',
                      name: 'Farhan',
                      expertise: 'Data Scientist',
                      reviews: '4.9/5 (150 reviews)',
                      location: 'New York, NY',
                      rate: '\$120/hr',
                    ),
                    UserProfileCard(
                      profilePicture: 'assets/images/p3.jpeg',
                      name: 'Alice',
                      expertise: 'UX Designer',
                      reviews: '4.7/5 (180 reviews)',
                      location: 'Madrid, Spain',
                      rate: '\$90/hr',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfileCard extends StatelessWidget {
  final String profilePicture;
  final String name;
  final String expertise;
  final String reviews;
  final String location;
  final String rate;

  UserProfileCard({
    required this.profilePicture,
    required this.name,
    required this.expertise,
    required this.reviews,
    required this.location,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        width: 200.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(profilePicture),
            ),
            SizedBox(height: 8.0),
            Text(
              name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.0),
            Text(
              expertise,
              style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
            ),
            SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Icon(Icons.star, color: Colors.amber),
               Text(
                reviews,
                style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
              ),

            ],
              
            ),
            SizedBox(height: 4.0),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        location,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.0), // Add some space between location and rate
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rate',
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        rate,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle view profile button press

                },
                child: Text('View Profile',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 9.0),
                  backgroundColor: Colors.teal, // Change the button color here
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}