import 'package:android_flickr/providers/auth.dart';
import 'package:android_flickr/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

/// Sign up page
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

///  A boolean that is true if the text is visible else it is hidden
bool secureText = true;

/// The text written on the button in login screen
String buttonText = 'Sign up';

final formKey = GlobalKey<FormState>();

/// A map that takes the email and the password of the user
Map<String, String> authData = {
  'email': '',
  'password': '',
  'firstname': '',
  'lastname': '',
  'age': '',
};

class _SignUpState extends State<SignUp> {
  @override

  /// Widget that shows an error message
  Widget build(BuildContext context) {
    void _showError(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred !'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.grey[900],

        /// Showing the logo and the title in the appbar
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/Logo.png',
              height: 25,
              width: 25,
            ),
            SizedBox(width: 5),
            Text(
              'flicker',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: new Theme(
        data: new ThemeData(
          primaryColor: Colors.blue[400],
        ),
        child: Container(
          child: Column(children: <Widget>[
            /// Showing the logo and the title beneath the appbar
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/Logo.png',
                      height: 25,
                      width: 25,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      'Sign up to Flicker',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Text fields to collect the user Sing up information
            Form(
              key: formKey,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 20, top: 10),
                    child: Column(children: <Widget>[
                      _textInput(
                          hint: 'First name',
                          label: 'First name',
                          userInfo: 'firstname',
                          keyboardType: TextInputType.name),
                      _textInput(
                          hint: 'Last name',
                          label: 'Last name',
                          userInfo: 'lastname',
                          keyboardType: TextInputType.name),
                      _textInput(
                          hint: 'Your age',
                          label: 'Your age',
                          userInfo: 'age',
                          keyboardType: TextInputType.number),
                      _textInput(
                          hint: 'Email address',
                          label: 'Email address',
                          userInfo: 'email',
                          keyboardType: TextInputType.emailAddress),
                      _textInput(
                          hint: 'Password',
                          label: 'Password',
                          userInfo: 'password',
                          keyboardType: TextInputType.visiblePassword,
                          obscure: secureText,
                          suffixIcon: secureText
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                          suffixIconPressed: () {
                            setState(() {
                              secureText = !secureText;
                            });
                          }),

                      /// Sign up button that saves the user info after checking for any possible error
                      Container(
                        child: RaisedButton(
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              if (formKey.currentState.validate()) {
                                print(authData);
                                Provider.of<Auth>(context, listen: false)
                                    .signup(
                                  authData['email'],
                                  authData['password'],
                                  authData['firstname'],
                                  authData['lastname'],
                                  authData['age'],
                                )
                                    .then((value) {
                                  var errorMessage = 'Error !';
                                  // print('ezz' + value.body);
                                  if (value.body.contains(
                                      'account with this email already exists.')) {
                                    errorMessage =
                                        'account with this email already exists.';
                                  } else if (value.body.contains(
                                      'password must contain at least one uppercase character')) {
                                    errorMessage =
                                        'Password must contain at least one uppercase character';
                                  } else if (value.body.contains(
                                      'password must contain at least one lowercase character')) {
                                    errorMessage =
                                        'Password must contain at least one lowercase character';
                                  } else if (value.body.contains(
                                      'password must contain at least one number')) {
                                    errorMessage =
                                        'Password must contain at least one number';
                                  } else if (value.body.contains(
                                      'Ensure this field has no more than 16 characters.')) {
                                    errorMessage =
                                        'Ensure this field has no more than 16 characters.';
                                  }
                                  _showError(errorMessage);
                                });

                                /// Moving to the log in page if the data entred is all good
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => LogIn()));
                              }
                            }
                          },
                          child: Container(
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            width: double.infinity,
                            height: 25,
                            alignment: Alignment.center,
                          ),
                          color: Colors.blue[600],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          /// Moving to the log in page
                          children: [
                            Text('Already a Flicker member ?'),
                            FlatButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LogIn()));
                                },
                                child: Text('Log in here.',
                                    style: TextStyle(color: Colors.blue[600])))
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Text input fields for the Sign up information
Widget _textInput({
  hint,
  label,
  keyboardType,
  obscure = false,
  suffixIcon,
  suffixIconPressed,
  String userInfo,
}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: TextFormField(
      validator: (value) {
        /// Checks if the text field is empty or not
        if (value.isEmpty) {
          return 'Required';
        }

        /// No white space in the begging of the password is allowed and the passwors length can't be less than 12
        if (hint == 'Password' &&
            ((value.length < 12) || value.startsWith(' '))) {
          return 'Invalid password';
        }

        /// No number bigger than 120 is accepted in the age field
        if (hint == 'Your age' && int.parse(value) > 120) {
          return 'Invalid age';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        suffixIcon:
            IconButton(icon: Icon(suffixIcon), onPressed: suffixIconPressed),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
      ),
      keyboardType: keyboardType,
      obscureText: obscure,
      onChanged: (value) {
        authData[userInfo] = value;
      },
    ),
  );
}
