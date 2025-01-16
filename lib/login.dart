import 'package:flutter/material.dart';
import 'package:flutter_tp3/AuthViewModel.dart';
import 'package:flutter_tp3/homePage.dart';
import 'package:flutter_tp3/mainNavigation.dart';
import 'package:flutter_tp3/profilePage.dart';
import 'package:flutter_tp3/sign_up.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authViewModel = Provider.of<Authviewmodel>(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(),
            _inputField(authViewModel,context),
            _forgetPassword(),
            _signUp(context),
          ],
        ),
      ),
    );
  }

  _header() {
    return Column(
      children: [
        Text(
          "Welcome back !!",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credential to login !!"),
      ],
    );
  }

  _inputField(authViewModel, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            hintText: "Email",
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.email),
            
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            hintText: "Password",
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () async {
              final email = _emailController.text.trim();
              final password = _passwordController.text.trim();

              if (email.isEmpty || password.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please fill in all fields")),
              );
              return;
            }

              final success = await authViewModel.login(email, password, context);
              if (success) {
              Navigator.pushReplacement(context,
               MaterialPageRoute(builder: (context) => MainNavigation()));
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: StadiumBorder()),
            child: Text(
              "Login",
              style: TextStyle(fontSize: 20, color: Colors.white),
            )),
      ],
    );
  }

  _forgetPassword() {
    return TextButton(
      onPressed: () => {},
      child: Text(
        "Forgot password",
        style: TextStyle(color: Colors.purple),
      ),
    );
  }

  _signUp(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account ?"),
        TextButton(
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage())
                ),
            child: Text(
              "Sign up",
              style: TextStyle(color: Colors.purple),
            ))
      ],
    );
  }

  
}
