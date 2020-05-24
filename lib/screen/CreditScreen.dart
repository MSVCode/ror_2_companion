import "package:flutter/material.dart";

class CreditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credit"),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: ListView(
          children: <Widget>[
            Text(
"""
This application is an open-sourced project and a lot of its content are gathered by third party players and developers worldwide. 

This page is dedicated as thanks to their works:

Hopoo Games for the amazing game and information.
Risk of Rain 2 Gamepedia for more detailed data.
All contributors in GitHub.
And you.
""",
            ),
          ],
        ),
      ),
    );
  }
}
