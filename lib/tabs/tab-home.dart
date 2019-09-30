import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {

  Widget _buildBodyBack() => Container(
    decoration: BoxDecoration(
      color: Colors.white
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(decoration: BoxDecoration(color: Colors.white)),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Novidades'),
                centerTitle: true,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(5),
              sliver: FutureBuilder<QuerySnapshot>(
                future: Firestore.instance.collection('home').orderBy('pos').getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return SliverToBoxAdapter(
                      child: Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                          )
                      ),
                    );
                  else {
                    var docs = snapshot.data.documents;
                    return SliverStaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      staggeredTiles: docs.map((doc) => StaggeredTile.count(doc.data['x'], doc.data['y'])).toList(),
                      children: docs.map((doc) => Card(
                        child: Stack(
                          children: <Widget>[
                            Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                            InkWell(
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: doc.data['image'],
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                              onTap: () {

                              },
                            )
                          ],
                        ),
                      )).toList()
                    );
                  }
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
