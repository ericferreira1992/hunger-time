import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'pages/home-page.dart';
import 'scoped-models/cart.scoped-model.dart';
import 'scoped-models/user.scoped-model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ScopedModel<UserScopedModel>(
      model: UserScopedModel(),
      child: ScopedModelDescendant<UserScopedModel>(
        builder: (context, child, userModel) {
          return ScopedModel<CartScopedModel>(
            model: CartScopedModel(userModel),
            child: MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.indigo,
                primaryColor: Colors.indigo,
                splashColor: Colors.indigo[100]
              ),
              debugShowCheckedModeBanner: false,
              home: HomePage(),
            )
          );
        },
      )
    )
  );
}
