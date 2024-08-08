import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/screens/new%20added%20screens/authenticateloginscreen.dart';
import 'package:thrivers/screens/admin_screens/SuperAdminLoginScreen.dart';
import 'package:thrivers/screens/user_screen/UserProfileDetails.dart';
import 'package:thrivers/screens/user_screen/UserLoginPage.dart';
import 'package:thrivers/screens/user_screen/UserRegisterPage.dart';
import 'package:thrivers/screens/not%20used%20screen/landingscreen.dart';


class ThriverLandingScreen extends StatefulWidget {


  @override
  State<ThriverLandingScreen> createState() => _ThriverLandingScreenState();
}

class _ThriverLandingScreenState extends State<ThriverLandingScreen> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override

  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Text(""),
        backgroundColor: Color(0xff0B0B0B),
        title: Text("SOLUTIONS", style: GoogleFonts.montserrat(
            textStyle: Theme.of(context).textTheme.headlineLarge,
            fontWeight: FontWeight.bold,
            color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () {
              context.go('/userRegister');

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => RegisterPage()),
              // );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.07,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue)
                ),
                child: Text('Register',textAlign: TextAlign.center,style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.titleSmall,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),)),
          ),
          SizedBox(width: 10,),
          InkWell(

            onTap: () {
              context.go('/userLogin');
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => UserLoginPage()),
              //   // MaterialPageRoute(builder: (context) => AuthenticateLogin(loginToken: loginToken,)),
              // );
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.07,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                ),
                child: Text('Login',textAlign: TextAlign.center,style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.titleSmall,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),)),
          ),
          SizedBox(width: 10,),

        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeaderWidget(size,context),
              FooterWidget(context)
            ],
          ),
        ),
      ),
    );
  }

  HeaderWidget(var size,context) {
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
                                color: Colors.blue),
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
                                color: Colors.blue),
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
                                color: Colors.blue),
                          ),
                        ]
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/mockPhone.png",height: size.height*0.5,width: size.height*0.2,),
                      SizedBox(width: 10,),
                      // Image.asset("assets/RHQRSample.png",height: size.height*0.2,width: size.height*0.2,),
                      Image.asset("assets/Retail Hub.png",height: size.height*0.2,width: size.height*0.2,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: (){
                            final Uri _url = Uri.parse('https://play.google.com/store/apps/details?id=app.retailhub.cloud');
                            // launchUrl(_url);
                          },
                          child: Image.asset("assets/googlePlayBtn.png",scale:9,)),
                      SizedBox(width: 10,),
                      GestureDetector(
                          onTap: (){
                            final Uri _url = Uri.parse('https://play.google.com/store/apps/details?id=app.retailhub.cloud');
                            // launchUrl(_url);
                          },
                          child: Image.asset("assets/googlePlayBtn.png",scale: 9,)),
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

  FooterWidget(BuildContext context) {
    return Container(
    color: Color(0xff0B0B0B),
    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1,bottom: MediaQuery.of(context).size.height*0.2,left: MediaQuery.of(context).size.height*0.05),
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'A ',
                style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.headlineLarge,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                children: <TextSpan>[
                  TextSpan(text: 'good tool ',
                    style: GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.headlineLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  TextSpan(text: 'is  ',
                    style: GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.headlineLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),

                  ),
                  TextSpan(text: 'better than ',
                    style: GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.headlineLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),),
                  TextSpan(text: 'nice words! Need any further information?',
                    style: GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.headlineLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),

                  ),
                ]
            ),
          ),
          SizedBox(height: 10,),
          Text("Our dedicated team will be thrilled to respond to your query by email, as soon as possible",style: GoogleFonts.montserrat(
              textStyle: Theme.of(context).textTheme.titleSmall,
              fontWeight: FontWeight.normal,
              color: Colors.white),),
          SizedBox(height: 30,),
          Divider(color: Colors.white,),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Useful Links",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 10,),
                  TextButton(
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>  StaticPageScreen(StaticPages: StaticPages.AboutUs,)),
                        // );
                      },
                      child: Text("Services",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, color: Colors.white))),
                  SizedBox(height: 10,),
                  TextButton(
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>  StaticPageScreen(StaticPages: StaticPages.AboutUs,)),
                        // );
                      },child: Text("Review",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, color: Colors.white))),
                ],
              ),

              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text("Follow Us",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, fontWeight: FontWeight.bold, color: Colors.white)),
              //     SizedBox(height: 10,),
              //     Row(
              //       children: [
              //         Icon(Icons.follow_the_signs,color: Colors.white),
              //         SizedBox(width: 5,),
              //         Text("Facebook",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, color: Colors.white)),
              //       ],
              //     ),
              //     SizedBox(height: 10,),
              //     Row(
              //       children: [
              //         Icon(Icons.facebook,color: Colors.white),
              //         SizedBox(width: 5,),
              //         Text("Instagram",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, color: Colors.white)),
              //       ],
              //     ),
              //     SizedBox(height: 10,),
              //     Row(
              //       children: [
              //         Icon(Icons.linke,color: Colors.white),
              //         SizedBox(width: 5,),
              //         Text("Linked In",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, color: Colors.white)),
              //       ],
              //     ),
              //     SizedBox(height: 10,),
              //     Row(
              //       children: [
              //         Icon(Icons.facebook,color: Colors.white),
              //         SizedBox(width: 5,),
              //         Text("Youtube",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, color: Colors.white)),
              //       ],
              //     ),
              //     SizedBox(height: 10,),
              //     InkWell(
              //       onTap: (){
              //         // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              //       },
              //       child:Row(
              //         children: [
              //           Icon(Icons.facebook,color: Colors.white),
              //           SizedBox(width: 5,),
              //           Text("Twitter",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, color: Colors.white)),
              //         ],
              //       ),
              //     )
              //
              //   ],
              // ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>  StaticPageScreen(StaticPages: StaticPages.AboutUs,)),
                        // );
                      },
                      child: Text("More Info",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, fontWeight: FontWeight.bold, color: Colors.white))),
                  SizedBox(height: 10,),
                  TextButton(
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>  StaticPageScreen(StaticPages: StaticPages.AboutUs,)),
                        // );
                      },
                      child: Text("About us",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, color: Colors.white))),
                  SizedBox(height: 10,),
                  TextButton(
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>  StaticPageScreen(StaticPages: StaticPages.AboutUs,)),
                        // );
                      },
                      child: Text("Terms & Conditions",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, color: Colors.white))),
                  SizedBox(height: 10,),
                  TextButton(
                      onPressed: (){
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>  StaticPageScreen(StaticPages: StaticPages.AboutUs,)),
                        // );
                      },
                      child: Text("Trust , Safety & Security",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall, color: Colors.white))),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>SuperAdminLoginScreen()));
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserAboutMePage(isClientLogeddin:true, emailId: "data")));
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>NewHomeScreenTabs()));
                      context.go('/userhome',);

                    },
                    child: Text("SOLUTIONS", style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.displaySmall,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.black,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                      text: 'Subscribe to our\n',
                                      style: GoogleFonts.montserrat(
                                          textStyle: Theme.of(context).textTheme.titleLarge,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      children: <TextSpan>[
                                        TextSpan(text: 'newsletter',
                                          style: GoogleFonts.montserrat(
                                              textStyle: Theme.of(context).textTheme.titleLarge,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                      ]
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: InkWell(
                                      onTap: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(Icons.close,size: 40, color: Colors.red)),
                                ),
                              ],
                            ),
                            content: Container(
                                width: MediaQuery.of(context).size.width*0.7,
                                height:MediaQuery.of(context).size.height*0.7,
                                child: HtmlElementView(viewType: 'newsletter')),
                          );
                        },
                      );
                    },
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                          text: 'Subscribe to our\n',
                          style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.titleLarge,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(text: 'newsletter',
                              style: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.titleLarge,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    ),
  );
  }
}




