





import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickassitnew/common/login_page.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/constans/text.dart';
import 'package:quickassitnew/models/user_model.dart';
import 'package:quickassitnew/services/userservice.dart';
import 'package:quickassitnew/widgets/appbutton.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/customtextformfiled.dart';

class UserRegistrationScreen extends StatefulWidget {
  final bool? fromadmin;
  const UserRegistrationScreen({Key? key,this.fromadmin}) : super(key: key);

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  // --------Text Editing Controllers..................................
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _builtinController = TextEditingController();
  //..............End of  TextEditing Controllers......................

  String?jobPlace;
  //----------Form key........................
  final _regKey = GlobalKey<FormState>();
  //---------End of Form Key.........----------

  UserService _userService = UserService();

  bool _isLoading = false;

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    UserModel user = UserModel(
        name: _nameController.text,
        phone: _contactController.text,
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        location: jobPlace,

        imgurl:"null"

    );

    try {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(Duration(seconds: 4));
      await _userService.registerUser(user).then((value) =>
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage())));

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
    final themedata=Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(

      ),
      body: SafeArea(
        child: Container(
            height: double.infinity,
            decoration:  BoxDecoration(


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
                              key: _regKey,
                              child: Container(
                                margin: const EdgeInsets.all(20),
                               // height: size.height * 0.70,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20,),

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
                                            text: 'Create an account ',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textColor1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextFormField(

                                      controller: _usernameController,
                                      hintText: 'Enter your Email',
                                      validator: (value) {

                                        if(value!.isEmpty){
                                          return 'Required Field';
                                        }
                                        var pattern =
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                        RegExp regex = new RegExp(pattern);
                                        if (!regex.hasMatch(value!))
                                        {
                                          return 'Email format is invalid';
                                        }

                                        else
                                        {
                                          return null;
                                        }
                                      },
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.blue),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.clear,color:Colors.black,),
                                        onPressed: () {
                                          _usernameController.clear();
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      controller: _nameController,
                                      hintText: 'Enter name',
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter name';
                                        }
                                        return null;
                                      },
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.blue),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.clear,color:Colors.black,),
                                        onPressed: () {
                                          _nameController.clear();
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      controller: _contactController,
                                      hintText: 'Enter Your Phone No',
                                      validator: (value) {
                                        if(value!.length!=10 || num.parse(value)==null)
                                          return'INVALID PHONE NUMBER';
                                        else
                                          return null;
                                      },
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.blue),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.clear,color:Colors.black,),
                                        onPressed: () {
                                          _contactController.clear();
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
                                        if(value!.length<8) {
                                          return('PASSWORD SHOULD CONTAIN ATLEAST 8 CHARACTERS');
                                        } else
                                          return null;

                                      },
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.blue),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),

                                    DropdownButtonFormField<String>(
                                      style: TextStyle(color: Colors.white),
                                      dropdownColor: AppColors.scaffoldColor,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.white)
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.white)
                                        )
                                        ,

                                        hintText: "Select City",
                                        hintStyle: TextStyle(color: Colors.white60,fontSize: 12),
                                      ),

                                      isExpanded: true,
                                      value: jobPlace,
                                      onChanged: (value) {
                                        setState(() {
                                          jobPlace = value;
                                        });
                                      },
                                      items: places.map((place) {
                                        return DropdownMenuItem<String>(
                                          value: place,
                                          child: Text(place.toString()),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: AppButton(
                                        child: Center(
                                            child: AppText(
                                                data: "Register",
                                                color: Colors.white
                                            )),
                                        height: 45,
                                        width: 250,
                                        color: AppColors.btnPrimaryColor,
                                        onTap: () {
                                          if (_regKey.currentState!.validate()) {
                                            _register();
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        widget.fromadmin==true?SizedBox():Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              data: "Already Have an Account?",
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: AppText(
                                  data: "Login",
                                  color: Colors.white,
                                  fw: FontWeight.bold,
                                  size: 18,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     InkWell(
                        //         onTap: () {
                        //           // Navigator.push(
                        //           //     context,
                        //           //     MaterialPageRoute(
                        //           //         builder: (context) => HouseOwnerRegistrationScreen()));
                        //         },
                        //         child: AppText(
                        //           data: "Register as House Owner",
                        //           color: Colors.white,
                        //           fw: FontWeight.bold,
                        //           size: 16,
                        //         )),
                        //     SizedBox(
                        //       width: 5,
                        //     ),
                        //     Container(
                        //       height: 30,
                        //       width: 30,
                        //       decoration: BoxDecoration(
                        //           //color: AppColors().primaryColor,
                        //           shape: BoxShape.circle),
                        //       child: Center(
                        //         child: Icon(
                        //           Icons.arrow_forward_ios,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // ),
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
            )),
      ),
    );
  }
}
