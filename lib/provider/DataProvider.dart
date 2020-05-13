import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ror_2_companion/model/Item.dart';
import 'package:ror_2_companion/model/Unlock.dart';

/// Load data eagerly
class DataProvider with ChangeNotifier {
  BuildContext context;
  String _lastQuery="";
  List<Item> itemList;
  List<Item> filteredItemList;
  List<Unlock> unlockList;
  Map<RARITY, bool> filterRarity = {
    RARITY.BOSS:true,
    RARITY.COMMON:true,
    RARITY.EQUIPMENT:true,
    RARITY.LEGENDARY:true,
    RARITY.LUNAR:true,
    RARITY.UNCOMMON:true,
  };
  Map<ITEM_CATEGORY, bool> filterItemCategory = {
    ITEM_CATEGORY.DAMAGE: true,
    ITEM_CATEGORY.EQUIPMENT: true,
    ITEM_CATEGORY.HEAL: true,
    ITEM_CATEGORY.UTILITY: true
  };

  //Receive context
  DataProvider(this.context);

  /// Set listen:true if used in build-method
  static DataProvider of(BuildContext context, {bool listen:false}) =>
      Provider.of<DataProvider>(context, listen: listen);

  Future<void> initialize() async{
    var item = loadItem();
    var unlock = loadUnlock();

    await Future.wait([item, unlock]);
  }

  /// Filter item using search query or filter checkbox
  /// 
  /// Updates filteredItemList
  void filterItem([String query]){
    query = query==null?_lastQuery:query.toLowerCase();
    filteredItemList = itemList.where((item) {
      bool contains = query.isEmpty || item.name.toLowerCase().contains(query) ||
        item.description.toLowerCase().contains(query);

      bool rarity = filterRarity[item.rarity];
      bool category = filterItemCategory[item.itemCategory];

      return contains && rarity && category;
    }).toList();

    if (query!=null)
      _lastQuery = query;

    notifyListeners();
  }

  /// Load item data
  Future<void> loadItem() async {
    if (itemList !=null) return;

    List<dynamic> itemJson;
    
    try {
      String data = await DefaultAssetBundle.of(context).loadString("asset/json/item.json");
      itemJson = json.decode(data);
    } catch (err) {
      throw new Exception("Unable to load item data");
    }

    //convert into class
    itemList = itemJson.map<Item>((v) => Item.fromMap(v)).toList();
    filteredItemList = itemList;
  }

  Item findItemById(int id){
    return itemList.firstWhere((val) => val.id==id);
  }

  /// Load unlock data
  Future<void> loadUnlock() async {
    if (unlockList !=null) return;

    List<dynamic> unlockJson;
    
    try {
      String data = await DefaultAssetBundle.of(context).loadString("asset/json/unlock.json");
      unlockJson = json.decode(data);
    } catch (err) {
      throw new Exception("Unable to load unlock data");
    }

    //convert into class
    unlockList = unlockJson.map<Unlock>((v) => Unlock.fromMap(v)).toList();
  }

  /// Find unlock for a certain item id
  /// 
  /// Might returns null
  Unlock findItemUnlock(int id){
    return unlockList.firstWhere((val) => val.key=="item-$id", orElse: ()=>null);
  }

  /// Set filter
  void setRarityFilter(Map<RARITY, bool> filter){
    filterRarity = filter;
  }

  /// Set filter
  void setCategoryFilter(Map<ITEM_CATEGORY, bool> filter){
    filterItemCategory = filter;
  }
}

