import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication with ChangeNotifier {
  //This local database connection
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //Here we make the Firebase Firestore connection
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference nm = FirebaseFirestore.instance.collection('Login');
  CollectionReference sp = FirebaseFirestore.instance.collection('SignUp');

  login(String email, String password) async {
    try {
      //The information of the person logging into the application is added to the Firestore
      await  nm.add({'mail':'$email'});
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  signUp(String name, String email, String password) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        //The information of a new registered user in the system is added to the Firestore SignUp section and the user logs in directly.
        await  sp.add({'name':'$name','mail':'$email'});
        await _auth.currentUser.updateDisplayName(name);
      }
    } catch (e) {
      throw e;
    }
  }

  signOut() async {
    try {
      //Used to log out of user login
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      throw error;
    }
  }
//This function works if the user wants to change his/her name.
  changeName(String newName, BuildContext context) async {
    try {
      if (newName.isNotEmpty) {
        await _auth.currentUser.updateDisplayName(newName);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Name updated")));
      }
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }
//This function is written to give an error message if an error occurs
  showError(String errormessage, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ERROR'),
          content: Text(errormessage),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'))
          ],
        );
      },
    );
  }
}
