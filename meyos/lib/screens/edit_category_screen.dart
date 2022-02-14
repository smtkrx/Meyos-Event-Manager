import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_manager/samples/group.dart';
import 'package:event_manager/vendors/database_helper.dart';
import 'package:event_manager/vendors/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';

//To create new category title and properties
class EditCategoryScreen extends StatefulWidget {
  static const routeName = 'edit-category-screen';

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ct = FirebaseFirestore.instance.collection('Category');
  var isLoading = false;
  final _formKey = GlobalKey<FormState>();
//To define the category title and color
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
      //The category is being added to the database.
      final id = await DatabaseHelper.instance.insertclub(cat.toMap());
      await ct.add({'Category Name':'$_title'});
      print(id);
      Provider.of<Events>(context, listen: false).addclub(cat.addId(id));
      //A message is published when a new category is created.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Category added successfully")));
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
        title: Text("Add Category"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    //The new category title and properties were retrieved from the user.
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
                  SizedBox(height: 40),
                  Spacer(),
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
