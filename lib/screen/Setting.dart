import "package:flutter/material.dart";
import 'package:ror_2_companion/provider/SettingProvider.dart';
import 'package:ror_2_companion/screen/DisclaimerScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SettingScreenState();
  }
}

class _SettingScreenState extends State<SettingScreen> {
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget _buildSettingGridCount() {
    var prov = SettingProvider.of(context, listen: true);
    int gridCount = prov.gridCount;
    return Column(
      children: <Widget>[
        Text(gridCount.toString()),
        Slider(
          value: gridCount.toDouble(),
          min: 1,
          max: 10,
          divisions: 10,
          label: gridCount.toString(),
          onChanged: (val) => prov.setGridCount(val.toInt()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("General"),
            ),
            ListTile(
              title: Text("List Grid Count"),
              subtitle: _buildSettingGridCount(),
            ),
            Divider(),
            ListTile(
              title: Text("About"),
            ),
            ListTile(
              title: Text("Disclaimer"),
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>DisclaimerScreen())),
            ),
            ListTile(
              title: Text("Open-Sourced Project by MSVCode"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Text("msvcode@gmail.com"),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Version 0.1.0"),
                ],
              ),
            ),
            ListTile(
              title: Text("Visit Github to help the development"),
              subtitle: Text("https://github.com/MSVCode/ror_2_companion"),
              onTap: () =>
                  _launchURL("https://github.com/MSVCode/ror_2_companion"),
            ),
          ],
        ),
      ),
    );
  }
}
