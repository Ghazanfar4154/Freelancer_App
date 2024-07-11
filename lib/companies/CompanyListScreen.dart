import 'package:flutter/material.dart';
import '../animation.dart';
import '../projects/const.dart';
import '../projects/projects_api.dart';
import 'Company.dart';

class CompanyListScreen extends StatefulWidget {
  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  final List<Company> companies = Company.companies;

  List<Project> projects = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ProjectConstants.loadProjects(isJob: true).then((value){
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
    return MaterialApp(
      title: 'Company Profile',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Company Jobs'),
          backgroundColor: Colors.teal,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back)),
        ),
        body: isLoading
            ? loadingAnimation
            : projects.isEmpty
            ? noDataAnimation
            : ProjectConstants.buildProjectsLists(
          projects: projects,
          context: context,
          setStateCallback: setState,isJob: true),

        // ListView.builder(
        //   itemCount: companies.length,
        //   itemBuilder: (context, index) {
        //     final company = companies[index];
        //     return AnimatedContainer(
        //       duration: Duration(milliseconds: 300),
        //       curve: Curves.easeInOut,
        //       child: Card(
        //         elevation: 5,
        //         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(15.0),
        //         ),
        //         child: ListTile(
        //           leading: CircleAvatar(
        //             backgroundImage: AssetImage(company.logoPath),
        //             radius: 30,
        //           ),
        //           title: Text(
        //             company.name,
        //             style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               color: Colors.black87,
        //             ),
        //           ),
        //           subtitle: Text(
        //             'Tap for details',
        //             style: TextStyle(
        //               color: Colors.black54,
        //             ),
        //           ),
        //           trailing: Icon(Icons.arrow_forward_ios, color: Colors.cyan),
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => CompanyDetailScreen(company: company),
        //               ),
        //             );
        //           },
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}



class CompanyCard extends StatelessWidget {
  final Company company;

  CompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(company.logoPath),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            company.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
