import 'package:flutter/material.dart';
import 'package:ror_2_companion/model/Survivor.dart';
import 'package:ror_2_companion/model/Unlock.dart';
import 'package:ror_2_companion/provider/DataProvider.dart';
import 'package:ror_2_companion/widget/CustomDetailRow.dart';

class SkillTile extends StatelessWidget {
  final int survivorId;
  final Skill skill;

  SkillTile({this.survivorId, this.skill});

  ///Beautify skill status section
  Widget _buildStatusSection(String title, String value) {
    return CustomDetailRow(
      flexList: [1, 2],
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          value,
        )
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 2,
          ),
          Text(skill.description)
        ],
      ),
    );
  }

  ///Some skill have multiple proc coefficient
  Widget _buildProcCoef() {
    List<String> output = [];

    for (int i = 0; i < skill.procList.length; i++) {
      if (skill.procList[i].name != null) {
        output.add("${skill.procList[i].name}: ${skill.procList[i].procCoef}");
      } else {
        output.add("${skill.procList[i].procCoef}");
      }
    }

    if (output.length == 0) return SizedBox();

    return _buildStatusSection("Proc Coef", output.join("\n"));
  }

  ///Specific note
  Widget _buildNote() {
    //ListTile(leading: Text("\u2022"), title: Text(val),)
    if (skill.noteList.length==0)
      return SizedBox();

    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            Divider(),
          Text(
            "Notes",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...skill.noteList
              .map((val) => CustomDetailRow(
                    flexList: [1, 20],
                    children: <Widget>[Text("\u2022"), Text(val)],
                  ))
              .toList()
        ],
      ),
    );
  }

  ///Conditionally build unlock. If available from start skipped to reduce UI clutter
  Widget _buildUnlock(BuildContext context) {
    Unlock unlock = DataProvider.of(context).findSkillUnlock(survivorId, skill.skillType, skill.variant);

    if (unlock == null) return SizedBox();

    return Container(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Divider(height: 20,),
          CustomDetailRow(
            flexList: [2, 5],
            children: <Widget>[
              Text(
                "Skill Unlock",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(unlock.name)
            ],
          ),
          CustomDetailRow(
            flexList: [2, 5],
            children: <Widget>[
              Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(unlock.description)
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String imagePath =
        "asset/gameAsset/skill/$survivorId-${skill.skillType.index}-${skill.variant}.png";

    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(top: 4, right: 12, bottom: 4, left: 2),
                  height: MediaQuery.of(context).size.width / 5,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Image.asset(
                    imagePath,
                    errorBuilder: (_, __, ___) => Icon(Icons.not_interested),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildStatusSection("Name", skill.name),
                      skill.damage != null
                          ? _buildStatusSection("Damage",
                              "${(skill.damage * 100).toStringAsFixed(0)}%")
                          : SizedBox(),
                      skill.cooldown != null
                          ? _buildStatusSection("Cooldown",
                              "${skill.cooldown.toStringAsFixed(0)}s")
                          : SizedBox(),
                      _buildProcCoef(),
                      _buildDescription(),
                    ],
                  ),
                )
              ],
            ),
            _buildNote(),
            _buildUnlock(context)
          ],
        ),
      ),
    );
  }
}
