import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ror_2_companion/helper/changeCase.dart';
import 'package:ror_2_companion/model/Item.dart';
import 'package:ror_2_companion/model/Unlock.dart';
import 'package:ror_2_companion/provider/DataProvider.dart';
import 'package:ror_2_companion/widget/CustomDetailRow.dart';
import 'package:ror_2_companion/widget/RenderRarity.dart';
import 'package:ror_2_companion/widget/StackSimulatorDialog.dart';

class ItemDetailScreen extends StatelessWidget {
  Widget _buildMeta(BuildContext context, Item data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Meta",
          style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor * 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 12,
        ),
        CustomDetailRow(
          flexList: [4, 7],
          children: <Widget>[
            Text(
              "ID",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(data.id >= 10000 ? "?" : data.id.toString())
          ],
        ),
        CustomDetailRow(
          flexList: [4, 7],
          children: <Widget>[
            Text(
              "Rarity",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RenderRarity(data.rarity)
          ],
        ),
        CustomDetailRow(
          flexList: [4, 7],
          children: <Widget>[
            Text(
              "Category",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(data.itemCategory.map((val) => enumToTitle(val)).join(", "))
          ],
        ),
      ],
    );
  }

  Widget _buildSimulateStack(BuildContext context, Item data) {
    //skip for equipment
    if (data.itemCategory.contains(ITEM_CATEGORY.EQUIPMENT)) return SizedBox();

    return RaisedButton(
      child: Text("Simulate Stack"),
      onPressed: () => showDialog(
        context: context,
        builder: (_) => StackSimulatorDialog(
          statusList: data.statusList,
        ),
      ),
    );
  }

  Widget _buildStatus(BuildContext context, Item data) {
    List<Widget> statList = [];

    for (int i = 0; i < data.statusList.length; i++) {
      var stat = data.statusList[i];
      statList.add(
        CustomDetailRow(
          flexList: [4, 2, 3, 2],
          children: <Widget>[
            Text(stat.type),
            Text(stat.initialAmount),
            Text(enumToTitle(stat.stackType)),
            Text(stat.addedAmount)
          ],
        ),
      );
    }
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
          flexList: [4, 2, 3, 2],
          children: <Widget>[
            Text(
              "Type",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Initial",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Stack",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Added",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
        ...statList,
        SizedBox(
          height: 16,
        ),
        _buildSimulateStack(context, data)
      ],
    );
  }

  Widget _buildUnlock(BuildContext context, Item data) {
    Unlock unlock = DataProvider.of(context).findItemUnlock(data.id);

    if (unlock == null) return Column(
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

  Widget _buildLore(BuildContext context, Item data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Lore",
          style: TextStyle(
              fontSize: MediaQuery.of(context).textScaleFactor * 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 12,
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.blueGrey[800],
              borderRadius: BorderRadius.circular(4)),
          child: Text(data.lore ?? "No Lore", style: TextStyle(color: Colors.blueGrey[200]),),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (_, model, __) {
        Item data =
            model.findItemById(ModalRoute.of(context).settings.arguments);

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
                    "asset/gameAsset/item/${data.id}.png",
                    errorBuilder: (_, __, ___) => Icon(Icons.not_interested),
                  ),
                ),
                Text(
                  data.description,
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
                  data.detail,
                ),
                Divider(height: 40),
                _buildMeta(context, data),
                Divider(height: 40),
                _buildStatus(context, data),
                Divider(height: 40),
                _buildUnlock(context, data),
                Divider(height: 40),
                _buildLore(context, data)
              ],
            ),
          ),
        );
      },
    );
  }
}
