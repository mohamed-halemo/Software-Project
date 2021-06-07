import 'package:android_flickr/providers/auth.dart';
import 'package:android_flickr/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:validators/validators.dart';

/// Sign up page
class SignUp extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();
}

TextFormField myfield;

bool hasNoNumbers = false;

///  A boolean that is true if the text is visible else it is hidden
bool secureText = true;

/// The text written on the button in login screen
String buttonText = 'Sign up';

///A key used in validating the text inputed by the user,
///manily to make sure the text input form is not empty
GlobalKey<FormState> formKey = GlobalKey<FormState>();

/// A map that takes the email and the password of the user
Map<String, String> authData = {
  'email': '',
  'password': '',
  'firstname': '',
  'lastname': '',
  'age': '',
};

class SignUpState extends State<SignUp> {
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
                                // print(authData);
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
                                    _showError(errorMessage);
                                  } else if (value.body.contains(
                                      'password must contain at least one number')) {
                                    errorMessage =
                                        'Password must contain at least one number';
                                    setState(() {
                                      hasNoNumbers = true;
                                    });
                                  }
                                });

                                ///Moving to the log in page if the data entred is all good
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LogIn()));
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
                                  Navigator.pushReplacement(
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
  myfield = TextFormField(
    maxLength: hint == 'Your age' ? 3 : null,
    validator: (value) {
      /// Checks if the text field is empty or not
      if (value.isEmpty) {
        return 'Required';
      }
      if (hint == 'Password' && hasNoNumbers) {
        return 'Password must contain at least one number';
      }

      /// No white space in the begging of the password is allowed and the passwors length can't be less than 12
      if (hint == 'Password' &&
          ((value.length < 12) ||
              (value.length > 16) ||
              value.startsWith(' '))) {
        return 'Invalid password';
      }
      if (isLowercase(value) && hint == 'Password') {
        return 'Password must contain at least one uppercase character';
      }
      if (isUppercase(value) && hint == 'Password') {
        return 'Password must contain at least one lowercase character';
      }

      /// No number bigger than 120 is accepted in the age field
      if (hint == 'Your age' && int.parse(value) > 120) {
        return 'Invalid age';
      }
      return null;
    },
    decoration: InputDecoration(
      counterText: '',
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
  );
  return Container(
    margin: EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: myfield,
  );
}
