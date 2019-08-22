import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';

class UserScopedModel extends Model {
  var _auth = FirebaseAuth.instance;
  
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  final BehaviorSubject<bool> _userSubject = BehaviorSubject<bool>();

  bool _isLoading = false;

  get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  BehaviorSubject<bool> get userSubject => _userSubject;

  UserScopedModel() {
    _userSubject.add(false);
  }

  static UserScopedModel of(BuildContext context) => ScopedModel.of<UserScopedModel>(context);


  @override
  void addListener(VoidCallback listener){
    super.addListener(listener);
    _loadCurrentUser();
  }

  Future<String> signUp(Map<String, dynamic> userData, String pass) async {
    return Future<String>(() async {
      isLoading = true;

      try {
        var user = await _auth.createUserWithEmailAndPassword(
          email: userData['email'],
          password: pass,
        );

        firebaseUser = user;

        await _saveUserData(userData);

        isLoading = false;
      }
      catch (e) {
        isLoading = false;
        return Future.error(e.message);
      }
      return null;
    });
  }

  Future<Null> signIn(String email, String pass) {
    return Future<Null>(() async {
      isLoading = true;

      try {
        var user = await _auth.signInWithEmailAndPassword(email: email, password: pass);
        firebaseUser = user;
        await _loadCurrentUser();

        isLoading = false;
      }
      catch (e) {
        isLoading = false;
        if (e is PlatformException)
          return Future.error(e.message);
        else{
          print(e.stackTrace);
          return Future.error('Ocorreu um erro durante o processo.');
        }
      }
    });
  }

  Future<bool> signOut() async {
    return Future<bool>(() async {
      isLoading = true;

      try {
        await _auth.signOut();

        firebaseUser = null;
        userData = null;

        userSubject.sink.add(false);

        isLoading = false;
        return true;
      }
      catch (e) {
        isLoading = false;
        return Future.error(e.message);
      }
    });

  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection('users').document(firebaseUser.uid).setData(userData);
  }

  Future<void> _loadCurrentUser() async {
    if (firebaseUser == null)
      firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData == null || userData['name'] == null) {
        var docUser = await Firestore.instance.collection('users').document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    userSubject.sink.add(true);
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }

  bool hasAllUserData() {
    return isLoggedIn() && userData != null;
  }

  Future<bool> recoverPass(String email) {
    return Future<bool>(() async {
      isLoading = true;

      try {
        await _auth.sendPasswordResetEmail(email: email);
        isLoading = false;
        return true;
      }
      catch (e) {
        isLoading = false;
        return Future.error(e.message);
      }
    });
  }
}
