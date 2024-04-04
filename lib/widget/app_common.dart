import 'package:flutter/material.dart';

InputDecoration inputDecoration (BuildContext context,{
  String? hintText,
  EdgeInsets? contentPadding,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Widget? prefix,
  Widget? suffix,
  TextStyle? hintStyle,
  OutlineInputBorder? enabledBorder,
  OutlineInputBorder? errorBorder,
  BoxConstraints? constraints,


  Color? fillcolor,
  bool? bool
}){
  return InputDecoration(
    constraints: constraints,
    hintStyle: hintStyle,
    filled: bool,
    fillColor: fillcolor,
    suffix: suffix,
    prefix: prefix,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
  contentPadding: contentPadding ?? EdgeInsets.all(17),
  hintText: hintText,
  enabledBorder: enabledBorder ?? OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color:Colors.grey),
  ),
  border: OutlineInputBorder(
  borderRadius:BorderRadius.circular(15),
  borderSide: BorderSide(color: Colors.grey),
  ),
  focusedBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: Colors.black),
  ),
  errorBorder: errorBorder ?? OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: Colors.red),
  ),
  );
}

AppBar appBar(BuildContext context,{
  Function()? onTap,
  Widget? icn,
  Widget? bgclr,
  Widget? titleWidget,
  Widget? actions,
  String? title,
  TextStyle? style,
  Color? bottomColor ,
  PreferredSizeWidget? bottom,

}){
  return AppBar(
    centerTitle: true,
    bottom: bottom ?? PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: Container(
        height: 1,
        color: bottomColor ??  Colors.grey,
      ),
    ),

    forceMaterialTransparency: true,
    elevation: 0,
    title: titleWidget ?? Center(child: Text( '$title',
      style: style?? TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    )),
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap?? (){
          Navigator.of(context).pop();
        },
        child: Container(
          width: 48,
          height: 48,
          child: icn?? Icon(Icons.arrow_back, size: 24, color: Colors.black,),
          decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle
          ),
        ),
      ),
    ),
    actions: [ actions ?? SizedBox(width: 60,)],
  );
}

BoxDecoration boxDecoration(BuildContext context, {
  BoxBorder? border,
  Color? clr,
  // Color? bdrclr,
  BorderRadius? borderRadius,
  LinearGradient? gradient
}){
  return BoxDecoration(
    gradient: gradient,
  borderRadius: borderRadius ?? BorderRadius.circular(15),
  border: border?? Border.all(color: Colors.grey),
  color: clr?? Colors.blue,
  );
}

InputDecoration input2Decoration (BuildContext context,{
  String? hintText,
  EdgeInsets? contentPadding,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Widget? prefix,
  Widget? suffix,
  TextStyle? hintStyle,
  OutlineInputBorder? enabledBorder,
  OutlineInputBorder? errorBorder,
  BoxConstraints? constraints,
  Color? fillcolor,
  bool? filled
}){
  return InputDecoration(
    constraints: constraints,
    hintStyle: hintStyle,
    filled: filled,
    fillColor: fillcolor,
    suffix: suffix,
    prefix: prefix,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    contentPadding: contentPadding ?? EdgeInsets.all(17),
    hintText: hintText,
    enabledBorder: enabledBorder ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color:Colors.blue),
    ),
    border: OutlineInputBorder(
      borderRadius:BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.blue),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.blue),
    ),
    errorBorder: errorBorder ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.red),
    ),
  );
}

BoxDecoration box2Decoration(BuildContext context, {
  BoxBorder? border,
  Color? clr,
  BorderRadius? borderRadius,
  LinearGradient? gradient
}){
  return BoxDecoration(
    gradient: gradient,
    borderRadius: borderRadius ?? BorderRadius.circular(15),
    border: border?? Border.all(color: Colors.blue),
    color: clr,
  );
}