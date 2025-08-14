import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: AppColors.contColor2,
      appBar: AppBar( backgroundColor: AppColors.contColor2,
        title: Text("About Us"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to House Hub",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "House Hub is your go-to platform for the best rental services. Whether you are looking for a cozy apartment, a spacious house, or a stylish condo, we've got you covered.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Key Features:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildFeature("Explore a Variety of Properties"),
            _buildFeature("Easy Booking Process"),
            _buildFeature("Transparent Pricing"),
            _buildFeature("Secure and Reliable"),
            SizedBox(height: 16),
            Text(
              "Our Mission:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "At House Hub, our mission is to provide a seamless rental experience. We strive to connect renters with their ideal homes while ensuring a hassle-free and trustworthy process.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(feature),
          ),
        ],
      ),
    );
  }
}


