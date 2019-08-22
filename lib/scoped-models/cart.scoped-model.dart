import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/models/cart-product.model.dart';
import 'package:virtual_store/models/coupon.model.dart';
import 'package:virtual_store/scoped-models/user.scoped-model.dart';

class CartScopedModel extends Model {

  UserScopedModel userModel;
  
  List<CartProduct> products = [];

  String couponCode;
  double discountPercentage = 0;

  String shipZipCode;
  double shipPrice = 0;

  bool _isLoading = false;

  get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isLoadingCoupon = false;

  get isLoadingCoupon => _isLoadingCoupon;
  set isLoadingCoupon(bool value) {
    _isLoadingCoupon = value;
    notifyListeners();
  }

  CartScopedModel(this.userModel);

  static CartScopedModel of(BuildContext context) => ScopedModel.of<CartScopedModel>(context);

  @override
  void addListener(VoidCallback listener){
    super.addListener(listener);

    if (userModel.hasAllUserData())
      _checkCartProducts();
    
    userModel.userSubject.listen((logged) {
      if(userModel.hasAllUserData())
        _checkCartProducts();
    });
  }

  bool someCartProductWithoutInfo() {
    return products.any((p) => p.product == null);
  }

  bool allCartProductHasInfo() {
    return products.every((p) => p.product != null);
  }

  Future<Null> _checkCartProducts() async {
    return Future<Null>(() async {
      isLoading = true;
      try {
        var doc = await Firestore.instance.collection('users')
          .document(userModel.firebaseUser.uid)
          .collection('cart')
          .getDocuments();

        products = doc.documents.map((d) => CartProduct.fromDocument(d)).toList();
        isLoading = false;
      }
      catch (e) {
        isLoading = false;
        return Future.error(e.message);
      }
    });
  }

  Future<CartProduct> getCartProduct(String productId) async {
    return Future<CartProduct>(() async {
      try {
        var snapshot = await Firestore.instance.collection('users')
          .document(userModel.firebaseUser.uid)
          .collection('cart')
          .where('pid', isEqualTo: productId)
          .getDocuments();

        if (snapshot.documents.length > 0)
          return CartProduct.fromDocument(snapshot.documents.first);
        else
          return null;
      }
      catch (e) {
        return Future.error(e.message);
      }
    });
  }

  Future<CartProduct> addCartProduct(CartProduct cartProduct) async {
    return Future<CartProduct>(() async {
      var cartProductExisting = products.any((p) => p.pid == cartProduct.pid) ? products.firstWhere((p) => p.pid == cartProduct.pid) : null;
      try {
        isLoading = true;
        if (cartProductExisting == null) {
          var doc = await Firestore.instance.collection('users')
            .document(userModel.firebaseUser.uid)
            .collection('cart')
            .add(cartProduct.toMap());

          cartProduct.cid = doc.documentID;
          products.add(cartProduct);
        }
        else {
          cartProductExisting.quantity++;
          await Firestore.instance.collection('users')
            .document(userModel.firebaseUser.uid)
            .collection('cart')
            .document(cartProductExisting.cid)
            .updateData(cartProductExisting.toMap());
        }

        if (cartProductExisting == null)
          return cartProduct;
        else
          return cartProductExisting;
      }
      catch (e) {
        if (cartProductExisting != null)
          cartProductExisting.quantity--;
        return Future.error(e.message);
      }
      finally {
        isLoading = false;
      }
    });
  }
  
  Future<bool> removeCartProduct(CartProduct cartProduct) {
    return Future<bool>(() async {
      isLoading = true;
      try {
        await Firestore.instance.collection('users')
          .document(userModel.firebaseUser.uid)
          .collection('cart')
          .document(cartProduct.cid)
          .delete();

        products.remove(cartProduct);
        isLoading = false;
        return true;
      }
      catch (e) {
        isLoading = false;
        return Future.error(e.message);
      }
    });
  }
  
  Future<Null> incCartProduct(CartProduct cartProduct) {
    return Future<Null>(() async {
      try {
        cartProduct.quantity++;
        await Firestore.instance.collection('users')
          .document(userModel.firebaseUser.uid)
          .collection('cart')
          .document(cartProduct.cid)
          .updateData(cartProduct.toMap());

        notifyListeners();
      }
      catch (e) {
        notifyListeners();
        cartProduct.quantity--;
        return Future.error(e.message);
      }
    });
  }
  
  Future<Null> decCartProduct(CartProduct cartProduct) {
    return Future<Null>(() async {
      try {
        cartProduct.quantity--;
        await Firestore.instance.collection('users')
          .document(userModel.firebaseUser.uid)
          .collection('cart')
          .document(cartProduct.cid)
          .updateData(cartProduct.toMap());

        notifyListeners();
      }
      catch (e) {
        notifyListeners();
        cartProduct.quantity++;
        return Future.error(e.message);
      }
    });
  }

  Future<Coupon> getCoupon(String coupon) async {
    isLoadingCoupon = true;
    return Future<Coupon>(() async {
      try {
        var snapshot = await Firestore.instance.collection('coupons').document(coupon).get();

        isLoadingCoupon = false;
        return (snapshot.data != null) ? Coupon.fromDocument(snapshot) : null;
      }
      catch (e) {
        isLoadingCoupon = false;
        return Future.error(e.stackTrace.toString());
      }
    });
  }

  void setCoupon(Coupon coupon) async {
    if (discountPercentage != coupon.percent || couponCode != coupon.id) {
      discountPercentage = coupon.percent;
      couponCode = coupon.id;
      notifyListeners();
    }
  }

  void unsetCoupon() async {
    if (discountPercentage != 0 || couponCode != null) {
      discountPercentage = 0;
      couponCode = null;
      notifyListeners();
    }
  }

  double getProductsPrice() {
    if (products.length > 0)
      return products.map<double>((p) => (p.product != null) ? (p.product.price * p.quantity) : 0)
        .reduce((curr, next) => (next ?? 0) + (curr ?? 0));
    return 0;
  }

  double getDiscountAmount() {
    if (discountPercentage > 0) {
      var total = getProductsPrice();
      return double.parse(((discountPercentage / 100) * total).toStringAsFixed(2));
    }
    else
      return 0;
  }

  double getShipPrice() {
    return 0;
  }

  double getTotalPrice() {
    var amount = getProductsPrice() - getDiscountAmount() + getShipPrice();
    return amount > 0 ? amount : 0;
  }

  Future<String> finishOrder() async {
    return Future<String>(() async {
      try {
        isLoading = true;

        if (products.length > 0) {
          var productsPrice = getProductsPrice();
          var shipPrice = getShipPrice();
          var discount = getDiscountAmount();
          var totalPrice = getTotalPrice();

          var refOrder = await Firestore.instance.collection('orders').add({
            'clientId': userModel.firebaseUser.uid,
            'products': products.map((cp) => cp.toMap(withProduct: false)).toList(),
            'productsPrice': productsPrice,
            'shipPrice': shipPrice,
            'discount': discount,
            'totalPrice': totalPrice,
            'status': 1
          });

          await Firestore.instance.collection('users')
            .document(userModel.firebaseUser.uid)
            .collection('orders')
            .document(refOrder.documentID)
            .setData({ 'orderData': refOrder.documentID });
          
          var query = await Firestore.instance.collection('users')
            .document(userModel.firebaseUser.uid)
            .collection('cart')
            .getDocuments();

          for(var doc in query.documents)
            await doc.reference.delete();

          products.clear();
          discount = 0;
          couponCode = null;
          shipPrice = 0;
          shipZipCode = null;

          return refOrder.documentID;
        }
        else
          throw Exception('Não há produtos no carrinho.');
      }
      catch (e) {
        isLoading = false;
        if (e is PlatformException)
          return Future.error(e.message);
        else
          return Future.error('Ocorreu um erro durante o processo.');
      }
    });
  }
  
}
