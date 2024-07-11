import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/animation.dart';
import 'package:untitled/googlsignin/GoogleSignIn.dart';

import 'package:untitled/login_screen/login_screen.dart';

import '../linkedinsignin/linkedinsignin.dart';
import 'LoginApiHandler.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController gmailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView( // Wrap the Stack with SingleChildScrollView
        child: Stack(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50,),
                    Image.asset("assets/images/bidbridgeicon.png",color: logoColor,),
                    Text(
                      'Welcome to Bidbridge',
                      style: TextStyle(fontSize: 24,color: logoTitleColor),
                    ),
                    SizedBox(height: 20),
                    Card(
                      child: Column(
                        children:  [

                          TextField(
                            decoration: InputDecoration(
                              labelText: 'User Name',
                              contentPadding: EdgeInsets.all(8.0),
                              suffixIcon: Icon(Icons.account_circle_outlined),
                            ),
                          ),
                          TextField(
                            controller: gmailController,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              contentPadding: EdgeInsets.all(8.0),
                              suffixIcon: Icon(Icons.email_outlined),
                            ),
                          ),
                          SizedBox(height: 5),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              contentPadding: EdgeInsets.all(8.0),
                              suffixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                          ),

                          SizedBox(height: 10,),
                          FloatingActionButton(
                            onPressed: () {
                              LoginApiHandler.checkUserRegistration(gmailController.text,context);
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
                    SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width:250,
                          child: ElevatedButton(
                            onPressed: () async{
                              await GoogleSignInApi.signIn(context);
                            },
                            child: Text('Login With Google',
                              style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0), // Set the border radius as needed
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width:250,
                          child: ElevatedButton(
                            onPressed: () {
                              LinkedInSignInApi.signin(context);
                            },
                            child: Text('Login With Linkedin',
                              style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0), // Set the border radius as needed
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('You have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                          },
                          child: Text('Sign in',style: TextStyle(color: Colors.teal),),
                        ),
                      ],
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
