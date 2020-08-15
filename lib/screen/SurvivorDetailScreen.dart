import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ror_2_companion/helper/changeCase.dart';
import 'package:ror_2_companion/model/Survivor.dart';
import 'package:ror_2_companion/model/Unlock.dart';
import 'package:ror_2_companion/provider/DataProvider.dart';
import 'package:ror_2_companion/widget/CustomDetailRow.dart';
import 'package:ror_2_companion/widget/SkillTile.dart';

class SurvivorDetailScreen extends StatelessWidget {
  Widget _buildStatus(BuildContext context, Survivor data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Status",
          style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor * 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 12,
        ),
        CustomDetailRow(
          flexList: [4, 3, 4],
          children: <Widget>[
            Text(
              "Health",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${data.health.toStringAsFixed(0)}"),
            Text("(+${data.addedHealth.toStringAsFixed(0)} per level)")
          ],
        ),
        CustomDetailRow(
          flexList: [4, 3, 4],
          children: <Widget>[
            Text(
              "Regen",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${data.regen.toStringAsFixed(1)}/s"),
            Text("(+${data.addedRegen.toStringAsFixed(1)}/s per level)")
          ],
        ),
        CustomDetailRow(
          flexList: [4, 3, 4],
          children: <Widget>[
            Text(
              "Damage",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${data.damage.toStringAsFixed(0)}"),
            Text("(+${data.addedDamage.toStringAsFixed(0)} per level)")
          ],
        ),
        CustomDetailRow(
          flexList: [4, 7],
          children: <Widget>[
            Text(
              "Speed",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${data.speed.toStringAsFixed(0)} m/s")
          ],
        ),
        CustomDetailRow(
          flexList: [4, 7],
          children: <Widget>[
            Text(
              "Armor",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(data.armor.toStringAsFixed(0))
          ],
        ),
      ],
    );
  }

  Widget _buildSkillSection(
      BuildContext context, Survivor data, SKILL_TYPE skillType) {
    //get skill list
    List<Skill> skillList =
        data.skillList.where((val) => val.skillType == skillType).toList();
    List<Widget> tileList = [];

    for (int i = 0; i < skillList.length; i++) {
      tileList.add(
        SkillTile(
          skill: skillList[i],
          survivorId: data.id,
        ),
      );
    }

    if (tileList.length==0)
      return SizedBox();

    return Column(
      children: <Widget>[
        Divider(height: 40,),
        Text(
          enumToTitle(skillType),
          style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor * 20,
              fontWeight: FontWeight.bold),
        ),
        ...tileList
      ],
    );
  }

  Widget _buildUnlock(BuildContext context, Survivor data) {
    Unlock unlock = DataProvider.of(context).findSurvivorUnlock(data.id);

    if (unlock == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Unlock",
            style: TextStyle(
                fontSize: MediaQuery.of(context).textScaleFactor * 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 12,
          ),
          Text("Available from beginning")
        ],
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Unlock",
          style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor * 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 12,
        ),
        CustomDetailRow(
          flexList: [1, 3],
          children: <Widget>[
            Text(
              "Title",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(unlock.name)
          ],
        ),
        CustomDetailRow(
          flexList: [1, 3],
          children: <Widget>[
            Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(unlock.description)
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (_, model, __) {
        Survivor data =
            model.findSurvivorById(ModalRoute.of(context).settings.arguments);

        return Scaffold(
          appBar: AppBar(
            title: Text(data.name),
          ),
          body: Container(
            padding: EdgeInsets.all(12),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(12),
                  height: MediaQuery.of(context).size.height / 4,
                  child: Image.asset(
                    "asset/gameAsset/survivor/${data.id}.png",
                    errorBuilder: (_, __, ___) => Icon(Icons.not_interested),
                  ),
                ),
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).textScaleFactor * 24,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  data.description,
                ),
                Divider(height: 40),
                _buildStatus(context, data),
                _buildSkillSection(context, data, SKILL_TYPE.PASSIVE),
                _buildSkillSection(context, data, SKILL_TYPE.PRIMARY),
                _buildSkillSection(context, data, SKILL_TYPE.SECONDARY),
                _buildSkillSection(context, data, SKILL_TYPE.UTILITY),
                _buildSkillSection(context, data, SKILL_TYPE.SPECIAL),
                _buildSkillSection(context, data, SKILL_TYPE.BEACON),
                Divider(height: 40),
                _buildUnlock(context, data),
              ],
            ),
          ),
        );
      },
    );
  }
}
