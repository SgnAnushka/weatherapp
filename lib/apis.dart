import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class square extends StatelessWidget {
  const square({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.all(8.0),
      child:Container(
        height:200,
        color: Colors.lightGreen,

      )


    );
  }
}
