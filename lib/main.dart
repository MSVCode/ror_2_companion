import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ror_2_companion/provider/DataProvider.dart';
import 'package:ror_2_companion/provider/SettingProvider.dart';
import 'package:ror_2_companion/screen/ItemDetailScreen.dart';
import 'package:ror_2_companion/screen/ItemListScreen.dart';
import 'package:ror_2_companion/screen/Setting.dart';
import 'package:ror_2_companion/screen/SurvivorDetailScreen.dart';
import 'package:ror_2_companion/screen/SurvivorListScreen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<SettingProvider>(
        create: (ctx) => SettingProvider(),
      ),
      ChangeNotifierProvider<DataProvider>(
        create: (ctx) => DataProvider(ctx),
      ),
    ],
    child: MaterialApp(
      title: 'Risk of Rain 2 Companion',
      theme: ThemeData.dark(),
      home: MyApp(),
      routes: {
        "/item": (context) => ItemDetailScreen(),
        "/survivor": (context) => SurvivorDetailScreen(),
      },
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
    SurvivorListScreen()
  ];

  @override
  void initState() {
    super.initState();

    _asyncLoad();
  }

  void _asyncLoad() async {
    //wait for settings
    await SettingProvider.of(context).initialize();

    //then load other futures
    var data = DataProvider.of(context).initialize();

    await Future.wait([data]);

    setState(() {
      _ready = true;
    });
  }

  ///Change tab and close drawer
  void _moveTab(int index){
    setState(() => _currentScreen = index);
    Navigator.of(context).pop();
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
                    enabled: _currentScreen!=0,
                    leading: Icon(Icons.storage),
                    title: Text("Item List"),
                    onTap: () => _moveTab(0),
                  ),
                  ListTile(
                    enabled: _currentScreen!=1,
                    leading: Icon(Icons.people),
                    title: Text("Survivor List"),
                    onTap: () => _moveTab(1),
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
