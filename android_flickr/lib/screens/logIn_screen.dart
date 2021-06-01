import 'package:android_flickr/screens/sign_up_screen.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'explore_screen.dart';
import 'splash_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Login page
class LogIn extends StatefulWidget {
  @override
  LogInState createState() => LogInState();
}

/// A map that takes the email and the password of the user
Map<String, String> authData = {
  'email': '',
  'password': '',
};

class LogInState extends State<LogIn> {
  ///  A boolean that is true if the text is visible else it is hidden
  bool secureText = true;

  /// The text written on the button in login screen
  String buttonText = 'Next';

  /// Remeber email address
  bool rememberMe = true;

  /// Checks if the email valid or not
  bool isEmailValidated = false;

  /// Key used in the validation process
  final formKey = GlobalKey<FormState>();

  /// Moving to explore screen when the user log in
  void loginScreen(BuildContext ctx) {
    Navigator.of(ctx).pop();
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FlickrSplashScreen(
          ExploreScreen(),
          false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Shows an error message
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
            child: Column(
          children: <Widget>[
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
                      'Log in to Flicker',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: formKey,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 20, top: 10),
                    child: Column(
                      /// Text fields to collect the user login information
                      children: <Widget>[
                        _textInput(
                          hint: 'Email address',
                          label: 'Email address',
                          userInfo: 'email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        isEmailValidated
                            ? _textInput(
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
                                })
                            : Container(),
                        Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(0.0)),
                            Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value;
                                  });
                                }),

                            /// Remeber email address checks when pressing on the check box or the sentence beside it
                            GestureDetector(
                              child: Text('Remeber email address'),
                              onTap: () {
                                setState(() {
                                  rememberMe = !rememberMe;
                                });
                              },
                            )
                          ],
                        ),

                        /// A button that shows the password textform if the user entered a valid email address
                        /// The button is also used to log in the user into the app if his authentication info is correct
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              final form = formKey.currentState;
                              formKey.currentState.validate();
                              setState(() {
                                if (formKey.currentState.validate()) {
                                  buttonText = 'Sign in';
                                  isEmailValidated = true;
                                }
                              });
                              if (buttonText == 'Sign in') {
                                // print(authData);
                                Provider.of<Auth>(context, listen: false)
                                    .login(
                                  authData['email'],
                                  authData['password'],
                                )
                                    .then((value) async {
                                  if (value.statusCode == 200) {
                                    // if (rememberMe) {
                                    //   SharedPreferences prefs =
                                    //       await SharedPreferences.getInstance();
                                    //   prefs?.setBool('remember', true);
                                    //   prefs?.setString('email', email);
                                    //   prefs?.setString('password', password);
                                    // }
                                    loginScreen(context);
                                    return;
                                  }
                                  var errorMessage = 'Error !';
                                  if (value.body.contains('Invalid')) {
                                    errorMessage = 'Invalid email or password.';
                                  }
                                  _showError(errorMessage);
                                });
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
                        Container(
                          alignment: Alignment.center,
                          child: FlatButton(
                            onPressed: () {},
                            child: Text(
                              'Forget password ?',
                              style: TextStyle(color: Colors.blue[600]),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Not a Fotone member ?'),

                              /// A button that moves you to the sign up page
                              FlatButton(
                                  padding: EdgeInsets.all(0.0),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()));
                                  },
                                  child: Text('Sign up here.',
                                      style:
                                          TextStyle(color: Colors.blue[600])))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

/// Text input fields for the login information as email and password
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
      /// Checks if the text field is empty or not
      validator: (String value) {
        if (value.isEmpty) {
          return 'Required';
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
