
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrivers/screens/homescreentab.dart';
import 'package:thrivers/screens/new%20added%20screens/NewHomeScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/UserAboutMePage.dart';


import '../core/EncryptDecrypt.dart';
import '../core/constants.dart';
import '../main.dart';
import 'not used screen/landingscreen.dart';


class AuthenticateLogin extends StatefulWidget {

  final String loginToken;
var islogin;
  AuthenticateLogin({required this.loginToken,this.islogin});



  @override
  State<AuthenticateLogin> createState() => _AuthenticateLoginState();
}

class _AuthenticateLoginState extends State<AuthenticateLogin> {

  late Future authenticationFuture;

  @override
  void initState() {
    // TODO: implement initState
    authenticationFuture = authenticate();
    super.initState();
    _checkLoginStatus();
    print("authenticationFuture: ${widget.loginToken}");
  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
      builder: (ctx, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("ERROR 404",textScaleFactor: 10,),
                      Text("Unauthorized Access",textScaleFactor: 1,),
                      Text(snapshot.error.toString(),textScaleFactor: 1,),
                    ],
                  ),
                ),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data as String;
            print("The Email ID");
            print(data);
            if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(data) && isloggedIn==true){
            // if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(data)){
              WidgetsBinding.instance.addPostFrameCallback((_) {
              // var abc =  sharedPreferences?.setBool("isLoggedIn",true);
              // var www = sharedPreferences?.setString("userEmail",data);

              // print("abc www: ${abc}");
              // print("abc www: ${www}");
                // sharedPreferences?.setString("userEmail",data);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      // return NewHomeScreenTabs();
                      // return UserAboutMePage(isClientLogeddin: true, emailId: data, loginToken: widget.loginToken);
                      return UserAboutMePage(isClientLogeddin: isloggedIn, emailId: data, loginToken: widget.loginToken);
                    },
                  ),
                );
              }
              );
              return Container(
                color: Colors.black,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Loging in as\n$data",style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.headline5,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 20,),
                      Container(
                        child: Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            child:  CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(primaryColorOfApp),
                            ),
                            height: 100,
                            width: 100,
                          ),
                        ),
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(8.0),

                      )
                    ],
                  ),
                ),
              );
            } else{
              context.go('/userlogin');
            }
            return Scaffold(
              body: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("ERROR 404",textScaleFactor: 10,),
                      Text("Login Token Expired",textScaleFactor: 1,),
                    ],
                  ),
                ),
              ),
            );
          }
        }

        // Displaying LoadingSpinner to indicate waiting state
        return Container(
          color: Colors.black,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Please Wait\nAuthenticating",style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.headline5,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,
                ),
                SizedBox(width: 20,),
                Container(
                  child: Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      child:  CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColorOfApp),
                      ),
                      height: 100,
                      width: 100,
                    ),
                  ),
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(8.0),

                )
              ],
            ),
          ),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: authenticationFuture,
    );
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isloggedIn = prefs.getBool('isLoggedIn') ?? false;
      // isloggedIn = widget.islogin;
      // print("isloginislogin ${widget.islogin}");
      print("getBoolisloggedIn: $isloggedIn");
    });
  }
  Future<String> authenticate() async {
    print("widget.loginToken ${widget.loginToken}");
    Map valueMap = EncryptData.verifyToken(widget.loginToken);
    String loginResponse = valueMap["email"];
    print("loginResponse");
    print(loginResponse);
    // checkIfLoggedIn();
    // print(sharedPreferences?.getString('loginToken'));

    return loginResponse;

  }
}


class DemoHomePage extends StatefulWidget {
  final String emailAddress;
  const DemoHomePage({Key? key, required this.emailAddress}) : super(key: key);

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(child: Text("Welcome "+widget.emailAddress),),),
    );
  }
}
