import 'package:flutter/material.dart';
import 'package:ror_2_companion/model/Item.dart';
import 'package:ror_2_companion/provider/DataProvider.dart';

class ItemFilterDialog extends StatefulWidget {
  ItemFilterDialog();

  @override
  ItemFilterDialogState createState() => ItemFilterDialogState();
}

class ItemFilterDialogState extends State<ItemFilterDialog> {
  TextStyle small = TextStyle(fontSize: 14);
  //item rarity
  bool _checkRarityBoss;
  bool _checkRarityCommon;
  bool _checkRarityLegendary;
  bool _checkRarityUncommon;
  bool _checkRarityEquipment;
  bool _checkRarityLunar;

  //item category
  bool _checkCategoryDamage;
  bool _checkCategoryEquipment;
  bool _checkCategoryHeal;
  bool _checkCategoryUtility;

  @override
  void initState() {
    super.initState();

    var prov = DataProvider.of(context);

    _checkRarityBoss = prov.filterRarity[RARITY.BOSS];
    _checkRarityCommon = prov.filterRarity[RARITY.COMMON];
    _checkRarityUncommon = prov.filterRarity[RARITY.UNCOMMON];
    _checkRarityLegendary = prov.filterRarity[RARITY.LEGENDARY];
    _checkRarityEquipment = prov.filterRarity[RARITY.EQUIPMENT];
    _checkRarityLunar = prov.filterRarity[RARITY.LUNAR];

    _checkCategoryDamage = prov.filterItemCategory[ITEM_CATEGORY.DAMAGE];
    _checkCategoryEquipment = prov.filterItemCategory[ITEM_CATEGORY.EQUIPMENT];
    _checkCategoryHeal = prov.filterItemCategory[ITEM_CATEGORY.HEAL];
    _checkCategoryUtility = prov.filterItemCategory[ITEM_CATEGORY.UTILITY];
  }

  void _saveFilter() {
    var prov = DataProvider.of(context);

    prov.setRarityFilter({
      RARITY.BOSS: _checkRarityBoss,
      RARITY.COMMON: _checkRarityCommon,
      RARITY.UNCOMMON: _checkRarityUncommon,
      RARITY.LEGENDARY: _checkRarityLegendary,
      RARITY.EQUIPMENT: _checkRarityEquipment,
      RARITY.LUNAR: _checkRarityLunar,
    });

    prov.setCategoryFilter({
      ITEM_CATEGORY.DAMAGE: _checkCategoryDamage,
      ITEM_CATEGORY.EQUIPMENT: _checkCategoryEquipment,
      ITEM_CATEGORY.HEAL: _checkCategoryHeal,
      ITEM_CATEGORY.UTILITY: _checkCategoryUtility,
    });

    //trigger filter
    prov.filterItem();
    Navigator.pop(context);
  }

  void _resetFilter() {
    var prov = DataProvider.of(context);

    prov.setRarityFilter({
      RARITY.BOSS: true,
      RARITY.COMMON: true,
      RARITY.UNCOMMON: true,
      RARITY.LEGENDARY: true,
      RARITY.EQUIPMENT: true,
      RARITY.LUNAR: true,
    });

    prov.setCategoryFilter({
      ITEM_CATEGORY.DAMAGE: true,
      ITEM_CATEGORY.EQUIPMENT: true,
      ITEM_CATEGORY.HEAL: true,
      ITEM_CATEGORY.UTILITY: true,
    });

    //trigger filter
    prov.filterItem();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(4),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 8),
            Text(
              "Rarity",
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text("Boss",
                        style: small.copyWith(color: Colors.yellow)),
                    value: _checkRarityBoss,
                    onChanged: (val) {
                      setState(() => _checkRarityBoss = val);
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: Text("Common", style: small),
                    value: _checkRarityCommon,
                    onChanged: (val) {
                      setState(() => _checkRarityCommon = val);
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text("Equipment",
                        style: small.copyWith(color: Colors.orange)),
                    value: _checkRarityEquipment,
                    onChanged: (val) {
                      setState(() => _checkRarityEquipment = val);
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: Text("Legendary",
                        style: small.copyWith(color: Colors.red)),
                    value: _checkRarityLegendary,
                    onChanged: (val) {
                      setState(() => _checkRarityLegendary = val);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text("Lunar",
                        style: small.copyWith(color: Colors.blue)),
                    value: _checkRarityLunar,
                    onChanged: (val) {
                      setState(() => _checkRarityLunar = val);
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: Text("Uncommon",
                        style: small.copyWith(color: Colors.green)),
                    value: _checkRarityUncommon,
                    onChanged: (val) {
                      setState(() => _checkRarityUncommon = val);
                    },
                  ),
                )
              ],
            ),
            Divider(height: 16),
            Text(
              "Category",
              textAlign: TextAlign.center,
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text("Damage",
                        style: small.copyWith(color: Colors.redAccent)),
                    value: _checkCategoryDamage,
                    onChanged: (val) {
                      setState(() => _checkCategoryDamage = val);
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: Text("Equipment",
                        style: small.copyWith(color: Colors.orangeAccent)),
                    value: _checkCategoryEquipment,
                    onChanged: (val) {
                      setState(() => _checkCategoryEquipment = val);
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text("Heal",
                        style: small.copyWith(color: Colors.greenAccent)),
                    value: _checkCategoryHeal,
                    onChanged: (val) {
                      setState(() => _checkCategoryHeal = val);
                    },
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: Text("Utility",
                        style: small.copyWith(color: Colors.purpleAccent)),
                    value: _checkCategoryUtility,
                    onChanged: (val) {
                      setState(() => _checkCategoryUtility = val);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Reset"),
          onPressed: _resetFilter,
        ),
        FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Save"),
          onPressed: _saveFilter,
        ),
      ],
    );
  }
}
