
import 'package:flutter/material.dart';
import 'package:untitled/animation.dart';
import 'package:untitled/googlsignin/GoogleSignIn.dart';
import 'package:untitled/linkedinsignin/linkedinsignin.dart';
import 'package:untitled/login_screen/signup.dart';

import 'LoginApiHandler.dart';
import 'forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController gmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                            controller: gmailController,
                          ),
                          SizedBox(height: 5),
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              contentPadding: EdgeInsets.all(8.0),
                              suffixIcon: Icon(Icons.lock),
                            ),
                            obscureText: true,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPassword()));
                              },
                              child: Text('Forget Password',style: TextStyle(color: Colors.teal),),
                            ),
                          ),
                          SizedBox(height: 10,),
                          FloatingActionButton(
                            onPressed: () {
                              var pdata = {
                                "email":gmailController.text,
                                "password":passwordController.text
                              };
                              LoginApiHandler.loginUser(pdata,context);
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
                            onPressed: () {
                              GoogleSignInApi.signIn(context);
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
                        Text('You do not have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_){
                              return SignupPage();
                            }));
                          },
                          child: Text('Sign Up',style: TextStyle(color: Colors.teal),),
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
