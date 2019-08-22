import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:virtual_store/scoped-models/user.scoped-model.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Criar conta'),
        centerTitle: true,
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
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nome completo'
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty)
                      return 'Campo obrigatório.';
                    else if (text.split(' ').length <= 1 || text.split(' ').any((s) => s.isEmpty))
                      return 'Informe também o sobrenome';
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'Endereço'
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty)
                      return 'Campo obrigatório.';
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'E-mail'
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text == null || text.isEmpty || !text.contains('@'))
                      return 'E-mail inválido.';
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
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    child: Text(
                      'Entrar',
                      style: TextStyle(fontSize: 18),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        var userData = {
                          'name': _nameController.text,
                          'address': _addressController.text,
                          'email': _emailController.text
                        };

                        model.signUp(userData, _passController.text)
                          .then((ok) {
                            _clearForm();
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Usuário criado com sucesso!'),
                                backgroundColor: Theme.of(context).primaryColor,
                                duration: Duration(seconds: 2),
                              )
                            );
                            Future.delayed(Duration(seconds: 2)).then((_) {
                              Navigator.of(context).pop();
                            });
                          }, onError: (dynamic msg) {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text(msg),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              )
                            );
                          });
                      }
                    },
                  ),
                )
              ],
            ),
          );
        }
      )
    );
  }

  _clearForm() {
    setState(() {
      _passController.clear();
      _emailController.clear();
      _nameController .clear();
      _addressController.clear();
    });
  }
}