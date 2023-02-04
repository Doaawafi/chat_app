
import 'package:flutter/material.dart';


class AppButton extends StatelessWidget {
  const AppButton({
    super.key, required this.color, required this.title, required this.onPressed,
  });
  final Color color;
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 10,
      borderRadius: BorderRadius.circular(15),
      child: MaterialButton(

        minWidth: double.infinity,
        height: 50,
        onPressed:onPressed,
        child:Text(title,style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),) ,
      ),
    );
  }
}