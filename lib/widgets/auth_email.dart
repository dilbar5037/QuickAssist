// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'package:learningappproejct/application/auth/models/user_model.dart';
// import 'package:learningappproejct/application/auth/widget/customtextformfiled.dart';
// import 'package:learningappproejct/application/core/constants/colors.dart';
// import 'package:learningappproejct/application/core/constants/padding.dart';
// import 'package:learningappproejct/application/core/utils/image_widget.dart';
//
//
//
//
//
//
// class EmailAuthView extends StatefulWidget {
//   const EmailAuthView({super.key});
//
//   @override
//   State<EmailAuthView> createState() => _EmailAuthViewState();
// }
//
// class _EmailAuthViewState extends State<EmailAuthView> {
//   TextEditingController _emailController = TextEditingController();
//
//   TextEditingController _passController = TextEditingController();
//
//   final _loginKey=GlobalKey<FormState>();
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themedata = Theme.of(context);
//
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(),
//       body: Container(
//           padding: contPadding,
//           height: double.infinity,
//           width: double.infinity,
//           child: CustomScrollView(
//             slivers: [
//               SliverFillRemaining(
//                 hasScrollBody: false,
//                 child: Form(
//                   key: _loginKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const ImageWidget(
//                           height: 250, width: 250, imgpath: 'login.png'),
//                       Text(
//                         "Login with Email",
//                         style: Theme.of(context).textTheme.displayLarge,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       CustomTextFormField(
//                           validator: (value){
//                             if(value!.isEmpty){
//
//                               return "Email is mandatory";
//                             }
//                           },
//                           controller: _emailController,
//                           hintText: "Enter Email"),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       CustomTextFormField(
//                           validator: (value){
//                             if(value!.isEmpty){
//
//                               return "Password is mandatory";
//                             }
//                           },
//                           obscureText: true,
//                           controller: _passController,
//                           hintText: "Password"),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           if(_loginKey.currentState!.validate()){
//                             print(_emailController.text.trim());
//                             print(_passController.text.trim());
//                             UserModel user=UserModel(
//
//                               email: _emailController.text,
//                               password: _passController.text,
//
//                             );
//
//
//
//                           }
//                         },
//                         onDoubleTap: () {},
//                         onLongPress: () {},
//                         child: Container(
//                           height: 55,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: AppColors.btnPrimaryColor),
//                           child: Center(
//                             child: Text(
//                               "Continue with Email",
//                               style: themedata.textTheme.bodyLarge,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Not a Memeber ?",
//                             style: themedata.textTheme.bodyLarge,
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           InkWell(
//                               onTap: () {
//                                 Navigator.pushNamed(
//                                     context, '/emailregister');
//                               },
//                               child: Text(
//                                 "Register",
//                                 style: themedata.textTheme.bodyLarge,
//                               ))
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           )),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickassitnew/admin/admin_home_page.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/models/user_model.dart';
import 'package:quickassitnew/services/userservice.dart';
import 'package:quickassitnew/widgets/appbutton.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/customtextformfiled.dart';
import 'package:quickassitnew/widgets/errorpage.dart';
import 'package:quickassitnew/user/userregistration.dart';
import 'package:shared_preferences/shared_preferences.dart';




class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // --------Text Editing Controllers..................................
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  //..............End of  TextEditing Controllers......................

  //----------Form key........................
  final _loginKey = GlobalKey<FormState>();


  // Service class and model class objects
  UserService _userService = UserService();
  UserModel _user = UserModel();

  //loading state variable
  bool _isLoading = false;
// function to handle login
  void _login() async {
    setState(() {
      _isLoading = true;
    });
    _user = UserModel(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim());

    try {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(Duration(seconds: 4));
      DocumentSnapshot data = await _userService.loginUser(_user);

      print(data['usertype']);
      var _type = data['usertype'];

      if (_type == "admin" ) {
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => AdminHomePage()),
        //         (route) => false);
      }else if(_type=="user" && data['status']==1){
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => BottomNavigationBarPage()),
        //         (route) => false);
      }
      else if(_type=="teacher" && data['status']==1){
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => TeacherHome()),
        //         (route) => false);
      }
      else{
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ErrorPage(errorMessage: "Contact Administrator")),
                (route) => false);
      }



      // Navigate to the next page after registration is complete
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      List err = e.toString().split("]");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.primaryColor,
          duration: Duration(seconds: 3),
          content: Container(
              height: 85,
              child: Center(
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.amber,
                          child: Icon(
                            Icons.warning,
                            color: Colors.white,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: Text(err[1].toString())),
                    ],
                  )))));
    }

    // Simulate registration delay
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(

          ),
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                          color: AppColors.contColor5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5.0,
                          child: Form(
                            key: _loginKey,
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              height: size.height * 0.40,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 30,),

                                  SizedBox(height: 30,),
                                  RichText(
                                    text: TextSpan(
                                      text: "Hey, ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 26,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Happy to see you again',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textColor2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomTextFormField(
                                    controller: _usernameController,
                                    hintText: 'Enter your username',
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a username';
                                      }
                                      return null;
                                    },
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue),
                                    ),
                                    prefixIcon: const Icon(Icons.person),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _usernameController.clear();
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomTextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    hintText: 'Enter your Password',
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a valid Password';
                                      }
                                      return null;
                                    },
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blue),
                                    ),
                                    prefixIcon: const Icon(Icons.person),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: AppButton(
                                      onTap: () async {
                                        if (_loginKey.currentState!.validate()) {
                                          if (_usernameController.text.trim() ==
                                              "admin@gmail.com" &&
                                              _passwordController.text.trim() ==
                                                  "12345678") {
                                            SharedPreferences _pref =
                                            await SharedPreferences
                                                .getInstance();
                                            _pref.clear();

                                            _pref.setString(
                                                'token', "admin@gmail.com");
                                            _pref.setString('name', "admin");
                                            _pref.setString('phone', "9847543117");
                                            _pref.setString('type', "admin");

                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdminHomePage()),
                                                    (route) => false);
                                          } else {
                                            _login();
                                          }
                                        }
                                      },
                                      text: "Login",
                                      height: 45,
                                      width: 250,
                                      color: AppColors.btnColor,
                                      child: Center(
                                        child: AppText(
                                          data: "Login",
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 100,
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppText(
                                      data: "Don't have an account?",
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserRegistrationScreen()));
                                        },
                                        child: AppText(
                                          data: "Sign up",
                                          color: Colors.white,
                                          fw: FontWeight.bold,
                                          size: 18,
                                        ))
                                  ],
                                )),
                          ))
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _isLoading,
                child: Center(
                  child: Lottie.asset('assets/json/loading.json'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
