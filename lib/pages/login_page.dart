import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/pages/signup-page.dart';
import 'package:virtual_store/scoped-models/user.scoped-model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  UserScopedModel get _userModel => UserScopedModel.of(context);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(!_userModel.isLoading),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Entrar'),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                'CRIAR CONTA',
                style: TextStyle(fontSize: 15),
              ),
              textColor: Colors.white,
              onPressed: () {
                if (!_userModel.isLoading)
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignupPage()));
              },
            )
          ],
        ),
        body: ScopedModelDescendant<UserScopedModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(child: CircularProgressIndicator());

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'E-mail'
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text == null || text.isEmpty || !text.contains('@'))
                        return 'E-mail inválido.';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                      hintText: 'Senha'
                    ),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: (text) {
                      if (text == null || text.isEmpty || text.length < 6)
                        return 'Senha invalida. Deve conter pelo menos 8 dígitos.';
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        if (_emailController?.text?.isEmpty)
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Insira seu email para recuperacao'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            )
                          );
                        else {
                          model.recoverPass(_emailController.text).then(
                            (ok) {
                              _clearForm();
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Um e-mail foi enviado ao usuário.'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                )
                              );
                            },
                            onError: (msg) {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(msg),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                )
                              );
                            }
                          );
                        }
                      },
                      child: Text('Esqueci minha senha', textAlign: TextAlign.right),
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 44,
                    child: RaisedButton(
                      child: Text(
                        'Enviar',
                        style: TextStyle(fontSize: 18),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) { 
                          var email = _emailController.text;
                          var pass = _passController.text;
                          
                          model.signIn(email, pass).then(
                            (ok) {
                              _clearForm();

                              Fluttertoast.showToast(
                              msg: 'Seja bem-vindo!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Theme.of(context).primaryColor
                              );
                              Navigator.of(context).pop();
                            },
                            onError: (dynamic msg) {
                              Fluttertoast.showToast(
                              msg: msg.toString(),
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.red,
                              );
                            }
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        )
      )
    );
  }

  _clearForm() {
    setState(() {
      _passController.clear();
      _emailController.clear();
    });
  }
}