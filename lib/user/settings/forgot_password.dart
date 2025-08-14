import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/widgets/appbutton.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      // Display a success message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Password Reset"),
            content: Text("Password reset email sent. Check your inbox."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Display an error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to send password reset email. ${e.toString()}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(  backgroundColor: AppColors.contColor2,
      appBar: AppBar(
        backgroundColor: AppColors.contColor2,
        title: Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            AppButton(onTap:  _resetPassword, child: Text("Reset Password",style: TextStyle(color: Colors.white),),height: 52,color: AppColors.contColor5,)


          ],
        ),
      ),
    );
  }
}


