import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/core/constants.dart';

class SolutionsLandingScreen extends StatefulWidget {
  const SolutionsLandingScreen({super.key});

  @override
  State<SolutionsLandingScreen> createState() => _SolutionsLandingScreenState();
}

class _SolutionsLandingScreenState extends State<SolutionsLandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu, size: 40,),
        leadingWidth: 100,
        backgroundColor: Colors.grey.withOpacity(0),
        centerTitle: true,
        // title: Text("THRIVERS", style: GoogleFonts.montserrat(
        title: Text("SOLUTION INCLUSION", style: GoogleFonts.montserrat(
            textStyle: Theme.of(context).textTheme.headlineLarge,
            fontWeight: FontWeight.bold,
            color: Colors.black),),
      ),
      // key: _scaffoldKey,
      backgroundColor: Colors.grey.withOpacity(0.2),
      //appBar:AppHelper().CustomAppBarForRetailHub(context),
      body:Container(
        margin: EdgeInsets.symmetric(horizontal:20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),

          // image: DecorationImage(
          //   image: NetworkImage("https://e0.pxfuel.com/wallpapers/1/408/desktop-wallpaper-expo-2020-dubai-live-from-the-opening-ceremony.jpg"),
          //   fit: BoxFit.cover,
          // ),

        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .6,
            height: MediaQuery.of(context).size.height * .3,
            child: Card(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: Text("Let's Create ,",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    //     color: primaryColorOfApp,
                    //     fontWeight: FontWeight.bold,
                    //
                    //   ),),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 10.0,bottom: 10),
                    //   child: Text("What would you like to create Today",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    //       color: Colors.grey,
                    //       fontWeight: FontWeight.w300
                    //
                    //   ),),
                    // ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  context.go("/userlogin");
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.person,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            // 'Thrivers',
                                            'Employee',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                                textStyle:
                                                Theme.of(context).textTheme.titleLarge,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ),
                            ),
                            // Expanded(
                            //   child: InkWell(
                            //     onTap: () async {
                            //       context.push("/admin");;
                            //     },
                            //     child: Container(
                            //       margin: EdgeInsets.all(10),
                            //       height: 60,
                            //       decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         border: Border.all(color:primaryColorOfApp, width: 1.0),
                            //         borderRadius: BorderRadius.circular(20.0),
                            //       ),
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //           children: [
                            //             Icon(Icons.manage_accounts,color: Colors.black,size: 30,),
                            //             SizedBox(width: 5,),
                            //             Expanded(
                            //               child: Text(
                            //                 'Line manager',
                            //                 overflow: TextOverflow.ellipsis,
                            //                 style: GoogleFonts.montserrat(
                            //                     textStyle:
                            //                     Theme.of(context).textTheme.titleLarge,
                            //                     color: Colors.black),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //
                            //   ),
                            // ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  context.go("/admin");
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(

                                      children: [
                                        // Icon(Icons.person_outline_outlined,color: Colors.black,size: 30,),
                                        Icon(Icons.laptop_chromebook_outlined,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            // 'User',
                                            'Client admin',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                                textStyle:
                                                Theme.of(context).textTheme.titleLarge,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
