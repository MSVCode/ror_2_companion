import "package:flutter/material.dart";

class DisclaimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disclaimer"),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: ListView(
          children: <Widget>[
            Text(
"""
[Risk of Rain 2 Companion] is a third-party open-sourced application developed by MSVCode. Please visit the GitHub page to help the development and providing suggestions.

Some data and information in this app are crowd-sourced from fans, so there might be some errors in them. Let us know on GitHub if you found any error and help us fill the correct info.

This application is not affiliated with, endorsed, sponsored, or specifically approved by Hopoo Games nor Gearbox Publishing.
Therefore, Hopoo Games and Gearbox Publishing are not responsible for this app.

Any Game content and assets are trademarks and copyrights of their respective publisher and its licensors and not included in [Risk of Rain 2 Companion]'s license.
""",
            ),
          ],
        ),
      ),
    );
  }
}
