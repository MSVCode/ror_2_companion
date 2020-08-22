import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ror_2_companion/model/Item.dart';
import 'package:ror_2_companion/model/Survivor.dart';
import 'package:ror_2_companion/model/Unlock.dart';
import 'package:ror_2_companion/provider/SettingProvider.dart';

/// Load data eagerly
class DataProvider with ChangeNotifier {
  BuildContext context;
  //optional translation from setting
  String translation = "";

  //items
  String lastItemQuery = "";
  List<Item> itemList;
  List<Item> filteredItemList;
  List<Unlock> unlockList;
  Map<RARITY, bool> filterRarity = {
    RARITY.BOSS: true,
    RARITY.COMMON: true,
    RARITY.EQUIPMENT: true,
    RARITY.LEGENDARY: true,
    RARITY.LUNAR: true,
    RARITY.UNCOMMON: true,
  };
  Map<ITEM_CATEGORY, bool> filterItemCategory = {
    ITEM_CATEGORY.DAMAGE: true,
    ITEM_CATEGORY.EQUIPMENT: true,
    ITEM_CATEGORY.HEAL: true,
    ITEM_CATEGORY.UTILITY: true,
    ITEM_CATEGORY.SCRAP: true
  };
  //survivor
  String lastSurvivorQuery = "";
  List<Survivor> survivorList;
  List<Survivor> filteredSurvivorList;

  //Receive context
  DataProvider(this.context);

  /// Set listen:true if used in build-method
  static DataProvider of(BuildContext context, {bool listen: false}) =>
      Provider.of<DataProvider>(context, listen: listen);

  Future<void> initialize() async {
    translation = "sample_en"; //SettingProvider.of(context).translation;

    var item = loadItem();
    var unlock = loadUnlock();
    var survivor = loadSurvivor();

    await Future.wait([item, unlock, survivor]);
  }

  /// Filter item using search query or filter checkbox
  ///
  /// Updates filteredItemList
  void filterItem([String query]) {
    query = query == null ? lastItemQuery : query.toLowerCase();
    filteredItemList = itemList.where((item) {
      bool contains = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);

      bool rarity = filterRarity[item.rarity];

      //find at least one true category
      var trueCategory =
          item.itemCategory.indexWhere((val) => filterItemCategory[val]);
      bool category = trueCategory > -1;

      return contains && rarity && category;
    }).toList();

    if (query != null) lastItemQuery = query;

    notifyListeners();
  }

  /// Load item data
  Future<void> loadItem() async {
    if (itemList != null) return;

    List<Map<String, dynamic>> itemJson;

    try {
      String data = await DefaultAssetBundle.of(context)
          .loadString("asset/json/core/item.json");
      //type hinting
      List<dynamic> rawData = json.decode(data);
      itemJson = rawData.map<Map<String, dynamic>>((e) => e).toList();
    } catch (err) {
      throw new Exception("Unable to load item data");
    }

    //if translation is used
    String translationData;
    List<Map<String, dynamic>> translationJson;
    if (translation.isNotEmpty) {
      try {
        translationData = await DefaultAssetBundle.of(context)
            .loadString("asset/json/$translation/item.json");
        //type hinting
        List<dynamic> rawData = json.decode(translationData);
        translationJson = rawData.map<Map<String, dynamic>>((e) => e).toList();
      } catch (err) {
        throw new Exception("Unable to load item translation");
      }
    }

    //convert into class
    itemList = itemJson.map<Item>((Map<String, dynamic> v) {
      //if translation is used, merge map
      if (translationJson != null) {
        //find translation data
        var replace = translationJson.firstWhere((rep) => rep["id"] == v["id"],
            orElse: () => null);
        if (replace != null) v.addAll(replace);
      }

      return Item.fromMap(v);
    }).toList();

    //sort by rarity, then name
    itemList.sort((a, b) {
      if (a.rarity != b.rarity) return a.rarity.index - b.rarity.index;

      return a.name.compareTo(b.name);
    });

    filteredItemList = itemList;
  }

  Item findItemById(int id) {
    return itemList.firstWhere((val) => val.id == id);
  }

  /// Load unlock data
  Future<void> loadUnlock() async {
    if (unlockList != null) return;

    List<Map<String, dynamic>> unlockJson;

    // Currently Unlock's core and translation data have exact same keys, so it's okay to load them directly
    try {
      String data;
      if (translation.isEmpty) {
        data = await DefaultAssetBundle.of(context)
            .loadString("asset/json/core/unlock.json");
      } else {
        data = await DefaultAssetBundle.of(context)
            .loadString("asset/json/$translation/unlock.json");
      }
      //type hinting
      List<dynamic> rawData = json.decode(data);
      unlockJson = rawData.map<Map<String, dynamic>>((e) => e).toList();
    } catch (err) {
      throw new Exception("Unable to load unlock data");
    }

    //convert into class
    unlockList = unlockJson.map<Unlock>((v) => Unlock.fromMap(v)).toList();
  }

  /// Find unlock for a certain item id
  ///
  /// Might returns null
  Unlock findItemUnlock(int id) {
    return unlockList.firstWhere(
        (val) => val.unlockType == UNLOCK_TYPE.ITEM && val.key == "item-$id",
        orElse: () => null);
  }

  /// Set filter
  void setRarityFilter(Map<RARITY, bool> filter) {
    filterRarity = filter;
  }

  /// Set filter
  void setCategoryFilter(Map<ITEM_CATEGORY, bool> filter) {
    filterItemCategory = filter;
  }

  //survivor
  /// Filter survivor using search query
  ///
  /// Updates filteredSurvivorList
  void filterSurvivor([String query]) {
    query = query == null ? lastSurvivorQuery : query.toLowerCase();
    filteredSurvivorList = survivorList.where((survivor) {
      bool contains = query.isEmpty ||
          survivor.name.toLowerCase().contains(query) ||
          survivor.description.toLowerCase().contains(query);

      return contains;
    }).toList();

    if (query != null) lastSurvivorQuery = query;

    notifyListeners();
  }

  /// Load survivor data
  Future<void> loadSurvivor() async {
    if (survivorList != null) return;

    List<Map<String, dynamic>> survivorJson;

    try {
      String data = await DefaultAssetBundle.of(context)
          .loadString("asset/json/core/survivor.json");

      List<dynamic> rawData = json.decode(data);
      survivorJson = rawData.map<Map<String, dynamic>>((e) => e).toList();
    } catch (err) {
      throw new Exception("Unable to load survivor data");
    }

    //if translation is used
    String translationData;
    List<Map<String, dynamic>> translationJson;
    if (translation.isNotEmpty) {
      try {
        translationData = await DefaultAssetBundle.of(context)
            .loadString("asset/json/$translation/survivor.json");
        //type hinting
        List<dynamic> rawData = json.decode(translationData);
        translationJson = rawData.map<Map<String, dynamic>>((e) => e).toList();
      } catch (err) {
        throw new Exception("Unable to load survivor translation");
      }
    }

    //convert into class
    survivorList = survivorJson.map<Survivor>((v) {
      //if translation is used, merge map
      if (translationJson != null) {
        //find translation data
        var replace = translationJson.firstWhere((rep) => rep["id"] == v["id"],
            orElse: () => null);

        if (replace != null) {
          //skip skill for general replace
          var finalData = {...replace};
          finalData.remove("skillList");

          //loop skill replacement here
          List<dynamic> rawCore = v["skillList"];
          List<Map<String, dynamic>> coreSkillList =
              rawCore.map<Map<String, dynamic>>((val) => val).toList();
          List<dynamic> rawTranslation = replace["skillList"];
          List<Map<String, dynamic>> translationSkillList =
              rawTranslation.map<Map<String, dynamic>>((val) => val).toList();

          //will automatically 'update' v - as it's by reference
          //find same type and same variant
          for (int i = 0; i < coreSkillList.length; i++) {
            var initialData = coreSkillList[i];
            var repData = translationSkillList.firstWhere(
                (val) =>
                    val["skillType"] == initialData["skillType"] &&
                    val["variant"] == initialData["variant"],
                orElse: () => null);

            //add skill to v here
            if (repData != null) {
              initialData.addAll(repData);
            }
          }

          //add other data
          v.addAll(finalData);
        }
      }

      return Survivor.fromMap(v);
    }).toList();

    //sort by rarity, then name
    survivorList.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    filteredSurvivorList = survivorList;
  }

  Survivor findSurvivorById(int id) {
    return survivorList.firstWhere((val) => val.id == id);
  }

  /// Find unlock for a certain survivor id
  ///
  /// Might returns null
  Unlock findSurvivorUnlock(int id) {
    return unlockList.firstWhere(
        (val) =>
            val.unlockType == UNLOCK_TYPE.SURVIVOR && val.key == "survivor-$id",
        orElse: () => null);
  }

  /// Find unlock for a certain survivor's skill loadout
  ///
  /// Might returns null
  Unlock findSkillUnlock(int survivorId, SKILL_TYPE type, int variant) {
    return unlockList.firstWhere(
        (val) =>
            val.unlockType == UNLOCK_TYPE.SKILL &&
            val.key == "skill-$survivorId-${type.index}-$variant",
        orElse: () => null);
  }
}
