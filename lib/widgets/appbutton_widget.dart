
import 'package:flutter/material.dart';

import 'package:quickassitnew/constans/colors.dart';



class AppButtonWidget extends StatelessWidget {

  const AppButtonWidget({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width:150,
      decoration: BoxDecoration(
          color: AppColors.btnPrimaryColor,
          borderRadius: BorderRadius.circular(20)

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Get Started",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),),
          SizedBox(width: 10,),
          Icon(Icons.arrow_forward,color: Colors.white,)
        ],
      ),
    );
  }
}