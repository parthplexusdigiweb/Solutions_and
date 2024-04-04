import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/screens/not%20used%20screen/loginscreen.dart';

import '../Network/FirebaseApi.dart';
import '../main.dart';

class AppHelper
{
  CustomAppBar(BuildContext context) {

    String? emailErrorText;
    TextEditingController userNameTextEditingController = TextEditingController();
    bool isLoggedIn = sharedPreferences?.getBool("isLoggedIn")??false;
    String userEmail = sharedPreferences?.getString("userEmail")??"";

    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        backgroundColor: Colors.black,

        title: Container(
            padding: EdgeInsets.all(0),
            child: Text("Welcome to Thriver Dashboard",style: TextStyle(color: Colors.white),)),
        actions: !isLoggedIn?[
          /*Container(
            margin: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.30,
              child: TextField(
                controller: userNameTextEditingController,
                cursorColor: primaryColorOfApp,
                onChanged: (value) {
                  print("Email Address is");
                  print(value);
                  if(value.length>=4){
                    emailErrorText = userNameTextEditingController.text.trim().isValidEmail() ? null : "Enter a valid email";
                  }
                },
                style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
                decoration: InputDecoration(
                  *//*prefixIcon: Icon(
                      Icons.person,color: primaryColorOfApp,
                    ),*//*
                  errorText:emailErrorText,
                  contentPadding: EdgeInsets.only(left: 25),
                  hintText: "Enter your email to login",
                  suffixIconColor: Colors.white,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(child: Text("Sign in with email",style:GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.bodySmall,
                        fontWeight: FontWeight.w400,
                        color: Colors.white) ,),onPressed: () async {
                      print("Sign in with Email");

                      if(!userNameTextEditingController.text.trim().isValidEmail()){
                        showDialog(
                            context: context,
                            barrierColor: Colors.black87,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(0.0)), //this right here
                                child: Container(
                                  height: 200,
                                  width: 200,
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
                                            Icon(Icons.error,color: Colors.red,size: 60,),
                                            SizedBox(width: 20,),
                                            Text("Enter a Valid\nEmail",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),),
                                          ],
                                        ),
                                        Text("${userNameTextEditingController.text.trim()} is not a valid email address",style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        ),),
                                        Row(
                                          children: [
                                            Icon(Icons.email,color:primaryColorOfApp,),
                                            SizedBox(width: 20,),
                                            Text(userNameTextEditingController.text,style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                            ),),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        SizedBox(
                                          width: 320.0,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.black,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Retype Email Address",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }

                      bool isLoginSuccessful = await ApiRepository().sendLoginMail(userNameTextEditingController.text.trim());
                      if(isLoginSuccessful){
                        showDialog(
                            context: context,
                            barrierColor: Colors.black87,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(0.0)), //this right here
                                child: Container(
                                  height: 200,
                                  width: 200,
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
                                            Icon(Icons.check_circle,color: Colors.green,size: 60,),
                                            SizedBox(width: 20,),
                                            Text("Email Sent\nSuccessfully",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),),
                                          ],
                                        ),
                                        Text("You Will Receive a link to login to your dashboard in your email",style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        ),),
                                        Row(
                                          children: [
                                            Icon(Icons.email,color:primaryColorOfApp,),
                                            SizedBox(width: 20,),
                                            Text(userNameTextEditingController.text,style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                            ),),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        SizedBox(
                                          width: 320.0,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.black,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Okay",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                      else{


                        showDialog(
                            context: context,
                            barrierColor: Colors.black87,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(0.0)), //this right here
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.error,color: Colors.red,size: 60,),
                                            SizedBox(width: 20,),
                                            Text("Something Went\nWrong",style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),),
                                          ],
                                        ),
                                        Text("Please Try again later",style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        ),),
                                        Row(
                                          children: [
                                            Icon(Icons.email,color:Colors.black,),
                                            SizedBox(width: 5,),
                                            Text(userNameTextEditingController.text,style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                            ),),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        SizedBox(
                                          width: 320.0,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.black,
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              bool isLoginSuccessful = await ApiRepository().sendLoginMail(userNameTextEditingController.text.trim());
                                              if(isLoginSuccessful){
                                                showDialog(
                                                    context: context,
                                                    barrierColor: Colors.black87,
                                                    builder: (BuildContext context) {
                                                      return Dialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(0.0)), //this right here
                                                        child: Container(
                                                          height: 200,
                                                          width: 200,
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
                                                                    Icon(Icons.check_circle,color: Colors.green,size: 60,),
                                                                    SizedBox(width: 20,),
                                                                    Text("Email Sent\nSuccessfully",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),),
                                                                  ],
                                                                ),
                                                                Text("You Will Receive a link to login to your dashboard in your email",style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                                ),),
                                                                Row(
                                                                  children: [
                                                                    Icon(Icons.email,color:primaryColorOfApp,),
                                                                    SizedBox(width: 20,),
                                                                    Text(userNameTextEditingController.text,style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                                                    ),),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10,),
                                                                SizedBox(
                                                                  width: 320.0,
                                                                  child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      primary: Colors.black,
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Text(
                                                                      "Okay",
                                                                      style: TextStyle(color: Colors.white),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            },
                                            child: Text(
                                              "Retry",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    },),
                  ),
                  hintStyle: GoogleFonts.montserrat(
                      textStyle: Theme.of(context).textTheme.bodySmall,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
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
          ),*/
          Container(
            margin: EdgeInsets.all(10),
            child: InkWell(
              onTap: () async {
                print("AshrafKhan");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Container(

                height: 60,
                decoration: BoxDecoration(
                  color: primaryColorOfApp,
                  border: Border.all(color:primaryColorOfApp, width: 2.0),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'LOGIN AS SUPER ADMIN',
                      style: GoogleFonts.montserrat(
                          textStyle:
                          Theme.of(context).textTheme.titleSmall,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),

            ),
          ),
        ]:[

          Center(child: Text("Welcome , "+userEmail,style: TextStyle(color: primaryColorOfApp),)),
          Container(
            margin: EdgeInsets.all(10),
            child: InkWell(
              onTap: () async {
                print("AshrafKhan");
                //AppHelper.uploadFileToSever();
              },
              child: Container(

                height: 60,
                decoration: BoxDecoration(
                  color: primaryColorOfApp,
                  border: Border.all(color:primaryColorOfApp, width: 2.0),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'SUBMIT YOUR START UP',
                      style: GoogleFonts.montserrat(
                          textStyle:
                          Theme.of(context).textTheme.titleSmall,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),

            ),
          ),

          PopupMenuButton(
            // add icon, by default "3 dot" icon
              icon: Icon(Icons.person,color: primaryColorOfApp,),
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("My Account"),
                  ),

                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Settings"),
                  ),

                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  print("My account menu is selected.");
                }else if(value == 1){
                  print("Settings menu is selected.");
                }else if(value == 2){
                  print("Logout menu is selected.");
                  sharedPreferences?.clear();
                  Navigator.pushReplacementNamed(
                      context,
                      '/home'
                  );
                }
              }
          ),


        ],
        centerTitle: false,),
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items


  List<String> mySelectedUsers = [];

  TextEditingController textEditingController = TextEditingController();

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        mySelectedUsers.add(itemValue);
      } else {
        mySelectedUsers.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, mySelectedUsers);
  }




  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: primaryColorOfApp),
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: Colors.black,
      title:  Text('Select Users to Sent Invites',style: TextStyle(color: primaryColorOfApp),),
      content: StatefulBuilder(
          builder: (context,innerState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  child: Container(
                    width: size.width * 0.9,
                    child: TypeAheadField(

                        textFieldConfiguration:TextFieldConfiguration(
                          controller: textEditingController,
                          //autofocus: true,

                          style: GoogleFonts.montserrat(
                              textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),


                          decoration: InputDecoration(
                            //errorText: firstNameErrorText,

                            contentPadding: EdgeInsets.all(25),
                            hintText: "Search & Send Invites ...",
                            labelText: "Type/Tap On Name to Add",
                            errorStyle: GoogleFonts.montserrat(
                                textStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.redAccent),
                            enabledBorder: OutlineInputBorder(
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
                                textStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.white54),
                          ),
                        ),
                      suggestionsCallback: (pattern) async {
                        return await AuthorityServices.getSuggestions(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion.toString()),
                          //subtitle: Text("Add Some Details Here"),
                        );
                      },

                      onSuggestionSelected: (suggestion) {
                        print("Im selected");
                        print(suggestion);
                        textEditingController.clear();
                        mySelectedUsers.add(suggestion.toString());
                        innerState((){});
                      },
                    ),
                  ),
                  padding: EdgeInsets.only(top: 0,bottom: 20),
                ),
                Padding(padding: const EdgeInsets.all(8.0),child: Text("The Following people will be sent an email and a ticket will be generated for them for the event you are creating",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,fontWeight:FontWeight.w300,color: Colors.grey)),),
                SingleChildScrollView(
                  child: ListBody(
                    children: mySelectedUsers.map((item) => CheckboxListTile(
                      checkColor: Colors.black,
                      activeColor: primaryColorOfApp,
                      value: mySelectedUsers.contains(item),
                      title: Text(item,style: TextStyle(color: primaryColorOfApp),),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (isChecked) => _itemChange(item, isChecked!),
                    ))
                        .toList(),
                  ),
                ),
              ],
            );
          }
      ),
      actions: [
        InkWell(
          onTap: _cancel,
          child: Container(
            width: size.width*0.2,
            margin: EdgeInsets.all(10),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color:primaryColorOfApp, width: 2.0),
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Center(
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                    textStyle:
                    Theme.of(context).textTheme.titleMedium,
                    color: primaryColorOfApp),
              ),
            ),
          ),

        ),
        InkWell(
          onTap: _submit,
          child: Container(
            width: size.width*0.2,
            margin: EdgeInsets.all(10),
            height: 60,
            decoration: BoxDecoration(
              color: primaryColorOfApp,
              border: Border.all(color:primaryColorOfApp, width: 2.0),
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Center(
              child: Text(
                'Done',
                style: GoogleFonts.montserrat(
                    textStyle:
                    Theme.of(context).textTheme.titleMedium,
                    color: Colors.black),
              ),
            ),
          ),

        ),
      ],
    );
  }
}
class AuthorityServices {
  static Future<List<String>> getSuggestions(String query) async {
    print("Getting Suggestion For " + query);
    //List<String> matches =  await ApiRepository().GetAuthorityMaster(query);
    List<String> matches = [
      'john.doe@example.com',
      'nehme.doe@example.com',
      'ashraf.doe@example.com',
      'diana.doe@example.com',
      'anna.smith@example.com',
      'johndoe87@hotmail.com',
      'emily.jones@gmail.com',
      'markthompson@yahoo.com',
      'lisa.wilson@example.com',
      'michael.brown@gmail.com',
      'laura.carter@hotmail.com',
      'david.johnson@example.com',
      'amanda.miller@yahoo.com',
      'robert.davis@gmail.com',
      'jennifer.wilson@example.com',
      'william.roberts@hotmail.com',
      'elizabeth.clark@example.com',
      'matthew.jackson@gmail.com'
    ];
    //print(matches.toList());
    //matches.addAll(cities);
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(query);
    if(emailValid){
      matches.add(query);
    }

    //print(matches.toList());
    //matches.addAll(cities);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}