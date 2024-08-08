import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/Provider/AddKeywordsProvider.dart';
import 'package:thrivers/Provider/userAboutMeProvider.dart';
import 'package:thrivers/core/progress_dialog.dart';
import 'package:thrivers/model/soluton_table_model.dart';
import 'package:toastification/toastification.dart';

import '../../model/challenges_table_model.dart';

class EditAboutMe{


  TextEditingController searchEmailcontroller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController employerController = TextEditingController();
  TextEditingController divisionOrSectionController = TextEditingController();
  TextEditingController RoleController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  TextEditingController EmployeeNumberController = TextEditingController();
  TextEditingController LineManagerController = TextEditingController();
  TextEditingController mycircumstancesController = TextEditingController();
  TextEditingController AboutMeLabeltextController = TextEditingController();
  TextEditingController RefineController = TextEditingController();
  TextEditingController MystrengthsController = TextEditingController();
  TextEditingController myOrganisationController = TextEditingController();
  TextEditingController myOrganisation2Controller = TextEditingController();
  TextEditingController editNotesController = TextEditingController();
  TextEditingController editsearchbyCatcontroller = TextEditingController();
  TextEditingController editsearchChallengescontroller = TextEditingController();


  List<SolutionModel> solutions = [];
  List<ChallengesModel> Challenges = [];


  var selectedEmail ;
  var resultString ;

  List<String> emailList = [];

  List<Map<String, dynamic>> solutionsList = [];
  List<Map<String, dynamic>> challengesList = [];

  bool isInitialTyping = true;
  var documentId;

  List<dynamic> generatedtags = [];
  List<dynamic> generatedsolutionstags = [];
  List<dynamic> generatedcategory = [];
  List<dynamic> generatedsolutionscategory = [];

  _navigateToTab(int index) {
    // _tabController.animateTo(index);
  }


  Widget AboutmeFormpage(context,aboutMeData, emaillist) {

    emailList = emaillist;
    selectedEmail = aboutMeData['Email']==null ? "" : aboutMeData['Email'];
    searchEmailcontroller.text = aboutMeData['Email']==null ? "" : aboutMeData['Email'];
    nameController.text = aboutMeData['User_Name']==null ? "" : aboutMeData['User_Name'];
    employerController.text = aboutMeData['Employer']==null ? "" : aboutMeData['Employer'];
    divisionOrSectionController.text = aboutMeData['Division_or_Section']==null ? "" : aboutMeData['Division_or_Section'];
    RoleController.text = aboutMeData['Role']==null ? "" : aboutMeData['Role'];
    LocationController.text = aboutMeData['Location']==null ? "" : aboutMeData['Location'];
    EmployeeNumberController.text = aboutMeData['Employee_Number']==null ? "" : aboutMeData['Employee_Number'];
    LineManagerController.text = aboutMeData['Line_Manager']==null ? "" : aboutMeData['Line_Manager'];
    documentId = aboutMeData.id;

    // nameController.text = aboutMeData['User_Name'];
    // nameController.text = aboutMeData['User_Name'];
    print("aboutMeData['Email']: ${aboutMeData['Email']}");
    print("documentId: ${documentId}");
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("1. Personal Info",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black)),
          ),
          SizedBox(height: 10,),
          Container(
            height: MediaQuery.of(context).size.height * .68,
            decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black)
            ),
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("1. Email:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),

                  // DropdownSearch<String>(
                  //   popupProps: PopupProps.menu(
                  //     showSelectedItems: true,
                  //     isFilterOnline: true,
                  //     searchDelay: Duration(milliseconds: 100),
                  //     searchFieldProps: TextFieldProps(
                  //         enableSuggestions: true,
                  //         decoration: InputDecoration(
                  //           contentPadding: EdgeInsets.all(10),
                  //           hintText: "Search Email",
                  //           labelText: "Search Email",
                  //           errorStyle: GoogleFonts.montserrat(
                  //               textStyle: Theme
                  //                   .of(context)
                  //                   .textTheme
                  //                   .bodyLarge,
                  //               fontWeight: FontWeight.w400,
                  //               color: Colors.redAccent),
                  //           focusedBorder: OutlineInputBorder(
                  //               borderSide: BorderSide(color: Colors.black),
                  //               borderRadius: BorderRadius.circular(15)),
                  //           border: OutlineInputBorder(
                  //               borderSide: BorderSide(color: Colors.black12),
                  //               borderRadius: BorderRadius.circular(15)),
                  //           labelStyle: GoogleFonts.montserrat(
                  //               textStyle: Theme
                  //                   .of(context)
                  //                   .textTheme
                  //                   .bodyLarge,
                  //               fontWeight: FontWeight.w400,
                  //               color: Colors.black),
                  //         ),
                  //         controller: searchEmailcontroller
                  //     ),
                  //     showSearchBox: true,
                  //   ),
                  //   // items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                  //   items: emailList,
                  //   dropdownDecoratorProps: DropDownDecoratorProps(
                  //     dropdownSearchDecoration: InputDecoration(
                  //       contentPadding: EdgeInsets.all(10),
                  //       errorStyle: GoogleFonts.montserrat(
                  //           textStyle: Theme
                  //               .of(context)
                  //               .textTheme
                  //               .bodyLarge,
                  //           fontWeight: FontWeight.w400,
                  //           color: Colors.redAccent),
                  //       focusedBorder: OutlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.black),
                  //           borderRadius: BorderRadius.circular(15)),
                  //       border: OutlineInputBorder(
                  //           borderSide: BorderSide(color: Colors.black12),
                  //           borderRadius: BorderRadius.circular(15)),
                  //       labelStyle: GoogleFonts.montserrat(
                  //           textStyle: Theme
                  //               .of(context)
                  //               .textTheme
                  //               .bodyLarge,
                  //           fontWeight: FontWeight.w400,
                  //           color: Colors.black),
                  //     ),
                  //   ),
                  //   onChanged: (val){
                  //     setState(() {
                  //       selectedEmail = val!;
                  //     });
                  //     print("selectedEmail:${selectedEmail}");
                  //
                  //   },
                  //   selectedItem: selectedEmail,
                  //
                  //
                  // ),

                  Consumer<AddKeywordProvider>(
                      builder: (c,addKeywordProvider, _){
                        return TypeAheadField(
                          noItemsFoundBuilder: (ctx){
                            print("ccccc: $ctx");
                            return Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Hit Enter to add: ${searchEmailcontroller.text}",
                                    // (ApiRepository().isValidEmail(searchEmailcontroller.text)) ? "Hit Enter to add: ${searchEmailcontroller.text}@gmail.com" : "Invalid email format. Please enter a valid email address.",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                                  ),
                                )
                            );
                          },
                          suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              scrollbarTrackAlwaysVisible: true,
                              scrollbarThumbAlwaysVisible: true,
                              hasScrollbar: true,
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, )
                          ),
                          suggestionsCallback: (pattern) async {
                            if (pattern.isEmpty) {
                              // Return the full email list if the pattern is empty
                              return emailList;
                            } else {
                              // Return filtered suggestions based on the input pattern
                              return emailList.where((email) => email.contains(pattern)).toList();
                            }
                          },
                          itemBuilder: (context, String suggestion) {
                            return Container(
                              // color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(suggestion,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                              ),
                            );
                          },
                          onSuggestionSelected: (String suggestion) async {
                            searchEmailcontroller.text = suggestion;
                            selectedEmail = suggestion;
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: searchEmailcontroller,
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                            ),
                            onSubmitted: (value) {
                              if (ApiRepository().isValidEmail(value)) {
                                searchEmailcontroller.text = value;
                                selectedEmail = value;
                                if(selectedEmail != null){
                                  toastification.show(context: context,
                                      title: Text('Email Selected'),
                                      autoCloseDuration: Duration(milliseconds: 2500),
                                      alignment: Alignment.center,
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      icon: Icon(Icons.check_circle, color: Colors.white,),
                                      animationDuration: Duration(milliseconds: 1000),
                                      showProgressBar: false
                                  );
                                }

                              } else {
                                toastification.show(context: context,
                                    title: Text('Invalid email format. Please enter a valid email address.'),
                                    autoCloseDuration: Duration(milliseconds: 2500),
                                    alignment: Alignment.center,
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icon(Icons.error, color: Colors.white,),
                                    animationDuration: Duration(milliseconds: 1000),
                                    showProgressBar: false
                                );
                              }
                            },                            decoration:InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            errorStyle: GoogleFonts.montserrat(
                                textStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.redAccent),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(15)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(15)),
                            labelStyle: GoogleFonts.montserrat(
                                textStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          ),
                        );
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("2. Name:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
                    controller: nameController,

                    // cursorColor: primaryColorOfApp,
                    onChanged: (value) {

                    },
                    style: GoogleFonts.montserrat(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      // labelText: "Name",
                      hintText: "Name",
                      errorStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.redAccent),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(15)),
                      labelStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  // SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("3. Employer:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
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
                        color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      // labelText: "Employer",
                      hintText: "Employer",
                      errorStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.redAccent),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(15)),
                      labelStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  // SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("4. Division or section:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
                    controller: divisionOrSectionController,

                    // cursorColor: primaryColorOfApp,
                    onChanged: (value) {

                    },
                    style: GoogleFonts.montserrat(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      // labelText: "Division or section:",
                      hintText: "Division or section:",
                      errorStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.redAccent),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(15)),
                      labelStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  // SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("5. Role:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
                    controller: RoleController,

                    // cursorColor: primaryColorOfApp,
                    onChanged: (value) {

                    },
                    style: GoogleFonts.montserrat(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      // labelText: "Division or section:",
                      hintText: "Role",
                      errorStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.redAccent),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(15)),
                      labelStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  // SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("6. Location:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
                    controller: LocationController,

                    // cursorColor: primaryColorOfApp,
                    onChanged: (value) {

                    },
                    style: GoogleFonts.montserrat(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      // labelText: "Division or section:",
                      hintText: "Location",
                      errorStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.redAccent),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(15)),
                      labelStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  // SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("7. Employee number:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
                    controller: EmployeeNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                    // cursorColor: primaryColorOfApp,
                    onChanged: (value) {

                    },
                    style: GoogleFonts.montserrat(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      // labelText: "Division or section:",
                      hintText: "Employee number",
                      errorStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.redAccent),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(15)),
                      labelStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  // SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("8. Line manager:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
                    controller: LineManagerController,

                    // cursorColor: primaryColorOfApp,
                    onChanged: (value) {

                    },
                    style: GoogleFonts.montserrat(
                        textStyle: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      // labelText: "Division or section:",
                      hintText: "Line manager ",
                      errorStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.redAccent),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(15)),
                      labelStyle: GoogleFonts.montserrat(
                          textStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 10,),

                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // InkWell(
              //   onTap: (){
              //     // page.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
              //     selectedEmail = null;
              //             nameController.clear();
              //             employerController.clear();
              //             divisionOrSectionController.clear();
              //             RoleController.clear();
              //             LocationController.clear();
              //             EmployeeNumberController.clear();
              //             LineManagerController.clear();
              //             mycircumstancesController.clear();
              //             MystrengthsController.clear();
              //             mycircumstancesController.clear();
              //             solutionsList.clear();
              //             _userAboutMEProvider.solutionss.clear();
              //             _userAboutMEProvider.challengess.clear();
              //             _userAboutMEProvider.combinedResults.clear();
              //             _userAboutMEProvider.combinedSolutionsResults.clear();
              //             _userAboutMEProvider.isRecommendedChallengeCheckedMap.clear();
              //             _userAboutMEProvider.isRecommendedSolutionsCheckedMap.clear();
              //             generatedsolutionscategory.clear();
              //             generatedsolutionstags.clear();
              //             generatedtags.clear();
              //             generatedcategory.clear();
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 15),
              //     width: MediaQuery.of(context).size.width * .3,
              //     height: 60,
              //     decoration: BoxDecoration(
              //       //color: Colors.white,
              //       border: Border.all(
              //         //color:primaryColorOfApp ,
              //           width: 1.0),
              //       borderRadius: BorderRadius.circular(15.0),
              //     ),
              //     child: Center(
              //       child: Text(
              //         'Cancel',
              //         style: GoogleFonts.montserrat(
              //           textStyle:
              //           Theme
              //               .of(context)
              //               .textTheme
              //               .titleSmall,
              //           fontWeight: FontWeight.bold,
              //           //color: primaryColorOfApp
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 5, width: 5,),
              InkWell(
                onTap: () async{
                  // if(selectedEmail==null|| nameController.text.isEmpty || employerController.text.isEmpty || divisionOrSectionController.text.isEmpty || RoleController.text.isEmpty ||
                  //     LocationController.text.isEmpty || EmployeeNumberController.text.isEmpty || LineManagerController.text.isEmpty ){
                  //   if(selectedEmail==null){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(nameController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(employerController.text.isEmpty ){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(divisionOrSectionController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(RoleController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(LocationController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(EmployeeNumberController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(LineManagerController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  // }
                  // page.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

                  int x = 0;
                  x = x + 1;
                  var createdAt = DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now());

                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('AboutMe')
                      .orderBy('Created_Date', descending: true)
                      .limit(1)
                      .get();
                  final abc =   querySnapshot.docs.first;
                  print("AB_id; ${abc['AB_id']}");
                  print("AB_id; ${abc['AB_id'].runtimeType}");
                  var ids = abc['AB_id'] + 1;

                  Map<String, dynamic> AboutMEDatas = {
                    // 'AB_id': ids,
                    'Email': selectedEmail,
                    'User_Name': nameController.text,
                    'Employer': employerController.text,
                    'Division_or_Section': divisionOrSectionController.text,
                    'Role': RoleController.text,
                    'Location': LocationController.text,
                    'Employee_Number': EmployeeNumberController.text,
                    'Line_Manager': LineManagerController.text,
                    // 'About_Me_Label': AboutMeLabeltextController.text,
                    // 'My_Circumstance': mycircumstancesController.text,
                    // 'My_Strength': MystrengthsController.text,
                    // 'My_Organisation': myOrganisationController.text,
                    // 'My_Challenges_Organisation': myOrganisation2Controller.text,
                    // 'Solutions': solutionsList,
                    // 'Challenges': challengesList,
                    // // "Created_By": widget.AdminName,
                    // "Created_Date": createdAt,
                    "Modified_By": "",
                    "Modified_Date": createdAt,
                    // Add other fields as needed
                  };

                  String solutionJson = json.encode(AboutMEDatas);
                  print(solutionJson);

                  ProgressDialog.show(context, "Creating About Me", Icons.chair);
                  await ApiRepository().updateAboutMe(AboutMEDatas, documentId);
                  ProgressDialog.hide();
                  if (documentId != null) {
                    _navigateToTab(1);
                    print("Document ID: ${documentId.runtimeType}");
                  } else {
                    // Handle error if document creation failed
                  }
                  // print("ApiRepository().documentId : ${ApiRepository().documentId}");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width * .2,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(
                        color: Colors.blue,
                        width: 2.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Text(
                      'Save and Next',
                      style: GoogleFonts.montserrat(
                          textStyle:
                          Theme
                              .of(context)
                              .textTheme
                              .titleSmall,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget Detailspage(context,aboutMeData) {
    return SingleChildScrollView(
        child:Consumer<UserAboutMEProvider>(
            builder: (c,userAboutMEProvider, _){
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("2. Details",
                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black)),
                  ),
                  SizedBox(height: 10,),

                  Container(
                    height: MediaQuery.of(context).size.height * .68,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black)
                    ),
                    // height: MediaQuery.of(context).size.height * .7,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                            child: Text("Label: ", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,fontWeight: FontWeight.w600)),
                          ),

                          TextField(
                            controller: AboutMeLabeltextController,
                            style: GoogleFonts.montserrat(
                                textStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              // labelText: "Name",
                              hintText: "About Me Label",
                              errorStyle: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(15)),
                              labelStyle: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                            child: Text("1. About me and my circumstances:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                          ),
                          TextField(
                            controller: mycircumstancesController,
                            maxLines: 3,
                            // cursorColor: primaryColorOfApp,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final lines = value.split('\n');

                                for (int i = 0; i < lines.length; i++) {
                                  if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                                    lines[i] = '• ' + lines[i];
                                  }
                                }

                                mycircumstancesController.text = lines.join('\n');
                                mycircumstancesController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: mycircumstancesController.text.length),
                                );
                              } else {
                                isInitialTyping = true; // Reset when the text field becomes empty
                              }
                            },
                            style: GoogleFonts.montserrat(
                                textStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              // labelText: "Name",
                              hintText: "About me and my circumstances",
                              errorStyle: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(15)),
                              labelStyle: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                          // SizedBox(width: 10,),
                          // VerticalDivider(),
                          // SizedBox(width: 10,),
                          SizedBox(height: 10,),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                            child: Text("2. My strengths that I want to have the opportunity to use in my role:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                          ),
                          TextField(
                            controller: MystrengthsController,

                            maxLines: 3,

                            // cursorColor: primaryColorOfApp,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final lines = value.split('\n');

                                for (int i = 0; i < lines.length; i++) {
                                  if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                                    lines[i] = '• ' + lines[i];
                                  }
                                }

                                MystrengthsController.text = lines.join('\n');
                                MystrengthsController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: MystrengthsController.text.length),
                                );
                              } else {
                                isInitialTyping = true; // Reset when the text field becomes empty
                              }
                            },
                            style: GoogleFonts.montserrat(
                                textStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              // labelText: "Name",
                              hintText: "My strengths that I want to have the opportunity to use in my role",
                              errorStyle: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(15)),
                              labelStyle: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),


                          SizedBox(height: 10,),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                            child: Text("3. What I value about [my organisation] and workplace environment that helps me perform to my best:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                          ),
                          TextField(
                            controller: myOrganisationController,

                            maxLines: 3,


                            // onChanged: (value) {
                            //   if (value.isNotEmpty) {
                            //     final lines = value.split('\n');
                            //     final lastLine = lines.last;
                            //
                            //     if (isInitialTyping || (lastLine.trimLeft().startsWith('• ') && !lastLine.contains('• '))) {
                            //       isInitialTyping = false;
                            //       myOrganisationController.text = value.replaceAll('\n', '\n• ');
                            //       myOrganisationController.selection = TextSelection.fromPosition(
                            //         TextPosition(offset: myOrganisationController.text.length),
                            //       );
                            //     } else if (value.endsWith('\n')) {
                            //       // If the last character entered is a newline, append a bullet point
                            //       myOrganisationController.text += '• ';
                            //       myOrganisationController.selection = TextSelection.fromPosition(
                            //         TextPosition(offset: myOrganisationController.text.length),
                            //       );
                            //     }
                            //   } else {
                            //     isInitialTyping = true; // Reset when the text field becomes empty
                            //   }
                            // },

                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final lines = value.split('\n');

                                for (int i = 0; i < lines.length; i++) {
                                  if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                                    lines[i] = '• ' + lines[i];
                                  }
                                }

                                myOrganisationController.text = lines.join('\n');
                                myOrganisationController.selection = TextSelection.fromPosition(
                                  TextPosition(offset: myOrganisationController.text.length),
                                );
                              } else {
                                isInitialTyping = true; // Reset when the text field becomes empty
                              }
                            },


                            style: GoogleFonts.montserrat(
                                textStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              // labelText: "Name",
                              hintText: "What I value about [my organisation] and workplace environment that helps me perform to my best",
                              errorStyle: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(15)),
                              labelStyle: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),

                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                            child: Text("4. What I find challenging about [My Organisation] and the workplace environment that makes it harder for me to perform my best:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                          ),
                          TextField(
                            controller: myOrganisation2Controller,
                            keyboardType: TextInputType.multiline,
                            // onSubmitted: (_) => userAboutMEProvider.handleEnter(myOrganisation2Controller),

                            maxLines: 3,

                            // cursorColor: primaryColorOfApp,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final lines = value.split('\n');

                                for (int i = 0; i < lines.length; i++) {
                                  if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                                    lines[i] = '• ' + lines[i];
                                  }
                                }

                                myOrganisation2Controller.text = lines.join('\n');
                                myOrganisation2Controller.selection = TextSelection.fromPosition(
                                  TextPosition(offset: myOrganisation2Controller.text.length),
                                );
                              } else {
                                isInitialTyping = true; // Reset when the text field becomes empty
                              }
                            },
                            style: GoogleFonts.montserrat(
                                textStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              // labelText: "Name",
                              hintText: "What I find challenging about [My Organisation] and the workplace environment that makes it harder for me to perform my best",
                              errorStyle: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(15)),
                              labelStyle: GoogleFonts.montserrat(
                                  textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),

                          SizedBox(height: 10,),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // InkWell(
                      //   onTap: (){
                      //     // page.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                      //     _navigateToTab(0);
                      //     // Navigator.pop(context);
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(horizontal: 15),
                      //     width: MediaQuery.of(context).size.width * .3,
                      //     height: 60,
                      //     decoration: BoxDecoration(
                      //       //color: Colors.white,
                      //       border: Border.all(
                      //         //color:primaryColorOfApp ,
                      //           width: 1.0),
                      //       borderRadius: BorderRadius.circular(15.0),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         'Back',
                      //         style: GoogleFonts.montserrat(
                      //           textStyle:
                      //           Theme
                      //               .of(context)
                      //               .textTheme
                      //               .titleSmall,
                      //           fontWeight: FontWeight.bold,
                      //           //color: primaryColorOfApp
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 5, width: 5,),
                      InkWell(
                        onTap: () async{

                          // if(mycircumstancesController.text.isEmpty || MystrengthsController.text.isEmpty || myOrganisationController.text.isEmpty){
                          //   if(mycircumstancesController.text.isEmpty){
                          //     showEmptyAlert(context,"Add About me\nand my circumstance");
                          //   }
                          //   else if(MystrengthsController.text.isEmpty){
                          //     showEmptyAlert(context,"Add My strengths");
                          //   }
                          //   else if(myOrganisationController.text.isEmpty){
                          //     showEmptyAlert(context,"Add My organisation");
                          //   }
                          // }
                          {
                            var q1 = "1. About me and my circumstance: ${mycircumstancesController.text}";
                            var q2 = "2. My strengths that I want to have the opportunity to use in my role: ${MystrengthsController.text}";
                            var q3 = "3. What I value about [my organisation] and workplace environment that helps me perform to my best: ${myOrganisationController.text}";
                            //
                            // var defaulttext,defaulttextq2 ;
                            // defaulttext = q1+" "+ q2+" " +q3;//"${q1}+${q2}\n${q3}" ;
                            // // defaulttext = defaulttext +""+ "where xxx = ${originaltextEditingController.text.toString()}";
                            // defaulttext = "Generate tags in a one list with from :$defaulttext";
                            // // defaulttextq2 =  defaulttext + " and select category from "+"${resultString}";
                            // defaulttextq2 =  "These is a category list : ${resultString} . Choose the categories that describe this text : $defaulttext.";

                            var defaulttext = "Generate tags in a one list with ',' from :$q1 $q2 $q3";
                            //
                            // var defaulttext =  q1+""+q2+" "+q3 + " where yyy is "+mycircumstancesController.text+" "+ MystrengthsController.text +" "+myOrganisationController.text;


                            var defaulttextq2 = "These are the category list: $resultString. Choose the categories that describe this text: $defaulttext.";

                            // print(defaulttext);
                            print("defaulttextq2 $defaulttextq2");
                            // await getChatResponse(defaulttext,defaulttextq2);

                            // await getRelatedChallenges(generatedtags, generatedcategory);

                            // await page.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                            Map<String, dynamic> AboutMEDatas = {
                              'About_Me_Label': AboutMeLabeltextController.text,
                              'My_Circumstance': mycircumstancesController.text,
                              'My_Strength': MystrengthsController.text,
                              'My_Organisation': myOrganisationController.text,
                              'My_Challenges_Organisation': myOrganisation2Controller.text,
                              // Add other fields as needed
                            };

                            String solutionJson = json.encode(AboutMEDatas);
                            print(solutionJson);

                            ProgressDialog.show(context, "Saving", Icons.save);
                            await ApiRepository().updateAboutMe(AboutMEDatas,documentId);
                            ProgressDialog.hide();
                            await _navigateToTab(2);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width * .2,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                                color: Colors.blue,
                                width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                            child: Text(
                              'Save and Next',
                              style: GoogleFonts.montserrat(
                                  textStyle:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .titleSmall,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              );
            })
    );
  }

  Widget RecommendedChallengesListTile(context,challengesData, i, documentsss){

    return SingleChildScrollView(
        child: Consumer<UserAboutMEProvider>(
            builder: (c,userAboutMEProvider, _){
              // addKeywordProvider.getcategoryAndKeywords();
              // addKeywordProvider.newgetSource();
              // addKeywordProvider.getThriversStatus();
              ChallengesModel challengesModel;

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text("CH0${challengesData['id']}.",
                      Text("${challengesData['Label']}",
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black)),
                      // Checkbox(
                      //   activeColor: Colors.blue,
                      //   value: userAboutMEProvider.isRecommendedcCheckedForTileChallenge(documentsss![i]), // Use the state from the provider
                      //   // value: userAboutMEProvider.challengess[i].isChecked, // Use the state from the provider
                      //   onChanged: (value) {
                      //     userAboutMEProvider.isRecommendedClickedBoxChallenge(value, i, documentsss![i] );
                      //   },
                      //
                      // ),

                      InkWell(
                        onTap: (){
                          userAboutMEProvider.EditRecommendedChallengeAdd(true, documentsss![i]);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          width: MediaQuery.of(context).size.width * .05,
                          // width: MediaQuery.of(context).size.width * .15,

                          // height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue ,
                            border: Border.all(
                                color:Colors.blue ,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            // child: Icon(Icons.add, size: 30,color: Colors.white,),
                            child: Text(
                              'Add',
                              style: GoogleFonts.montserrat(
                                textStyle:
                                Theme
                                    .of(context)
                                    .textTheme
                                    .titleSmall,
                                fontWeight: FontWeight.bold,
                                color:Colors.white ,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),

                  // Text("${challengesData['Label']}",
                  //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                  //         fontSize: 25,
                  //         color: Colors.black)),

                  SizedBox(height: 5,),


                  Text("${challengesData['Final_description']}",
                      maxLines: 3,
                      style: GoogleFonts.montserrat(
                        // fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black)),
                  SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Impact : ",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black)),
                      SizedBox(height: 2,),
                      Expanded(
                        child: Text("${challengesData['Impact']}",
                            maxLines: 3,
                            style: GoogleFonts.montserrat(
                              // fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black)),
                      ),
                    ],
                  ),

                  // Text("Tags :",
                  //     style: GoogleFonts.montserrat(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //         color: Colors.black)),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Wrap(
                  //     spacing: 10,
                  //     runSpacing: 5,
                  //     crossAxisAlignment: WrapCrossAlignment.start,
                  //     alignment: WrapAlignment.start,
                  //     runAlignment: WrapAlignment.start,
                  //     children: (challengesData['tags'] as List<dynamic>).map<Widget>((item){
                  //       print("solutionDataitem: $item");
                  //       print("solutionData['tags']: ${challengesData['tags']}");
                  //       return Container(
                  //         height: 35,
                  //         // width: 200,
                  //         margin: EdgeInsets.only(bottom: 2),
                  //         padding: EdgeInsets.all(6),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //             color: Colors.blue
                  //         ),
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text("${item}", style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 14
                  //             ),),
                  //           ],
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                  //
                  // SizedBox(height: 5,),
                  //
                  // Text("Category :",
                  //     style: GoogleFonts.montserrat(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //         color: Colors.black)),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Wrap(
                  //     spacing: 10,
                  //     runSpacing: 5,
                  //     crossAxisAlignment: WrapCrossAlignment.start,
                  //     alignment: WrapAlignment.start,
                  //     runAlignment: WrapAlignment.start,
                  //     children: (challengesData['Keywords'] as List<dynamic>).map<Widget>((item){
                  //       print("solutionDataitem: $item");
                  //       print("solutionData['Keywords']: ${challengesData['Keywords']}");
                  //       return Container(
                  //         height: 35,
                  //         // width: 200,
                  //         margin: EdgeInsets.only(bottom: 2),
                  //         padding: EdgeInsets.all(6),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //             color: Colors.blue
                  //         ),
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text("${item}", style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 14
                  //             ),),
                  //           ],
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // )
                ],
              );
            })

    );
  }

  Widget RecommendedSolutionsListTile(context,solutionsData, i, documentsss){
    return SingleChildScrollView(
        child: Consumer<UserAboutMEProvider>(
            builder: (c,userAboutMEProvider, _){
              // addKeywordProvider.getcategoryAndKeywords();
              // addKeywordProvider.newgetSource();
              // addKeywordProvider.getThriversStatus();
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text("CH0${challengesData['id']}.",
                      Text("${solutionsData['Name']}",
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black)),
                      // Checkbox(
                      //   activeColor: Colors.blue,
                      //   value: userAboutMEProvider.isRecommendedcCheckedForTileSoltuions(documentsss![i]), // Use the state from the provider
                      //   onChanged: (value) {
                      //     userAboutMEProvider.isRecommendedClickedBoxSolutions(value, i, documentsss![i] );
                      //   },
                      // ),
                      InkWell(
                        onTap: (){
                          userAboutMEProvider.EditRecommendedSolutionAdd(true,  documentsss![i]);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          width: MediaQuery.of(context).size.width * .05,
                          // width: MediaQuery.of(context).size.width * .15,

                          // height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue ,
                            border: Border.all(
                                color:Colors.blue ,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            // child: Icon(Icons.add, size: 30,color: Colors.white,),
                            child: Text(
                              'Add',
                              style: GoogleFonts.montserrat(
                                textStyle:
                                Theme
                                    .of(context)
                                    .textTheme
                                    .titleSmall,
                                fontWeight: FontWeight.bold,
                                color:Colors.white ,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Text("${challengesData['Label']}",
                  //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                  //         fontSize: 25,
                  //         color: Colors.black)),

                  SizedBox(height: 5,),

                  Text("${solutionsData['Final_description']}",
                      maxLines: 3,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black)
                  ),

                  SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Impact : ",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black)),
                      SizedBox(height: 10,),
                      Expanded(
                        child: Text("${solutionsData['Impact']}",
                            // child: Text("hasduhsuiehdfuijhrediogotryou9ot6uy9it9puy9pt6y9phiopjfgiohguirhgv78tirinbtg8irty8iyivh5rthuiht89uyioveugrfuynvubotniugrufygtiburiufgnvrtguihirh",
                            maxLines: 3,
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black)),
                      ),
                    ],
                  ),

                  // Text("Tags :",
                  //     style: GoogleFonts.montserrat(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //         color: Colors.black)),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Wrap(
                  //     spacing: 10,
                  //     runSpacing: 5,
                  //     crossAxisAlignment: WrapCrossAlignment.start,
                  //     alignment: WrapAlignment.start,
                  //     runAlignment: WrapAlignment.start,
                  //     children: (challengesData['tags'] as List<dynamic>).map<Widget>((item){
                  //       print("solutionDataitem: $item");
                  //       print("solutionData['tags']: ${challengesData['tags']}");
                  //       return Container(
                  //         height: 35,
                  //         // width: 200,
                  //         margin: EdgeInsets.only(bottom: 2),
                  //         padding: EdgeInsets.all(6),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //             color: Colors.blue
                  //         ),
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text("${item}", style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 14
                  //             ),),
                  //           ],
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                  //
                  // SizedBox(height: 5,),
                  //
                  // Text("Category :",
                  //     style: GoogleFonts.montserrat(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //         color: Colors.black)),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Wrap(
                  //     spacing: 10,
                  //     runSpacing: 5,
                  //     crossAxisAlignment: WrapCrossAlignment.start,
                  //     alignment: WrapAlignment.start,
                  //     runAlignment: WrapAlignment.start,
                  //     children: (challengesData['Keywords'] as List<dynamic>).map<Widget>((item){
                  //       print("solutionDataitem: $item");
                  //       print("solutionData['Keywords']: ${challengesData['Keywords']}");
                  //       return Container(
                  //         height: 35,
                  //         // width: 200,
                  //         margin: EdgeInsets.only(bottom: 2),
                  //         padding: EdgeInsets.all(6),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //             color: Colors.blue
                  //         ),
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text("${item}", style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 14
                  //             ),),
                  //           ],
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // )

                ],

              );
            })

    );
  }

  // Widget AddChallengesPage(context) {
  //   var tags = ["Engineer", "Problem-solving", "Mechanical Engineering", "Automotive Industry", "Innovation", "Communication", "Organization", "Collaboration", "Teamwork", "Professional" "Growth"];
  //   var keywords = ["Mental & Emotional", "Physical", "Life"];
  //   var keywordss = ["Workspace", "Travel", "Communication"];
  //   return Container(
  //     height: MediaQuery.of(context).size.height,
  //     child: SingleChildScrollView(
  //         child:Consumer<UserAboutMEProvider>(
  //             builder: (c,userAboutMEProvider, _){
  //               return  Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   SizedBox(height: 5,),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 20.0),
  //                     child: Text("3. Challenges",
  //                         style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
  //                             fontSize: 30,
  //                             color: Colors.black)),
  //                   ),
  //                   SizedBox(height: 10,),
  //                   Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       InkWell(
  //                         onTap:(){
  //                           // showChallengesSelector();
  //                         },
  //                         child:Container(
  //                           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //                           // width: MediaQuery.of(context).size.width * .2,
  //                           width: MediaQuery.of(context).size.width * .15,
  //
  //                           // height: 60,
  //                           decoration: BoxDecoration(
  //                             color:Colors.blue ,
  //                             border: Border.all(
  //                                 color:Colors.blue ,
  //                                 width: 1.0),
  //                             borderRadius: BorderRadius.circular(15.0),
  //                           ),
  //                           child: Center(
  //                             // child: Icon(Icons.add, size: 30,color: Colors.white,),
  //                             child: Text(
  //                               'Browse',
  //                               style: GoogleFonts.montserrat(
  //                                 textStyle:
  //                                 Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleSmall,
  //                                 fontWeight: FontWeight.bold,
  //                                 color:Colors.white ,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: 15,),
  //                       InkWell(
  //                         onTap:(){
  //                           // showAddChallengesDialogBox();
  //                         },
  //                         child:Container(
  //                           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //                           // width: MediaQuery.of(context).size.width * .2,
  //                           width: MediaQuery.of(context).size.width * .15,
  //
  //                           // height: 60,
  //                           decoration: BoxDecoration(
  //                             // color:Colors.blue ,
  //                             border: Border.all(
  //                                 color:Colors.blue ,
  //                                 width: 1.0),
  //                             borderRadius: BorderRadius.circular(15.0),
  //                           ),
  //                           child: Center(
  //                             // child: Icon(Icons.add, size: 30,color: Colors.white,),
  //                             child: Text(
  //                               'Create My Own',
  //                               style: GoogleFonts.montserrat(
  //                                 textStyle:
  //                                 Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleSmall,
  //                                 fontWeight: FontWeight.bold,
  //                                 color:Colors.blue ,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: 15,),
  //
  //                     ],
  //                   ),
  //                   SizedBox(height: 10,),
  //
  //                   TextField(
  //                     controller: RefineController,
  //                     maxLines: 3,
  //                     onChanged: (value) {
  //                       if (value.isNotEmpty) {
  //                         final lines = value.split('\n');
  //
  //                         for (int i = 0; i < lines.length; i++) {
  //                           if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
  //                             lines[i] = '• ' + lines[i];
  //                           }
  //                         }
  //
  //                         RefineController.text = lines.join('\n');
  //                         RefineController.selection = TextSelection.fromPosition(
  //                           TextPosition(offset: RefineController.text.length),);
  //                         userAboutMEProvider.updateisRefinetextChange(false);
  //                         print("isRefinetextChange: ${userAboutMEProvider.isRefinetextChange}");
  //                       } else {
  //                         isInitialTyping = true; // Reset when the text field becomes empty
  //                         userAboutMEProvider.updateisRefinetextChange(false);
  //                         print("isRefinetextChange: ${userAboutMEProvider.isRefinetextChange}");
  //                       }
  //                     },
  //
  //                     style: GoogleFonts.montserrat(
  //                         textStyle: Theme
  //                             .of(context)
  //                             .textTheme
  //                             .bodyLarge,
  //                         fontWeight: FontWeight.w400,
  //                         color: Colors.black),
  //                     decoration: InputDecoration(
  //                       contentPadding: EdgeInsets.all(10),
  //                       // labelText: "Name",
  //                       hintText: "Search Challenges",
  //                       errorStyle: GoogleFonts.montserrat(
  //                           textStyle: Theme
  //                               .of(context)
  //                               .textTheme
  //                               .bodyLarge,
  //                           fontWeight: FontWeight.w400,
  //                           color: Colors.redAccent),
  //                       focusedBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(color: Colors.black),
  //                           borderRadius: BorderRadius.circular(15)),
  //                       border: OutlineInputBorder(
  //                           borderSide: BorderSide(color: Colors.black12),
  //                           borderRadius: BorderRadius.circular(15)),
  //                       labelStyle: GoogleFonts.montserrat(
  //                           textStyle: Theme
  //                               .of(context)
  //                               .textTheme
  //                               .bodyLarge,
  //                           fontWeight: FontWeight.w400,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                   SizedBox(height: 10,),
  //
  //                   (userAboutMEProvider.isRefinetextChange==true) ?
  //
  //                   InkWell(
  //                     onTap:() async {
  //
  //                       print("Refine.text: ${RefineController.text}");
  //
  //                       var defaulttext = "Generate related tags using this line in a one list with ',' :${RefineController.text}";
  //                       //
  //                       // var defaulttext =  q1+""+q2+" "+q3 + " where yyy is "+mycircumstancesController.text+" "+ MystrengthsController.text +" "+myOrganisationController.text;
  //
  //
  //                       var defaulttextq2 = "These are the category list: $resultString. Choose the categories that describe this text: $defaulttext.";
  //
  //                       // print(defaulttext);
  //                       print("defaulttextq2 $defaulttextq2");
  //
  //                       await getChatKeywordsResponse(defaulttext,defaulttextq2);
  //                       //
  //                       await userAboutMEProvider.getRelatedChallenges(generatedtags, generatedcategory);
  //
  //                     },
  //                     child:Container(
  //                       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //                       // width: MediaQuery.of(context).size.width * .2,
  //                       width: MediaQuery.of(context).size.width * .15,
  //
  //                       // height: 60,
  //                       decoration: BoxDecoration(
  //                         color:Colors.blue ,
  //                         border: Border.all(
  //                             color:Colors.blue ,
  //                             width: 1.0),
  //                         borderRadius: BorderRadius.circular(15.0),
  //                       ),
  //                       child: Center(
  //                         // child: Icon(Icons.add, size: 30,color: Colors.white,),
  //                         child: Text(
  //                           'Search',
  //                           style: GoogleFonts.montserrat(
  //                             textStyle:
  //                             Theme
  //                                 .of(context)
  //                                 .textTheme
  //                                 .titleSmall,
  //                             fontWeight: FontWeight.bold,
  //                             color:Colors.white ,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                       :
  //                   InkWell(
  //                     onTap:(){
  //                       var defaulttext = "Refine this sentence and give it in proper sentence";
  //
  //                       defaulttext = defaulttext +"=" +" ${RefineController.text}";
  //
  //                       getChatRefineResponse(defaulttext);
  //                     },
  //                     child:Container(
  //                       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //                       // width: MediaQuery.of(context).size.width * .2,
  //                       width: MediaQuery.of(context).size.width * .15,
  //
  //                       // height: 60,
  //                       decoration: BoxDecoration(
  //                         color:Colors.blue ,
  //                         border: Border.all(
  //                             color:Colors.blue ,
  //                             width: 1.0),
  //                         borderRadius: BorderRadius.circular(15.0),
  //                       ),
  //                       child: Center(
  //                         // child: Icon(Icons.add, size: 30,color: Colors.white,),
  //                         child: Text(
  //                           'Refine',
  //                           style: GoogleFonts.montserrat(
  //                             textStyle:
  //                             Theme
  //                                 .of(context)
  //                                 .textTheme
  //                                 .titleSmall,
  //                             fontWeight: FontWeight.bold,
  //                             color:Colors.white ,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //
  //
  //
  //                   SizedBox(height: 10,),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       // (userAboutMEProvider.combinedResults.isEmpty) ?
  //                       // Container(
  //                       //   // height: 350,
  //                       //   height: MediaQuery.of(context).size.height * .5,
  //                       //   width: MediaQuery.of(context).size.width * .46,
  //                       //
  //                       //   child: Column(
  //                       //       mainAxisAlignment: MainAxisAlignment.start,
  //                       //       crossAxisAlignment: CrossAxisAlignment.start,
  //                       //       children: [
  //                       //         Padding(
  //                       //           padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
  //                       //           child: Text("Shortlist (${userAboutMEProvider.combinedResults.length}):",
  //                       //             overflow: TextOverflow.ellipsis,
  //                       //             style: GoogleFonts.montserrat(
  //                       //                 textStyle: Theme.of(context).textTheme.titleLarge,
  //                       //                 fontWeight: FontWeight.bold,
  //                       //                 color: Colors.black),
  //                       //           ),
  //                       //         ),
  //                       //         SizedBox(height: 6,),
  //                       //       ]
  //                       //   ),
  //                       //   decoration: BoxDecoration(
  //                       //     border: Border.all(color: Colors.black),
  //                       //     borderRadius: BorderRadius.circular(20),
  //                       //   ),
  //                       // ) :
  //                       Container(
  //                         height: MediaQuery.of(context).size.height * .48,
  //                         width: MediaQuery.of(context).size.width * .46,
  //                         decoration: BoxDecoration(
  //                           border: (userAboutMEProvider.combinedResults.isEmpty) ?  Border.all(color: Colors.black) : Border.all(color: Colors.black),
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
  //                               child: Text("Shortlist (${userAboutMEProvider.combinedResults.length}):",
  //                                 overflow: TextOverflow.ellipsis,
  //                                 style: GoogleFonts.montserrat(
  //                                     textStyle: Theme.of(context).textTheme.titleLarge,
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.black),
  //                               ),
  //                             ),
  //                             SizedBox(height: 6,),
  //
  //                             Container(
  //                               // width: MediaQuery.of(context).size.width,
  //                               height: MediaQuery.of(context).size.height * .41,
  //                               child: ListView.builder(
  //                                 scrollDirection: Axis.vertical,
  //                                 shrinkWrap: true,
  //                                 itemCount: userAboutMEProvider.combinedResults.length,
  //                                 itemBuilder: (c, i) {
  //                                   // relatedSolutionlength = relatedChallenges?.length;
  //                                   // print("relatedSolutionlength: ${combinedResults.length}");
  //                                   RelatedChallengesdocuments = userAboutMEProvider.combinedResults.toList();
  //                                   // print("solutionData: ${RelatedChallengesdocuments}");
  //
  //                                   DocumentSnapshot document = RelatedChallengesdocuments[i];
  //
  //                                   return GestureDetector(
  //                                     onTap: (){
  //                                       // ViewChallengesDialog(document.reference,document.id, document['Label'], document['Description'], document['Category']
  //                                       //     ,document['Keywords'],document['Created Date'],document['Created By'],document['tags'],document['Modified By']
  //                                       //     ,document['Modified Date'],document['id']);
  //                                       NewViewDialog(document['Label'],document['Description'],document['Impact'],document['Final_description'], document['Keywords'],document['tags'],document['id'],);
  //                                     },
  //                                     child: Container(
  //                                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
  //                                         padding: EdgeInsets.all(12),
  //                                         width: 470,
  //                                         // height: 300,
  //                                         decoration: BoxDecoration(
  //                                           border: Border.all(color: Colors.black26),
  //                                           borderRadius: BorderRadius.circular(20),
  //                                         ),
  //                                         child: RecommendedChallengesListTile(document, i, RelatedChallengesdocuments)
  //                                     ),
  //                                   );
  //                                 },
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //
  //                       // SizedBox(width: 15,),
  //
  //                       // Text("Recommended Challenges :",
  //                       //   style: GoogleFonts.montserrat(
  //                       //     textStyle: Theme.of(context).textTheme.titleLarge,
  //                       //     fontWeight: FontWeight.bold,
  //                       //     color: Colors.black),
  //                       // ),
  //
  //                       // SizedBox(height: 10,),
  //                       // Consumer<UserAboutMEProvider>(
  //                       //   builder: (context, userAboutMEProvider, _) {
  //                       //     // solutions = userAboutMEProvider.getSelectedSolutions();
  //                       //     print("challengesssss : ${userAboutMEProvider.challengess}");
  //                       //
  //                       //     return (userAboutMEProvider.challengess.isEmpty) ?
  //                       //     Container(
  //                       //       height: 300,
  //                       //       child: Center(child: Text("Recommended Challenges", style:
  //                       //       GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.displaySmall,
  //                       //           fontWeight: FontWeight.bold,
  //                       //           color: Colors.black),),),
  //                       //       decoration: BoxDecoration(
  //                       //         border: Border.all(color: Colors.black),
  //                       //         borderRadius: BorderRadius.circular(20),
  //                       //       ),
  //                       //     ) : Container(
  //                       //       height: 300,
  //                       //       decoration: BoxDecoration(
  //                       //         border: Border.all(color: Colors.black),
  //                       //         borderRadius: BorderRadius.circular(20),
  //                       //       ),
  //                       //       width: MediaQuery.of(context).size.width,
  //                       //       child:SingleChildScrollView(
  //                       //         child: DataTable(
  //                       //           // decoration: BoxDecoration(
  //                       //           //     border: Border.all(color: Colors.black),
  //                       //           //     borderRadius: BorderRadius.circular(15)
  //                       //           // ),
  //                       //           // horizontalMargin: 10,
  //                       //           dataRowMaxHeight:60 ,
  //                       //           headingTextStyle: GoogleFonts.montserrat(
  //                       //               textStyle: Theme.of(context).textTheme.titleMedium,
  //                       //               fontWeight: FontWeight.w500,
  //                       //               color: Colors.black),
  //                       //           columnSpacing: 15,
  //                       //           columns: [
  //                       //             DataColumn(
  //                       //                 label: Container(
  //                       //                     width: 60,
  //                       //                     child: Center(
  //                       //                         child: Text('ID')
  //                       //                     )
  //                       //                 )
  //                       //             ),
  //                       //             DataColumn(
  //                       //               label: Container(
  //                       //                 width: 180,
  //                       //                 child: Center(
  //                       //                     child: Text('Label',)
  //                       //                 ),
  //                       //               ),
  //                       //             ),
  //                       //             DataColumn(
  //                       //               label: Container(
  //                       //                 // width: 400,
  //                       //                   child: Center(child:
  //                       //                   Text('Description')
  //                       //                   )
  //                       //               ),
  //                       //             ),
  //                       //             DataColumn(
  //                       //                 label: Container(
  //                       //                   // width: 140,
  //                       //                     child: Center(child: Text('Confirm/Cancel')
  //                       //                     )
  //                       //                 )
  //                       //             ),
  //                       //
  //                       //             // DataColumn(
  //                       //             //     label: Center(
  //                       //             //         child: Text('Attachments')
  //                       //             //     )
  //                       //             // ),
  //                       //             // DataColumn(
  //                       //             //     label: Container(
  //                       //             //         width: 120,
  //                       //             //         child: Center(child: Text('Provider')
  //                       //             //         )
  //                       //             //     )
  //                       //             // ),
  //                       //             // DataColumn(label: Container(
  //                       //             //     width: 60,
  //                       //             //     child: Center(child: Text('In Place')
  //                       //             //     )
  //                       //             // )
  //                       //             // ),
  //                       //             // DataColumn(label: Container(
  //                       //             //     width: 140,
  //                       //             //     child: Center(child: Text('Priority')
  //                       //             //     )
  //                       //             // )
  //                       //             // ),
  //                       //           ],
  //                       //           rows: userAboutMEProvider.challengess.map((challenge) {
  //                       //             int index = userAboutMEProvider.challengess.indexOf(challenge);
  //                       //
  //                       //
  //                       //             // print(jsonString);
  //                       //
  //                       //             return DataRow(
  //                       //               cells: [
  //                       //                 DataCell(
  //                       //                     Container(
  //                       //                         width: 60,
  //                       //                         child: Center(
  //                       //                           child: Text(challenge.id, style: GoogleFonts.montserrat(
  //                       //                               textStyle: Theme.of(context).textTheme.bodySmall,
  //                       //                               fontWeight: FontWeight.w600,
  //                       //                               color: Colors.black),),
  //                       //                         ))),
  //                       //                 DataCell(
  //                       //                     Container(
  //                       //                         width: 180,
  //                       //                         child: Center(
  //                       //                           child: Text(challenge.label,
  //                       //                               overflow: TextOverflow.ellipsis,maxLines: 2,
  //                       //                               style: GoogleFonts.montserrat(
  //                       //                                   textStyle: Theme.of(context).textTheme.bodySmall,
  //                       //                                   fontWeight: FontWeight.w600,
  //                       //                                   color: Colors.black)
  //                       //                           ),
  //                       //                         ))),
  //                       //                 DataCell(
  //                       //                     Container(
  //                       //                       // width: 400,
  //                       //                         child: Center(
  //                       //                           child: Text(challenge.description,
  //                       //                               overflow: TextOverflow.ellipsis,maxLines: 2,
  //                       //                               style: GoogleFonts.montserrat(
  //                       //                                   textStyle: Theme.of(context).textTheme.bodySmall,
  //                       //                                   fontWeight: FontWeight.w600,
  //                       //                                   color: Colors.black)
  //                       //                           ),
  //                       //                         ))),
  //                       //                 DataCell(
  //                       //                   Container(
  //                       //                     // height: 100,
  //                       //                     margin: EdgeInsets.all(5),
  //                       //                     // width: 140,
  //                       //                     child: Center(
  //                       //                       // child: (userAboutMEProvider.isConfirm==true) ?
  //                       //                         child: (challenge.isConfirmed==true) ?
  //                       //                         Text('Confirmed',
  //                       //                           style: TextStyle(color: Colors.green),
  //                       //                         )
  //                       //                             :
  //                       //                         Row(
  //                       //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       //                           children: [
  //                       //                             IconButton(
  //                       //                               onPressed: () {
  //                       //                                 showconfirmrDialogBox(challenge.id, challenge.label,challenge.description, challenge.Source, challenge.Status,challenge.tags,challenge.CreatedBy,
  //                       //                                     challenge.CreatedDate,challenge.ModifiedBy,challenge.ModifiedDate,challenge.OriginalDescription,challenge.Impact,challenge.Final_description,
  //                       //                                     challenge.Category,challenge.Keywords,challenge.PotentialStrengths,challenge.HiddenStrengths, index,userAboutMEProvider.challengess);
  //                       //                                 print("solution.isConfirmed: ${challenge.isConfirmed}");
  //                       //                               },
  //                       //                               icon: Icon(Icons.check, color: Colors.green),
  //                       //                             ),
  //                       //                             IconButton(
  //                       //                               onPressed: () {
  //                       //                                 userAboutMEProvider.removeChallenge(index);
  //                       //                               },
  //                       //                               icon: Icon(Icons.close, color: Colors.red),
  //                       //                             )
  //                       //                             //      :
  //                       //
  //                       //
  //                       //                           ],
  //                       //                         )
  //                       //                     ),
  //                       //                   ),
  //                       //                 ),
  //                       //
  //                       //                 // DataCell(
  //                       //                 //   Container(
  //                       //                 //     // height: 100,
  //                       //                 //     margin: EdgeInsets.all(5),
  //                       //                 //     width: 140,
  //                       //                 //     child: Center(
  //                       //                 //       child: TextField(
  //                       //                 //         maxLines: 4,
  //                       //                 //         controller: TextEditingController(text: solution.notes),
  //                       //                 //         onChanged: (value) {
  //                       //                 //         },
  //                       //                 //         style: GoogleFonts.montserrat(
  //                       //                 //             textStyle: Theme
  //                       //                 //                 .of(context)
  //                       //                 //                 .textTheme
  //                       //                 //                 .bodySmall,
  //                       //                 //             fontWeight: FontWeight.w400,
  //                       //                 //             color: Colors.black),
  //                       //                 //         decoration: InputDecoration(
  //                       //                 //           contentPadding: EdgeInsets.all(10),
  //                       //                 //           // labelText: "Name",
  //                       //                 //           hintText: "Notes",
  //                       //                 //           errorStyle: GoogleFonts.montserrat(
  //                       //                 //               textStyle: Theme
  //                       //                 //                   .of(context)
  //                       //                 //                   .textTheme
  //                       //                 //                   .bodyLarge,
  //                       //                 //               fontWeight: FontWeight.w400,
  //                       //                 //               color: Colors.redAccent),
  //                       //                 //           focusedBorder: OutlineInputBorder(
  //                       //                 //               borderSide: BorderSide(color: Colors.black),
  //                       //                 //               borderRadius: BorderRadius.circular(5)),
  //                       //                 //           border: OutlineInputBorder(
  //                       //                 //               borderSide: BorderSide(color: Colors.black12),
  //                       //                 //               borderRadius: BorderRadius.circular(5)),
  //                       //                 //           labelStyle: GoogleFonts.montserrat(
  //                       //                 //               textStyle: Theme
  //                       //                 //                   .of(context)
  //                       //                 //                   .textTheme
  //                       //                 //                   .bodyLarge,
  //                       //                 //               fontWeight: FontWeight.w400,
  //                       //                 //               color: Colors.black),
  //                       //                 //         ),
  //                       //                 //       ),
  //                       //                 //     ),
  //                       //                 //   ),), // Empty cell for Notes
  //                       //
  //                       //                 // DataCell(
  //                       //                 //     Container(
  //                       //                 //       child: IconButton(
  //                       //                 //         onPressed: (){
  //                       //                 //
  //                       //                 //         },
  //                       //                 //         icon: Icon(Icons.add),
  //                       //                 //       ),
  //                       //                 //     )),  // Empty cell for Attachments
  //                       //                 // DataCell(
  //                       //                 //   Container(
  //                       //                 //     width: 120,
  //                       //                 //     child: DropdownButton(
  //                       //                 //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                       //                 //       // value: selectedProvider,
  //                       //                 //       value: selectedProviderValues[index],
  //                       //                 //       onChanged: (newValue) {
  //                       //                 //         // userAboutMEProvider.updatevalue(selectedProviderValues[index], newValue.toString());
  //                       //                 //         setState(() {
  //                       //                 //           // selectedProvider = newValue.toString();
  //                       //                 //           selectedProviderValues[index] = newValue.toString();
  //                       //                 //         });
  //                       //                 //       },
  //                       //                 //       items: provider.map((option) {
  //                       //                 //         return DropdownMenuItem(
  //                       //                 //           value: option,
  //                       //                 //           child: Text(option, overflow: TextOverflow.ellipsis,maxLines: 2,),
  //                       //                 //         );
  //                       //                 //       }).toList(),
  //                       //                 //     ),
  //                       //                 //   ),
  //                       //                 // ),  // Empty cell for Provider
  //                       //                 // DataCell(
  //                       //                 //   Container(
  //                       //                 //     width: 60,
  //                       //                 //     child: DropdownButton(
  //                       //                 //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                       //                 //       value: selectedInPlaceValues[index],
  //                       //                 //       // value: selectedInPlace,
  //                       //                 //       onChanged: (newValue) {
  //                       //                 //         setState(() {
  //                       //                 //           selectedInPlaceValues[index] = newValue.toString();
  //                       //                 //           // selectedInPlace = newValue.toString();
  //                       //                 //         });
  //                       //                 //       },
  //                       //                 //       items: InPlace.map((option) {
  //                       //                 //         return DropdownMenuItem(
  //                       //                 //           value: option,
  //                       //                 //           child: Text(option),
  //                       //                 //         );
  //                       //                 //       }).toList(),
  //                       //                 //     ),
  //                       //                 //   ),
  //                       //                 // ),  // Empty cell for In Place
  //                       //                 // DataCell(
  //                       //                 //   Container(
  //                       //                 //     width: 140,
  //                       //                 //     // child:  DropdownButton(
  //                       //                 //     //   style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                       //                 //     //   value: selectedPriorityValues[index],
  //                       //                 //     //   // value: selectedPriority,
  //                       //                 //     //   onChanged: (newValue) {
  //                       //                 //     //     setState(() {
  //                       //                 //     //       selectedPriorityValues[index] = newValue.toString();
  //                       //                 //     //
  //                       //                 //     //       print("$index: ${selectedPriorityValues[index]} ");
  //                       //                 //     //       // selectedPriority = newValue.toString();
  //                       //                 //     //     });
  //                       //                 //     //   },
  //                       //                 //     //   items: Priority.map((option) {
  //                       //                 //     //     return DropdownMenuItem(
  //                       //                 //     //       value: option,
  //                       //                 //     //       child: Text(option, overflow: TextOverflow.ellipsis,),
  //                       //                 //     //     );
  //                       //                 //     //   }).toList(),
  //                       //                 //     // ),
  //                       //                 //     child:  DropdownButtonFormField(
  //                       //                 //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                       //                 //       decoration: InputDecoration(
  //                       //                 //
  //                       //                 //         hintText: 'Priority',
  //                       //                 //       ),
  //                       //                 //       value: userAboutMEProvider.selectedPriorityValues[index],
  //                       //                 //       onChanged: (newValue) {
  //                       //                 //         userAboutMEProvider.updateSelectedPriorityValues(index, newValue);
  //                       //                 //         print('priority ${index} and ${userAboutMEProvider.selectedPriorityValues}');
  //                       //                 //       },
  //                       //                 //       icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
  //                       //                 //       items: selectedPriorityValues.map<DropdownMenuItem<String>>((String value) {
  //                       //                 //         // String displayedText = value;
  //                       //                 //         // if (displayedText.length > 5) {
  //                       //                 //         //   // Limit the displayed text to 10 characters and add ellipsis
  //                       //                 //         //   displayedText = displayedText.substring(0, 5) + '..';
  //                       //                 //         // }
  //                       //                 //         return DropdownMenuItem<String>(
  //                       //                 //           value: value,
  //                       //                 //           child: Text(value, overflow: TextOverflow.ellipsis,),
  //                       //                 //         );
  //                       //                 //       }).toList(),
  //                       //                 //     ),
  //                       //                 //   ),
  //                       //                 // ),  // Empty cell for Priority
  //                       //
  //                       //               ],
  //                       //             );
  //                       //           }).toList(),
  //                       //         ),
  //                       //       ),
  //                       //
  //                       //     );
  //                       //   },
  //                       // ),
  //
  //                       Consumer<UserAboutMEProvider>(
  //                         builder: (context, userAboutMEProvider, _) {
  //                           // print("challengesssss : ${userAboutMEProvider.challengess}");
  //
  //
  //                           return (userAboutMEProvider.challengess.isEmpty) ?
  //                           Container(
  //                             // height: 350,
  //                             height: MediaQuery.of(context).size.height * .48,
  //                             width: MediaQuery.of(context).size.width * .46,
  //
  //                             child: Center(
  //                               child: Text("No Challenges Added Yet",
  //                                 overflow: TextOverflow.ellipsis,
  //                                 style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.displaySmall,
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.black),),),
  //                             decoration: BoxDecoration(
  //                               border: Border.all(color: Colors.black),
  //                               borderRadius: BorderRadius.circular(20),
  //                             ),
  //                           ) : Container(
  //                             // height: 350,
  //                             height: MediaQuery.of(context).size.height * .48,
  //                             width: MediaQuery.of(context).size.width * .46,
  //
  //                             decoration: BoxDecoration(
  //                               border: Border.all(color: Colors.black26),
  //                               borderRadius: BorderRadius.circular(20),
  //                             ),
  //                             // width: MediaQuery.of(context).size.width,
  //                             child:SingleChildScrollView(
  //                               child: DataTable(
  //                                 dataRowMaxHeight:60 ,
  //                                 headingTextStyle: GoogleFonts.montserrat(
  //                                     textStyle: Theme.of(context).textTheme.titleMedium,
  //                                     fontWeight: FontWeight.w500,
  //                                     color: Colors.black),
  //                                 // border: TableBorder.all(color: Colors.black),
  //                                 columnSpacing: 15,
  //                                 columns: [
  //
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // color: Colors.blue,
  //                                       // width: 60,
  //                                       child: Text('No.',textAlign: TextAlign.center,),
  //                                     ),
  //
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 180,
  //                                       child: Text('Label',),
  //                                     ),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 250,
  //                                       child: Text('Impact',),
  //                                     ),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 400,
  //                                         child: Text('Description')
  //                                     ),
  //                                   ),
  //                                   DataColumn(
  //                                       label: Container(
  //                                         // width: 140,
  //                                           child: Text('Confirm/Cancel')
  //                                       )
  //                                   ),
  //                                 ],
  //                                 rows: userAboutMEProvider.challengess.map((challenge) {
  //                                   int index = userAboutMEProvider.challengess.indexOf(challenge);
  //                                   // print(jsonString);
  //                                   return DataRow(
  //                                     cells: [
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 60,
  //                                               child: Text("${index + 1}.", style: GoogleFonts.montserrat(
  //                                                   textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                   fontWeight: FontWeight.w600,
  //                                                   color: Colors.black),))
  //                                       ),
  //                                       DataCell(
  //                                           Container(
  //                                             child: Text(challenge.label,
  //                                                 overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                 style: GoogleFonts.montserrat(
  //                                                     textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                     fontWeight: FontWeight.w600,
  //                                                     color: Colors.black)
  //                                             ),
  //                                           )),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 250,
  //                                               child: Text(challenge.Impact,
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 400,
  //                                               child: Text(challenge.Final_description,
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                       DataCell(
  //                                         Container(
  //                                           // height: 100,
  //                                           margin: EdgeInsets.all(5),
  //                                           // width: 140,
  //                                           child: (challenge.isConfirmed==true) ?
  //                                           Text('Confirmed',
  //                                             style: TextStyle(color: Colors.green),
  //                                           )
  //                                               :
  //                                           Row(
  //                                             mainAxisAlignment: MainAxisAlignment.start,
  //                                             crossAxisAlignment: CrossAxisAlignment.start,
  //                                             children: [
  //                                               IconButton(
  //                                                 onPressed: () {
  //                                                   // (challenge.Keywords.isEmpty || challenge.tags.isEmpty) ? toastification.show(context: context,
  //                                                   // title: Text('Cannot View this Challenge'),
  //                                                   // autoCloseDuration: Duration(milliseconds: 2500),
  //                                                   //   alignment: Alignment.center,
  //                                                   //   backgroundColor: Colors.blue,
  //                                                   //   foregroundColor: Colors.white,
  //                                                   //   animationDuration: Duration(milliseconds: 1000),
  //                                                   //   showProgressBar: false
  //                                                   // )
  //                                                   // :
  //                                                   NewViewDialog(challenge.label,challenge.description,challenge.Impact,challenge.Final_description, challenge.Keywords,challenge.tags,challenge.id,);
  //                                                   print("challenge.isConfirmed: ${challenge.isConfirmed}");
  //                                                 },
  //                                                 icon: Icon(Icons.visibility, color: Colors.blue),
  //                                               ),
  //                                               SizedBox(width: 10,),
  //                                               IconButton(
  //                                                 onPressed: () {
  //                                                   showconfirmChallengeDialogBox(challenge.id, challenge.label,challenge.description, challenge.Source, challenge.Status,challenge.tags,challenge.CreatedBy,
  //                                                       challenge.CreatedDate,challenge.ModifiedBy,challenge.ModifiedDate,challenge.OriginalDescription,challenge.Impact,challenge.Final_description,
  //                                                       challenge.Category,challenge.Keywords,challenge.PotentialStrengths,challenge.HiddenStrengths, index,userAboutMEProvider.challengess,challenge.notes);                                        print("challenge.isConfirmed: ${challenge.isConfirmed}");
  //                                                 },
  //                                                 icon: Icon(Icons.check, color: Colors.green),
  //                                               ),
  //                                               SizedBox(width: 10,),
  //                                               IconButton(
  //                                                 onPressed: () {
  //                                                   userAboutMEProvider.removeChallenge(index,challenge);
  //                                                   // userAboutMEProvider.removeRecommendedChallenge(challenge.id);
  //                                                   // userAboutMEProvider.removeRecommendedChallenge(challenge.id);
  //                                                   // userAboutMEProvider.isRecommendedcCheckedForTileChallenge(index);
  //                                                   // userAboutMEProvider.removeRecommendedChallenge(index);
  //                                                   // userAboutMEProvider.isRecommendedChallengeCheckedMap[index] = false;;
  //                                                 },
  //                                                 icon: Icon(Icons.close, color: Colors.red),
  //                                               )
  //                                               //      :
  //
  //
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   );
  //                                 }).toList(),
  //                               ),
  //                             ),
  //
  //                           );
  //                         },
  //                       ),
  //
  //
  //                     ],
  //                   ),
  //
  //
  //                   SizedBox(height: 10,),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       // InkWell(
  //                       //   onTap: (){
  //                       //     // page.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  //                       //     _navigateToTab(1);
  //                       //     // Navigator.pop(context);
  //                       //   },
  //                       //   child: Container(
  //                       //     padding: EdgeInsets.symmetric(horizontal: 15),
  //                       //     width: MediaQuery.of(context).size.width * .3,
  //                       //     height: 60,
  //                       //     decoration: BoxDecoration(
  //                       //       //color: Colors.white,
  //                       //       border: Border.all(
  //                       //         //color:primaryColorOfApp ,
  //                       //           width: 1.0),
  //                       //       borderRadius: BorderRadius.circular(15.0),
  //                       //     ),
  //                       //     child: Center(
  //                       //       child: Text(
  //                       //         'Back',
  //                       //         style: GoogleFonts.montserrat(
  //                       //           textStyle:
  //                       //           Theme
  //                       //               .of(context)
  //                       //               .textTheme
  //                       //               .titleSmall,
  //                       //           fontWeight: FontWeight.bold,
  //                       //           //color: primaryColorOfApp
  //                       //         ),
  //                       //       ),
  //                       //     ),
  //                       //   ),
  //                       // ),
  //                       SizedBox(height: 5, width: 5,),
  //                       InkWell(
  //                         onTap: () async{
  //
  //                           await userAboutMEProvider.getRelatedSolutions(generatedsolutionstags, generatedsolutionscategory);
  //                           // await userAboutMEProvider.getRelatedSolutions(tags, keywordss);
  //
  //                           // await page.animateToPage(3, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  //
  //                           Map<String, dynamic> AboutMEDatas = {
  //
  //                             'Challenges': challengesList,
  //
  //                           };
  //
  //                           String solutionJson = json.encode(AboutMEDatas);
  //                           print(solutionJson);
  //
  //                           ProgressDialog.show(context, "Saving", Icons.save);
  //                           await ApiRepository().updateAboutMe(AboutMEDatas,documentId);
  //                           ProgressDialog.hide();
  //
  //                           await _navigateToTab(3);
  //
  //                         },
  //                         child: Container(
  //                           padding: EdgeInsets.symmetric(horizontal: 15),
  //                           width: MediaQuery.of(context).size.width * .2,
  //                           height: 60,
  //                           decoration: BoxDecoration(
  //                             color: Colors.blue,
  //                             border: Border.all(
  //                                 color: Colors.blue,
  //                                 width: 2.0),
  //                             borderRadius: BorderRadius.circular(15.0),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               'Save and Next',
  //                               style: GoogleFonts.montserrat(
  //                                   textStyle:
  //                                   Theme
  //                                       .of(context)
  //                                       .textTheme
  //                                       .titleSmall,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.white),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               );
  //             })
  //     ),
  //   );
  // }
  //
  // Widget AddSolutionsPage(context) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height,
  //     child: SingleChildScrollView(
  //         child:Consumer<UserAboutMEProvider>(
  //             builder: (c,userAboutMEProvider, _){
  //               return Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   SizedBox(height: 5,),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 20.0),
  //                     child: Text("4. Solutions",
  //                         style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
  //                             fontSize: 30,
  //                             color: Colors.black)),
  //                   ),
  //
  //                   SizedBox(height: 10,),
  //                   Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       InkWell(
  //                         onTap:(){
  //                           showSolutionSelectors();
  //                         },
  //                         child:Container(
  //                           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //                           // width: MediaQuery.of(context).size.width * .2,
  //                           width: MediaQuery.of(context).size.width * .15,
  //
  //                           // height: 60,
  //                           decoration: BoxDecoration(
  //                             color:Colors.blue ,
  //                             border: Border.all(
  //                                 color:Colors.blue ,
  //                                 width: 1.0),
  //                             borderRadius: BorderRadius.circular(15.0),
  //                           ),
  //                           child: Center(
  //                             // child: Icon(Icons.add, size: 30,color: Colors.white,),
  //                             child: Text(
  //                               'Browse',
  //                               style: GoogleFonts.montserrat(
  //                                 textStyle:
  //                                 Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleSmall,
  //                                 fontWeight: FontWeight.bold,
  //                                 color:Colors.white ,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: 15,),
  //                       InkWell(
  //                         onTap:(){
  //                           showAddThriverDialogBox();
  //                         },
  //                         child:Container(
  //                           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //                           // width: MediaQuery.of(context).size.width * .2,
  //                           width: MediaQuery.of(context).size.width * .15,
  //
  //                           // height: 60,
  //                           decoration: BoxDecoration(
  //                             // color:Colors.blue ,
  //                             border: Border.all(
  //                                 color:Colors.blue ,
  //                                 width: 1.0),
  //                             borderRadius: BorderRadius.circular(15.0),
  //                           ),
  //                           child: Center(
  //                             // child: Icon(Icons.add, size: 30,color: Colors.white,),
  //                             child: Text(
  //                               'Create My Own',
  //                               style: GoogleFonts.montserrat(
  //                                 textStyle:
  //                                 Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleSmall,
  //                                 fontWeight: FontWeight.bold,
  //                                 color:Colors.blue ,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: 15,),
  //
  //                     ],
  //                   ),
  //
  //
  //                   SizedBox(height: 10,),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Container(
  //                         height: MediaQuery.of(context).size.height * .6,
  //                         width: MediaQuery.of(context).size.width * .46,
  //                         decoration: BoxDecoration(
  //                           border: (userAboutMEProvider.combinedSolutionsResults.isEmpty) ?  Border.all(color: Colors.black) : Border.all(color: Colors.black),
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
  //                               child: Text("Shortlist (${userAboutMEProvider.combinedSolutionsResults.length}):",
  //                                 style: GoogleFonts.montserrat(
  //                                     textStyle: Theme.of(context).textTheme.titleLarge,
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.black),
  //                               ),
  //                             ),
  //
  //                             SizedBox(height: 10,),
  //
  //                             Container(
  //                               height: MediaQuery.of(context).size.height * .5,
  //                               // width: MediaQuery.of(context).size.width * .46,
  //                               child: ListView.builder(
  //                                 scrollDirection: Axis.vertical,
  //                                 shrinkWrap: true,
  //                                 itemCount: userAboutMEProvider.combinedSolutionsResults.length,
  //                                 itemBuilder: (c, i) {
  //                                   // relatedSolutionlength = relatedChallenges?.length;
  //                                   // print("relatedSolutionlength: ${combinedResults.length}");
  //                                   RelatedSolutionsdocuments = userAboutMEProvider.combinedSolutionsResults.toList();
  //                                   // print("solutionData: ${RelatedChallengesdocuments}");
  //
  //                                   DocumentSnapshot document = RelatedSolutionsdocuments[i];
  //
  //                                   return GestureDetector(
  //                                     onTap: (){
  //                                       // ViewSolutionsDialog(document.reference,document.id, document['Name'], document['Description'], document['Category']
  //                                       //     ,document['Keywords'],document['Created Date'],document['Created By'],document['tags'],document['Modified By']
  //                                       //     ,document['Modified Date'],document['id']);
  //                                       NewViewDialog(document['Name'],document['Description'],document['Impact'],document['Final_description'], document['Keywords'],document['tags'],document['id'],);
  //                                     },
  //                                     child: Container(
  //                                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
  //                                         padding: EdgeInsets.all(12),
  //                                         width: 470,
  //                                         // height: 300,
  //                                         decoration: BoxDecoration(
  //                                           border: Border.all(color: Colors.black26),
  //                                           borderRadius: BorderRadius.circular(20),
  //                                         ),
  //                                         child: RecommendedSolutionsListTile(document, i, RelatedSolutionsdocuments)
  //                                     ),
  //                                   );
  //                                 },
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //
  //                       SizedBox(height: 10,),
  //
  //                       Consumer<UserAboutMEProvider>(
  //                         builder: (context, userAboutMEProvider, _) {
  //                           // solutions = userAboutMEProvider.getSelectedSolutions();
  //                           print("solutionssssss : ${userAboutMEProvider.solutionss}");
  //
  //                           List<String> selectedProviderValues = List.generate(userAboutMEProvider.solutionss.length, (index) => "Me");
  //                           List<String> selectedInPlaceValues = List.generate(userAboutMEProvider.solutionss.length, (index) => "Yes");
  //                           // List<String> selectedPriorityValues = List.generate(userAboutMEProvider.solutionss.length, (index) => "Must have");
  //                           userAboutMEProvider.selectedPriorityValues = List.generate(userAboutMEProvider.solutionss.length, (ind) => 'Must have');
  //
  //                           return (userAboutMEProvider.solutionss.isEmpty) ?
  //                           Container(
  //                             height: MediaQuery.of(context).size.height * .6,
  //                             width: MediaQuery.of(context).size.width * .46,
  //                             child: Center(child: Text("No Solutions Added Yet", style:
  //                             GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.displaySmall,
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.black),),),
  //                             decoration: BoxDecoration(
  //                               border: Border.all(color: Colors.black),
  //                               borderRadius: BorderRadius.circular(20),
  //                             ),
  //                           ) : Container(
  //                             height: MediaQuery.of(context).size.height * .6,
  //                             width: MediaQuery.of(context).size.width * .46,
  //                             decoration: BoxDecoration(
  //                               border: Border.all(color: Colors.black),
  //                               borderRadius: BorderRadius.circular(20),
  //                             ),
  //                             // width: MediaQuery.of(context).size.width,
  //                             child:SingleChildScrollView(
  //                               child: DataTable(
  //                                 dataRowMaxHeight:60 ,
  //                                 headingTextStyle: GoogleFonts.montserrat(
  //                                     textStyle: Theme.of(context).textTheme.titleMedium,
  //                                     fontWeight: FontWeight.w500,
  //                                     color: Colors.black),
  //                                 columnSpacing: 15,
  //                                 columns: [
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // color: Colors.blue,
  //                                       // width: 60,
  //                                       child: Text('No.',textAlign: TextAlign.center,),
  //                                     ),
  //
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 180,
  //                                       child: Text('Label',),
  //                                     ),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Text('Impact',),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 400,
  //                                         child: Text('Description')
  //                                     ),
  //                                   ),
  //                                   DataColumn(
  //                                       label: Container(
  //                                         // width: 140,
  //                                           child: Text('Confirm/Cancel')
  //                                       )
  //                                   ),
  //
  //
  //                                 ],
  //
  //                                 rows: userAboutMEProvider.solutionss.map((solution) {
  //                                   int index = userAboutMEProvider.solutionss.indexOf(solution);
  //
  //
  //                                   // print(jsonString);
  //
  //                                   return DataRow(
  //                                     cells: [
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 60,
  //                                             // child: Text(solution.id, style: GoogleFonts.montserrat(
  //                                               child: Text("${index + 1}.", style: GoogleFonts.montserrat(
  //                                                   textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                   fontWeight: FontWeight.w600,
  //                                                   color: Colors.black),))),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 180,
  //                                               child: Text(solution.label,
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 400,
  //                                               child: Text(solution.Impact,
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 400,
  //                                               child: Text(solution.Final_description,
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                       DataCell(
  //                                         Container(
  //                                           // height: 100,
  //                                           margin: EdgeInsets.all(5),
  //                                           // width: 140,
  //                                           child: (solution.isConfirmed==true) ?
  //                                           Text('Confirmed',
  //                                             style: TextStyle(color: Colors.green),
  //                                           )
  //                                               :
  //                                           Row(
  //                                             mainAxisAlignment: MainAxisAlignment.start,
  //                                             children: [
  //                                               IconButton(
  //                                                 onPressed: () {
  //                                                   NewViewDialog(solution.label, solution.description, solution.Impact, solution.Final_description, solution.Keywords, solution.tags, solution.id);
  //                                                 },
  //                                                 icon: Icon(Icons.visibility, color: Colors.blue),
  //                                               ),
  //                                               SizedBox(width: 15,),
  //                                               IconButton(
  //                                                 onPressed: () {
  //                                                   showconfirmSolutionsDialogBox(solution.id, solution.label,solution.description, solution.Source, solution.Status,solution.tags,solution.CreatedBy,
  //                                                       solution.CreatedDate,solution.ModifiedBy,solution.ModifiedDate,solution.OriginalDescription,solution.Impact,solution.Final_description,
  //                                                       solution.Category,solution.Keywords,"","", index,userAboutMEProvider.solutionss,solution.notes);
  //                                                   print("solution.isConfirmed: ${solution.isConfirmed}");
  //                                                 },
  //                                                 icon: Icon(Icons.check, color: Colors.green),
  //                                               ),
  //                                               SizedBox(width: 15,),
  //                                               IconButton(
  //                                                 onPressed: () {
  //                                                   userAboutMEProvider.removeSolution(index,solution);
  //                                                 },
  //                                                 icon: Icon(Icons.close, color: Colors.red),
  //                                               )
  //                                               //      :
  //
  //
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ),
  //
  //                                       // DataCell(
  //                                       //   Container(
  //                                       //     // height: 100,
  //                                       //     margin: EdgeInsets.all(5),
  //                                       //     width: 140,
  //                                       //     child: Center(
  //                                       //       child: TextField(
  //                                       //         maxLines: 4,
  //                                       //         controller: TextEditingController(text: solution.notes),
  //                                       //         onChanged: (value) {
  //                                       //         },
  //                                       //         style: GoogleFonts.montserrat(
  //                                       //             textStyle: Theme
  //                                       //                 .of(context)
  //                                       //                 .textTheme
  //                                       //                 .bodySmall,
  //                                       //             fontWeight: FontWeight.w400,
  //                                       //             color: Colors.black),
  //                                       //         decoration: InputDecoration(
  //                                       //           contentPadding: EdgeInsets.all(10),
  //                                       //           // labelText: "Name",
  //                                       //           hintText: "Notes",
  //                                       //           errorStyle: GoogleFonts.montserrat(
  //                                       //               textStyle: Theme
  //                                       //                   .of(context)
  //                                       //                   .textTheme
  //                                       //                   .bodyLarge,
  //                                       //               fontWeight: FontWeight.w400,
  //                                       //               color: Colors.redAccent),
  //                                       //           focusedBorder: OutlineInputBorder(
  //                                       //               borderSide: BorderSide(color: Colors.black),
  //                                       //               borderRadius: BorderRadius.circular(5)),
  //                                       //           border: OutlineInputBorder(
  //                                       //               borderSide: BorderSide(color: Colors.black12),
  //                                       //               borderRadius: BorderRadius.circular(5)),
  //                                       //           labelStyle: GoogleFonts.montserrat(
  //                                       //               textStyle: Theme
  //                                       //                   .of(context)
  //                                       //                   .textTheme
  //                                       //                   .bodyLarge,
  //                                       //               fontWeight: FontWeight.w400,
  //                                       //               color: Colors.black),
  //                                       //         ),
  //                                       //       ),
  //                                       //     ),
  //                                       //   ),), // Empty cell for Notes
  //
  //                                       // DataCell(
  //                                       //     Container(
  //                                       //       child: IconButton(
  //                                       //         onPressed: (){
  //                                       //
  //                                       //         },
  //                                       //         icon: Icon(Icons.add),
  //                                       //       ),
  //                                       //     )),  // Empty cell for Attachments
  //                                       // DataCell(
  //                                       //   Container(
  //                                       //     width: 120,
  //                                       //     child: DropdownButton(
  //                                       //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                                       //       // value: selectedProvider,
  //                                       //       value: selectedProviderValues[index],
  //                                       //       onChanged: (newValue) {
  //                                       //         // userAboutMEProvider.updatevalue(selectedProviderValues[index], newValue.toString());
  //                                       //         setState(() {
  //                                       //           // selectedProvider = newValue.toString();
  //                                       //           selectedProviderValues[index] = newValue.toString();
  //                                       //         });
  //                                       //       },
  //                                       //       items: provider.map((option) {
  //                                       //         return DropdownMenuItem(
  //                                       //           value: option,
  //                                       //           child: Text(option, overflow: TextOverflow.ellipsis,maxLines: 2,),
  //                                       //         );
  //                                       //       }).toList(),
  //                                       //     ),
  //                                       //   ),
  //                                       // ),  // Empty cell for Provider
  //                                       // DataCell(
  //                                       //   Container(
  //                                       //     width: 60,
  //                                       //     child: DropdownButton(
  //                                       //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                                       //       value: selectedInPlaceValues[index],
  //                                       //       // value: selectedInPlace,
  //                                       //       onChanged: (newValue) {
  //                                       //         setState(() {
  //                                       //           selectedInPlaceValues[index] = newValue.toString();
  //                                       //           // selectedInPlace = newValue.toString();
  //                                       //         });
  //                                       //       },
  //                                       //       items: InPlace.map((option) {
  //                                       //         return DropdownMenuItem(
  //                                       //           value: option,
  //                                       //           child: Text(option),
  //                                       //         );
  //                                       //       }).toList(),
  //                                       //     ),
  //                                       //   ),
  //                                       // ),  // Empty cell for In Place
  //                                       // DataCell(
  //                                       //   Container(
  //                                       //     width: 140,
  //                                       //     // child:  DropdownButton(
  //                                       //     //   style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                                       //     //   value: selectedPriorityValues[index],
  //                                       //     //   // value: selectedPriority,
  //                                       //     //   onChanged: (newValue) {
  //                                       //     //     setState(() {
  //                                       //     //       selectedPriorityValues[index] = newValue.toString();
  //                                       //     //
  //                                       //     //       print("$index: ${selectedPriorityValues[index]} ");
  //                                       //     //       // selectedPriority = newValue.toString();
  //                                       //     //     });
  //                                       //     //   },
  //                                       //     //   items: Priority.map((option) {
  //                                       //     //     return DropdownMenuItem(
  //                                       //     //       value: option,
  //                                       //     //       child: Text(option, overflow: TextOverflow.ellipsis,),
  //                                       //     //     );
  //                                       //     //   }).toList(),
  //                                       //     // ),
  //                                       //     child:  DropdownButtonFormField(
  //                                       //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                                       //       decoration: InputDecoration(
  //                                       //
  //                                       //         hintText: 'Priority',
  //                                       //       ),
  //                                       //       value: userAboutMEProvider.selectedPriorityValues[index],
  //                                       //       onChanged: (newValue) {
  //                                       //         userAboutMEProvider.updateSelectedPriorityValues(index, newValue);
  //                                       //         print('priority ${index} and ${userAboutMEProvider.selectedPriorityValues}');
  //                                       //       },
  //                                       //       icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
  //                                       //       items: selectedPriorityValues.map<DropdownMenuItem<String>>((String value) {
  //                                       //         // String displayedText = value;
  //                                       //         // if (displayedText.length > 5) {
  //                                       //         //   // Limit the displayed text to 10 characters and add ellipsis
  //                                       //         //   displayedText = displayedText.substring(0, 5) + '..';
  //                                       //         // }
  //                                       //         return DropdownMenuItem<String>(
  //                                       //           value: value,
  //                                       //           child: Text(value, overflow: TextOverflow.ellipsis,),
  //                                       //         );
  //                                       //       }).toList(),
  //                                       //     ),
  //                                       //   ),
  //                                       // ),  // Empty cell for Priority
  //
  //                                     ],
  //                                   );
  //                                 }).toList(),
  //                               ),
  //                             ),
  //
  //                           );
  //                         },
  //                       ),
  //
  //                     ],
  //                   ),
  //
  //                   SizedBox(height: 20,),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       // InkWell(
  //                       //   onTap: (){
  //                       //     // page.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  //                       //     _navigateToTab(2);
  //                       //     // Navigator.pop(context);
  //                       //   },
  //                       //   child: Container(
  //                       //     padding: EdgeInsets.symmetric(horizontal: 15),
  //                       //     width: MediaQuery.of(context).size.width * .3,
  //                       //     height: 60,
  //                       //     decoration: BoxDecoration(
  //                       //       //color: Colors.white,
  //                       //       border: Border.all(
  //                       //         //color:primaryColorOfApp ,
  //                       //           width: 1.0),
  //                       //       borderRadius: BorderRadius.circular(15.0),
  //                       //     ),
  //                       //     child: Center(
  //                       //       child: Text(
  //                       //         'Back',
  //                       //         style: GoogleFonts.montserrat(
  //                       //           textStyle:
  //                       //           Theme
  //                       //               .of(context)
  //                       //               .textTheme
  //                       //               .titleSmall,
  //                       //           fontWeight: FontWeight.bold,
  //                       //           //color: primaryColorOfApp
  //                       //         ),
  //                       //       ),
  //                       //     ),
  //                       //   ),
  //                       // ),
  //                       SizedBox(height: 5, width: 5,),
  //                       InkWell(
  //                         onTap: () async {
  //                           // page.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  //                           _navigateToTab(4);
  //
  //                         },
  //                         child: Container(
  //                           padding: EdgeInsets.symmetric(horizontal: 15),
  //                           width: MediaQuery.of(context).size.width * .3,
  //                           height: 60,
  //                           decoration: BoxDecoration(
  //                             // color: Colors.white,
  //                             border: Border.all(
  //                                 color: Colors.blue,
  //                                 width: 2.0),
  //                             borderRadius: BorderRadius.circular(15.0),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               'Preview',
  //                               style: GoogleFonts.montserrat(
  //                                   textStyle: Theme.of(context).textTheme.titleSmall,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.blue
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(height: 5, width: 5,),
  //                       InkWell(
  //                         onTap: () async {
  //                           // page.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  //                           ///
  //                           // Row(
  //                           //   mainAxisAlignment: MainAxisAlignment.center,
  //                           //   children: [
  //                           //     InkWell(
  //                           //       onTap: (){
  //                           //         selectedEmail = null;
  //                           //         nameController.clear();
  //                           //         employerController.clear();
  //                           //         divisionOrSectionController.clear();
  //                           //         RoleController.clear();
  //                           //         LocationController.clear();
  //                           //         EmployeeNumberController.clear();
  //                           //         LineManagerController.clear();
  //                           //         mycircumstancesController.clear();
  //                           //         MystrengthsController.clear();
  //                           //         mycircumstancesController.clear();
  //                           //         solutionsList.clear();
  //                           //         _userAboutMEProvider.solutionss.clear();
  //                           //         Navigator.pop(context);
  //                           //       },
  //                           //       child: Container(
  //                           //         padding: EdgeInsets.symmetric(horizontal: 15),
  //                           //         width: MediaQuery.of(context).size.width * .3,
  //                           //         height: 60,
  //                           //         decoration: BoxDecoration(
  //                           //           //color: Colors.white,
  //                           //           border: Border.all(
  //                           //             //color:primaryColorOfApp ,
  //                           //               width: 1.0),
  //                           //           borderRadius: BorderRadius.circular(15.0),
  //                           //         ),
  //                           //         child: Center(
  //                           //           child: Text(
  //                           //             'Cancel',
  //                           //             style: GoogleFonts.montserrat(
  //                           //               textStyle:
  //                           //               Theme
  //                           //                   .of(context)
  //                           //                   .textTheme
  //                           //                   .titleSmall,
  //                           //               fontWeight: FontWeight.bold,
  //                           //               //color: primaryColorOfApp
  //                           //             ),
  //                           //           ),
  //                           //         ),
  //                           //       ),
  //                           //     ),
  //                           //     SizedBox(height: 5, width: 5,),
  //                           //     InkWell(
  //                           //       onTap: () async {
  //                           //         int x = 0;
  //                           //         x = x + 1;
  //                           //         var createdAt = DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now());
  //                           //
  //                           //         Map<String, dynamic> AboutMEDatas = {
  //                           //           // 'AB_id': x,
  //                           //           'Email': selectedEmail,
  //                           //           'User_Name': nameController.text,
  //                           //           'Employee': employerController.text,
  //                           //           'Division_or_Section': divisionOrSectionController.text,
  //                           //           'Role': RoleController.text,
  //                           //           'Location': LocationController.text,
  //                           //           'Employee_Number': EmployeeNumberController.text,
  //                           //           'Line_Manager': LineManagerController.text,
  //                           //           'My_Circumstance': mycircumstancesController.text,
  //                           //           'My_Strength': MystrengthsController.text,
  //                           //           'My_Organisation': mycircumstancesController.text,
  //                           //           'Solutions': solutionsList,
  //                           //           "Created_By": widget.AdminName,
  //                           //           "Created_Date": createdAt,
  //                           //           "Modified_By": "",
  //                           //           "Modified_Date": "",
  //                           //           // Add other fields as needed
  //                           //         };
  //                           //
  //                           //         String solutionJson = json.encode(AboutMEDatas);
  //                           //         print(solutionJson);
  //                           //
  //                           //         ProgressDialog.show(context, "Creating About Me", Icons.chair);
  //                           //         await ApiRepository().createAboutMe(AboutMEDatas);
  //                           //         ProgressDialog.hide();
  //                           //         selectedEmail = null;
  //                           //         nameController.clear();
  //                           //         employerController.clear();
  //                           //         divisionOrSectionController.clear();
  //                           //         RoleController.clear();
  //                           //         LocationController.clear();
  //                           //         EmployeeNumberController.clear();
  //                           //         LineManagerController.clear();
  //                           //         mycircumstancesController.clear();
  //                           //         MystrengthsController.clear();
  //                           //         mycircumstancesController.clear();
  //                           //         solutionsList.clear();
  //                           //         _userAboutMEProvider.solutionss.clear();
  //                           //         Navigator.pop(context);
  //                           //         setState(() {
  //                           //
  //                           //         });
  //                           //       },
  //                           //       child: Container(
  //                           //         padding: EdgeInsets.symmetric(horizontal: 15),
  //                           //         width: MediaQuery.of(context).size.width * .3,
  //                           //         height: 60,
  //                           //         decoration: BoxDecoration(
  //                           //           color: Colors.blue,
  //                           //           border: Border.all(
  //                           //               color: Colors.blue,
  //                           //               width: 2.0),
  //                           //           borderRadius: BorderRadius.circular(15.0),
  //                           //         ),
  //                           //         child: Center(
  //                           //           child: Text(
  //                           //             'Add',
  //                           //             style: GoogleFonts.montserrat(
  //                           //                 textStyle:
  //                           //                 Theme
  //                           //                     .of(context)
  //                           //                     .textTheme
  //                           //                     .titleSmall,
  //                           //                 fontWeight: FontWeight.bold,
  //                           //                 color: Colors.white),
  //                           //           ),
  //                           //         ),
  //                           //       ),
  //                           //     ),
  //                           //   ],
  //                           // ),
  //
  //                           int x = 0;
  //                           x = x + 1;
  //                           var createdAt = DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now());
  //
  //                           Map<String, dynamic> AboutMEDatass = {
  //                             // 'AB_id': x,
  //                             'Email': selectedEmail,
  //                             'User_Name': nameController.text,
  //                             'Employer': employerController.text,
  //                             'Division_or_Section': divisionOrSectionController.text,
  //                             'Role': RoleController.text,
  //                             'Location': LocationController.text,
  //                             'Employee_Number': EmployeeNumberController.text,
  //                             'Line_Manager': LineManagerController.text,
  //                             'About_Me_Label': AboutMeLabeltextController.text,
  //                             'My_Circumstance': mycircumstancesController.text,
  //                             'My_Strength': MystrengthsController.text,
  //                             'My_Organisation': myOrganisationController.text,
  //                             'My_Challenges_Organisation': myOrganisation2Controller.text,
  //                             'Solutions': solutionsList,
  //                             'Challenges': challengesList,
  //                             "Created_By": widget.AdminName,
  //                             "Created_Date": createdAt,
  //                             "Modified_By": "",
  //                             "Modified_Date": "",
  //                             // Add other fields as needed
  //                           };
  //
  //                           Map<String, dynamic> AboutMEDatas = {
  //                             'Solutions': solutionsList,
  //                           };
  //
  //                           String solutionJson = json.encode(AboutMEDatas);
  //                           print(solutionJson);
  //
  //                           ProgressDialog.show(context, "Saving", Icons.save);
  //                           await ApiRepository().updateAboutMe(AboutMEDatas,documentId);
  //                           ProgressDialog.hide();
  //
  //                           // ProgressDialog.show(context, "Creating About Me", Icons.chair);
  //                           // await ApiRepository().createAboutMe(AboutMEDatas);
  //                           // ProgressDialog.hide();
  //                           selectedEmail = null;
  //                           nameController.clear();
  //                           employerController.clear();
  //                           divisionOrSectionController.clear();
  //                           RoleController.clear();
  //                           LocationController.clear();
  //                           EmployeeNumberController.clear();
  //                           LineManagerController.clear();
  //                           mycircumstancesController.clear();
  //                           MystrengthsController.clear();
  //                           mycircumstancesController.clear();
  //                           RefineController.clear();
  //                           solutionsList.clear();
  //                           _userAboutMEProvider.solutionss.clear();
  //                           _userAboutMEProvider.challengess.clear();
  //                           _userAboutMEProvider.combinedSolutionsResults.clear();
  //                           _userAboutMEProvider.combinedResults.clear();
  //                           _navigateToTab(0);
  //                           Navigator.pop(context);
  //                           setState(() {
  //
  //                           });
  //                         },
  //                         child: Container(
  //                           padding: EdgeInsets.symmetric(horizontal: 15),
  //                           width: MediaQuery.of(context).size.width * .3,
  //                           height: 60,
  //                           decoration: BoxDecoration(
  //                             color: Colors.blue,
  //                             border: Border.all(
  //                                 color: Colors.blue,
  //                                 width: 2.0),
  //                             borderRadius: BorderRadius.circular(15.0),
  //                           ),
  //                           child: Center(
  //                             child: Text(
  //                               'Save',
  //                               style: GoogleFonts.montserrat(
  //                                   textStyle: Theme.of(context).textTheme.titleSmall,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.white
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //
  //
  //                     ],
  //                   ),
  //                 ],
  //               );
  //             })
  //     ),
  //   );
  // }

}