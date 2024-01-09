import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_ppb/auth/auth_service.dart';
import 'package:tubes_ppb/auth/register.dart';
import 'package:tubes_ppb/screen/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    bool isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200], // Light gray background
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: isKeyboardVisible ? 2 : 4,
              child: Container(
                width: mediaQuery.size.width,
                color: Colors.grey[200], // Light gray background
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://i.ibb.co/vxbFHLs/ababil-removebg-preview.png',
                      height: 100,
                      width: 120,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.only(top: 30),
                width: mediaQuery.size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                    topRight: Radius.circular(70),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: mediaQuery.size.width / 1.2,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email here',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: mediaQuery.size.width / 1.2,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !isVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password here',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: FaIcon(
                              isVisible
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final message = await AuthService().login(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        if (message == 'Login Success') {
                          // Navigate to the home page after successful login
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text(message ?? 'An error occurred'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Black button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                      child: const Text(
                        'Don\'t have an account? Sign up',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
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
    );
  }
}
