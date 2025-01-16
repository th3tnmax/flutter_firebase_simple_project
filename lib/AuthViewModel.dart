import 'package:flutter/material.dart';
import 'package:flutter_tp3/services/AuthService.dart';

class Authviewmodel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      final user = await _authService.loginWithEmail(email, password);
      notifyListeners(); // Notifie les widgets que l'état a changé
      return user != null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      notifyListeners();
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _authService.logout();
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have successfully logged out.")),
      );
    } catch (e) {
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout error : $e")),
      );
    }
  }

  void clearError() {
    notifyListeners();
  }
}
