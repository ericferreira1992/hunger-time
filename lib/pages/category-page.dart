import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_store/models/product.model.dart';
import 'package:virtual_store/widgets/cart-button.dart';
import 'package:virtual_store/widgets/tiles/product-tile.dart';

class CategoryPage extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryPage(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: CartButton(),
        appBar: AppBar(
          title: Text(snapshot.data['title']),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.list))
            ],
          ),
        ),
        body: FutureBuilder(
          future: Firestore.instance.collection('menu').document(snapshot.documentID).collection('items').getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else {
              var items = snapshot.data.documents as List;
              return TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      childAspectRatio: .65
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = Product.fromDocument(items[index]);
                      item.category = this.snapshot.documentID;
                      return ProductTile('grid', item);
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = Product.fromDocument(items[index]);
                      item.category = this.snapshot.documentID;
                      return ProductTile('list', item);
                    },
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}