import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/scoped-models/cart.scoped-model.dart';
import 'package:virtual_store/scoped-models/user.scoped-model.dart';
import 'package:virtual_store/widgets/tiles/order-tile.dart';

import 'login_page.dart';

class OrdersTab extends StatelessWidget {

  BuildContext context;

  CartScopedModel get cartModel => CartScopedModel.of(context);
  UserScopedModel get userModel => UserScopedModel.of(context);

  OrdersTab();

  @override
  Widget build(BuildContext context) {
    this.context = context;

    if (userModel.isLoggedIn()) {
      var uid = userModel.firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection('users').document(uid).collection('orders').getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data.documents.map((doc) => OrderTile()).toList(),
          );
        },
      );
    }
    else
      return _getNoAuthenticatedPage();
  }

  Widget _getNoAuthenticatedPage() {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            Icons.assignment,
            color: Theme.of(context).primaryColor,
            size: 80,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              'Faça o login para visualizar seus pedidos.',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black54,
                fontWeight: FontWeight.w500
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 44,
            child: RaisedButton(
              child: Text('Entrar', style: TextStyle(fontSize: 18)),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          )
        ],
      ),
    );
  }
}