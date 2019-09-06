import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/services/helper.service.dart';

class OrderTile extends StatelessWidget {

  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('orders').document(orderId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            int status = snapshot.data['status'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Código do pedido: ${snapshot.data.documentID}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  _buildProductsTet(snapshot.data)
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      _buildCircle('1', 'Preparação', status, 1),
                      Expanded(child: Container(height: 1, color: Colors.grey[500],)),
                      _buildCircle('2', 'Transporte', status, 2),
                      Expanded(child: Container(height: 1, color: Colors.grey[500],)),
                      _buildCircle('3', 'Entregue', status, 3)
                    ],
                  ),
                )
              ],
            );
          },
        )
      ),
    );
  }

  String _buildProductsTet(DocumentSnapshot snapshot) {
    var text = 'Descrição\n';

    for(LinkedHashMap p in snapshot.data['products']) {
      var quantity = p['quantity'];
      var name = p['product']['title'];
      var price = Helper.curencyFormat(p['product']['price']);
      text += '$quantity x $name ($price)\n';
    }

    var total = Helper.curencyFormat(snapshot.data['totalPrice']);
    text += 'Total: $total';

    return text;
  }

  Widget _buildCircle(String title, String subtitle, int status, int thisStatus) {
    Color bgColor;
    Widget child;

    if (status < thisStatus) {
      bgColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white));
    }
    else if (status == thisStatus) {
      bgColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white)),
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
        ],
      );
    }
    else {
      bgColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundColor: bgColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }
}