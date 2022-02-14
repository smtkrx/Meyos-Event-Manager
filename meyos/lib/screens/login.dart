import 'package:event_manager/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fonts/fonts.dart';
import '../vendors/authentication.dart';
import '../screens/signup.dart';
import '../widgets/auth_screen_intro.dart';
import '../fonts/size.dart';

//The page created to login
class Login extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Initializing Fields
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  var isLoading = false;
  // Method to log the user in and navigate to homescreen
  // Also to show a dialog box in case of error
  void tryLogIn() async {
    if (!_formKey.currentState.validate()) {
      return null;
    }
    _formKey.currentState.save();

    final authInstance = Provider.of<Authentication>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      await authInstance.login(_email, _password);
      Navigator.of(context).pushReplacementNamed(CalendarScreen.routeName);
    } catch (error) {
      authInstance.showError(error.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
              //Show a spinner when loading
            )
          : LayoutBuilder(builder: (context, constraint) {
              //Else show the main content
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.screenHeight,
                      child: Image(
                        image: AssetImage("assets/images/background.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    // Use constraint box to properly use SingleChildScrollView with Spacer in column
                    // Column takes infinite height by default and singleChildScrollView gives a vertical scrollable area.
                    // Now using space is used to fill the empty space, but because a column is wrapped in a singleChildScrollView it forces the column to take infinite space which gives an error
                    // So constraints are applied to limit the column size so that its height is no more than the screen height
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthScreenIntro(), // The top header
                            Spacer(), //To fill all the available empty spaces
                            //Main Form widget starts here
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.horizontalBlockSize * 5,
                              ),
                              height: 450,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // color: Colors.purple.shade100,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                              ),
                              child: Form(
                                // Using a form key to communicate with the form element outside of the widget tree for saving and validating stuff
                                key: _formKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: SizeConfig.screenHeight * 0.05,
                                    ),
                                    // Email text field
                                    TextFormField(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 10, 12, 10),
                                        labelText: "Email",
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          borderSide: BorderSide(
                                              color: Colors.blue[900]),
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      onSaved: (value) {
                                        _email = value;
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Please enter your email";
                                        }
                                        //Features that a mail should have are defined
                                        if (!value.contains("@") ||
                                            !value.contains(".")) {
                                          return "Please enter a valid email address";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    // Password text field
                                    TextFormField(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        contentPadding:
                                            EdgeInsets.fromLTRB(12, 10, 12, 10),
                                        labelText: "Password",
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          borderSide: BorderSide(
                                              color: Colors.blue[900]),
                                        ),
                                      ),
                                      obscureText:
                                          true, //to hide the characters
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                      onSaved: (value) {
                                        _password = value;
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Please enter a password";
                                        }
                                        //It is written on the screen that the entered password must be greater than 6 characters.
                                        if (value.length < 6) {
                                          return "Please enter a password greater than 6 characters";
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    // Login Button
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 12),
                                      //A login button has been created for the user to login.
                                      child: ElevatedButton(
                                        onPressed: () {
                                          tryLogIn();
                                        },
                                        child: Text(
                                          "Log In",
                                          style: MyFonts.medium.factor(5),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          fixedSize: Size(1000, 50),
                                          // primary: darkBlue,
                                          primary: Colors.blue[900],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    // This row widget creates two horizontal lines and places a text between them
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //It was used to separate with the above fields.
                                        Container(
                                          width: (SizeConfig.screenWidth -(2 *SizeConfig.horizontalBlockSize *10))/2-30,
                                          height: 2,
                                          color: Colors.grey.withOpacity(0.6),
                                        ),
                                        Text(
                                          "OR",
                                          style: MyFonts.medium
                                              .factor(4)
                                              .setColor(Colors.grey.withOpacity(0.9)),
                                        ),
                                        Container(
                                          width: (SizeConfig.screenWidth-(2 *SizeConfig.horizontalBlockSize *10))/2-30,
                                          height: 2,
                                          color: Colors.grey.withOpacity(0.6),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    // Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don't have an account?  ",
                                          style: MyFonts.medium
                                              .tsFactor(18)
                                              .setColor(Colors.grey),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    SignUp.routeName,
                                                    (route) => false);
                                          },
                                          child: Text(
                                            "Sign Up",
                                            style: MyFonts.bold.tsFactor(18),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
    );
  }
}
