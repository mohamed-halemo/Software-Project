import 'package:android_flickr/screens/signUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'explore_screen.dart';
import 'splash_screen.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

Map<String, String> _authData = {
  'email': '',
  'password': '',
};

class _LogInState extends State<LogIn> {
  // If true the text is visible e;se it is not
  bool _secureText = true;
  // The text written on the button in login screen
  String _buttonText = 'Next';
  // Remeber email address
  bool _rememberMe = true;
  // Checks if the email valid or not
  bool _isEmailValidated = false;
  final _formKey = GlobalKey<FormState>();
  void loginScreen(BuildContext ctx) {
    Navigator.of(ctx).push(
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
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Colors.grey[900],
        // Showing the logo and the title in the appbar
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
            // Showing the logo and the title under the appbar
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
              key: _formKey,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 20, top: 10),
                    child: Column(
                      // Text fields to collect the user login information
                      children: <Widget>[
                        _textInput(
                          hint: 'Email address',
                          label: 'Email address',
                          userInfo: 'email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        //Checks if the email is valid or not
                        _isEmailValidated
                            ? _textInput(
                                hint: 'Password',
                                label: 'Password',
                                userInfo: 'password',
                                keyboardType: TextInputType.visiblePassword,
                                obscure: _secureText,
                                suffixIcon: _secureText
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye,
                                // Changes the state of the password (Visible or not)
                                suffixIconPressed: () {
                                  setState(() {
                                    _secureText = !_secureText;
                                  });
                                })
                            : Container(),
                        Row(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(0.0)),
                            Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value;
                                  });
                                }),
                            // Remeber email address checks when pressing on the check box or the sentence beside it
                            GestureDetector(
                              child: Text('Remeber email address'),
                              onTap: () {
                                setState(() {
                                  _rememberMe = !_rememberMe;
                                });
                              },
                            )
                          ],
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              final form = _formKey.currentState;
                              _formKey.currentState.validate();
                              setState(() {
                                if (_formKey.currentState.validate()) {
                                  _buttonText = 'Sign in';
                                  _isEmailValidated = true;
                                }
                              });
                              if (_buttonText == 'Sign in') {
                                print(_authData);
                                Provider.of<Auth>(context, listen: false)
                                    .login(
                                  _authData['email'],
                                  _authData['password'],
                                )
                                    .then((value) {
                                  if (value.statusCode == 200) {
                                    loginScreen(context);
                                  }
                                });
                              }
                            },
                            child: Container(
                              child: Text(
                                _buttonText,
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
                        // A line that divides the screen
                        Divider(
                          color: Colors.grey,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Not a Fotone member ?'),
                              // Moving to the sign up page
                              FlatButton(
                                  padding: EdgeInsets.all(0.0),
                                  onPressed: () {
                                    Navigator.push(
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

// Text input fields
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
      // Checks if the text field is empty or not
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
        _authData[userInfo] = value;
      },
    ),
  );
}

/* Widget _EmailField() {
  return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Email address',
            labelText: 'Email address',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.only(top: 20, bottom: 20, left: 20),
          ),
          keyboardType: TextInputType.emailAddress,
          autofillHints: [AutofillHints.email],
          validator: (String value) {
            if (value.isEmpty) {
              return 'Required';
            }
            return null;
          }));
} */
