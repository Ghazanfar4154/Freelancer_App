import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/Home%20Screen/MainPage.dart';

import 'LoginApiHandler.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? _image;
  final picker = ImagePicker();
  // Controllers for text fields
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _gmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();

  // Gender options
  String _selectedGender = 'Male'; // Initializing with 'Male'

  // Date of Birth
  DateTime _selectedDate = DateTime.now(); // Initializing with current date

  // List to hold education details
  List<Map<String, String>> _educationDetails = [];

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to add education details
  void _addEducationDetails() {
    setState(() {
      _educationDetails.add({
        'degree': '',
        'major subject': '',
        'graduationYear': '',
        'university': '',
      });
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register New User'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Basic Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 12.0),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  ),
                  SizedBox(height: 12.0),
                  _image != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      _image!,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            _buildTextField(_usernameController, 'Username', Icons.person),
            _buildTextField(_gmailController, 'Gmail', Icons.email),
            _buildTextField(_passwordController, 'Password', Icons.lock, obscureText: true),
            SizedBox(height: 12.0),
            DropdownButtonFormField(
              value: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
              items: ['Male', 'Female', 'Other']
                  .map((gender) => DropdownMenuItem(
                child: Text(gender),
                value: gender,
              ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            SizedBox(height: 12.0),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                      text: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            _buildTextField(_phoneNumberController, 'Phone Number', Icons.phone, keyboardType: TextInputType.phone),
            _buildTextField(_addressController, 'Address', Icons.home, maxLines: 3),
            SizedBox(height: 24.0),
            Text(
              'Education Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 12.0),
            ..._educationDetails.asMap().entries.map((entry) {
              final index = entry.key;
              final educationDetail = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Education Detail ${index + 1}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.0),
                  _buildEducationField(index, 'Degree', 'degree', Icons.school),
                  SizedBox(height: 12.0),
                  _buildEducationField(index, 'Major', 'major', Icons.book),
                  SizedBox(height: 12.0),
                  _buildEducationField(index, 'Graduation Year', 'graduationYear', Icons.calendar_today, keyboardType: TextInputType.number),
                  SizedBox(height: 12.0),
                  _buildEducationField(index, 'University Name', 'university', Icons.location_city),
                  SizedBox(height: 24.0),
                ],
              );
            }).toList(),
            ElevatedButton(
              onPressed: _addEducationDetails,
              child: Text('Add Education Details'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
            SizedBox(height: 24.0),
            Text(
              'Skills',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 12.0),
            _buildTextField(_skillsController, 'Skills', Icons.build),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                // Implement registration logic here
                if (_usernameController.text.isEmpty ||
                    _phoneNumberController.text.isEmpty ||
                    _addressController.text.isEmpty ||
                    _educationDetails.isEmpty ||
                    _skillsController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please fill in all fields.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  String? base64Image;
                  if (_image != null) {
                    base64Image = base64Encode(await _image!.readAsBytes());
                  }
                  // All fields are filled, proceed with registration
                  // Your registration logic here
                  Map<String, dynamic> userData = {
                    'email': _gmailController.text,
                    'password': _passwordController.text,
                    'username': _usernameController.text,
                    'gender': _selectedGender,
                    'dateOfBirth': _selectedDate.toString(),
                    'phoneNumber': _phoneNumberController.text,
                    'address': _addressController.text,
                    'educationDetails': _educationDetails,
                    'skills': _skillsController.text,
                    'image': base64Image,
                  };

                  // Call the registerUser function
                  bool registered = await LoginApiHandler.registerUser(userData);
                  if (registered) {
                    // Registration successful, navigate to login page or perform any other action
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                      return Mainpage();
                    }));
                  } else {
                    // Registration failed, display error message
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to register user.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              child: Text('Register'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {bool obscureText = false, TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildEducationField(int index, String labelText, String key, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          _educationDetails[index][key] = value;
        });
      },
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }
}
