import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/temp_storage.dart';
import 'home.dart';

class EmailLoginPage extends StatefulWidget {
  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final Color primaryColor = Color(0xFF767FE9);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypeController = TextEditingController();

  bool showPasswordFields = false;
  bool obscurePassword = true;
  bool obscureRetype = true;
  String errorText = '';
  bool isLoading = false;
  bool emailExists = false;
  bool hasPassword = false;

  void _checkEmail(String value) async {
    if (value.trim().endsWith('@gmail.com') && value.trim().isNotEmpty) {
      setState(() {
        isLoading = true;
        errorText = '';
      });
      
      try {
        final result = await AuthService.checkEmail(value.trim());
        setState(() {
          emailExists = result['exists'] ?? false;
          hasPassword = result['hasPassword'] ?? false;
          showPasswordFields = emailExists;
          isLoading = false;
          if (!emailExists) {
            errorText = result['message'] ?? 'Email not found';
          }
        });
      } catch (e) {
        setState(() {
          isLoading = false;
          errorText = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } else {
      setState(() {
        showPasswordFields = false;
        emailExists = false;
        hasPassword = false;
        errorText = '';
      });
    }
  }

  void _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final retype = _retypeController.text;

    if (!email.endsWith('@gmail.com')) {
      setState(() {
        errorText = 'Please enter a valid Gmail address.';
      });
      return;
    }
    if (password.length != 6) {
      setState(() {
        errorText = 'Password must be exactly 6 digits.';
      });
      return;
    }
    // Only check retype when setting new password
    if (!hasPassword && password != retype) {
      setState(() {
        errorText = 'Passwords do not match.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorText = '';
    });

    try {
      if (!hasPassword) {
        // Set password for new user
        final result = await AuthService.setPassword(email, password);
        if (result['success'] == true) {
          setState(() {
            hasPassword = true;
            isLoading = false;
          });
          // Show success message and navigate
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password set successfully! Please login.')),
          );
          // Clear password fields
          _passwordController.clear();
          _retypeController.clear();
        } else {
          setState(() {
            isLoading = false;
            errorText = result['message'] ?? 'Failed to set password';
          });
        }
      } else {
        // Login existing user
        print('Attempting login with email: $email, password: $password');
        final result = await AuthService.login(email, password);
        print('Login result: $result');
        
        if (result['success'] == true) {
          print('Login successful, navigating to home');
          setState(() {
            isLoading = false;
          });
          // Store email in both SharedPreferences and temp storage
          TempStorage.setUserEmail(email);
          if (result['student'] != null && result['student']['name'] != null) {
            TempStorage.setUserName(result['student']['name']);
          }
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_email', email);
          } catch (e) {
            print('SharedPreferences error: $e');
            // Continue with temp storage if SharedPreferences fails
          }
          // Navigate to home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        } else {
          print('Login failed: ${result['error']}');
          setState(() {
            isLoading = false;
            errorText = result['error'] ?? 'Invalid email or password';
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorText = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),
                // Acadexa logo image
                Image.asset(
                  'assets/icons/Acadexa.png',
                  width: 170,
                  height: 170,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),

                SizedBox(height: 50),
                // Email entry box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Material(
                        color: Colors.white,
                        elevation: 3,
                        borderRadius: BorderRadius.circular(12),
                        child: TextField(
                          controller: _emailController,
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              prefixIcon:
                                  Icon(Icons.email_outlined, color: primaryColor),
                              suffixIcon: isLoading
                                  ? Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                        ),
                                      ),
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(vertical: 18),
                            ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: _checkEmail,
                        ),
                      ),
                      if (showPasswordFields) ...[
                        SizedBox(height: 18),
                        Material(
                          color: Colors.white,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(12),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: obscurePassword,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: hasPassword ? 'Enter your password' : 'Set password (6 digits)',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              prefixIcon:
                                  Icon(Icons.lock_outline, color: primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 18),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        if (!hasPassword) ...[
                          SizedBox(height: 18),
                          Material(
                            color: Colors.white,
                            elevation: 3,
                            borderRadius: BorderRadius.circular(12),
                            child: TextField(
                              controller: _retypeController,
                              obscureText: obscureRetype,
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Re-type Password',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              prefixIcon:
                                  Icon(Icons.lock_outline, color: primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureRetype
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscureRetype = !obscureRetype;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 18),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        ],
                      ],
                      SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (showPasswordFields && !isLoading) ? _signIn : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 3,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  hasPassword ? 'Sign In' : 'Set Password',
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 28),
                      _signInButton(
                        context,
                        icon: Image.asset(
                          'assets/icons/google.png',
                          width: 24,
                          height: 24,
                        ),
                        text: 'Sign in with Google',
                        onTap: () {},
                      ),
                      if (errorText.isNotEmpty) ...[
                        SizedBox(height: 12),
                        Text(
                          errorText,
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 38),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInButton(BuildContext context,
      {required Widget icon,
      required String text,
      required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 52,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              icon,
              SizedBox(width: 18),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
