import 'package:flutter/material.dart';
import 'package:todo_app/database/auth.dart';
import 'package:provider/provider.dart';
import 'login.dart';

void main() => runApp(SignUp());

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  String _email = '';
  String _username = '';
  String _password = '';
  String _tempPassword = '';
  bool _obscureText = true;
  bool _obscureTextTemp = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
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
                      mainAxisSize: MainAxisSize.min,
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
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  setState(() {
                                    _username = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  labelText: 'Username',
                                ),
                                validator: (value) {
                                  if (value!.length < 4) {
                                    return 'Enter at least 4 characters';
                                  } else if (value.length >= 15) {
                                    return 'Max Length 15';
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
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _obscureTextTemp,
                                onChanged: (value) {
                                  setState(() {
                                    _tempPassword = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  // ignore: deprecated_member_use
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureTextTemp
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        _obscureTextTemp = !_obscureTextTemp;
                                      });
                                    },
                                  ),
                                  labelText: 'Confirm Password',
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
                                if (_email.isNotEmpty &&
                                    _username.isNotEmpty &&
                                    _password.isNotEmpty &&
                                    _tempPassword.isNotEmpty) {
                                  if (_password == _tempPassword) {
                                    context
                                        .read<AuthenticationService>()
                                        .createAccount(
                                          name: _username.trim(),
                                          email: _email.trim(),
                                          password: _password.trim(),
                                        );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Account Created'),
                                      ),
                                    );
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => LoginScreen(),
                                      ),
                                    );
                                  }
                                } else {
                                  print("Password mismatch");
                                }
                              } else {
                                print("Please enter all fields");
                              }
                            },
                            child: Text(
                              "Sign Up",
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
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'already have an account? ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'LOGIN',
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
