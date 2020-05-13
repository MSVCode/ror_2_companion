import 'package:flutter/material.dart';

class CustomDetailRow extends StatelessWidget {
  final List<Widget> children;
  final List<int> flexList;

  CustomDetailRow({this.children, this.flexList});

  List<Widget> _buildRow(){
    List<Widget> list = [];
    for(int i=0;i<children.length;i++){
      int flex = flexList!=null&&flexList.length>i?flexList[i]:1;

      list.add(Expanded(child: children[i], flex: flex,));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: _buildRow(),
      ),
    );
  }
}
