import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/core/apphelper.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';
import 'package:thrivers/screens/new%20added%20screens/UserLoginPage.dart';
import 'package:thrivers/screens/new%20added%20screens/thriverLandingScreen.dart';

class RegisterPage extends StatefulWidget {


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailTextEditingController = TextEditingController();

  // TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  // TextEditingController nameController = TextEditingController();
  TextEditingController employerController = TextEditingController();
  TextEditingController divisionOrSectionController = TextEditingController();
  TextEditingController RoleController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  TextEditingController EmployeeNumberController = TextEditingController();
  TextEditingController LineManagerController = TextEditingController();
  TextEditingController NotesController = TextEditingController();
  TextEditingController searchbyCatcontroller = TextEditingController();
  TextEditingController searchbyTagcontroller = TextEditingController();

  String whoYouAre = "Job Seeker";

  List<String> listOfWhoYouAre = [
    "Job Seeker",
    "Employer",
    "Neurodiversity Champion with lived experience",
    "Neurodiversity Ally",
    "Other",
  ];

  TextEditingController descriptionTextEditingController = TextEditingController();

  String? emailErrorText;

  String? nameErrorText;

  var documentId;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  Future<void> registerUser() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Users').where('email', isEqualTo: emailTextEditingController.text.trim()).get();

      if (querySnapshot.docs.isNotEmpty) {

        showEmptyAlert(context,'Email Already Exists',Icons.mark_email_read , Colors.red);
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text('Email Already Exists'),
        //       content: Text('The provided email address is already registered.'),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: Text('OK'),
        //         ),
        //       ],
        //     );
        //   },
        // );
      } else {

        // UserCredential userCredential =
        // await _auth.createUserWithEmailAndPassword(
        //   email: emailTextEditingController.text.trim(),
        //   password: 'dummyPassword', // You should handle passwords securely
        // );

        await _firestore.collection('Users').doc().set({
          // 'User_uid': userCredential.user!.uid,
          'UserName': nameTextEditingController.text,
          'email': emailTextEditingController.text,
          // 'Description': descriptionTextEditingController.text,
          'isPPS': true,
          'Employer': employerController.text,
          'Division_or_Section': divisionOrSectionController.text,
          'Role': RoleController.text,
          'Location': LocationController.text,
          'Employee_Number': EmployeeNumberController.text,
          'Line_Manager': LineManagerController.text,
        });

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').orderBy('AB_id', descending: true).limit(1).get();
        var createdAt = DateFormat('yyyy-MM-dd, HH:mm').format(DateTime.now());
        int ids;
        if (querySnapshot.size == 0) {
          // Collection doesn't exist, set 'AB_id' to 1 by default
          ids = 1;
        } else {
          final abc = querySnapshot.docs.first;
          print("AB_id; ${abc['AB_id']}");
          print("AB_id; ${abc['AB_id'].runtimeType}");
          ids = abc['AB_id'] + 1;
        }
        Map<String, dynamic> AboutMEDatas = {
          'AB_id': ids,
          'Email': emailTextEditingController.text,
          'User_Name': nameTextEditingController.text,
          'Employer': employerController.text,
          'Division_or_Section': divisionOrSectionController.text,
          'Role': RoleController.text,
          'Location': LocationController.text,
          'Employee_Number': EmployeeNumberController.text,
          'Line_Manager': LineManagerController.text,
          'isPPS': true,
          'About_Me_Label': "${createdAt}_" + nameTextEditingController.text + "_PPS",
          'Purpose_of_report': "${createdAt}_" + nameTextEditingController.text + "_PPS",
          'Purpose': "Others" ,
          'AB_Description' : "",
          'AB_Date' : DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now()),
          'AB_Useful_Info' : "",
          'AB_Attachment' : "",
          'AB_Status' : "Draft",
          'My_Circumstance': "",
          'My_Strength': "",
          'My_Organisation': "",
          'My_Challenges_Organisation': "",
          'Solutions': [],
          'Challenges': [],
          "Created_By": nameTextEditingController.text,
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
        documentId = await ApiRepository().createAboutMe(AboutMEDatas);

        showEmptyAlert(context,'Registration Successful',Icons.mark_email_read , Colors.green);
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: Text('Registration Successful'),
        //       content: Text('You have successfully registered.'),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: Text('OK'),
        //         ),
        //       ],
        //     );
        //   },
        // );
      }
    } catch (e) {
      // Handle registration errors
      print('Error during registration: $e');
    }
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Register Page'),
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
          child: Text("SOLUTIONS", style: GoogleFonts.montserrat(
              textStyle: Theme.of(context).textTheme.headlineLarge,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          ),
        ),
        // actions: [
        //   // InkWell(
        //   //   onTap: () {
        //   //     Navigator.push(
        //   //       context,
        //   //       MaterialPageRoute(builder: (context) => RegisterPage()),
        //   //     );
        //   //   },
        //   //   child: Container(
        //   //       width: MediaQuery.of(context).size.width * 0.07,
        //   //       padding: EdgeInsets.all(15),
        //   //       decoration: BoxDecoration(
        //   //           borderRadius: BorderRadius.circular(10),
        //   //           border: Border.all(color: Colors.blue)
        //   //       ),
        //   //       child: Text('Register',textAlign: TextAlign.center,style: GoogleFonts.montserrat(
        //   //           textStyle: Theme.of(context).textTheme.titleSmall,
        //   //           fontWeight: FontWeight.bold,
        //   //           color: Colors.white),)),
        //   // ),
        //   SizedBox(width: 10,),
        //   InkWell(
        //     onTap: () {
        //       context.go('/userLogin');
        //       // showEmptyAlert(context,'Email Already Exists',Icons.mark_email_read , Colors.red);
        //
        //       // Navigator.push(
        //       //   context,
        //       //   MaterialPageRoute(builder: (context) => UserLoginPage()),
        //       //   // MaterialPageRoute(builder: (context) => AuthenticateLogin(loginToken: loginToken,)),
        //       // );
        //     },
        //     child: Container(
        //         width: MediaQuery.of(context).size.width * 0.07,
        //         padding: EdgeInsets.all(15),
        //         decoration: BoxDecoration(
        //           color: Colors.blue,
        //           borderRadius: BorderRadius.circular(10),
        //         ),
        //         child: Text('Login',textAlign: TextAlign.center,style: GoogleFonts.montserrat(
        //             textStyle: Theme.of(context).textTheme.titleSmall,
        //             fontWeight: FontWeight.bold,
        //             color: Colors.white),)),
        //   ),
        //   SizedBox(width: 10,),
        //
        // ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .85,
                width: MediaQuery.of(context).size.width * .5,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black,blurRadius: 10,),
                    ]
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Text('Register', style:GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.displayMedium,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                        child: TextField(
                          maxLines: null,
                          controller: nameTextEditingController,
                          cursorColor: Colors.white,
                            
                            
                          style: GoogleFonts.montserrat(
                              textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          decoration: InputDecoration(
                            //errorText: userAccountSearchErrorText,
                            contentPadding: EdgeInsets.all(10),
                            labelText: "Name",
                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.white),
                            
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.person,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                        child: TextField(
                          maxLines: null,
                          controller: emailTextEditingController,
                          cursorColor: Colors.white,
                            
                            
                          style: GoogleFonts.montserrat(
                              textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          decoration: InputDecoration(
                            
                            //errorText: userAccountSearchErrorText,
                            
                            contentPadding: EdgeInsets.all(10),
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
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                      //   child: TextField(
                      //     maxLines: 3,
                      //     // controller: editoriginaltextEditingController,
                      //     cursorColor: Colors.white,
                      //     style: GoogleFonts.montserrat(
                      //         textStyle: Theme
                      //             .of(context)
                      //             .textTheme
                      //             .bodyLarge,
                      //         fontWeight: FontWeight.w400,
                      //         color: Colors.white),
                      //     decoration: InputDecoration(
                      //       //errorText: userAccountSearchErrorText,
                      //       contentPadding: EdgeInsets.all(10),
                      //       // labelText: "Email",
                      //       hintText: "For what purpose? (Optional)",
                      //       hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                      //       errorStyle: GoogleFonts.montserrat(
                      //           textStyle: Theme
                      //               .of(context)
                      //               .textTheme
                      //               .bodyLarge,
                      //           fontWeight: FontWeight.w400,
                      //           color: Colors.redAccent),
                      //
                      //       focusedBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.white,width: 4),
                      //           borderRadius: BorderRadius.circular(0)),
                      //       border: OutlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.white,),
                      //           borderRadius: BorderRadius.circular(15)),
                      //       disabledBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.white),
                      //           borderRadius: BorderRadius.circular(15)),
                      //       enabledBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.white,width: 2 ),
                      //           borderRadius: BorderRadius.circular(0)),
                      //       labelStyle: GoogleFonts.montserrat(
                      //           textStyle: Theme
                      //               .of(context)
                      //               .textTheme
                      //               .bodyLarge,
                      //           fontWeight: FontWeight.w400,
                      //           color: Colors.white),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                        child: TextField(
                          controller: employerController,
                  
                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                  
                          },

                          style: GoogleFonts.montserrat(
                              textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          cursorColor: Colors.white,

                          decoration: InputDecoration(
                            //errorText: userAccountSearchErrorText,
                            contentPadding: EdgeInsets.all(10),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.add_home_work,
                                  color: Colors.white
                              ),
                            ),
                            // labelText: "Email",
                            hintText: "Employer",
                            hintStyle: TextStyle(color: Colors.white, fontSize: 15),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                        child: TextField(
                          controller: divisionOrSectionController,
                          cursorColor: Colors.white,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                  
                          },
                          style: GoogleFonts.montserrat(
                              textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          decoration: InputDecoration(
                            //errorText: userAccountSearchErrorText,
                            contentPadding: EdgeInsets.all(10),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.account_balance,
                                  color: Colors.white
                              ),
                            ),

                            // labelText: "Email",
                            hintText: "Division or section",
                            hintStyle: TextStyle(color: Colors.white, fontSize: 15),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                        child: TextField(
                          controller: RoleController,
                          cursorColor: Colors.white,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                  
                          },
                          style: GoogleFonts.montserrat(
                              textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.task,
                                  color: Colors.white
                              ),
                            ),
                            contentPadding: EdgeInsets.all(10),
                            // labelText: "Division or section:",
                            hintText: "Role",
                            hintStyle: TextStyle(color: Colors.white, fontSize: 15),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                        child:  TextField(
                          controller: LocationController,
                          cursorColor: Colors.white,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                  
                          },
                          style: GoogleFonts.montserrat(
                              textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.location_history,
                                  color: Colors.white
                              ),
                            ),
                            contentPadding: EdgeInsets.all(10),
                            // labelText: "Division or section:",
                            hintText: "Location",
                            hintStyle: TextStyle(color: Colors.white, fontSize: 15),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                        child:   TextField(
                          controller: EmployeeNumberController,
                          cursorColor: Colors.white,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                  
                          },
                          style: GoogleFonts.montserrat(
                              textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.dialpad_rounded,
                                  color: Colors.white
                              ),
                            ),
                            // labelText: "Division or section:",
                            hintText: "Employee number",
                            hintStyle: TextStyle(color: Colors.white, fontSize: 15),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                        child: TextField(
                          controller: LineManagerController,
                          cursorColor: Colors.white,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                  
                          },
                          style: GoogleFonts.montserrat(
                              textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            // labelText: "Division or section:",
                            hintText: "Line manager ",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.manage_accounts,
                                  color: Colors.white
                              ),
                            ),
                            hintStyle: TextStyle(color: Colors.white, fontSize: 15),
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
                            
                      InkWell(
                        onTap: () async {
                          if(nameTextEditingController.text.isEmpty||emailTextEditingController.text.isEmpty||employerController.text.isEmpty
                              ||divisionOrSectionController.text.isEmpty||RoleController.text.isEmpty||LocationController.text.isEmpty
                              ||EmployeeNumberController.text.isEmpty||LineManagerController.text.isEmpty){
                            if(nameTextEditingController.text.isEmpty){showEmptyAlert2(context,"Enter Your Name","","","OK");}
                            else if(emailTextEditingController.text.isEmpty){showEmptyAlert2(context,"Enter Your Email\nto register","","","OK");}
                            else if(employerController.text.isEmpty){showEmptyAlert2(context,"Enter Your employer","","","OK");}
                            else if(divisionOrSectionController.text.isEmpty){showEmptyAlert2(context,"Enter Your division\nor section","","","OK");}
                            else if(RoleController.text.isEmpty){showEmptyAlert2(context,"Enter Your role","","","OK");}
                            else if(LocationController.text.isEmpty){showEmptyAlert2(context,"Enter Your location","","","OK");}
                            else if(EmployeeNumberController.text.isEmpty){showEmptyAlert2(context,"Enter Your employee number","","","OK");}
                            else if(LineManagerController.text.isEmpty){showEmptyAlert2(context,"Enter Your line manager","","","OK");}
                          }
                          else  if(!emailTextEditingController.text.trim().isValidEmail()){
                            showEmptyAlert2(context,"Enter a Valid Email","${emailTextEditingController.text.trim()} is not a valid email address",emailTextEditingController,"Retype Email Address");
                          }
                          else {
                            ProgressDialog.show(context, "Creating Your\nAccount", Icons.ice_skating);
                            await registerUser();
                            ProgressDialog.hide();
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
                            child: Text("Create My Account",
                            style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w900,fontSize: 15),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 25,),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void showEmptyAlert(context,message,IconData icon, Color? color) {
    showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(0.0)), //this right here
            insetPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.34,
                vertical: MediaQuery.of(context).size.height * 0.04
            ),
            content: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(icon,color: color,size: 60,),
                          SizedBox(width: 20,),
                          Flexible(
                            child: Text(message,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              SizedBox(
                // width: 320.0,
                width: MediaQuery.of(context).size.width ,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/userLogin');
                    nameTextEditingController.clear();
                    emailTextEditingController.clear();
                    employerController.clear();
                    divisionOrSectionController.clear();
                    RoleController.clear();
                    LocationController.clear();
                    EmployeeNumberController.clear();
                    LineManagerController.clear();
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

  void showEmptyAlert2(context, message, message2, message4, message3) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.35,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 60),
                      SizedBox(width: 20),
                      Flexible(
                        child: Text(
                          message,
                          style: Theme.of(context).textTheme.headline6?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Text(
                      message2,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(),
                    ),
                  ),
                  (message4 != "" || message4.toString().isNotEmpty)
                      ? Row(
                    children: [
                      Icon(
                        Icons.email,
                        color: primaryColorOfApp,
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: Text(
                          "${message4.text}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(),
                        ),
                      ),
                    ],
                  )
                      : Container(),
                ],
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  message4.clear();
                },
                child: Text(
                  message3,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        );
      },
    );
  }


//
  // checkSignInLink() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //
  //   // Get the incoming link
  //   final PendingDynamicLinkData? data =
  //   await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri deepLink = data?.link ?? Uri.parse('https://thriver-solutions.web.app/register');
  //
  //   // Check if the link is a sign-in link
  //   if (auth.isSignInWithEmailLink(deepLink.toString())) {
  //     // Extract the email from the link
  //     String email = deepLink.queryParameters['email']!;
  //
  //     // Use the email to sign in the user
  //     try {
  //       UserCredential userCredential =
  //       await auth.signInWithEmailLink(email: email, emailLink: deepLink.toString());
  //
  //       // If the user is successfully signed in, navigate back to the register screen
  //       if (userCredential.user != null) {
  //         _handleEmailVerification(email, deepLink.toString());
  //         Navigator.popUntil(context, ModalRoute.withName('/register'));
  //       }
  //     } catch (e) {
  //       // Handle sign-in errors
  //       print("Error signing in with email link: $e");
  //     }
  //   }
  // }
  //
  // void _handleEmailVerification(String email, String link) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailLink(
  //       email: email,
  //       emailLink: link,
  //     );
  //
  //     // Map<String,dynamic> data = {
  //     //   "Firstname":nameTextEditingController.text.trim(),
  //     //   // "Lastname":nameTextEditingController.text.trim(),
  //     //   "EmailAddress":emailTextEditingController.text.trim(),
  //     //   // "WhichAppliesToYou":whoYouAre,
  //     //   "Description":descriptionTextEditingController.text.trim(),
  //     //   // "ListOfBoughtTests":[],
  //     //   // "Invocies":[],
  //     //   // "Credits": "UNVERIFIEDEMAIL"
  //     // };
  //
  //     if (userCredential.user!.emailVerified) {
  //       await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
  //         'email': email,
  //       });
  //
  //       print('User email verification successful');
  //     } else {
  //       print('User email not verified');
  //     }
  //   } catch (e) {
  //     print('Error during email verification: $e');
  //   }
  // }

}
