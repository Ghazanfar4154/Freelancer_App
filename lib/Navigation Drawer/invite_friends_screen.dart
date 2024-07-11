import 'package:flutter/material.dart';

class InvitationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitation'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/invite.PNG', // Ensure you have this image in your assets
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 100),
            Container(
              width: 250, // Set the width of the button
              child: ElevatedButton(
                onPressed: () {
                  print('Invite Now button pressed' ,);
                  // You can add your invite logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Set the background color of the button
                   // Set the text color of the button
                  padding: EdgeInsets.symmetric(vertical: 16), // Set the padding for vertical space
                ),
                child: Text('Invite Now',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
