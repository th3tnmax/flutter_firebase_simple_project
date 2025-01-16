import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tp3/homePage.dart';
import 'package:flutter_tp3/login.dart';
import 'package:flutter_tp3/main.dart';
import 'package:flutter_tp3/mainNavigation.dart';
import 'package:flutter_tp3/profilePage.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwdController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();


  Future<void> signUp(BuildContext context, String email, String password,
      String username) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the newly created user's UID
      String uid = userCredential.user!.uid;
// Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'photoUrl':'https://www.pngmart.com/files/23/Profile-PNG-Photo.png', // Default profile picture
        'birthdate': "",
        'phone': "",
        'genre': "",
      });

// Navigate to HomePage on successful sign-up
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainNavigation()));

// Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-up successful! Welcome, $username ")),
      );

      // Navigator.pop(context);
    } catch (e) {
      // Handle sign-up errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-up failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Sign Up",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text("Create an account"),
                ],
              ),
              Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        hintText: "User Name",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        hintText: "Password",
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _confirmPwdController,
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.purple.withOpacity(0.1),
                        filled: true,
                        hintText: "Confirm Password",
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  final username = _usernameController.text.trim();
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  final confirmPassword = _confirmPwdController.text.trim();

                  // Validate username and passwords match
                  if (username.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Username cannot be empty")),
                    );
                    return;
                  }

                  // Validate passwords match
                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Passwords do not match")));
                    return;
                  }

                  // Call sign-up method
                  signUp(context, email, password, username);
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: StadiumBorder()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account ?"),
                  TextButton(
                      onPressed: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage())),
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.purple),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
