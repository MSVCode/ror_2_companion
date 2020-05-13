import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ror_2_companion/provider/DataProvider.dart';
import 'package:ror_2_companion/provider/SettingProvider.dart';
import 'package:ror_2_companion/screen/ItemDetailScreen.dart';
import 'package:ror_2_companion/screen/ItemListScreen.dart';
import 'package:ror_2_companion/screen/Setting.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<DataProvider>(
        create: (ctx) => DataProvider(ctx),
      ),
      ChangeNotifierProvider<SettingProvider>(
        create: (ctx) => SettingProvider(),
      ),
    ],
    child: MaterialApp(
      title: 'Risk of Rain 2 Companion',
      theme: ThemeData.dark(),
      home: MyApp(),
      routes: {"/item": (context) => ItemDetailScreen()},
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _ready = false;
  int _currentScreen = 0;
  List<Widget> _screenList = [
    ItemListScreen(),
  ];

  @override
  void initState() {
    super.initState();

    _asyncLoad();
  }

  void _asyncLoad() async {
    var data = DataProvider.of(context).initialize();
    var setting = SettingProvider.of(context).initialize();

    await Future.wait([data, setting]);

    setState(() {
      _ready = true;
    });
  }

  Widget _buildApp() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Risk of Rain 2 Companion"),
      ),
      body: _screenList[_currentScreen],
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 40, bottom: 10, left: 15),
              child: Text(
                "Menu",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              decoration: BoxDecoration(color: Colors.grey),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.list),
                    title: Text("Item List"),
                    onTap: () => setState(() => _currentScreen = 0),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Setting"),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => SettingScreen())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ready
        ? _buildApp()
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
