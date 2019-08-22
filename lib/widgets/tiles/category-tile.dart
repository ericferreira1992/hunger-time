import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:virtual_store/pages/category-page.dart';

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  String get title => snapshot.data['title'];
  String get urlIcon => snapshot.data['urlIcon'];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(15),
      leading: CircleAvatar(
        radius: 25,
        child: SvgPicture.network(urlIcon),
        backgroundColor: Colors.transparent,
      ),
      title: Padding(
        padding: EdgeInsets.only(left: 5),
        child: Text(title, style: TextStyle(fontSize: 18)),
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryPage(snapshot)));
      },
    );
  }
}