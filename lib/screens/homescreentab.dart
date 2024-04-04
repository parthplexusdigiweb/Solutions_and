import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/screens/CategoryView.dart';
import 'package:thrivers/screens/addchallengesScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/AddKeywordsScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/chatgptSettings.dart';
import 'package:thrivers/screens/new%20added%20screens/chatgptscreen.dart';

import '../core/apphelper.dart';
import '../core/constants.dart';
import 'BrevoScreen.dart';
import 'addthriverscreen.dart';



class HomeScreenTabs extends StatefulWidget {



  const HomeScreenTabs({Key? key,}) : super(key: key);

  @override
  State<HomeScreenTabs> createState() => _HomeScreenTabsState();
}

class _HomeScreenTabsState extends State<HomeScreenTabs> {

  PageController page = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((p0) {
      page.jumpToPage(p0);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar:AppHelper().CustomAppBar(context),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              itemBorderRadius: BorderRadius.circular(100),
                itemOuterPadding: EdgeInsets.symmetric(horizontal: 30),
              // showTooltip: false,
                displayMode: SideMenuDisplayMode.auto,
                hoverColor: Colors.grey,
                iconSize: 20,
                selectedColor: Colors.blue.withOpacity(0.5),
                selectedTitleTextStyle: const TextStyle(color: Colors.black,fontSize: 14),
                selectedIconColor: Colors.black,
                backgroundColor: Colors.grey.withOpacity(0.2),
                unselectedIconColor: Colors.black,
                unselectedTitleTextStyle: TextStyle(color: Colors.black,fontSize: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
              // backgroundColor: Colors.blueGrey[700]
            ),
            title: Column(
              children: [
                SizedBox(height: 20,),
                /*ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),*/

                Text("Welcome , Admin" , style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    color: Colors.black
                )),
                SizedBox(height: 20,),
                Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
                SizedBox(height: 20,)
              ],
            ),
            footer: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'AKCess Pvt Ltd',
                style: TextStyle(fontSize: 15),
              ),
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Dashboard',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.home),
                //badgeColor: Colors.amber,
                //badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                //tooltipContent: "Dashboard Is Under Construction!",
              ),
              SideMenuItem(
                priority: 1,
                title: 'Thriver',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.event_note),
              ),
              /*SideMenuItem(
                priority: 2,
                title: 'Profiles',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.supervisor_account),
                *//*trailing: Container(
                    decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 3),
                      child: Text(
                        'New',
                        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                      ),
                    )),*//*
              ),*/

              SideMenuItem(
                priority: 2,
                title: 'Challenge',
                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "Challenge",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.book_online_sharp),
              ),

              // SideMenuItem(
              //   priority: 3,
              //   title: 'Solution',
              //   //badgeColor: Colors.amber,
              //   // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
              //   tooltipContent: "Solution",
              //   onTap: (page, _) {
              //     sideMenu.changePage(page);
              //   },
              //   icon: const Icon(Icons.article),
              // ),
              SideMenuItem(
                priority: 3,
                title: 'Users',
                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "Users",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.people_alt_outlined),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Settings',
                // isNotAMenu: true,

                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "Settings",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.settings),

              ),

              // SideMenuItem(
              //   priority: 5,
              //   title: 'Category',
              //   //badgeColor: Colors.amber,
              //   // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
              //   tooltipContent: "Category",
              //   onTap: (page, _) {
              //     sideMenu.changePage(page);
              //   },
              //   icon: const Icon(Icons.list_alt),
              // ),
              SideMenuItem(

                priority: 5,
                title: 'Keywords',
                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "Keywords",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.list_alt),
              ),
              SideMenuItem(
                priority: 6,
                title: 'Brevo',
                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "Brevo",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.key),
              ),
              SideMenuItem(
                priority: 7,
                title: 'Chat-Gpt ',
                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "Chat-Gpt",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                // icon: const Icon(Icons.email_outlined),
                icon: const Icon(Icons.search),
              ),
              SideMenuItem(
                priority: 8,
                title: 'Chat-Gpt Settings',
                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "Chat-Gpt Settings",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                // icon: const Icon(Icons.email_outlined),
                icon: const Icon(Icons.settings),
              ),
              // SideMenuItem(
              //   priority: 5,
              //   onTap:(page){
              //     sideMenu.changePage(5);
              //   },
              //   icon: const Icon(Icons.image_rounded),
              // ),
              // SideMenuItem(
              //   priority: 6,
              //   title: 'Only Title',
              //   onTap:(page){
              //     sideMenu.changePage(6);
              //   },
              // ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
               // BrevoScreen(),
                DashBoardScreen(),
                AddThriversScreen(),
                AddChallengesScreen(),
                AddThriversScreen(),
                BrevoScreen(),
                // CategoryTreeView(),
                AddKeywordsScreen(),
                BrevoScreen(),
                ChatGptScreen(),
                ChatGptSettingsScreen(),
                /*AddChallenges(),
                AddSolutionsScreen,

                UserListingScreen()*/


              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget DashBoardScreen(){
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      //appBar:AppHelper().CustomAppBarForRetailHub(context),
      body:Container(
        margin: EdgeInsets.all(20),
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
            width: 470,
            height: 300,
            child: Card(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Let's Create ,",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: primaryColorOfApp,
                        fontWeight: FontWeight.bold,

                      ),),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0,bottom: 10),
                      child: Text("What would you like to create Today",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300

                      ),),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  sideMenu.changePage(1);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.event,color: Colors.black,size: 30,),
                                      Text(
                                        'Thrivers',
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.titleLarge,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  sideMenu.changePage(2);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.book_online_sharp,color: Colors.black,size: 30,),
                                      Text(
                                        'Challanges',
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.titleLarge,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  sideMenu.changePage(4);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.person_outline_outlined,color: Colors.black,size: 30,),
                                      Text(
                                        'User',
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.titleLarge,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  sideMenu.changePage(4);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.article,color: Colors.black,size: 30,),
                                      Text(
                                        'Solutions',
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.titleLarge,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ),
                          ],
                        )
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
  }

}



