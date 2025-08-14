import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;

  ErrorPage({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Oops! Something went wrong:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
