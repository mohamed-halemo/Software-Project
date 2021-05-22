import 'package:android_flickr/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

// If true the text is visible e;se it is not
bool _secureText = true;
// The text written on the button in login screen
String _buttonText = 'Sign up';
final _formKey = GlobalKey<FormState>();

class _SignUpState extends State<SignUp> {
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
          child: Column(children: <Widget>[
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
                      'Sign up to Flicker',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text fields to collect the user login information
            Form(
              key: _formKey,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 20, top: 10),
                    child: Column(children: <Widget>[
                      _textInput(
                          hint: 'First name',
                          label: 'First name',
                          keyboardType: TextInputType.name),
                      _textInput(
                          hint: 'Last name',
                          label: 'Last name',
                          keyboardType: TextInputType.name),
                      _textInput(
                          hint: 'Your age',
                          label: 'Your age',
                          keyboardType: TextInputType.number),
                      _textInput(
                          hint: 'Email address',
                          label: 'Email address',
                          keyboardType: TextInputType.emailAddress),
                      _textInput(
                          hint: 'Password',
                          label: 'Password',
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
                          }),
                      Container(
                        child: RaisedButton(
                          onPressed: () {
                            _formKey.currentState.validate()
                                // Moving to the log in page
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LogIn()))
                                : null;
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
                      Divider(
                        color: Colors.grey,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // Moving to the log in page
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

Widget _textInput({
  hint,
  label,
  keyboardType,
  obscure = false,
  suffixIcon,
  suffixIconPressed,
}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      color: Colors.white,
    ),
    child: TextFormField(
      validator: (String value) {
        // Checks if the text field is empty or not
        if (value.isEmpty) {
          return 'Required';
        }
        // No white space in the begging of the password is allowed and the passwors length can't be less than 12
        if (hint == 'Password' &&
            ((value.length < 12) || value.startsWith(' '))) {
          return 'Invalid password';
        }
        // No number bigger than 120 is accepted in the age field
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
    ),
  );
}
