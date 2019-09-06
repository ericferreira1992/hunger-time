import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  ShopTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: Image.network(
              snapshot.data['image'],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  snapshot.data['title'],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17
                  ),
                ),
                Text(
                  snapshot.data['address'],
                  textAlign: TextAlign.start,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text('Ver no mapa'),
                  textColor: Colors.blue,
                  onPressed: () {
                    launch('https://google.com/maps/search/?api=1&query=${snapshot.data['lat']},${snapshot.data['long']}');
                  },
                ),
                FlatButton(
                  child: Text('Ligar'),
                  textColor: Colors.blue,
                  onPressed: () {
                    launch('tel:${snapshot.data['phone']}');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}