import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoDataWidget extends StatelessWidget {
  final String errorMessage;

  NoDataWidget({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Lottie.asset('assets/json/cat.json'),
          SizedBox(height: 16),
          Text(
            '$errorMessage',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
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
    );
  }
}
