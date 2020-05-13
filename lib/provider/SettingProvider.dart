
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Load data eagerly
class SettingProvider with ChangeNotifier {
  SharedPreferences _pref;

  /// Grid count in GridView
  int gridCount;

  SettingProvider();

  /// Set listen:true if used in build-method
  static SettingProvider of(BuildContext context, {bool listen:false}) =>
      Provider.of<SettingProvider>(context, listen: listen);

  Future<void> initialize() async {
    _pref = await SharedPreferences.getInstance();

    gridCount = _pref.getInt("gridCount") ?? 3;
  }

  void setGridCount(int count){
    _pref.setInt("gridCount", count);
    gridCount = count;

    notifyListeners();
  }
}

