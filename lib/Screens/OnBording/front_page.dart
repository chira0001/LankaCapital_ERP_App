import 'package:flutter/material.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("..\\..\\Assets\\0d17532a-6d28-47fc-ace8-1e878859b3fb.png",
        width: 100,
        fit: BoxFit.cover,
        
        ),
        SizedBox(height: 20,),
        Center(
          child: Text("N.K.R.S.Lanka Capital",
         ),
        )
      ],
    );
  }
}