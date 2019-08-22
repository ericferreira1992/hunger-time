import 'package:flutter/material.dart';
import 'package:virtual_store/models/product.model.dart';
import 'package:virtual_store/pages/product-page.dart';

class ProductTile extends StatelessWidget {

  final String type;
  final Product product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Stack(
          children: <Widget>[
            type == 'grid'
                ? _getGridWidget(context)
                : _getListWidget(context),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  highlightColor: Colors.grey.withAlpha(30),
                  splashColor: Colors.grey.withAlpha(50),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductPage(this.product)));
                  },
                )
              ),
            )
          ],
        )
      );
  }

  Widget _getGridWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: .85,
          child: Image.network(
            product.images.first,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                product.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
              Text(
                'R\$' + product.price.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _getListWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Image.network(
            product.images.first,
            fit: BoxFit.cover,
            height: 210,
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  'R\$' + product.price.toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}