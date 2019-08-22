import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/models/cart-product.model.dart';
import 'package:virtual_store/models/product.model.dart';
import 'package:virtual_store/pages/cart-page.dart';
import 'package:virtual_store/scoped-models/cart.scoped-model.dart';
import 'package:virtual_store/scoped-models/user.scoped-model.dart';
import 'package:virtual_store/widgets/cart-button.dart';

import 'login_page.dart';

class ProductPage extends StatefulWidget {

  final Product product;

  ProductPage(this.product);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  BuildContext context;

  Product get product => widget.product;

  Color get color => Theme.of(context).primaryColor;

  String sizeSelected;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  UserScopedModel get userModel => UserScopedModel.of(context);
  CartScopedModel get cartModel => CartScopedModel.of(context);

  bool __isLoading = false;

  get _isLoading => __isLoading;
  set _isLoading(bool value) {
    setState(() {
      __isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: CartButton(),
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .9,
              child: Carousel(
                images: product.images.map((imgUrl) => NetworkImage(imgUrl)).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: color,
                autoplay: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),
                    maxLines: 3
                  ),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color
                    )
                  ),
                  ...(this.product.sizes.length > 0 
                    ? ([
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text('Tamanho', style: TextStyle(fontWeight: FontWeight.w500))
                        ),
                        SizedBox(
                          height: 34,
                          child: GridView(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 8,
                              childAspectRatio: .5
                            ),
                            children: product.sizes.map((size) => InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(4)),
                                  border: Border.all(
                                    color: size == sizeSelected ? color : Colors.grey[500],
                                    width: 3
                                  )
                                ),
                                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                                alignment: Alignment.center,
                                child: Text(size),
                              ),
                              onTap: () {
                                setState(() {
                                  sizeSelected = size;
                                });
                              },
                            )).toList(),
                          ),
                        )
                      ])
                    : []),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        onPressed: (product.sizes.length == 0 || sizeSelected != null) 
                          ? () {
                            if (userModel.isLoggedIn()) {
                              var cartProduct = CartProduct();
                              cartProduct.size = sizeSelected;
                              cartProduct.quantity = 1;
                              cartProduct.pid = product.id;
                              cartProduct.category = product.category;

                              _isLoading = true;
                              cartModel.addCartProduct(cartProduct).then(
                                (ok) {
                                  cartProduct.product = product;
                                  _isLoading = false;
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartPage()));
                                },
                                onError: (dynamic msg) {
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(msg),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    )
                                  );
                                  _isLoading = false;
                                }
                              );
                            }
                            else
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                          }
                          : null,
                        child: Text(
                          userModel.isLoggedIn() ? 'Adicionar ao carrinho' : 'Entre para comprar',
                          style: TextStyle(fontSize: 18)
                        ),
                        color: color,
                        textColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Descrição',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)
                    ),
                    SizedBox(height: 5),
                    Text(
                      product.description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 15, color: Colors.black.withAlpha(210))
                    ),
                ],
              ),
            )
          ],
        ),
    );
  }
}