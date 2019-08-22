import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String category;
  String title;
  String description;
  double price;
  List<String> images;
  List<String> sizes;

  Product.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data['title'];
    description = snapshot.data['description'];
    price = snapshot.data['price'] as double;
    images = (snapshot.data['images'] as List<dynamic>).map((img) => img.toString()).toList();
    sizes = (snapshot.data['sizes'] as List<dynamic>).map((size) => size.toString()).toList();
  }

  Map<String, dynamic> toResumeMap() {
    return {
      'title': title, 
      'description': description, 
      'price': price, 
    };
  }
}