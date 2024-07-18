import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/core/apphelper.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';
import 'package:thrivers/main.dart';
import 'package:thrivers/screens/new%20added%20screens/NewHomeScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/UserRegisterPage.dart';
import 'package:thrivers/screens/new%20added%20screens/thriverLandingScreen.dart';

class UserLoginPage extends StatefulWidget {


  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {

  TextEditingController loginTextEditingcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login Page'),
      // ),
      appBar: AppBar(
        backgroundColor: Color(0xff0B0B0B),
        leading: Text(""),
        centerTitle: true,
        title: InkWell(
          onTap: () {
            context.go('/');

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ThriverLandingScreen()),
            // );

          },
          child: Text("SOLUTION INCLUSION", style: GoogleFonts.montserrat(
              textStyle: Theme.of(context).textTheme.headlineLarge,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          ),
        ),
        // actions: [
        //   InkWell(
        //     onTap: () {
        //       context.go('/userRegister');
        //
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(builder: (context) => RegisterPage()),
        //       // );
        //     },
        //     child: Container(
        //         width: MediaQuery.of(context).size.width * 0.1,
        //         padding: EdgeInsets.all(15),
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(10),
        //             color: Colors.blue
        //         ),
        //         child: Text('Register',textAlign: TextAlign.center,style: GoogleFonts.montserrat(
        //             textStyle: Theme.of(context).textTheme.titleSmall,
        //             fontWeight: FontWeight.bold,
        //             color: Colors.white),)),
        //   ),
        //   SizedBox(width: 10,),
        //   // InkWell(
        //   //
        //   //   onTap: () {
        //   //     Navigator.push(
        //   //       context,
        //   //       MaterialPageRoute(builder: (context) => UserLoginPage()),
        //   //       // MaterialPageRoute(builder: (context) => AuthenticateLogin(loginToken: loginToken,)),
        //   //     );
        //   //   },
        //   //   child: Container(
        //   //       width: MediaQuery.of(context).size.width * 0.07,
        //   //       padding: EdgeInsets.all(15),
        //   //       decoration: BoxDecoration(
        //   //         color: Colors.blue,
        //   //         borderRadius: BorderRadius.circular(10),
        //   //       ),
        //   //       child: Text('Login',textAlign: TextAlign.center,style: GoogleFonts.montserrat(
        //   //           textStyle: Theme.of(context).textTheme.titleSmall,
        //   //           fontWeight: FontWeight.bold,
        //   //           color: Colors.white),)),
        //   // ),
        //   // SizedBox(width: 10,),
        //
        // ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 330,
              width: 420,
              // color: Colors.blue,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black,blurRadius: 10,),
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Solution Login', style:TextStyle(
                      fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('You will receive a link to login to your dashboard in your email ', style:TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                    child: TextField(
                      // maxLines: null,
                      controller: loginTextEditingcontroller,
                      cursorColor: Colors.white,
                      style: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                      onSubmitted: (value) {
                        sendEmail();
                      },
                      decoration: InputDecoration(
                        //errorText: userAccountSearchErrorText,
                        contentPadding: EdgeInsets.all(25),
                        labelText: "Email",
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.white),

                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.mail,
                              color: Colors.white
                          ),
                        ),

                        errorStyle: GoogleFonts.montserrat(
                            textStyle: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                            fontWeight: FontWeight.w400,
                            color: Colors.redAccent),

                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 4),
                            borderRadius: BorderRadius.circular(0)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,),
                            borderRadius: BorderRadius.circular(15)),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 2 ),
                            borderRadius: BorderRadius.circular(0)),
                        labelStyle: GoogleFonts.montserrat(
                            textStyle: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),

                  Center(
                    child: InkWell(
                      onTap: sendEmail,
                      child: Container(
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black,blurRadius: 10,),
                            ]
                        ),

                        child: Center(
                          child: Text("Login",
                            style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w900,fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendEmail()  async {
    final prefs = await SharedPreferences.getInstance();
    isloggedIn = await prefs.setBool('isLoggedIn', true);
    print("setBoolisloggedIn: $isloggedIn");
    if(loginTextEditingcontroller.text.isEmpty){showEmptyAlert2(context,"Enter Email to Login","","","OK");}
    else  if(!loginTextEditingcontroller.text.trim().isValidEmail()){
      showEmptyAlert2(context,"Enter a Valid Email","${loginTextEditingcontroller.text.trim()} is not a valid email address","${loginTextEditingcontroller.text}","Retype Email Address");
      // showDialog(
      //     context: context,
      //     barrierColor: Colors.black87,
      //     builder: (BuildContext context) {
      //       return Dialog(
      //         shape: RoundedRectangleBorder(
      //             borderRadius:
      //             BorderRadius.circular(0.0)), //this right here
      //         child: Container(
      //           height: 200,
      //           width: 350,
      //           child: Padding(
      //             padding: const EdgeInsets.all(12.0),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   children: [
      //                     Icon(Icons.error,color: Colors.red,size: 60,),
      //                     SizedBox(width: 20,),
      //                     Text("Enter a Valid Email",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
      //                       fontWeight: FontWeight.bold,
      //                     ),),
      //                   ],
      //                 ),
      //                 Text("${loginTextEditingcontroller.text.trim()} is not a valid email address",style: Theme.of(context).textTheme.labelMedium?.copyWith(
      //                 ),),
      //                 Row(
      //                   children: [
      //                     Icon(Icons.email,color:primaryColorOfApp,),
      //                     SizedBox(width: 20,),
      //                     Text(loginTextEditingcontroller.text,style: Theme.of(context).textTheme.labelMedium?.copyWith(
      //                     ),),
      //                   ],
      //                 ),
      //                 SizedBox(height: 10,),
      //                 SizedBox(
      //                   width: 320.0,
      //                   child: ElevatedButton(
      //                     style: ElevatedButton.styleFrom(
      //                       primary: Colors.black,
      //                     ),
      //                     onPressed: () {
      //                       Navigator.pop(context);
      //                       loginTextEditingcontroller.clear();
      //                     },
      //                     child: Text(
      //                       "Retype Email Address",
      //                       style: TextStyle(color: Colors.white),
      //                     ),
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //         ),
      //       );
      //     });
    }
    else {
      print("inside else:");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').
      where('email', isEqualTo: loginTextEditingcontroller.text.trim()).get();
      if (querySnapshot.docs.isNotEmpty) {

        print("inside querySnapshot: ${querySnapshot.docs.first.get("email")}");

        ProgressDialog.show(context, "Logging in\n${loginTextEditingcontroller.text}", Icons.ice_skating);

        QuerySnapshot newquerySnapshot = await FirebaseFirestore.instance.collection('Users').where('email', isEqualTo: loginTextEditingcontroller.text).where('isPPS', isEqualTo: false).limit(1).get();

        if(newquerySnapshot.docs.isNotEmpty){

          var userData = newquerySnapshot.docs.first;

          print("inside user: $userData");

          QuerySnapshot AboutMequerySnapshot = await FirebaseFirestore.instance.collection('AboutMe').orderBy('AB_id', descending: true).limit(1).get();
          var createdAt = DateFormat('yyyy-MM-dd, HH:mm').format(DateTime.now());
          int ids;
          if (AboutMequerySnapshot.size == 0) {
            // Collection doesn't exist, set 'AB_id' to 1 by default
            ids = 1;
          } else {
            final abc = AboutMequerySnapshot.docs.first;
            print("AB_id; ${abc['AB_id']}");
            print("AB_id; ${abc['AB_id'].runtimeType}");
            ids = abc['AB_id'] + 1;
          }
          Map<String, dynamic> AboutMEDatas = {
            'AB_id': ids,
            'Email': loginTextEditingcontroller.text,
            'User_Name': userData['UserName'],
            'Employer': userData['Employer'],
            'Division_or_Section': userData['Division_or_Section'],
            'Role': userData['Role'],
            'Location': userData['Location'],
            'Employee_Number': userData['Employee_Number'],
            'Line_Manager': userData['Line_Manager'],
            'isPPS': true,
            'isOS': false,
            // 'About_Me_Label': "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${userData['UserName']}_Personal Private Summary.pdf",
            'About_Me_Label': "PPS",
            'Purpose_of_report': "",
            'Purpose': "Others" ,
            'AB_Description' : "",
            'AB_Date' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
            'AB_Useful_Info' : "",
            'AB_Attachment' : "",
            'AB_Status' : "main",
            'My_Circumstance': "",
            'My_Strength': "",
            'My_Organisation': "",
            'My_Challenges_Organisation': "",
            'Solutions': [],
            'Challenges': [],
            "Created_By": userData['UserName'],
            "Created_Date": DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now()),
            "Modified_By": "",
            "Modified_Date": "",
            "Report_sent_to": [],
            "Report_sent_to_cc": [],
            // Add other fields as needed
          };

          String solutionJson = json.encode(AboutMEDatas);
          print(solutionJson);
          print("runtimeType :${AboutMEDatas.runtimeType}");
          // ProgressDialog.show(context, "Creating About Me", Icons.chair);
          var userdocs = await newquerySnapshot.docs.first.id;
          await ApiRepository().updateUserDetail({"isPPS": true},userdocs);
          var documentId = await ApiRepository().createAboutMe(AboutMEDatas);
        }
        ///
        // bool isLoginSuccessful = await ApiRepository().sendLoginMail(loginTextEditingcontroller.text);
        bool isLoginSuccessful = true;
        ///
        // bool isLoginSuccessful = true;
        // isloggedIn = true;
        ProgressDialog.hide();
        if (isLoginSuccessful) {
          // showEmptyAlert(context,"Email Sent\nSuccessfully\nYou Will Receive a link to login\nto your dashboard in your email",Icons.mark_email_read_outlined, Colors.green);
          // Navigator.pushReplacement(
          //   context,
          //   // MaterialPageRoute(builder: (context) =>  HomeScreenTabs()),
          //   MaterialPageRoute(builder: (context) =>  NewHomeScreenTabs()),
          // );
          showDialog(
            context: context,
            barrierColor: Colors.black87,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                actionsAlignment: MainAxisAlignment.center,
                content: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 60,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Email Sent Successfully",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    loginTextEditingcontroller.text,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "You will receive a link to login to your dashboard in your email",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Okay",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          );

        } else {
          showEmptyAlert(context, "Something went wrong",
              '', Icons.error, Colors.red);
        }
      } else {
        showEmptyAlert(
            context,
            "Email does not exist",
            'First, register your email to login',
            Icons.error,
            Colors.red);
      }
    }
  }

  void showEmptyAlert(context,message, message2,IconData icon, Color? color) {
    showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.2,
                vertical: MediaQuery.of(context).size.height * 0.04
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(0.0)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon,color: color,size: 60,),
                SizedBox(width: 20,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(message,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(message2,style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ],
                ),
              ],
            ),
/// ere@gmail.com
            actions: [
              SizedBox(
              width: 320.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                onPressed: () {
                  message == "Something went wrong" ? Navigator.pop(context) : context.go("/userRegister");

                },
                child: Text(
                  "Okay",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
            ],
          );
        });
  }

  void showEmptyAlert2(BuildContext context, String message, String message2, String message4, String message3) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          actionsAlignment: MainAxisAlignment.center,
          content: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 60,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        message2,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(),
                      ),
                      if (message4.isNotEmpty)
                        SizedBox(height: 10),
                      if (message4.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                message4,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  loginTextEditingcontroller.clear();
                },
                child: Text(
                  message3,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }



}
