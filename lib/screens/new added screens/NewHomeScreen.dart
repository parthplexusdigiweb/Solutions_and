import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/screens/BrevoScreen.dart';
import 'package:thrivers/screens/CategoryView.dart';
import 'package:thrivers/screens/addchallengesScreen.dart';
import 'package:thrivers/screens/addthriverscreen.dart';
import 'package:thrivers/screens/demo.dart';
import 'package:thrivers/screens/new%20added%20screens/AddKeywordsScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/AdminAboutMePage.dart';
import 'package:thrivers/screens/new%20added%20screens/ReportScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/SuperAdminLoginScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/admin_user_setting_screen.dart';
import 'package:thrivers/screens/new%20added%20screens/chatgptSettings.dart';
import 'package:thrivers/screens/new%20added%20screens/chatgptscreen.dart';
import 'package:thrivers/screens/new%20added%20screens/thriverLandingScreen.dart';
import 'package:thrivers/screens/new%20added%20screens/user_list_screen_admin.dart';
import 'package:thrivers/screens/new%20added%20screens/AdminAboutMePage.dart';






class NewHomeScreenTabs extends StatefulWidget {
  var AdminName;

  NewHomeScreenTabs({this.AdminName});

  @override
  State<NewHomeScreenTabs> createState() => _NewHomeScreenTabsState();
}

class _NewHomeScreenTabsState extends State<NewHomeScreenTabs> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  PageController page = PageController();
  SideMenuController sideMenu = SideMenuController();

  bool isDrawerOpen = true;

  late DrawerController drawerController;


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
      onDrawerChanged: (isOpened) {

      },
      // key: _scaffoldKey,
      drawerEnableOpenDragGesture: true ,
      drawerDragStartBehavior: DragStartBehavior.start,
      // appBar:AppHelper().CustomAppBar(context),
      drawer: Drawer(
        child: ListView(
          children: [
            SideMenuScreen(),
          ],
        ),
      ),
      // drawer: newwDrawer(),
      appBar: AppBar(
        // leading: Icon(Icons.menu, size: 40,),
        leadingWidth: 100,
        backgroundColor: Colors.grey.withOpacity(0.2),
        centerTitle: true,
        // title: Text("THRIVERS", style: GoogleFonts.montserrat(
        title: Text("SOLUTIONS", style: GoogleFonts.montserrat(
            textStyle: Theme.of(context).textTheme.headlineLarge,
            fontWeight: FontWeight.bold,
            color: Colors.black),),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SideMenu(
          //   controller: sideMenu,
          //   style: SideMenuStyle(
          //     itemBorderRadius: BorderRadius.circular(100),
          //     itemOuterPadding: EdgeInsets.symmetric(horizontal: 30),
          //     // showTooltip: false,
          //     displayMode: SideMenuDisplayMode.auto,
          //     hoverColor: Colors.grey,
          //     iconSize: 20,
          //     selectedColor: Colors.blue.withOpacity(0.5),
          //     selectedTitleTextStyle: const TextStyle(color: Colors.black,fontSize: 14),
          //     selectedIconColor: Colors.black,
          //     backgroundColor: Colors.grey.withOpacity(0.2),
          //     unselectedIconColor: Colors.black,
          //     unselectedTitleTextStyle: TextStyle(color: Colors.black,fontSize: 14),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(0)),
          //     ),
          //     // backgroundColor: Colors.blueGrey[700]
          //   ),
          //   title: Column(
          //     children: [
          //       SizedBox(height: 20,),
          //       /*ConstrainedBox(
          //         constraints: const BoxConstraints(
          //           maxHeight: 150,
          //           maxWidth: 150,
          //         ),
          //         child: Image.asset(
          //           'assets/logo.png',
          //         ),
          //       ),*/
          //
          //       Text("Welcome , Admin" , style: GoogleFonts.montserrat(
          //           textStyle: Theme.of(context).textTheme.headlineMedium,
          //           color: Colors.black
          //       )),
          //       SizedBox(height: 20,),
          //       Divider(
          //         indent: 8.0,
          //         endIndent: 8.0,
          //       ),
          //       SizedBox(height: 20,)
          //     ],
          //   ),
          //   footer: const Padding(
          //     padding: EdgeInsets.all(8.0),
          //     child: Text(
          //       'AKCess Pvt Ltd',
          //       style: TextStyle(fontSize: 15),
          //     ),
          //   ),
          //   items: [
          //     SideMenuItem(
          //       priority: 0,
          //       title: 'Dashboard',
          //       onTap: (page, _) {
          //         sideMenu.changePage(page);
          //       },
          //       icon: const Icon(Icons.home),
          //       //badgeColor: Colors.amber,
          //       //badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //       //tooltipContent: "Dashboard Is Under Construction!",
          //     ),
          //     SideMenuItem(
          //       priority: 1,
          //       title: 'Thriver',
          //       onTap: (page, _) {
          //         sideMenu.changePage(page);
          //       },
          //       icon: const Icon(Icons.event_note),
          //     ),
          //     /*SideMenuItem(
          //       priority: 2,
          //       title: 'Profiles',
          //       onTap: (page, _) {
          //         sideMenu.changePage(page);
          //       },
          //       icon: const Icon(Icons.supervisor_account),
          //       *//*trailing: Container(
          //           decoration: const BoxDecoration(
          //               color: Colors.amber,
          //               borderRadius: BorderRadius.all(Radius.circular(6))),
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 6.0, vertical: 3),
          //             child: Text(
          //               'New',
          //               style: TextStyle(fontSize: 11, color: Colors.grey[800]),
          //             ),
          //           )),*//*
          //     ),*/
          //
          //     SideMenuItem(
          //       priority: 2,
          //       title: 'Challenge',
          //       //badgeColor: Colors.amber,
          //       // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //       tooltipContent: "Challenge",
          //       onTap: (page, _) {
          //         sideMenu.changePage(page);
          //       },
          //       icon: const Icon(Icons.book_online_sharp),
          //     ),
          //
          //     // SideMenuItem(
          //     //   priority: 3,
          //     //   title: 'Solution',
          //     //   //badgeColor: Colors.amber,
          //     //   // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //     //   tooltipContent: "Solution",
          //     //   onTap: (page, _) {
          //     //     sideMenu.changePage(page);
          //     //   },
          //     //   icon: const Icon(Icons.article),
          //     // ),
          //     SideMenuItem(
          //       priority: 3,
          //       title: 'Users',
          //       //badgeColor: Colors.amber,
          //       // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //       tooltipContent: "Users",
          //       onTap: (page, _) {
          //         sideMenu.changePage(page);
          //       },
          //       icon: const Icon(Icons.people_alt_outlined),
          //     ),
          //     SideMenuItem(
          //       priority: 4,
          //       title: 'Settings',
          //       // isNotAMenu: true,
          //
          //       //badgeColor: Colors.amber,
          //       // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //       tooltipContent: "Settings",
          //       onTap: (page, _) {
          //         sideMenu.changePage(page);
          //       },
          //       icon: const Icon(Icons.settings),
          //
          //     ),
          //
          //     // SideMenuItem(
          //     //   priority: 5,
          //     //   title: 'Category',
          //     //   //badgeColor: Colors.amber,
          //     //   // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //     //   tooltipContent: "Category",
          //     //   onTap: (page, _) {
          //     //     sideMenu.changePage(page);
          //     //   },
          //     //   icon: const Icon(Icons.list_alt),
          //     // ),
          //     SideMenuItem(
          //
          //       priority: 5,
          //       title: 'Keywords',
          //       //badgeColor: Colors.amber,
          //       // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //       tooltipContent: "Keywords",
          //       onTap: (page, _) {
          //         sideMenu.changePage(page);
          //       },
          //       icon: const Icon(Icons.list_alt),
          //     ),
          //     SideMenuItem(
          //       priority: 6,
          //       title: 'Brevo',
          //       //badgeColor: Colors.amber,
          //       // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //       tooltipContent: "Brevo",
          //       onTap: (page, _) {
          //         sideMenu.changePage(page);
          //       },
          //       icon: const Icon(Icons.key),
          //     ),
          //     SideMenuItem(
          //       priority: 7,
          //       title: 'Chat-Gpt ',
          //       //badgeColor: Colors.amber,
          //       // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //       tooltipContent: "Chat-Gpt",
          //       onTap: (page, _) {
          //         sideMenu.changePage(page);
          //       },
          //       // icon: const Icon(Icons.email_outlined),
          //       icon: const Icon(Icons.search),
          //     ),
          //     SideMenuItem(
          //       priority: 8,
          //       title: 'Chat-Gpt Settings',
          //       //badgeColor: Colors.amber,
          //       // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //       tooltipContent: "Chat-Gpt Settings",
          //       onTap: (page, _) {
          //         sideMenu.changePage(page);
          //       },
          //       // icon: const Icon(Icons.email_outlined),
          //       icon: const Icon(Icons.settings),
          //     ),
          //     // SideMenuItem(
          //     //   priority: 5,
          //     //   onTap:(page){
          //     //     sideMenu.changePage(5);
          //     //   },
          //     //   icon: const Icon(Icons.image_rounded),
          //     // ),
          //     // SideMenuItem(
          //     //   priority: 6,
          //     //   title: 'Only Title',
          //     //   onTap:(page){
          //     //     sideMenu.changePage(6);
          //     //   },
          //     // ),
          //   ],
          // ),
          Expanded(
            child: PageView(
              controller: page,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // BrevoScreen(),
                DashBoardScreen(),
                AdminAboutMePage(AdminName: (widget.AdminName==null) ? "Admin" : widget.AdminName),
                AddThriversScreen(AdminName: (widget.AdminName==null) ? "Admin" : widget.AdminName),
                AddChallengesScreen(AdminName: (widget.AdminName==null) ? "Admin" : widget.AdminName),
                ReportScreen(),
                // AddThriversScreen(),
                // BrevoScreen(),
                UserListScreenForAdmin(),
                AdminUserSettingScreen(),
                // CategoryTreeView(),
                AddKeywordsScreen(),
                // DSemo(),
                BrevoScreen(),
                ChatGptScreen(),
                ChatGptSettingsScreen(),
                // AdminAboutMePage(),
                // DSemo(),
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
      // key: _scaffoldKey,
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
            width: 530,
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
                                  // sideMenu.changePage(2);
                                  page.jumpToPage(1);
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
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  // sideMenu.changePage(3);
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
                                        Icon(Icons.manage_accounts,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            'Line manager',
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
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  // sideMenu.changePage(5);
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
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  // sideMenu.changePage(6);
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
                                        // Icon(Icons.article,color: Colors.black,size: 30,),
                                        Icon(Icons.admin_panel_settings,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),

                                        Expanded(
                                          child: Text(
                                            // 'Solutions',
                                            'Super Admin',
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


  Widget SideMenuScreen(){
    return SideMenu(
        controller: sideMenu,
        style: SideMenuStyle(
          itemBorderRadius: BorderRadius.circular(100),
          itemOuterPadding: EdgeInsets.symmetric(horizontal: 10),
          // showTooltip: false,
          displayMode: SideMenuDisplayMode.open,
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

            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Welcome, ${(widget.AdminName==null) ? "Admin" : widget.AdminName}" , style: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                  color: Colors.black
              )),
            ),
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
            ' My Wings Ltd',
            style: TextStyle(fontSize: 15),
          ),
        ),
        items: [
          SideMenuItem(
            priority: 0,
            title: 'Dashboard',
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home),
            //badgeColor: Colors.amber,
            //badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            //tooltipContent: "Dashboard Is Under Construction!",
          ),
          SideMenuItem(
            priority: 1,
            // title: 'Thriver',
            title: 'About Me',
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.add_box_outlined),
          ),

          SideMenuItem(
            priority: 2,
            // title: 'Thriver',
            title: 'Solutions',
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.event_note),
          ),

          SideMenuItem(
            priority: 3,
            title: 'Challenges',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Challenges",
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);

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
            priority: 4,
            title: 'Report',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Report",
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);

            },
            icon: const Icon(Icons.insert_drive_file_outlined),
          ),
          SideMenuItem(
            priority: 5,
            title: 'Users',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Users",
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);

            },
            icon: const Icon(Icons.people_alt_outlined),
          ),
          SideMenuItem(
            priority: 6,
            title: 'Admin Users',
            // isNotAMenu: true,

            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Admin Users",
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);

            },
            icon: const Icon(Icons.admin_panel_settings),

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

            priority: 7,
            title: 'Keywords',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Keywords",
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);

            },
            icon: const Icon(Icons.list_alt),
          ),
          SideMenuItem(
            priority: 8,
            title: 'Brevo',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Brevo",
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);

            },
            icon: const Icon(Icons.key),
          ),
          SideMenuItem(
            priority: 9,
            title: 'Chat-Gpt ',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Chat-Gpt",
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);

            },
            // icon: const Icon(Icons.email_outlined),
            icon: const Icon(Icons.search),
          ),
          SideMenuItem(
            priority: 10,
            title: 'Solutions Chat-Gpt Settings',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Solutions Chat-Gpt Settings",
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);
            },
            // icon: const Icon(Icons.email_outlined),
            icon: const Icon(Icons.settings_accessibility),
          ),
          SideMenuItem(
            priority: 11,
            title: 'Challenges Chat-Gpt Settings',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Challenges Chat-Gpt Settings",
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);
            },
            // icon: const Icon(Icons.email_outlined),
            icon: const Icon(Icons.settings_suggest),
          ),
          // SideMenuItem(
          //   priority: 11,
          //   title: 'Import',
          //   //badgeColor: Colors.amber,
          //   // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //   tooltipContent: "Import",
          //   onTap: (page, _) {
          //     sideMenu.changePage(page);
          //     Navigator.pop(context);
          //   },
          //   // icon: const Icon(Icons.email_outlined),
          //   icon: const Icon(Icons.settings_suggest),
          // ),
          SideMenuItem(
            priority: 12,
            title: 'Log Out',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Log Out",
            onTap: (page, _) {
              // sideMenu.changePage(page);
              showDialog(context: context, builder: (context) => AlertDialog(
                title: Text('Logout Confirmation'),
                content: Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Perform logout logic here
                      ApiRepository().logout();
                      context.go('/');
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SuperAdminLoginScreen()));
                    },
                    child: Text('Logout'),
                  ),
                ],
              )
              );
            },
            // icon: const Icon(Icons.email_outlined),
            icon: const Icon(Icons.logout),
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
      );
  }

  Widget DrawerControllers() {
    return DrawerController(
      alignment: DrawerAlignment.start,
      child: Drawer(
        child: ListView(
          children: [
            SideMenuScreen(),
            // DrawerHeader(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text("Welcome , Admin" , style: GoogleFonts.montserrat(
            //           textStyle: Theme.of(context).textTheme.headlineMedium,
            //           color: Colors.black
            //       )),
            //     ],
            //   ),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.withOpacity(0.2),
            //   ),
            // ),
            // ListTile(
            //   title: Text("Dashboard"),
            //   leading: Icon(Icons.home),
            //   onTap: () {
            //     sideMenu.changePage(0);
            //   },
            // ),
            // ListTile(
            //   title: Text("Thrivers"),
            //   leading: Icon(Icons.event_note),
            //   onTap: () {
            //     sideMenu.changePage(1);
            //   },
            // ),
          ],
        ),
      ),
      isDrawerOpen: true,
    );
  }

  Widget newwDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome , Admin" , style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    color: Colors.black
                )),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          ListTile(
            title: Text("Dashboard"),
            leading: Icon(Icons.home),
            onTap: () {
              sideMenu.changePage(0);
            },
          ),
          ListTile(
            title: Text("Thrivers"),
            leading: Icon(Icons.event_note),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddThriversScreen()));
              // sideMenu.changePage(1);
            },
          ),
          ListTile(
            title: Text("Challenges"),
            leading: Icon(Icons.book_online_sharp),
            onTap: () {
              sideMenu.changePage(2);
            },
          ),
          ListTile(
            title: Text("Users"),
            leading: Icon(Icons.people_alt_outlined),
            onTap: () {
              sideMenu.changePage(3);
            },
          ),
          ListTile(
            title: Text("Settings"),
            leading: Icon(Icons.settings),
            onTap: () {
              sideMenu.changePage(4);
            },
          ),
          ListTile(
            title: Text("Keywords"),
            leading: Icon(Icons.list_alt),
            onTap: () {
              sideMenu.changePage(5);
            },
          ),
          ListTile(
            title: Text("Brevo"),
            leading: Icon(Icons.key),
            onTap: () {
              sideMenu.changePage(6);
            },
          ),
          ListTile(
            title: Text("Chat Gpt"),
            leading: Icon(Icons.search),
            onTap: () {
              sideMenu.changePage(7);
            },
          ),
          ListTile(
            title: Text("Chat Gpt Settings"),
            leading: Icon(Icons.search),
            onTap: () {
              sideMenu.changePage(8);
            },
          ),
        ],
      )
    );
  }
}



