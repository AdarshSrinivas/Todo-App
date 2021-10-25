import 'package:flutter/material.dart';
import 'package:todo_app/database/auth.dart';
import 'package:provider/provider.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final formKey = GlobalKey<FormState>();
  String _email = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Todo.",
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
              SizedBox(
                height: 5,
                width: MediaQuery.of(context).size.width * 0.55,
                child: Divider(
                  height: 20,
                  thickness: 2,
                  color: Colors.cyan[100],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, right: 2, left: 2),
                child: Form(
                  key: formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              _email = value;
                            });
                          },
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
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.cyan.shade200,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.cyan.shade200,
                              ),
                            ),
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        // ignore: deprecated_member_use
                        RaisedButton(
                          color: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: () {
                            final isValid = formKey.currentState!.validate();
                            FocusScope.of(context).unfocus();

                            if (isValid) {
                              formKey.currentState!.save();
                            }

                            if (_email.isNotEmpty) {
                              context.read<AuthenticationService>().forgotPassword(email:_email);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Reset Link Sent')));
                              Navigator.pop(context);
                            } else {
                              print("Please enter email.");
                            }
                          },
                          elevation: 5,
                          child: Text('Send Email',
                              style: TextStyle(
                                color: Colors.cyan,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "\"We will mail you a link.\n Please click on that link to reset your password.\"",
                          style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
