import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/scoped-models/cart.scoped-model.dart';
import 'package:virtual_store/services/helper.service.dart';

class CartPrice extends StatefulWidget {
  VoidCallback onFinishBuy;

  CartPrice({
    Key key,
    this.onFinishBuy,
  }) : super(key: key);

  CartPriceState createState() => CartPriceState();
}

class CartPriceState extends State<CartPrice> {

  CartPriceState();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(16),
        child: ScopedModelDescendant<CartScopedModel>(
          builder: (context, child, cartModel) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Resumo do pedido',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Subtotal'
                    ),
                    Text(
                      Helper.curencyFormat(cartModel.getProductsPrice()),
                      style: TextStyle(fontWeight: cartModel.getProductsPrice() > 0 ? FontWeight.w500 : FontWeight.normal),
                    ),
                  ],
                ),
                Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Desconto',
                    ),
                    Text(
                      cartModel.getDiscountAmount() > 0
                        ? '+ ${Helper.curencyFormat(cartModel.getDiscountAmount())}'
                        : Helper.curencyFormat(0),
                      style: TextStyle(
                        fontWeight: cartModel.getDiscountAmount() > 0 ? FontWeight.w500 : FontWeight.normal,
                        color: cartModel.getDiscountAmount() > 0 ? Colors.green : null,
                      ),
                    ),
                  ],
                ),
                Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Entrega'
                    ),
                    Text(
                      Helper.curencyFormat(cartModel.getShipPrice()),
                      style: TextStyle(fontWeight: cartModel.getShipPrice() > 0 ? FontWeight.w500 : FontWeight.normal),
                    ),
                  ],
                ),
                Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      Helper.curencyFormat(cartModel.getTotalPrice()),
                      style: TextStyle(
                        fontSize: 19,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 46,
                  child: RaisedButton(
                    child: Text(
                      'Finalizar compra',
                      style: TextStyle(fontSize: 18)
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: widget.onFinishBuy,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
