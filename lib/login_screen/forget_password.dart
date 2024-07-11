import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/animation.dart';
import 'package:untitled/login_screen/LoginApiHandler.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  TextEditingController gmailController = TextEditingController();

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
                  Image.asset("assets/images/bidbridgeicon.png",color: logoColor,),
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
                            labelText: 'Enter Email Address',
                            contentPadding: EdgeInsets.all(8.0),
                            suffixIcon: Icon(Icons.email_outlined),
                          ),
                          controller: gmailController,
                        ),
                        SizedBox(height: 20),
                        FloatingActionButton(
                          onPressed: () {
                            LoginApiHandler.checkUserPasswordRecover(gmailController.text, context);
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
