
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/screens/new%20added%20screens/thriverLandingScreen.dart';





class DashboardCommonWidgets{
    PreferredSize CommonAppBar(BuildContext context,bool isLoggedIn,bool showLoginBtn,bool showRegisterBtn,{String? emailID,bool? automaticallyImplyLeading,bool? showSettings,bool? showLogout}){

    var size = MediaQuery.of(context).size;

    // CreditsNotifier creditsNotifier = CreditsNotifier();

    return PreferredSize(
      preferredSize: Size.fromHeight(100.0),

      child:LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600) {
            //web
            return AppBar(
              leading: Text(""),
              centerTitle: true,
              // automaticallyImplyLeading: automaticallyImplyLeading??false,
              // backgroundColor:  Color(0xff0B0B0B),elevation: 0,
              backgroundColor:  Colors.blue,elevation: 0,
              /*actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: InkWell(
              onTap: (){
                Get.toNamed("/register");
              },
              child: Container(
                decoration: BoxDecoration(
                    color: primaryColorOfApp,
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                child: Icon(Icons.person,),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: InkWell(
              onTap: (){
                Get.to(CMSLoginScreen());
              },
              child: Container(
                decoration: BoxDecoration(
                    color: primaryColorOfApp,
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                child: Icon(Icons.admin_panel_settings,),
              ),
            ),
          ),
        ],*/
              flexibleSpace: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Container(),flex: 3,),
                  Expanded(child: Center(
                    child: Text("SOLUTIONS", style: GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.headlineLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    ),
                  ),flex: 5,),

                  Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isLoggedIn?CircleAvatar(
                            backgroundImage: NetworkImage("https://st3.depositphotos.com/19428878/36416/v/450/depositphotos_364169666-stock-illustration-default-avatar-profile-icon-vector.jpg"),
                      ):Container(),

                      Visibility(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: Text(emailID??"user@solutions.com",style: TextStyle(color: Colors.white),),
                        ),
                      ),visible: isLoggedIn,),

                      isLoggedIn?Container(
                        //margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Flexible(
                          child: Row(
                            children: [
                              // showSettings??true?Padding(
                              //   padding: const EdgeInsets.only(right:25.0,bottom: 10),
                              //   child: IconButton(onPressed: (){Get.to(SettingsScreen(emailId: emailID??""));},icon: Icon(Icons.settings,color: Colors.white,size: 40,)),
                              // ):Container(),
                              showLogout??true?Padding(
                                padding: const EdgeInsets.only(right:20.0,bottom: 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(onPressed: (){
                                      print("logout to /");
                                      context.go("/");
                                    //   Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => ThriverLandingScreen()),
                                    // );
                                      },icon: Icon(Icons.logout,color: Colors.white,size: 45,)),
                                    SizedBox(height: 10,),
                                    Text("Logout",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
                                  ],
                                ),
                              ):Container(),
                            ],
                          ),
                        ),
                      ):Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: primaryColorOfApp,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                          child: Row(

                            children: [
                              showLoginBtn?InkWell(
                                onTap: (){
                                  // Get.toNamed("/clientlogin");
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login,color: Colors.white,size: 45,),
                                    Text("Login",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
                                  ],
                                ),
                              ):Container(),
                              SizedBox(width: 20,),
                              showRegisterBtn?InkWell(
                                onTap: (){
                                  // Get.toNamed("/register");
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.app_registration,color: Colors.white,size: 45,),
                                    Text("Register",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
                                  ],
                                ),
                              ):Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),flex: 3,),
                ],
              ),
            );
          } else {
            //Mobile
            return AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: primaryColorOfApp,elevation: 0,
              /*actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: InkWell(
              onTap: (){
                Get.toNamed("/register");
              },
              child: Container(
                decoration: BoxDecoration(
                    color: primaryColorOfApp,
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                child: Icon(Icons.person,),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: InkWell(
              onTap: (){
                Get.to(CMSLoginScreen());
              },
              child: Container(
                decoration: BoxDecoration(
                    color: primaryColorOfApp,
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                child: Icon(Icons.admin_panel_settings,),
              ),
            ),
          ),
        ],*/
              flexibleSpace: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Container(),flex: 2,),
                  Expanded(child: InkWell(
                      onTap: (){
                        print("logout to /");
                        context.go("/");
                      },
                      child: Image.asset(
                          height:260,width:150,
                          "assets/amplifi_logo.png")),flex: 3,),

                  Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      isLoggedIn?CircleAvatar(
                        backgroundImage: NetworkImage("https://st3.depositphotos.com/19428878/36416/v/450/depositphotos_364169666-stock-illustration-default-avatar-profile-icon-vector.jpg"),
                      ):Container(),

                      Visibility(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(emailID??"user@amplify.com",style: TextStyle(color: Colors.white),),
                      ),visible: isLoggedIn,),
                      isLoggedIn?Container(
                        //margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: showSettings??true?Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right:10.0,bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(onPressed: (){
                                  print("logout to /");
                                  context.go("/");
                                  },icon: Icon(Icons.logout,color: Colors.white,size: 20,)),
                                SizedBox(height: 10,),
                                Text("Logout",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
                              ],
                            ),
                          ),
                        ):Container(),
                      ):Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: primaryColorOfApp,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                          child: Row(

                            children: [
                              showLoginBtn?InkWell(
                                onTap: (){
                                  // Get.toNamed("/clientlogin");
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login,color: Colors.white,size: 45,),
                                    Text("Login",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
                                  ],
                                ),
                              ):Container(),
                              SizedBox(width: 20,),
                              showRegisterBtn?InkWell(
                                onTap: (){
                                  // Get.toNamed("/register");
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.app_registration,color: Colors.white,size: 45,),
                                    Text("Register",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)
                                  ],
                                ),
                              ):Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),flex: 3,),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}


