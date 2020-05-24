import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ror_2_companion/provider/DataProvider.dart';
import 'package:ror_2_companion/provider/SettingProvider.dart';
import 'package:ror_2_companion/widget/CustomGridTile.dart';

class SurvivorListScreen extends StatefulWidget {
  @override
  _SurvivorListScreenState createState() => _SurvivorListScreenState();
}

class _SurvivorListScreenState extends State<SurvivorListScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState(){
    super.initState();

    _searchController.text = DataProvider.of(context).lastSurvivorQuery;
  }

  Widget _buildSurvivorGrid(BuildContext ctx, int index) {
    var prov = DataProvider.of(context);
    var data = prov.filteredSurvivorList[index];

    return CustomGridTile(
      id: data.id,
      imagePath: "asset/gameAsset/survivor/${data.id}.png",
      name: data.name,
      path: "/survivor",
    );
  }

  void _onSearch(String text) {
    DataProvider.of(context).filterSurvivor(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Consumer<DataProvider>(
        builder: (_, dataModel, __) {
          return Column(
            children: <Widget>[
              Container(
                // height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(6),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Search",
                    suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.text = "";
                          _onSearch("");
                        }),
                  ),
                  controller: _searchController,
                  onChanged: _onSearch,
                  onSubmitted: _onSearch,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Expanded(
                child: Consumer<SettingProvider>(
                  builder: (_, settingModel, __) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: settingModel.gridCount),
                      itemBuilder: _buildSurvivorGrid,
                      itemCount: dataModel.filteredSurvivorList.length,
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
