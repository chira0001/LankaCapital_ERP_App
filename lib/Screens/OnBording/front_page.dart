import 'package:flutter/material.dart';
import 'package:nkrs_app/constrants/colors.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "Assets/logo.png",
          width: 250,
          fit:BoxFit.fill,
        ),
        SizedBox(height: 20,),
         Text("N.K.R.S\nLanka Capital",textAlign: TextAlign.center,style: TextStyle(fontSize: 35,color: kMainColor,decoration:TextDecoration.none,
              fontWeight: FontWeight.bold,fontFamily: 'MyCustomFont'),
         ),

      ],
    );
  }
}
