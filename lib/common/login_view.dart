

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickassitnew/common/login_page.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:svg_flutter/svg_flutter.dart';





class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    final themedata=Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,

        actions: [

        ],

      ),

      body: Container(
        padding: EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/logo.svg'),
            SizedBox(
              height: 20,
            ),
            Text(
              "Login or Signup",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Please select your preferred method to continue setting up your account",
              textAlign: TextAlign.center,
              style:TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              },
              onDoubleTap: () {},
              onLongPress: () {},
              child: Container(
                height: 55,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), color: AppColors.btnPrimaryColor),
                child: Center(
                  child: Text("Continue with Email",style: themedata.textTheme.displayMedium,),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {

              },
              onDoubleTap: () {},
              onLongPress: () {},
              child: Container(
                height: 55,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white30
                ),
                child: Center(
                  child: Text(
                    "Continue with Phone",
                    style: themedata.textTheme.displayMedium,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Expanded(
                  child: Container(
                    height: 65,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                       color: Colors.white30),
                    child: Center(child: Icon(Icons.apple,size: 40,color: Colors.white,),),
                  ),

                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    height: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white30),

                    child: Center(child: FaIcon(FontAwesomeIcons.google,color: Colors.white,),),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "If you are creating a new account ,Terms and Conditions & Privacy policy will apply",
              textAlign: TextAlign.center,
              style:TextStyle(color: Colors.white,fontSize: 16),
            ),







          ],
        ),
      ),
    );
  }
}
