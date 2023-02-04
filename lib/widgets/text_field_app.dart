import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldApp extends StatelessWidget {
   TextFieldApp({
    super.key, required this.hintText, required this.color, required this.color1, required this.textInputType, required this.scure, required this.change,
  });
final String hintText;
final Color color;
final Color color1;
final TextInputType textInputType;
final bool scure;
 String ? change ;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value){
        change=value;
      },
      obscureText:scure ,
      keyboardType: textInputType,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(
              color: Colors.black
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: color,
                  width: 1
              )
          ),
        focusedBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: color1,
                width: 1
            )
        ),
      ),
    );
  }
}