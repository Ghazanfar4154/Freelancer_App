import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/animation.dart';
import 'package:untitled/login_screen/LoginApiHandler.dart';

class NewPassword extends StatefulWidget {
  String gmail;
  NewPassword({super.key, required this.gmail});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {

  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                color: Colors.teal,
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 100,),
                  Image.asset("assets/images/bidbridgeicon.png", color: logoColor,),
                  Text(
                    'Foreget Password',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            contentPadding: EdgeInsets.all(8.0),
                            suffixIcon: Icon(Icons.lock),
                          ),
                          controller: newPassword,
                        ),
                        SizedBox(height: 20,),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            contentPadding: EdgeInsets.all(8.0),
                            suffixIcon: Icon(Icons.lock),
                          ),
                          controller: confirmNewPassword,
                        ),
                        SizedBox(height: 20),
                        FloatingActionButton(
                          onPressed: () {
                            if(newPassword.text.length<6){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password length must be greater than 6")));
                            }
                            else if(newPassword.text!= confirmNewPassword.text){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password is not same")));
                            }
                            else{
                              LoginApiHandler.setNewPassword(widget.gmail, newPassword.text, context);
                            }
                          },
                          child: Icon(Icons.arrow_forward),
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0), // Set the border radius as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
