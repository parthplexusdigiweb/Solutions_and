import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Network/FirebaseApi.dart';
import '../../core/apphelper.dart';
import '../../core/constants.dart';
import 'homescreentab.dart';



class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  String? loginErrorText;


  TextEditingController passwordTextEditingController = TextEditingController();

  var shouldObscurePassword = true;

  CollectionReference eventsCollection = FirebaseFirestore.instance.collection('Events');
  List<Map> dataItems = [];

  List<DocumentSnapshot> documents = [];


  TextEditingController searchEventsController = TextEditingController();
  TextEditingController searchArticlesController = TextEditingController();
  TextEditingController searchStartupsController = TextEditingController();

  late Future<QuerySnapshot> eventsFuture;

  String? emailErrorText;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    TextEditingController userNameTextEditingController = TextEditingController();


    return Scaffold(
      backgroundColor: Colors.black87,
      //New App bar with Text Field and Btn
      appBar:AppHelper().CustomAppBar(context),

      body:Center(
        child: Container(
          width: 400,
          height: 350,
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
                    child: Text("Please Enter Your Email Id to Login",style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                        prefixIcon: Icon(
                          Icons.person,color: primaryColorOfApp,
                        ),
                        //errorText: userAccountSearchErrorText,
                        contentPadding: EdgeInsets.all(25),
                        hintText: "Enter your Email Id",
                        labelText: "Enter your Email Id",
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
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: () async {
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
                          'Recieve Login Invite',
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
    );
  }

  HeaderWidget(var size) {
    return Container(
      margin: EdgeInsets.only(top: size.height*0.01,bottom:size.height*0.1,left: size.height*0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(



              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'The Innovation you cannot miss,',
                        style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.headlineLarge,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(text: ' all in one ',
                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.headlineLarge,
                                fontWeight: FontWeight.bold,
                                color: primaryColorOfApp),
                          ),
                          TextSpan(text: 'place',
                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.headlineLarge,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ]
                    ),
                  ),
                  SizedBox(height: 20,),
                  RichText(
                    text: TextSpan(
                        text: 'Leverage the power of ',
                        style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.titleLarge,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(text: 'the world’s first retail-centric platform ',
                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.titleLarge,
                                fontWeight: FontWeight.bold,
                                color: primaryColorOfApp),
                          ),
                          TextSpan(text: 'to quickly and efficiently identify innovative retail firms globally. Are you ',
                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.titleLarge,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),

                          ),
                          TextSpan(text: 'not finding the perfect fit? We go on a mission for you!',
                              style: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.titleLarge,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),),
                        ]
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Download ',
                      style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.headlineSmall,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(text: 'Our App',
                          style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.headlineSmall,
                              fontWeight: FontWeight.bold,
                              color: primaryColorOfApp),
                        ),
                      ]
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/mockPhone.png",height: size.height*0.5,width: size.height*0.2,),
                    SizedBox(width: 10,),
                    Image.asset("assets/RHQRSample.png",height: size.height*0.2,width: size.height*0.2,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/googlePlayBtn.png",scale:9,),
                    SizedBox(width: 10,),
                    Image.asset("assets/googlePlayBtn.png",scale: 9,),
                  ],
                )
              ],
            )
          ),
          Container(width: 40,),
        ],
      ),
    );
  }
  HeaderSmallWidget(var size) {
    return Container(
      margin: EdgeInsets.only(top: size.height*0.01,bottom:size.height*0.1,),
      child: ListView(
        shrinkWrap: true,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'The Innovation you cannot miss,',
                      style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.headlineLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(text: ' all in one ',
                          style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.headlineLarge,
                              fontWeight: FontWeight.bold,
                              color: primaryColorOfApp),
                        ),
                        TextSpan(text: 'place',
                          style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.headlineLarge,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      ]
                  ),
                ),
                SizedBox(height: 20,),
                RichText(
                  text: TextSpan(
                      text: 'Leverage the power of ',
                      style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.titleLarge,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                      children: <TextSpan>[
                        TextSpan(text: 'the world’s first retail-centric platform ',
                          style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.titleLarge,
                              fontWeight: FontWeight.bold,
                              color: primaryColorOfApp),
                        ),
                        TextSpan(text: 'to quickly and efficiently identify innovative retail firms globally. Are you ',
                          style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.titleLarge,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),

                        ),
                        TextSpan(text: 'not finding the perfect fit? We go on a mission for you!',
                            style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.titleLarge,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),),
                      ]
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              RichText(
                text: TextSpan(
                    text: 'Download ',
                    style: GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(text: 'Our App',
                        style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.headlineSmall,
                            fontWeight: FontWeight.bold,
                            color: primaryColorOfApp),
                      ),
                    ]
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/mockPhone.png",height: size.height*0.5,width: size.height*0.2,),
                  SizedBox(width: 10,),
                  Image.asset("assets/RHQRSample.png",height: size.height*0.2,width: size.height*0.2,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/googlePlayBtn.png",scale:15,),
                  SizedBox(width: 10,),
                  Image.asset("assets/googlePlayBtn.png",scale: 15,),
                ],
              )
            ],
          ),
          //Container(width: 40,),
        ],
      ),
    );
  }

/*

  MiddleWidgetForBigDisplay() {
    return Row(
      children: [
        StartUpsList(),
        ArticlesList(),
        EventsList(),
      ],
    );
  }

  MiddleWidgetForSmallDisplay() {
    return ListView(
      shrinkWrap: true,
      children: [
        StartUpsList(),
        ArticlesList(),
        EventsList(),
      ],
    );
  }




  StartUpsList() {
    return Expanded(


      child:  StatefulBuilder(
        builder: (context,innerState) {
          return FutureBuilder<List<Startups>>(
            builder: (ctx, snapshot) {
              // Checking if future is resolved or not
              if (snapshot.connectionState == ConnectionState.done) {
                // If we got an error
                if (snapshot.hasError) {
                  print("Ashraf Error Aaya haiu");
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: TextStyle(fontSize: 18,color: Colors.white),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  // Extracting data from snapshot object
                  List<Startups> data = snapshot.data!;

                  if(data.length==0){
                    return Container(
                      height: MediaQuery.of(context).size.height*0.6,
                      color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Start Ups ",style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.headlineMedium,
                                fontWeight: FontWeight.w400,
                                color: primaryColorOfApp)),
                          ),
                          TextField(
                            controller: searchStartupsController,
                            style: const TextStyle(color: Colors.white),
                            textInputAction: TextInputAction.search,
                            onChanged: (ss) {
                              print("onChanged selectedTabIndex");
                              print(ss);
                              if(searchStartupsController.text.length<=2){}
                              else{
                                innerState(() {
                                  startUpFuture = getSearchStartup();
                                });

                              }
                            },
                            onEditingComplete: (() {
                              if(searchStartupsController.text.length<=2){}
                              else{
                                innerState(() {
                                  startUpFuture = getSearchStartup();
                                });

                              }
                            }) ,
                            onSubmitted: ((value) {
                              print("onSubmitted selectedTabIndex");

                              if(searchStartupsController.text.length<=2){}
                              else{
                                innerState(() {
                                  startUpFuture = getSearchStartup();
                                });

                              }

                            }),
                            decoration:  InputDecoration(
                              hintText: "Search Startups...",
                              fillColor: Colors.white,
                              suffixIconColor: Colors.white,
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              suffixIcon: (searchStartupsController.text.isEmpty??false)?null:IconButton(onPressed: ()
                              {
                                searchStartupsController.clear();

                                innerState(() {
                                  startUpFuture = getStartups();
                                });

                              }, icon: Icon(Icons.close,color: Colors.white,)),
                              border: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffBEE73E)),
                              ),
                            ),
                          ),
                          Center(child: Text(
                            'No Results for '+searchStartupsController.text,
                            style: TextStyle(fontSize: 18,color: Colors.white),
                          ),),
                        ],
                      ),
                    );
                  }

                  return Container(
                    color: Colors.black,
                    height: MediaQuery.of(context).size.height*0.6,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Startups? startups = data[index];
                          //startups.imageName = blogs.imageName.replaceAll("35.246.127.78", "Staticprod.retailhub.ai");
                          print("startups.logo");

                          //  String logo = "https://app.retailhub.ai/api/v2/avatar/files/112026"

                          // /api/v2/avatar/files/112026
                          print(startups.logoId);
                          print(startups.logo30Id);
                          print(startups.logo);
                          print(startups.logo60);
                          print(startups.logo60Id);
                          print(startups.logo120);
                          print(startups.logo120Id);

                          print("Ashiq");
                          print("https://app.retailhub.ai/api/v2/avatar/files/${startups.logo120Id}");

                          //print(startups.logo.toString());
                          // print(startups.toJson());
                          */
/*print(startups.id);
                          print(startups.companyShortName);
                          print(startups.logoId);
                          print(startups.logo30Id);
                          print(startups.logo);
                          print(startups.logo60);
                          print(startups.logo60Id);
                          print(startups.logo120);
                          print(startups.logo120Id);

                          print(startups.companyDescription);
                          print(startups.linkedInCompanyPage);*//*



                          if(index==0){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Start Ups ",style: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.headlineMedium,
                                  fontWeight: FontWeight.w400,
                                  color: primaryColorOfApp)),
                                ),
                                TextField(
                                  controller: searchStartupsController,
                                  style: const TextStyle(color: Colors.white),
                                  textInputAction: TextInputAction.search,
                                  onChanged: (ss) {
                                    print("onChanged selectedTabIndex");
                                    print(ss);
                                    if(searchStartupsController.text.length<=2){}
                                    else{
                                      innerState(() {
                                        startUpFuture = getSearchStartup();
                                      });

                                    }
                                  },
                                  onEditingComplete: (() {
                                    if(searchStartupsController.text.length<=2){}
                                    else{
                                      innerState(() {
                                        startUpFuture = getSearchStartup();
                                      });

                                    }
                                  }) ,
                                  onSubmitted: ((value) {
                                    print("onSubmitted selectedTabIndex");

                                    if(searchStartupsController.text.length<=2){}
                                    else{
                                      innerState(() {
                                        startUpFuture = getSearchStartup();
                                      });

                                    }

                                  }),
                                  decoration:  InputDecoration(
                                    hintText: "Search Startups...",
                                    fillColor: Colors.white,
                                    suffixIconColor: Colors.white,
                                    hintStyle: TextStyle(color: Colors.white),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    suffixIcon: (searchStartupsController.text.isEmpty??false)?null:IconButton(onPressed: ()
                                    {
                                      searchStartupsController.clear();

                                      innerState(() {
                                        startUpFuture = getStartups();
                                      });

                                    }, icon: Icon(Icons.close,color: Colors.white,)),
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffBEE73E)),
                                    ),
                                  ),
                                ),
                                StartUpItems(
                                  startups.id,
                                  startups.companyShortName??"No Name",
                                  "https://app.retailhub.ai/api/v2/avatar/files/${startups.logo30Id}"??"",
                                  startups.companyDescription.toString().replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''),
                                  startups.linkedInCompanyPage, myCallback: (){
                                  //viewModel.navigateToStartupDetails(startups);
                                },
                                )
                              ],
                            );
                          }

                          return StartUpItems(
                            startups.id,
                            startups.companyShortName??"No Name",
                            "https://app.retailhub.ai/api/v2/avatar/files/${startups.logo30Id}"??"",
                            startups.companyDescription.toString().replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''),
                            startups.linkedInCompanyPage, myCallback: (){
                            //viewModel.navigateToStartupDetails(startups);
                          },
                          );
                        }),
                  );
                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return Container(
                height: MediaQuery.of(context).size.height*0.6,
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Start Ups ",style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontWeight: FontWeight.w400,
                          color: primaryColorOfApp)),
                    ),
                    TextField(
                      controller: searchStartupsController,
                      style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.search,
                      onChanged: (ss) {
                        print("onChanged selectedTabIndex");
                        print(ss);
                        if(searchStartupsController.text.length<=2){}
                        else{
                          innerState(() {
                            startUpFuture = getSearchStartup();
                          });

                        }
                      },
                      onEditingComplete: (() {
                        if(searchStartupsController.text.length<=2){}
                        else{
                          innerState(() {
                            startUpFuture = getSearchStartup();
                          });

                        }
                      }) ,
                      onSubmitted: ((value) {
                        print("onSubmitted selectedTabIndex");

                        if(searchStartupsController.text.length<=2){}
                        else{
                          innerState(() {
                            startUpFuture = getSearchStartup();
                          });

                        }

                      }),
                      decoration:  InputDecoration(
                        hintText: "Search Startups...",
                        fillColor: Colors.white,
                        suffixIconColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        suffixIcon: (searchStartupsController.text.isEmpty??false)?null:IconButton(onPressed: ()
                        {
                          searchStartupsController.clear();

                          innerState(() {
                            startUpFuture = getStartups();
                          });

                        }, icon: Icon(Icons.close,color: Colors.white,)),
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBEE73E)),
                        ),
                      ),
                    ),
                    Center(child: CircularProgressIndicator(color: primaryColorOfApp,)),
                  ],
                ),
              );
            },

            // Future that needs to be resolved
            // inorder to display something on the Canvas
            future: startUpFuture,
          );
        }
      ),

    );
  }

  Future<List<Startups>> getStartups() {
    return ApiRepository().getStartUps();
  }

  ArticlesList() {
    return Expanded(


      child:  StatefulBuilder(
        builder: (context,innerState) {
          return FutureBuilder<List<Datum>>(
            builder: (ctx, snapshot) {
              // Checking if future is resolved or not
              if (snapshot.connectionState == ConnectionState.done) {
                // If we got an error
                if (snapshot.hasError) {
                  print("Ashraf Error Aaya haiu");
                  return Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: TextStyle(fontSize: 18,color: Colors.white),
                    ),
                  );

                  // if we got our data
                } else if (snapshot.hasData) {
                  // Extracting data from snapshot object
                  List<Datum> data = snapshot.data!;
                  if(data.length==0){
                    return Container(
                      height: MediaQuery.of(context).size.height*0.6,
                      color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Articles ",style: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.headlineMedium,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
                          ),
                          TextField(
                            controller: searchArticlesController,
                            style: const TextStyle(color: Colors.white),
                            textInputAction: TextInputAction.search,
                            onChanged: (ss) {
                              print("onChanged selectedTabIndex");
                              print(ss);
                              if(searchArticlesController.text.length<=2){}
                              else{
                                innerState(() {
                                  articlesFuture = searchArticles();
                                });
                              }
                            },
                            onEditingComplete: (() {
                              if(searchArticlesController.text.length<=2){
                                print("onEditingComplete selectedTabIndex");

                              }
                              else{
                                innerState(() {
                                  articlesFuture = searchArticles();
                                });
                              }
                            }) ,
                            onSubmitted: ((value) {
                              print("onSubmitted selectedTabIndex");

                              if(searchArticlesController.text.length<=2){
                                print("onEditingComplete selectedTabIndex");

                              }
                              else{
                                innerState(() {
                                  articlesFuture = searchArticles();
                                });
                              }

                            }),
                            decoration:  InputDecoration(
                              hintText: "Search Articles...",
                              fillColor: Colors.white,
                              suffixIconColor: Colors.white,
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              suffixIcon: (searchArticlesController.text.isEmpty??false)?null:IconButton(onPressed: ()
                              {
                                searchArticlesController.clear();
                                innerState(() {
                                  articlesFuture = getArticles();
                                });


                              }, icon: Icon(Icons.close,color: Colors.white,)),
                              border: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xffBEE73E)),
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'No Results for '+searchArticlesController.text,
                              style: TextStyle(fontSize: 18,color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  else{
                    return Container(
                      color: Colors.black,
                      height: MediaQuery.of(context).size.height*0.6,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Datum? blogs = data[index];
                          blogs.imageName = blogs.imageName.replaceAll("35.246.127.78", "Staticprod.retailhub.cloud");
                          // blogs.imageName = blogs.imageName.replaceAll("http","https");
                          print("Apna Blog Name");
                          print(blogs.imageName);

                          if(index==0){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text("Articles ",style: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.headlineMedium,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey)),
                                ),
                                TextField(
                                  controller: searchArticlesController,
                                  style: const TextStyle(color: Colors.white),
                                  textInputAction: TextInputAction.search,
                                  onChanged: (ss) {
                                    print("onChanged selectedTabIndex");
                                    print(ss);
                                    if(searchArticlesController.text.length<=2){}
                                    else{
                                      innerState(() {
                                        articlesFuture = searchArticles();
                                      });
                                    }
                                  },
                                  onEditingComplete: (() {
                                    if(searchArticlesController.text.length<=2){
                                      print("onEditingComplete selectedTabIndex");

                                    }
                                    else{
                                      innerState(() {
                                        articlesFuture = searchArticles();
                                      });
                                    }
                                  }) ,
                                  onSubmitted: ((value) {
                                    print("onSubmitted selectedTabIndex");

                                    if(searchArticlesController.text.length<=2){
                                      print("onEditingComplete selectedTabIndex");

                                    }
                                    else{
                                      innerState(() {
                                        articlesFuture = searchArticles();
                                      });
                                    }

                                  }),
                                  decoration:  InputDecoration(
                                    hintText: "Search Articles...",
                                    fillColor: Colors.white,
                                    suffixIconColor: Colors.white,
                                    hintStyle: TextStyle(color: Colors.white),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    suffixIcon: (searchArticlesController.text.isEmpty??false)?null:IconButton(onPressed: ()
                                    {
                                      searchArticlesController.clear();
                                      innerState(() {
                                        articlesFuture = getArticles();
                                      });


                                    }, icon: Icon(Icons.close,color: Colors.white,)),
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffBEE73E)),
                                    ),
                                  ),
                                ),
                                StartUpItems(
                                  myCallback: () {
                                    // viewModel.navigateToDetails(blogs);
                                  },
                                  blogs.id,
                                  blogs.title,
                                  blogs.imageName,
                                  blogs.description,
                                  blogs.articlesLink,
                                )
                              ],
                            );
                          }


                          return StartUpItems(
                            myCallback: () {
                              // viewModel.navigateToDetails(blogs);
                            },
                            blogs.id,
                            blogs.title,
                            blogs.imageName,
                            blogs.description,
                            blogs.articlesLink,
                          );
                        },
                      ),
                    );
                  }

                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return Container(
                height: MediaQuery.of(context).size.height*0.6,
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Articles ",style: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey)),
                    ),
                    TextField(
                      controller: searchArticlesController,
                      style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.search,
                      onChanged: (ss) {
                        print("onChanged selectedTabIndex");
                        print(ss);
                        if(searchArticlesController.text.length<=2){}
                        else{
                          innerState(() {
                            articlesFuture = searchArticles();
                          });
                        }
                      },
                      onEditingComplete: (() {
                        if(searchArticlesController.text.length<=2){
                          print("onEditingComplete selectedTabIndex");

                        }
                        else{
                          innerState(() {
                            articlesFuture = searchArticles();
                          });
                        }
                      }) ,
                      onSubmitted: ((value) {
                        print("onSubmitted selectedTabIndex");

                        if(searchArticlesController.text.length<=2){
                          print("onEditingComplete selectedTabIndex");

                        }
                        else{
                          innerState(() {
                            articlesFuture = searchArticles();
                          });
                        }

                      }),
                      decoration:  InputDecoration(
                        hintText: "Search Articles...",
                        fillColor: Colors.white,
                        suffixIconColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        suffixIcon: (searchArticlesController.text.isEmpty??false)?null:IconButton(onPressed: ()
                        {
                          searchArticlesController.clear();
                          innerState(() {
                            articlesFuture = getArticles();
                          });


                        }, icon: Icon(Icons.close,color: Colors.white,)),
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffBEE73E)),
                        ),
                      ),
                    ),
                    Center(child: CircularProgressIndicator(color: primaryColorOfApp,)),
                  ],
                ),
              );
            },

            // Future that needs to be resolved
            // inorder to display something on the Canvas
            future: articlesFuture,
          );
        }
      ),

    );
  }

  EventsList() {
    return Expanded(
      child:  StatefulBuilder(
        builder: (context,innerState) {
          return FutureBuilder(
            future: eventsFuture,
            builder: (ctx,AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: MediaQuery.of(context).size.height*0.6,
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Events ",style: GoogleFonts.montserrat(
                            textStyle: Theme.of(context).textTheme.headlineMedium,
                            fontWeight: FontWeight.w400,
                            color: primaryColorOfApp)),
                      ),
                      TextField(
                        controller: searchEventsController,
                        style: const TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.search,
                        onChanged: (ss) {
                          print("onChanged selectedTabIndex");
                          print(ss);
                          print(ss.length);
                          print(searchEventsController.text.length);
                          print("yjsdyusjyd");
                          if(searchEventsController.text.length<=2){}
                          else{
                            //articlesFuture = searchArticles();
                            innerState((){
                              documents.removeWhere((element) => (!(element.get("Name").toString().toLowerCase().contains(searchEventsController.text.toLowerCase()))));
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Search Events...",
                          fillColor: Colors.white,
                          suffixIconColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          suffixIcon: (searchEventsController.text.isEmpty??false)?null:IconButton(onPressed: ()
                          {
                            searchEventsController.clear();
                            innerState(() {
                              print("Removing Item");
                              eventsFuture = eventsCollection.get();
                            });
                          }, icon: Icon(Icons.close,color: Colors.white,)),
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBEE73E)),
                          ),
                        ),
                      ),
                      Center(child: CircularProgressIndicator(color: primaryColorOfApp,)),
                    ],
                  ),
                );
              }

              documents =(streamSnapshot.data?.docs)??[];
              print("documents.toList()");
              print(documents.first.data());
              //todo Documents list added to filterTitle
              */
/*if (searchText.length > 0) {
                        documents = documents.where((element) {
                          print(element.data().toString());
                          return element
                              .get('UserId')
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                        }).toList();
                      }*//*

              documents.removeWhere((element) => (!(element.get("Name").toString().toLowerCase().contains(searchEventsController.text.toLowerCase()))));
              return Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height*0.6,
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: documents.length,
                    itemBuilder: (c,i){

                      if(i==0){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Events ",style: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.headlineMedium,
                                  fontWeight: FontWeight.w400,
                                  color: primaryColorOfApp)),
                            ),
                            TextField(
                              controller: searchEventsController,
                              style: const TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.search,
                              onChanged: (ss) {
                                print("onChanged Evnets selectedTabIndex");
                                print(ss);
                                print(ss.length);
                                if(ss.length<=2){}
                                else{
                                  print("Removing Items");
                                  innerState((){});
                                }
                              },
                              decoration:  InputDecoration(
                                hintText: "Search Events...",
                                fillColor: Colors.white,
                                suffixIconColor: Colors.white,
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                suffixIcon: (searchEventsController.text.isEmpty??false)?null:IconButton(onPressed: ()
                                {
                                  searchEventsController.clear();

                                  innerState(() {
                                    eventsFuture = eventsCollection.get();
                                  });


                                }, icon: Icon(Icons.close,color: Colors.white,)),
                                border: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffBEE73E)),
                                ),
                              ),
                            ),
                            ListTile(
                              isThreeLine:true,
                              leading: Image.network(documents[i].get("Image"),height: 100,
                                  width: 100,
                                  fit: BoxFit.fitHeight),
                              title: Text(documents[i].get("Name"),style: TextStyle(color: Colors.white),),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(documents[i].get("Description"),style: TextStyle(color: Colors.white54),),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month,size: 20,color: primaryColorOfApp,),
                                      SizedBox(width: 5,),
                                      Text(documents[i].get("DatedOn"),style: TextStyle(color: Colors.white54),),
                                      SizedBox(width: 20,),
                                      Icon(Icons.location_on,size: 20,color: primaryColorOfApp,),
                                      SizedBox(width: 5,),
                                      Text(documents[i].get("Location"),style: TextStyle(color: Colors.white54),),
                                      SizedBox(width: 20,),
                                      Icon(Icons.people,size: 20,color: primaryColorOfApp,),
                                      SizedBox(width: 5,),
                                      Text(documents[i].get("NumberOfAllowedPeople"),style: TextStyle(color: Colors.white54),),
                                    ],
                                  ),
                                ],
                              ),
                              */
/*trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    _showMultiSelect();
                                  },
                                  icon: Icon(Icons.add_circle_outline,color: primaryColorOfApp,)),
                              SizedBox(width: 20,),
                              IconButton(
                                  onPressed: () async {
                                    ///dataItems.removeAt(i);
                                    showListOfInvitedPeopleToEvent(documents[i].reference,documents[i]["Name"]);
                                    setState(() {

                                    });
                                  },
                                  icon: Icon(Icons.list_alt,color: primaryColorOfApp,)),
                              SizedBox(width: 20,),
                              IconButton(
                                  onPressed: () async {
                                    ///dataItems.removeAt(i);
                                    showEditEventDialogBox(context,documents[i].reference,documents[i].get("Name"));
                                    setState(() {

                                    });
                                  },
                                  icon: Icon(Icons.edit,color: primaryColorOfApp,)),
                              SizedBox(width: 20,),
                              IconButton(
                                  onPressed: () async {
                                    ///dataItems.removeAt(i);
                                    //await ApiRepository().DeleteEvent(documents[i].reference);
                                    *//*
*/
/*setState(() {

                                            });*//*
*/
/*
                                  },
                                  icon: Icon(Icons.delete,color: primaryColorOfApp,)),
                              SizedBox(width: 20,),
                            ],
                          )*//*

                            )
                          ],
                        );
                      }

                      return ListTile(
                          isThreeLine:true,
                          leading: Image.network(documents[i].get("Image"),height: 100,
                              width: 100,
                              fit: BoxFit.fitHeight),
                          title: Text(documents[i].get("Name"),style: TextStyle(color: Colors.white),),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(documents[i].get("Description"),style: TextStyle(color: Colors.white54),),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Icon(Icons.calendar_month,size: 20,color: primaryColorOfApp,),
                                  SizedBox(width: 5,),
                                  Text(documents[i].get("DatedOn"),style: TextStyle(color: Colors.white54),),
                                  SizedBox(width: 20,),
                                  Icon(Icons.location_on,size: 20,color: primaryColorOfApp,),
                                  SizedBox(width: 5,),
                                  Text(documents[i].get("Location"),style: TextStyle(color: Colors.white54),),
                                  SizedBox(width: 20,),
                                  Icon(Icons.people,size: 20,color: primaryColorOfApp,),
                                  SizedBox(width: 5,),
                                  Text(documents[i].get("NumberOfAllowedPeople"),style: TextStyle(color: Colors.white54),),
                                ],
                              ),
                            ],
                          ),
                          */
/*trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    _showMultiSelect();
                                  },
                                  icon: Icon(Icons.add_circle_outline,color: primaryColorOfApp,)),
                              SizedBox(width: 20,),
                              IconButton(
                                  onPressed: () async {
                                    ///dataItems.removeAt(i);
                                    showListOfInvitedPeopleToEvent(documents[i].reference,documents[i]["Name"]);
                                    setState(() {

                                    });
                                  },
                                  icon: Icon(Icons.list_alt,color: primaryColorOfApp,)),
                              SizedBox(width: 20,),
                              IconButton(
                                  onPressed: () async {
                                    ///dataItems.removeAt(i);
                                    showEditEventDialogBox(context,documents[i].reference,documents[i].get("Name"));
                                    setState(() {

                                    });
                                  },
                                  icon: Icon(Icons.edit,color: primaryColorOfApp,)),
                              SizedBox(width: 20,),
                              IconButton(
                                  onPressed: () async {
                                    ///dataItems.removeAt(i);
                                    //await ApiRepository().DeleteEvent(documents[i].reference);
                                    *//*
*/
/*setState(() {

                                            });*//*
*/
/*
                                  },
                                  icon: Icon(Icons.delete,color: primaryColorOfApp,)),
                              SizedBox(width: 20,),
                            ],
                          )*//*

                      );
                    }),
              );
            },
          );
        }
      ),

    );
  }

  Future<List<Datum>> getArticles() {
    return ApiRepository().getArticles();
  }

  Future<List<Datum>> searchArticles() {
    return ApiRepository().getSearchArticle(searchArticlesController.text.trim().toString());
  }

  Future<List<Startups>> getSearchStartup() {
    return ApiRepository().getSearchStartup(searchArticlesController.text.trim().toString());
  }
*/


}


enum StaticPages {
  Services,
  Review,
  AboutUs,
  TermsAndConditions,
  TrustSafetyAndSecurity
}