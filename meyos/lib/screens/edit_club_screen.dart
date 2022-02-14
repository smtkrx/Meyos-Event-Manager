import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_manager/samples/group.dart';
import 'package:event_manager/vendors/database_helper.dart';
import 'package:event_manager/vendors/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

//To create new club title and properties
class EditclubScreen extends StatefulWidget {
  static const routeName = 'edit-club-screen';

  @override
  _EditclubScreenState createState() => _EditclubScreenState();
}

class _EditclubScreenState extends State<EditclubScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ct = FirebaseFirestore.instance.collection('Club');
  var isLoading = false;
  final _formKey = GlobalKey<FormState>();
//To define the club title and color
  String _title;
  Color _color;

  submit() async {
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      var cat = Group(
        title: _title,
        color: _color,
      );
      //The club is being added to the database.
      final id = await DatabaseHelper.instance.insertclub(cat.toMap());
      await ct.add({'Club Name':'$_title'});
      print(id);
      Provider.of<Events>(context, listen: false).addclub(cat.addId(id));
      //A message is published when a new club is created.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("club added successfully")));
    } catch (error) {
      print(error);
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //One top bar has been created
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Add Club"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                    //The new club title and properties were retrieved from the user.
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Title",
                        icon: Icon(Icons.edit),
                        fillColor: Colors.blue,
                      ),
                      onSaved: (value) {
                        _title = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                    //The new club title and properties were retrieved from the user.
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Explanation",
                        icon: Icon(Icons.edit),
                        fillColor: Colors.blue,
                      ),
                      onSaved: (value) {
                        _title = value;
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  Text("Select Color"),
                  SizedBox(height: 15),
                  Expanded(
                    child: MaterialColorPicker(
                      onColorChange: (Color color) {
                        _color = color;
                      },
                      selectedColor: _color,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      enableFeedback: true,
                      backgroundColor: MaterialStateProperty.all(Colors.blue[900]),
                    ),
                    //Information saved
                    onPressed: submit,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
