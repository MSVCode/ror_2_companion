import 'package:flutter/material.dart';

class CustomGridTile extends StatelessWidget {
  final String path;
  final int id;
  final String name;
  final String imagePath;
  final Color cardColor;

  CustomGridTile(
      {this.path, this.id, this.name, this.imagePath, this.cardColor});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Card(
        shape: cardColor!=null?RoundedRectangleBorder(
          side: new BorderSide(color: cardColor, width: 2.0),
          borderRadius: BorderRadius.circular(4.0),
        ):null,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, path, arguments: id),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Image.asset(
                      imagePath,
                      errorBuilder: (_, __, ___) => Icon(Icons.not_interested),
                    ),
                  ),
                ),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
