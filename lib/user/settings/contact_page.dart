import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quickassitnew/constans/colors.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.contColor2,
      appBar: AppBar(backgroundColor: AppColors.contColor2,
        title: Text("Contact Us"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Have questions or feedback? We're here to help!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildContactInfo(
              "Email: support@househub.com",
              Icons.email,
                  () => _launchEmail("support@househub.com"),
            ),
            _buildContactInfo(
              "Phone: +1 (123) 456-7890",
              Icons.phone,
                  () => _launchPhone("+11234567890"),
            ),
            _buildContactInfo(
              "Visit our office:",
              Icons.location_on,
                  () async {
                // Add logic to open a map or provide office address
              },
            ),
            SizedBox(height: 16),
            _buildText(
              "We strive to respond to your inquiries as quickly as possible. Your satisfaction is our priority.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(String text, IconData icon, Future<void> Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => onPressed(),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.blue,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    await _launchUri(uri);
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    await _launchUri(uri);
  }

  Future<void> _launchUri(Uri uri) async {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      debugPrint('Could not launch $uri');
    }
  }
}



