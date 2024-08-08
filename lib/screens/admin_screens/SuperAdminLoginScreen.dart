
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/screens/not%20used%20screen/homescreentab.dart';
import 'package:thrivers/screens/admin_screens/NewHomeScreen.dart';




class SuperAdminLoginScreen extends StatefulWidget {
  const SuperAdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<SuperAdminLoginScreen> createState() => _SuperAdminLoginScreenState();
}

class _SuperAdminLoginScreenState extends State<SuperAdminLoginScreen> {

  String? loginErrorText;

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  var shouldObscurePassword = true;

  _buildAdminScreen( context) async {
    bool loggedIn = await ApiRepository().isLoggedIn(); // Implement isLoggedIn() according to your authentication logic
    var username = await ApiRepository().getSavedUsername(); // Implement getSavedUsername() to retrieve the username if logged in
    print("_buildAdminScreen fenil");
    if (loggedIn) {
      // return NewHomeScreenTabs(AdminName: username);
      context.go("/admin/dashboard" , extra: username);
    }
    else {
      // return SuperAdminLoginScreen();
      context.go("/admin");

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;


    return WillPopScope(
      onWillPop: () async {
        // Allow back button press to navigate to the previous screen
        return true; // Allow default back button action
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,

          leading: Container(),

          title: Center(
            child: Text("SOLUTIONS INCLUSIONS", style: GoogleFonts.montserrat(
                textStyle: Theme.of(context).textTheme.headlineLarge,
                fontWeight: FontWeight.bold,
                color: Colors.white),
            ),
          ),
        ),
        body:Container(
          decoration: BoxDecoration(
            color: Colors.white
            /*image: DecorationImage(
              image: NetworkImage("https://images.unsplash.com/photo-1579792685643-a4bb28186899?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE2fHx8ZW58MHx8fHw%3D&w=1000&q=80"),
              fit: BoxFit.cover,
            ),*/
          ),
          child: Center(
            child: Container(
              width: 400,
              height: 400,
              child: Card(
                color: Colors.blue,
                child:Scaffold(

                  body: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                      // boxShadow: [
                      //   BoxShadow(color: Colors.black,blurRadius: 10,),
                      //
                      // ]
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Login",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                        ),),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: userNameTextEditingController,
                            cursorColor: Colors.white,
                            onChanged: (value) {

                            },
                            style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge,fontWeight:FontWeight.w400,color: Colors.white) ,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces
                            ],
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,color: Colors.white,
                              ),
                              //errorText: userAccountSearchErrorText,
                              contentPadding: EdgeInsets.all(25),
                              hintText: "Enter your email",
                              labelText: "Enter your email",
                              errorStyle: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge,fontWeight:FontWeight.w400,color: Colors.redAccent),
                              focusedBorder:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.white,width: 3),borderRadius: BorderRadius.circular(0)),
                              border:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.white12,width: 3),borderRadius: BorderRadius.circular(0)),
                              enabledBorder:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.white,width: 2),borderRadius: BorderRadius.circular(0)),
                              //hintText: "e.g Abouzied",
                              hintStyle: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge,fontStyle:FontStyle.italic,fontWeight:FontWeight.w400,color: Colors.white54) ,
                              labelStyle: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge,fontStyle:FontStyle.italic,fontWeight:FontWeight.w400,color: Colors.white54) ,

                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: passwordTextEditingController,
                            cursorColor: Colors.white,
                            onChanged: (value) {

                            },
                            inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces
                          ],
                            obscuringCharacter: "*",
                            obscureText: shouldObscurePassword,
                            style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge,fontWeight:FontWeight.w400,color: Colors.white) ,

                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,color: Colors.white,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  onPressed: (){
                                    shouldObscurePassword=!shouldObscurePassword;
                                    setState(() {

                                    });
                                  },
                                  icon:Icon(shouldObscurePassword?Icons.visibility:Icons.visibility_off,color: Colors.white,),
                                ),
                              ),
                              //errorText: userAccountSearchErrorText,
                              contentPadding: EdgeInsets.all(25),
                              hintText: "Enter your password",
                              labelText: "Enter your password",
                              errorStyle: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge,fontWeight:FontWeight.w400,color: Colors.redAccent),
                              focusedBorder:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.white,width: 3),borderRadius: BorderRadius.circular(0)),
                              border:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.white12,width: 3),borderRadius: BorderRadius.circular(0)),
                              enabledBorder:  OutlineInputBorder(borderSide:  BorderSide(color: Colors.white,width: 2),borderRadius: BorderRadius.circular(0)),
                              //hintText: "e.g Abouzied",
                              labelStyle: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge,fontStyle:FontStyle.italic,fontWeight:FontWeight.w400,color: Colors.white54) ,
                              hintStyle: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.bodyLarge,fontStyle:FontStyle.italic,fontWeight:FontWeight.w400,color: Colors.white54) ,

                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Visibility(child:Text(loginErrorText??"",style: TextStyle(color: Colors.white),),visible: loginErrorText!=null,),
                        InkWell(
                          onTap: () async {
                            String loginResponse = await ApiRepository().newloginAdminPanel(userNameTextEditingController.text,passwordTextEditingController.text);
                            if(loginResponse=="Success"){
                              /// Navigate to dashboard

                              await ApiRepository().saveLoginState(userNameTextEditingController.text);

                              // context.go('/admin', extra: userNameTextEditingController.text.toString());
                              // context.go('/admin/dashboard', extra: userNameTextEditingController.text.toString());

                              // context.pushReplacementNamed('/admin', extra: userNameTextEditingController.text.toString());


                              Navigator.push(
                                context,
                                // MaterialPageRoute(builder: (context) =>  HomeScreenTabs()),
                                MaterialPageRoute(builder: (context) =>  NewHomeScreenTabs(AdminName: userNameTextEditingController.text.toString())),


                              );

                            }
                            else{
                              loginErrorText = loginResponse;
                              setState(() {
                              });
                            }
                          },

                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // border: Border.all(color:Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurStyle: BlurStyle.outer,
                                  offset: Offset(8, 10),
                                  // blurRadius: 10
                                )
                              ]
                            ),
                            child: Center(
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                    textStyle:
                                    Theme.of(context).textTheme.titleSmall,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
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
        ),
      ),
    );
  }
}
