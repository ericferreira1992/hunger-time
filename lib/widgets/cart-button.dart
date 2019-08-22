import 'package:flutter/material.dart';
import 'package:virtual_store/pages/cart-page.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.shopping_cart),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));
      },
    );
  }
}