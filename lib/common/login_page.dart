




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickassitnew/admin/admin_home_page.dart';
import 'package:quickassitnew/common/forgot_password.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/mechanic/mechanic_home_page.dart';
import 'package:quickassitnew/shops/shop_home_page.dart';
import 'package:quickassitnew/shops/shop_registration.dart';
import 'package:quickassitnew/user/bottomnavigation_page.dart';
import 'package:quickassitnew/user/userregistration.dart';
import 'package:quickassitnew/widgets/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_flutter/svg_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordtext = TextEditingController();

  final _loginKey = GlobalKey<FormState>();


  bool visible = true;

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    return Scaffold(backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(backgroundColor: AppColors.scaffoldColor,),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.all(20),

        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Form(
          key: _loginKey,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [

                        SvgPicture.asset('assets/svg/logo.svg'),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Continue with Email",
                          style: Theme
                              .of(context)
                              .textTheme
                              .displayLarge,
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Container(

                          child: TextFormField(
                            validator: (value) {
                             return Validate.emailValidator(value!);
                            },
                            controller: emailText,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              filled: true,
                              hintStyle: TextStyle(
                                  color: Colors.black26, fontSize: 14),
                              fillColor: Colors.white,
                              hintText: 'Enter Email',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              suffixIcon: Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(

                          child: TextFormField(
                            validator: (value) {
                              return Validate.pwdvalidator(value!);
                            },
                            controller: passwordtext,
                            obscureText: visible,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: TextStyle(
                                  color: Colors.black26, fontSize: 14),
                              hintText: 'password',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(17),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              suffixIcon: IconButton(
                                icon: visible == true
                                    ? Icon(
                                  Icons.visibility_off,
                                  color: Colors.black,
                                )
                                    : Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    visible = !visible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()));
                                },

                                child: Text("Forgot Password",
                                  style: themedata.textTheme.displaySmall,))
                          ],
                        ),

                        SizedBox(height: 20,),

                        Center(
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 52,
                            child: ElevatedButton(

                              onPressed: () async {
                                if (_loginKey.currentState!.validate()) {
                                  _login();
                                }
                              },
                              child: Text(
                                  "Continue with Email",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.btnPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Dont have an account?',
                              style: themedata.textTheme.displaySmall,),
                            SizedBox(width: 10,),
                            InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          UserRegistrationScreen()));
                                },
                                child: Text(
                                  'Create new',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        ),

                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                         ShopRegistrationScreen()));
                                },
                                child: Text(
                                  'Click to Regiseter Your Business',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _login() async {
    try {
      if (emailText.text == "admin@gmail.com" && passwordtext.text == "12345678") {
        SharedPreferences _pref = await SharedPreferences.getInstance();
        _pref.setString('uid', "adminid");
        _pref.setString('email', emailText.text);
        _pref.setString('name', "Admin");
        _pref.setString('phone', "9846543117");
        _pref.setString('token', "admintoken");
        _pref.setString('type', "admin");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AdminHomePage(),
          ),
              (route) => false,
        );
      } else {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailText.text,
          password: passwordtext.text,
        );
        print(userCredential.user!.uid);

        if (userCredential != null) {
          DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('login').doc(userCredential.user!.uid).get();
          print(snapshot['usertype']);

          if (snapshot['usertype'] == "user") {
            var snap = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();

            FirebaseFirestore.instance.collection('bookmarks').doc(userCredential.user!.uid).set({
              'userId': userCredential.user!.uid, 'shopIds': []
            });

            if (snap != null) {
              SharedPreferences _pref = await SharedPreferences.getInstance();
              _pref.setString('uid', snap['uid']);
              _pref.setString('email', snap['email']);
              _pref.setString('name', snap['name']);
              _pref.setString('phone', snap['phone']);
              _pref.setString('type', "user");
              _pref.setString('location', "location");
              _pref.setString('imgurl', "assets/img/profile.png");
              _pref.setString('token', userCredential.user!.getIdToken().toString());

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BottomNavigationPage(data: snap),
                ),
                    (route) => false,
              );
            }
          } else if (snapshot['usertype'] == "shop") {
            print("am here jobin");
            var snap = await FirebaseFirestore.instance.collection('shops').doc(userCredential.user!.uid).get();

            if (snap != null) {
              SharedPreferences _pref = await SharedPreferences.getInstance();
              _pref.setString('uid', userCredential.user!.uid);
              _pref.setString('email', snap['email']);
              _pref.setString('name', snap['shopname']);
              _pref.setString('phone', snap['phone']);
              _pref.setString('type', "user");
              _pref.setString('img', "assets/img/profile.png");
              _pref.setString('address', snap['address']);
              _pref.setString('account', snap['accountinfo']);
              _pref.setString('license', snap['licenceno']);
              _pref.setString('egst', snap['gst']);

              _pref.setString('type', "shop");
              _pref.setString('location', "location");
              _pref.setString('token', userCredential.user!.getIdToken().toString());

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ShopHomePage(),
                ),
                    (route) => false,
              );
            }
          }

          else if (snapshot['usertype'] == "employee") {
            print("am here jobin");
            var snap = await FirebaseFirestore.instance.collection('employees').doc(userCredential.user!.uid).get();

            if (snap != null) {
              SharedPreferences _pref = await SharedPreferences.getInstance();
              _pref.setString('uid', userCredential.user!.uid);
              _pref.setString('email', snap['email']);
              _pref.setString('name', snap['name']);
              _pref.setString('phone', snap['phone']);
              _pref.setString('type', "emloyee");
              _pref.setString('img', "assets/img/profile.png");
              _pref.setString('address', snap['address']);
              _pref.setString('account', snap['accountInfo']);
              _pref.setString('jobtype', snap['jobType']);
              _pref.setString('shopid', snap['shopId']);

             // _pref.setString('type', "shop");
              _pref.setString('location', "location");
              _pref.setString('token', userCredential.user!.getIdToken().toString());

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MechanicHome(),
                ),
                    (route) => false,
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login Failed"),
            ),
          );
        }
      }
    } catch (e) {

      var err=e.toString().split("]")[0];
      print("Firebase Exception: $e");
      print("Firebase Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Firebase Exception: $err"),
        ),
      );
    }

  }
}
