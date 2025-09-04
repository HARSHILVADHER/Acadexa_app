import 'package:flutter/material.dart';

void main() => runApp(AcadexaApp());

class AcadexaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Acadexa Login',
      debugShowCheckedModeBanner: false,
      home: AcadexaLoginPage(),
    );
  }
}

class AcadexaLoginPage extends StatefulWidget {
  @override
  _AcadexaLoginPageState createState() => _AcadexaLoginPageState();
}

class _AcadexaLoginPageState extends State<AcadexaLoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  // ignore: unused_field
  String _email = '';
  // ignore: unused_field
  String _password = '';

  final Color primaryColor = Color(0xFF767FE9);

  @override
  Widget build(BuildContext context) {
    // Full screen width & height
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ACADEXA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: primaryColor,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'your one stop solution',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 28),
                // Illustration Image (replace url with your actual asset or url)
                SizedBox(
                  height: size.height * 0.25,
                  child: Image.network(
                    'https://i.ibb.co/9mg17Fb5/focused-tiny-people-reading-books.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Log in to Account',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email TextField
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon:
                              Icon(Icons.email_outlined, color: Colors.black87),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          return null;
                        },
                        onChanged: (val) => _email = val,
                      ),
                      SizedBox(height: 18),
                      // Password TextField
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon:
                              Icon(Icons.lock_outline, color: Colors.black87),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 20),
                        ),
                        obscureText: _hidePassword,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          return null;
                        },
                        onChanged: (val) => _password = val,
                      ),
                      SizedBox(height: 8),
                      // Forgot Password aligned right
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            // TODO: Forgot password logic
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 26),
                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_email.contains('@gmail') &&
                                  _password.length == 6) {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Enter a valid @gmail email and 6 digit password')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Register text
                      RichText(
                        text: TextSpan(
                          text: 'Don’t have account ? ',
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              // Add gesture recognizer if need tap event
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 18),

                      Text(
                        'Sign in with',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 16),

                      // Social Icons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google Button
                          InkWell(
                            onTap: () {
                              // TODO: Google sign-in logic
                            },
                            child: Image.network(
                              'https://i.ibb.co/YYrcQYh/google.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                          SizedBox(width: 26),
                          // Phone Button (black circle with phone icon)
                          InkWell(
                            onTap: () {
                              // TODO: Phone sign-in logic
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.phone,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
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
