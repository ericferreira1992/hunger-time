import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/models/cart-product.model.dart';
import 'package:virtual_store/models/product.model.dart';
import 'package:virtual_store/scoped-models/cart.scoped-model.dart';
import 'package:virtual_store/services/helper.service.dart';

class CartTile extends StatelessWidget {

  CartProduct cartProduct;

  BuildContext context;

  VoidCallback finishedLoad;

  bool forceLoad;

  CartTile(this.cartProduct, {this.forceLoad, this.finishedLoad}) {
    if (forceLoad) {
      cartProduct.product = null;
    }
  }

  Product get product => cartProduct.product;

  CartScopedModel get cartModel => CartScopedModel.of(context);

  Future<DocumentSnapshot> _getCartProductsFuture() {
    return Firestore.instance.collection('menu')
      .document(cartProduct.category)
      .collection('items')
      .document(cartProduct.pid).get();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: cartProduct.product == null
        ? FutureBuilder<DocumentSnapshot>(
          future: _getCartProductsFuture(),
          builder: (context, snapshot) {
            if (snapshot.hasData && cartProduct.product == null) {
              cartProduct.product = Product.fromDocument(snapshot.data);

              if(finishedLoad != null)
                finishedLoad();
            }
            
            if (cartProduct.product != null)
              return _buildConent(context);
            else
              return Container(
                height: 130,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
          },
        )
      : _buildConent(context)
    );
  }

  Widget _buildConent(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 120,
          child: product.images.length > 0
            ? Image.network(
              product.images[0],
              fit: BoxFit.cover,
            )
            : null
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Tamanho: ' + ((cartProduct.size != null && cartProduct.size.isNotEmpty) ? cartProduct.size : 'Único'),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black54
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  Helper.curencyFormat(product.price),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      color: Theme.of(context).primaryColor,
                      onPressed: cartProduct.quantity > 1
                        ? () {
                          cartModel.decCartProduct(cartProduct).then((ok) {});
                        }
                        : null,
                    ),
                    Text(
                      cartProduct.quantity.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        cartModel.incCartProduct(cartProduct).then((ok) {});
                      },
                    ),
                    FlatButton(
                      child: Text('Remover'),
                      textColor: Colors.grey,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Helper.getConfirmDialog(
                              context: context,
                              title: 'Remover',
                              description: 'Você realmente deseja remover este produto do carrinho?',
                              onYes: () {
                                cartModel.removeCartProduct(cartProduct).then((ok) {});
                              }
                            );
                          } 
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}