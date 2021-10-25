import 'package:flutter/material.dart';
import './forgotScreen.dart';
import './signup.dart';
import '../database/auth.dart';

import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscureText = true;
  
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(55),
                  child: Text(
                    "Todo.",
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsetsDirectional.all(8),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  setState(() {
                                    _email = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  labelText: 'E-mail',
                                ),
                                validator: (value) {
                                  final pattern =
                                      r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                                  final regExp = RegExp(pattern);

                                  if (value!.isEmpty) {
                                    return 'Enter an email';
                                  } else if (!regExp.hasMatch(value)) {
                                    return 'Enter a valid email';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _obscureText,
                                onChanged: (value) {
                                  setState(() {
                                    _password = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  // ignore: deprecated_member_use
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                  labelText: 'Password',
                                ),
                                validator: (value) {
                                  if (value!.length < 7) {
                                    return 'Password must contain at least 7 characters';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        // ignore: deprecated_member_use
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ForgotScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height:
                              1.4 * (MediaQuery.of(context).size.height / 20),
                          width: 5 * (MediaQuery.of(context).size.width / 10),
                          margin: EdgeInsets.only(bottom: 20, top: 12),
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            elevation: 5.0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            onPressed: () {
                              final isValid = formKey.currentState!.validate();
                              FocusScope.of(context).unfocus();

                              if (isValid) {
                                formKey.currentState!.save();
                              }

                              if (_email.isNotEmpty && _password.isNotEmpty) {
                                context.read<AuthenticationService>().logIn(email: _email.trim(),password: _password.trim());
                              } else {
                                print("Please enter Fields");
                              }
                            },
                            child: Text(
                              "login",
                              style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => SignUp(),
                              ),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'don\'t have an account? ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'SIGN UP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
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
          ),
        ),
      ),
    );
  }
}
