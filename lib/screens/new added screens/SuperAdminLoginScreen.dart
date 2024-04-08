
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/screens/homescreentab.dart';
import 'package:thrivers/screens/new%20added%20screens/NewHomeScreen.dart';




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

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

        leading: Container(),

        title: Center(
          child: Text("SOLUTIONS", style: GoogleFonts.montserrat(
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
                    boxShadow: [
                      BoxShadow(color: Colors.black,blurRadius: 10,),

                    ]
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Admin Login",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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

                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,color: Colors.white,
                            ),
                            //errorText: userAccountSearchErrorText,
                            contentPadding: EdgeInsets.all(25),
                            hintText: "Enter your Username",
                            labelText: "Enter your Username",
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
                            context.go('/', extra: userNameTextEditingController.text.toString());

                            // context.pushReplacementNamed('/admin', extra: userNameTextEditingController.text.toString());


                            // Navigator.push(
                            //   context,
                            //   // MaterialPageRoute(builder: (context) =>  HomeScreenTabs()),
                            //   MaterialPageRoute(builder: (context) =>  NewHomeScreenTabs(AdminName: userNameTextEditingController.text.toString())),
                            //
                            //
                            // );
                          }
                          else{
                            loginErrorText = loginResponse;
                            setState(() {
                            });
                          }
                        },

                        child: Material(
                          elevation: 20,
                          child: Container(
                            margin: EdgeInsets.all(0),
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // border: Border.all(color:Colors.blue, width: 2.0),
                              // borderRadius: BorderRadius.circular(15.0),
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

                      ),
                    ],
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
