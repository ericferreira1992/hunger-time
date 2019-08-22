import 'package:flutter/material.dart';
import 'package:virtual_store/tabs/tab-menu.dart';
import 'package:virtual_store/tabs/tab-home.dart';
import 'package:virtual_store/widgets/cart-button.dart';
import 'package:virtual_store/widgets/custom-drawer.dart';

import 'order-tab.dart';
import 'shops-tab.dart';

class HomePage extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Cardápio'),
            centerTitle: true
          ),
          floatingActionButton: CartButton(),
          drawer: CustomDrawer(_pageController),
          body: MenuTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Lojas'),
            centerTitle: true
          ),
          drawer: CustomDrawer(_pageController),
          body: ShopsTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Pedidos'),
            centerTitle: true
          ),
          drawer: CustomDrawer(_pageController),
          body: OrdersTab(),
        )
      ],
    );
  }
}
