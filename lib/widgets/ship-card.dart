import 'package:flutter/material.dart';
import 'package:virtual_store/scoped-models/cart.scoped-model.dart';

class ShipCard extends StatelessWidget {

  BuildContext context;

  CartScopedModel get cartModel => CartScopedModel.of(context);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ExpansionTile(
        title: Text(
          'Cacular frete',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]
          ),
        ),
        initiallyExpanded: cartModel.shipZipCode != null,
        leading: Icon(Icons.location_on),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu CEP'
              ),
              initialValue: cartModel.shipZipCode,
              onFieldSubmitted: (text) {
                
              },
            ),
          )
        ],
      ),
    );
  }
}