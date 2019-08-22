import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtual_store/models/coupon.model.dart';
import 'package:virtual_store/scoped-models/cart.scoped-model.dart';
import 'package:virtual_store/services/helper.service.dart';

class DiscountCard extends StatelessWidget {

  BuildContext context;

  CartScopedModel get cartModel => CartScopedModel.of(context);

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ExpansionTile(
        title: Text(
          'Cupom de desconto',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]
          ),
        ),
        initiallyExpanded: cartModel.couponCode != null,
        
        leading: Icon(Icons.card_giftcard),
        trailing: getRightIcon(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu cupom'
              ),
              initialValue: cartModel.couponCode,
              onFieldSubmitted: (text) {
                if (text != null && text.isNotEmpty) {
                  cartModel.getCoupon(text).then(
                    (coupon) {
                      Fluttertoast.cancel();
                      if (coupon != null) {
                        Fluttertoast.showToast(
                          msg: 'Desconto de ${Helper.decimalFormat(coupon.percent)}% aplicado!',
                          backgroundColor: Colors.green
                        );
                        cartModel.setCoupon(coupon);
                      }
                      else {
                        Fluttertoast.showToast(
                          msg: 'Código do cupom inválido',
                          backgroundColor: Colors.red,
                          toastLength: Toast.LENGTH_LONG
                        );
                        cartModel.unsetCoupon();
                      }
                    },
                    onError: (error) {
                      Fluttertoast.showToast(
                        msg: 'Erro: $error',
                        backgroundColor: Colors.red,
                        toastLength: Toast.LENGTH_LONG
                      );
                      cartModel.unsetCoupon();
                    }
                  );
                }
                else
                  cartModel.unsetCoupon();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget getRightIcon() {
    if (cartModel.isLoadingCoupon)
      return Container(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 3)
      );
    else
      return cartModel.couponCode == null
        ? Icon(Icons.add)
        : Icon(Icons.done, color: Colors.green, size: 30,);
  }
}