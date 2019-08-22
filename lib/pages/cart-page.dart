import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/pages/login_page.dart';
import 'package:virtual_store/scoped-models/cart.scoped-model.dart';
import 'package:virtual_store/scoped-models/user.scoped-model.dart';
import 'package:virtual_store/services/helper.service.dart';
import 'package:virtual_store/widgets/cart-price.dart';
import 'package:virtual_store/widgets/discount-card.dart';
import 'package:virtual_store/widgets/ship-card.dart';
import 'package:virtual_store/widgets/tiles/cart-tile.dart';

import 'order-finished-page.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _cartPriceKey = GlobalKey<CartPriceState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  UserScopedModel get userModel => UserScopedModel.of(context);
  CartScopedModel get cartModel => CartScopedModel.of(context);

  bool _alreadyLoadProducts = false;

  _CartPageState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Meu carrinho'),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 10),
            child: ScopedModelDescendant<CartScopedModel>(
              builder: (context, build, cartModel) {
                int p = cartModel.products.length;
                return Text((userModel.isLoading || cartModel.isLoading) ? '' : '$p ${p == 1 ? 'ITEM' : 'ITENS'}');
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartScopedModel>(
        builder: (context, child, cartModel) {
          if (cartModel.isLoading || userModel.isLoading)
            return Center(child: CircularProgressIndicator());
          else if(!userModel.isLoggedIn())
            return Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    color: Theme.of(context).primaryColor,
                    size: 80,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Faça o login para adicionar prdutos',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
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
          else if (cartModel.products == null || cartModel.products.length == 0)
            return Container(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.fastfood,
                    color: Theme.of(context).primaryColor,
                    size: 80,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Nenhum produto\nno carrinho.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400
                    )
                  )
                ],
              )
            );

          return ListView(
            padding: EdgeInsets.symmetric(vertical: 10),
            children: <Widget>[
              Column(
                children: cartModel.products.map((cartProduct) => CartTile(
                  cartProduct,
                  forceLoad: !_alreadyLoadProducts,
                  finishedLoad: () {
                    if (cartModel.allCartProductHasInfo()) {
                      _alreadyLoadProducts = true;
                      cartModel.notifyListeners();
                    }
                  }
                )).toList()
              ),
              DiscountCard(),
              ShipCard(),
              CartPrice(onFinishBuy: () async {
                if (cartModel.products.length > 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Helper.getConfirmDialog(
                        context: context,
                        title: 'Finalizar pedido',
                        description: 'Deseja realmente finalizar seu pedido?',
                        onYes: () {
                          cartModel.finishOrder().then(
                            (orderId) {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => OrderFinishedPage(orderId.toUpperCase())));
                              Timer(Duration(milliseconds: 500), () => cartModel.isLoading = false);
                            },
                            onError: (error) {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(error),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                )
                              );
                            }
                          ); 
                        }
                      );
                    }
                  );
                }
              }),
            ],
          );
        },
      ),
    );
  }
}