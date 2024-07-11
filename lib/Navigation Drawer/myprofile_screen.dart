import 'dart:convert'; // Import this to decode base64 string
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../login_screen/LoginApiHandler.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Map<String, dynamic>? userDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  _fetchUserDetails() async {
    var details = await LoginApiHandler.getUserDetails();
    setState(() {
      userDetails = details;
      isLoading = false;
    });
  }

  Widget buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 28),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserInfoTile(String title, String value) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  Widget buildEducationDetails(List<dynamic> educationDetails) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text('Education Details', style: TextStyle(fontWeight: FontWeight.bold)),
      children: educationDetails
          .map((educationDetail) => Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text('Degree: ${educationDetail['degree']}', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(
              'Major: ${educationDetail['major']}\nGraduation Year: ${educationDetail['graduationYear']}\nUniversity: ${educationDetail['university']}'),
        ),
      ))
          .toList(),
    );
  }

  Widget buildUserImage(String base64Image) {
    Uint8List bytes = base64Decode(base64Image);

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: MemoryImage(bytes),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : userDetails != null
            ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: buildUserImage(userDetails!['image']),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  userDetails!['username'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ),
              Center(
                child: Text(
                  userDetails!['email'],
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              buildSectionTitle('Basic Information', Icons.info),
              buildUserInfoTile('User ID', userDetails!['_id']),
              buildUserInfoTile('Gender', userDetails!['gender']),
              buildUserInfoTile('Date of Birth', userDetails!['dateOfBirth']),
              buildUserInfoTile('Phone Number', userDetails!['phoneNumber']),
              buildUserInfoTile('Address', userDetails!['address']),

              buildSectionTitle('Education Details', Icons.school),
              buildEducationDetails(userDetails!['educationDetails']),

              buildSectionTitle('Skills', Icons.work),
              buildUserInfoTile('Skills', userDetails!['skills']),
            ],
          ),
        )
            : Text('Failed to fetch user details'),
      ),
    );
  }
}
