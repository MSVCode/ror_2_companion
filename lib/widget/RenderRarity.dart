import 'package:flutter/material.dart';
import 'package:ror_2_companion/helper/changeCase.dart';
import 'package:ror_2_companion/model/Item.dart';

class RenderRarity extends StatelessWidget {
  final RARITY rarity;

  RenderRarity(this.rarity);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (rarity) {
      case RARITY.COMMON:
        color = Colors.white;
        break;
      case RARITY.UNCOMMON:
        color = Colors.green;
        break;
      case RARITY.LEGENDARY:
        color = Colors.red;
        break;
      case RARITY.BOSS:
        color = Colors.yellow;
        break;
      case RARITY.EQUIPMENT:
        color = Colors.orange;
        break;
      case RARITY.LUNAR:
        color = Colors.blue;
        break;
    }
    return Text(
      enumToTitle(rarity),
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }
}
