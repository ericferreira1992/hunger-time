import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/widgets/tiles/shop-tile.dart';

class ShopsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection('shops').getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        
        return ListView(
          children: snapshot.data.documents.map((doc) => ShopTile(doc)).toList().reversed.toList(),
        );
      },
    );
  }
}