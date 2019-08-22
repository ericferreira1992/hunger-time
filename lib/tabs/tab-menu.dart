import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/widgets/tiles/category-tile.dart';

class MenuTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('menu').getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else {
          var dividedTile = ListTile.divideTiles(
            tiles: snapshot.data.documents.map((doc) => CategoryTile(doc)).toList(),
            color: Colors.grey
          ).toList();

          return ListView(
            children: dividedTile,
          );
        }
      },
    );
  }
}