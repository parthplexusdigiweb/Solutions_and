import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Network/FirebaseApi.dart';
import '../../core/constants.dart';
import 'homescreentab.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String? loginErrorText;

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  var shouldObscurePassword = true;

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
    //  appBar:AppHelper().CustomAppBarForRetailHub(context),
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://e0.pxfuel.com/wallpapers/1/408/desktop-wallpaper-expo-2020-dubai-live-from-the-opening-ceremony.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 400,
            height: 400,
            child: Card(
              color: Colors.black,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0,bottom: 8),
                      child: Text("Admin Login ,",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: primaryColorOfApp,
                        fontWeight: FontWeight.bold,

                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Login using the admin credentials \nprovided to you",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w300

                      ),),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: userNameTextEditingController,
                        cursorColor: primaryColorOfApp,
                        onChanged: (value) {

                        },
                        style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,color: primaryColorOfApp,
                          ),
                          //errorText: userAccountSearchErrorText,
                          contentPadding: EdgeInsets.all(25),
                          hintText: "Enter your Username",
                          labelText: "Enter your Username",
                          errorStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),
                          enabledBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white12),
                              borderRadius: BorderRadius.circular(100)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white12),
                              borderRadius: BorderRadius.circular(100)),
                          //hintText: "e.g Abouzied",
                          labelStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white54),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: passwordTextEditingController,
                        cursorColor: primaryColorOfApp,
                        onChanged: (value) {

                        },
                        obscuringCharacter: "*",
                        obscureText: shouldObscurePassword,
                        style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,color: primaryColorOfApp,
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              onPressed: (){
                                shouldObscurePassword=!shouldObscurePassword;
                                setState(() {

                                });
                              },
                              icon:Icon(shouldObscurePassword?Icons.visibility:Icons.visibility_off,color: Colors.grey,),
                            ),
                          ),
                          //errorText: userAccountSearchErrorText,
                          contentPadding: EdgeInsets.all(25),
                          hintText: "Enter your password",
                          labelText: "Enter your password",
                          errorStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(100)),
                          enabledBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white12),
                              borderRadius: BorderRadius.circular(100)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white12),
                              borderRadius: BorderRadius.circular(100)),
                          //hintText: "e.g Abouzied",
                          labelStyle: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white54),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Visibility(child:Text(loginErrorText??"",style: TextStyle(color: Colors.red),),visible: loginErrorText!=null,),
                    InkWell(
                      onTap: () async {
                        String loginResponse = await ApiRepository().LoginAdminPanel(userNameTextEditingController.text,passwordTextEditingController.text);
                        if(loginResponse=="Success"){
                          ///Navigate to dashboard
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  HomeScreenTabs()),
                          );
                        }
                        else{
                          loginErrorText = loginResponse;
                          setState(() {
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: 60,
                        decoration: BoxDecoration(
                          color: primaryColorOfApp,
                          border: Border.all(color:primaryColorOfApp, width: 2.0),
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            style: GoogleFonts.montserrat(
                                textStyle:
                                Theme.of(context).textTheme.titleMedium,
                                color: Colors.black),
                          ),
                        ),
                      ),

                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
