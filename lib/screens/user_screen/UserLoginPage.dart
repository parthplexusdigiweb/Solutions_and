import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/Provider/RegisterAndLoginProvider.dart';
import 'package:thrivers/core/apphelper.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';
import 'package:thrivers/main.dart';
import 'package:thrivers/screens/admin_screens/NewHomeScreen.dart';
import 'package:thrivers/screens/user_screen/UserRegisterPage.dart';
import 'package:thrivers/screens/new%20added%20screens/thriverLandingScreen.dart';
import 'package:toastification/toastification.dart';

class UserLoginPage extends StatefulWidget {


  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login Page'),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
      body: Form(
        key: _formKey,
        child: Consumer<LoginRegisterProvider>(
          builder: (c,loginRegisterProvider, _) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .49,
                    width: MediaQuery.of(context).size.width * .25,
                    // height: 330,
                    // width: 420,
                    // color: Colors.blue,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black,blurRadius: 10,),
                        ]
                    ),
                    child: SingleChildScrollView(
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
                            // child: Text('You will receive a link to login to your dashboard in your email ', style:TextStyle(
                            child: Text('Enter your email and password to login to your dashboard', style:TextStyle(
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
                              controller: emailcontroller,
                              cursorColor: Colors.white,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces
                              ],
                              style: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                              onSubmitted: (value) {
                                if(emailcontroller.text.isEmpty || passwordcontroller.text.isEmpty){
                                  if(emailcontroller.text.isEmpty){
                                    toastification.show(context: context,
                                        title: Text('enter email'),
                                        autoCloseDuration: Duration(milliseconds: 2500),
                                        alignment: Alignment.center,
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icon(Icons.error, color: Colors.white,),
                                        animationDuration: Duration(milliseconds: 1000),
                                        showProgressBar: false
                                    );
                                  }
                                  else if(passwordcontroller.text.isEmpty){
                                    toastification.show(context: context,
                                        title: Text('enter password'),
                                        autoCloseDuration: Duration(milliseconds: 2500),
                                        alignment: Alignment.center,
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icon(Icons.error, color: Colors.white,),
                                        animationDuration: Duration(milliseconds: 1000),
                                        showProgressBar: false
                                    );
                                  }
                                }
                               else  if (_formKey.currentState?.validate() ?? false) {
                                  userLogin();
                                };
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
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                            child: TextFormField(
                              // maxLines: null,
                              controller: passwordcontroller,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces
                              ],
                              cursorColor: Colors.white,
                              style: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                              onFieldSubmitted:  (value) {
                                if(emailcontroller.text.isEmpty || passwordcontroller.text.isEmpty){
                                  if(emailcontroller.text.isEmpty){
                                    toastification.show(context: context,
                                        title: Text('enter email'),
                                        autoCloseDuration: Duration(milliseconds: 2500),
                                        alignment: Alignment.center,
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icon(Icons.error, color: Colors.white,),
                                        animationDuration: Duration(milliseconds: 1000),
                                        showProgressBar: false
                                    );
                                  }
                                  else if(passwordcontroller.text.isEmpty){
                                    toastification.show(context: context,
                                        title: Text('enter password'),
                                        autoCloseDuration: Duration(milliseconds: 2500),
                                        alignment: Alignment.center,
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icon(Icons.error, color: Colors.white,),
                                        animationDuration: Duration(milliseconds: 1000),
                                        showProgressBar: false
                                    );
                                  }
                                }
                                else if (_formKey.currentState?.validate() ?? false) {
                                  userLogin();
                                };
                              },
                              obscureText: loginRegisterProvider.isVisible,
                              obscuringCharacter: "*",
                              decoration: InputDecoration(
                                //errorText: userAccountSearchErrorText,
                                contentPadding: EdgeInsets.all(25),
                                labelText: "Password",
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.password,
                                      color: Colors.white
                                  ),
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: Icon(
                                      loginRegisterProvider.isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white,),
                                    onPressed: loginRegisterProvider.toggleVisibility,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (!RegExp(r'\d').hasMatch(value)) {
                                  return 'Password must contain at least one digit';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 5,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                              Flexible(
                                child: InkWell(
                                  onTap: (){
                                      context.go("/forgetPassword");
                                    },
                                  child: Text("Forgot password?",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 15),
                                      maxLines: 1,
                                    ),
                                ),
                              )
                            ],),
                          ),
                          SizedBox(height: 25,),
                                    
                          Center(
                            child: InkWell(
                              onTap: () async {
                                // NewAlertBox(context, "Email does not exist", 'First, register your email to login', "Okay",);
                                if (_formKey.currentState?.validate() ?? false) {
                                  // sendEmail();
                                  userLogin();
                                }
                              },
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
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }


  userLogin() async {


          if (emailcontroller.text.isEmpty || passwordcontroller.text.isEmpty ||!emailcontroller.text.trim().isValidEmail()) {
        if (emailcontroller.text.isEmpty) {
          // showEmptyAlert2(context, "Enter Email to Login", "", "", "OK");
          NewAlertBox(context, "Enter Email to Login", '', "Ok",);

        }
        else if (passwordcontroller.text.isEmpty) {
          // showEmptyAlert2(context, "Enter password to Login", "", "", "OK");
          NewAlertBox(context, "Enter password to Login", '', "Ok",);
        }
        else if (!emailcontroller.text.trim().isValidEmail()) {
          // showEmptyAlert2(context, "Enter a Valid Email", "${emailcontroller.text.trim()} is not a valid email address", "${emailcontroller.text}", "Retype Email Address");
          NewAlertBox(context, "Enter a Valid Email", '${emailcontroller.text.trim()} is not a valid email address', "Retype Email Address",);
        }
      }
      else {
        print("inside else:");
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').
        where('email', isEqualTo: emailcontroller.text.trim()).get();
        if (querySnapshot.docs.isNotEmpty) {

          print("inside querySnapshot: ${querySnapshot.docs.first.get("email")}");

          ProgressDialog.show(context, "Logging in\n${emailcontroller.text}", Icons.ice_skating);

          QuerySnapshot newquerySnapshot = await FirebaseFirestore.instance.collection('Users').where('email', isEqualTo: emailcontroller.text).where('isPPS', isEqualTo: false).limit(1).get();

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
              'Email': emailcontroller.text,
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
          String loginResponse = await ApiRepository().userlogin(emailcontroller.text, passwordcontroller.text);
          if(loginResponse=="Success"){
            final prefs = await SharedPreferences.getInstance();
            isloggedIn = await prefs.setBool('isLoggedIn', true);
            emailId = await prefs.setString('emailId', emailcontroller.text.toString());
            print("setBoolisloggedIn: $isloggedIn");
            print("setStringemailId: $emailId");
            context.go("/userLogin/home");
          }
          else{
            NewAlertBox(context, "Something went wrong", 'email or password is incorrect', "Ok", );
            // showEmptyAlert(context, "Something went wrong", 'email or password is incorrect', Icons.error, Colors.red);
          }
          ProgressDialog.hide();
        } else {
          NewAlertBox(context, "Email does not exist", 'First, register your email to login', "Ok",);
          // showEmptyAlert(context, "Email does not exist", 'First, register your email to login', Icons.error, Colors.red);

        }
      }

  }

  void sendEmail()  async {
    final prefs = await SharedPreferences.getInstance();
    isloggedIn = await prefs.setBool('isLoggedIn', true);
    print("setBoolisloggedIn: $isloggedIn");
    if (emailcontroller.text.isEmpty) {
      showEmptyAlert2 (context,"Enter Email to Login","","","OK");
    }
    else if (!emailcontroller.text.trim().isValidEmail()){
      showEmptyAlert2(context,"Enter a Valid Email","${emailcontroller.text.trim()} is not a valid email address","${emailcontroller.text}","Retype Email Address");
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
      where('email', isEqualTo: emailcontroller.text.trim()).get();
      if (querySnapshot.docs.isNotEmpty) {

        print("inside querySnapshot: ${querySnapshot.docs.first.get("email")}");

        ProgressDialog.show(context, "Logging in\n${emailcontroller.text}", Icons.ice_skating);

        QuerySnapshot newquerySnapshot = await FirebaseFirestore.instance.collection('Users').where('email', isEqualTo: emailcontroller.text).where('isPPS', isEqualTo: false).limit(1).get();

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
            'Email': emailcontroller.text,
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
                                    emailcontroller.text,
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
          NewAlertBox(context, "Something went wrong", '', "Ok", );

          // showEmptyAlert(context, "Something went wrong",
          //     '', Icons.error, Colors.red);
        }
      } else {
        NewAlertBox(context, "Email does not exist", 'First, register your email to login', "Ok",);
        // showEmptyAlert(context, "Email does not exist", 'First, register your email to login', Icons.error, Colors.red);
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
                  emailcontroller.clear();
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
  
  void NewAlertBox(BuildContext ctx, String title, String content, String buttontxt1,) {
    showDialog(
        context: ctx,
        builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actionsAlignment: MainAxisAlignment.center,
          title: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.deepPurple, size: 60),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    if (content.isNotEmpty)
                      SizedBox(height: 10),
                    if (content.isNotEmpty)
                    Text(content,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (buttontxt1.isNotEmpty)  Expanded(
                  child: InkWell(
                    onTap:  () async {
                      if(title == "Enter Email to Login"){
                        try{
                          emailcontroller.clear();
                        Navigator.pop(context);
                        }
                        catch(e){
                          print("errorrrr: $e");
                        }
                      }
                     else if(title == "Enter password to Login"){
                        Navigator.pop(context);
                        passwordcontroller.clear();
                      }
                      else if(title == "Enter a Valid Email"){
                        Navigator.pop(context);
                        emailcontroller.clear();
                      }
                      else if(title == "Something went wrong" && content =="email or password is incorrect"){
                        Navigator.pop(context);
                      }
                      else if(title == "Email does not exist"){
                        context.go('/userRegister');
                      }
                      else Navigator.pop(context);
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(buttontxt1,style: TextStyle(color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,),),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }



}
