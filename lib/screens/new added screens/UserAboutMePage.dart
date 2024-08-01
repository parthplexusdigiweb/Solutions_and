import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/Provider/AddKeywordsProvider.dart';
import 'package:thrivers/Provider/previewProvider.dart';
import 'package:thrivers/Provider/userAboutMeProvider.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';
import 'package:thrivers/main.dart';
import 'package:thrivers/model/soluton_table_model.dart';
import 'package:thrivers/screens/addthriverscreen.dart';
import 'package:thrivers/screens/new%20added%20screens/UserLoginPage.dart';
import 'package:thrivers/screens/not%20used%20screen/DashboardCommonWidgets.dart';
import 'package:thrivers/screens/userLoginAboutME/UserLogedInAboutMePage.dart';

import '../../widget/progressbar_widget.dart';


class UserAboutMePage extends StatefulWidget {

   var isClientLogeddin;
    var emailId;
    var loginToken;

   UserAboutMePage({ this.isClientLogeddin, required this.emailId, this.loginToken});

   @override
  State<UserAboutMePage> createState() => _UserAboutMePageState();
}

class _UserAboutMePageState extends State<UserAboutMePage> {
  late PageController page;
  SideMenuController sideMenu = SideMenuController();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController employerController = TextEditingController();
  TextEditingController divisionOrSectionController = TextEditingController();
  TextEditingController RoleController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  TextEditingController EmployeeNumberController = TextEditingController();
  TextEditingController LineManagerController = TextEditingController();
  TextEditingController NotesController = TextEditingController();
  TextEditingController searchbyCatcontroller = TextEditingController();
  TextEditingController searchbyTagcontroller = TextEditingController();

  late  AddKeywordProvider _addKeywordProvider;
  late  UserAboutMEProvider _userAboutMEProvider;
  late  PreviewProvider _userPreviewProvider;

  bool isVisible = false;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }


  Future<void> _initSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    var isLoggedIn = await prefs.getBool('isLoggedIn');    // After clearing, navigate to the login screen or any other appropriate screen
    var userEmail = await prefs.getString('userEmail');
    var loginToken = await prefs.getString('loginToken');
    print("isLoggedIn: $isLoggedIn");
    print("userEmail: $userEmail");
    print("userEmail: $loginToken");
  }

  Future<Map<String, dynamic>> _getStoredPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    isloggedIn = prefs.getBool('isLoggedIn') ?? false;
     emailId = prefs.getString('emailId') ?? '';
    return {'isLoggedIn': isloggedIn, 'emailId': emailId};
  }


  Future<void> _logout() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isLoggedIn', false);    // After clearing, navigate to the login screen or any other appropriate screen
    // await prefs.setString('userEmail', "");    // After clearing, navigate to the login screen or any other appropriate screen
    // context.go("/userLogin"); // Replace '/login' with your actual login screen route
    // sharedPreferences?.remove("isLoggedIn");
    // sharedPreferences?.remove("userEmail");
    // await sharedPreferences?.clear();
    // await widget.loginToken.clear();
    context.replace("/userLogin"); // Replace '/login' with your actual login screen route
  }



  Future<void> newlogout(BuildContext context) async {
    // Clear the login token or any other authentication data
    // For example, clear from shared preferences or secure storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to the login page
    Navigator.pushNamedAndRemoveUntil(context, '/userlogin', (route) => false);
  }

  void logoutt() {
    sharedPreferences?.remove("isLoggedIn");
    sharedPreferences?.remove("userEmail");
    sharedPreferences?.remove("loginToken");

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => UserLoginPage()),
          (Route<dynamic> route) => false,
    );
  }

  // late final PreviewProvider _userPreviewProvider;


  @override
  void initState() {
    page = PageController(initialPage: 0??0);
    sideMenu.addListener((p0) {
      print("Listener Executed");
      page.jumpToPage(p0);
    });
    _addKeywordProvider = Provider.of<AddKeywordProvider>(context, listen: false);
    _userAboutMEProvider = Provider.of<UserAboutMEProvider>(context, listen: false);
    _userPreviewProvider = Provider.of<PreviewProvider>(context, listen: false);
    // _loadDataForPage(_currentPage);
    super.initState();
    isVisible = !isVisible;
    _getStoredPreferences();
    _fetchUserData();
    // WidgetsBinding.instance!.addPostFrameCallback((_) {});
      // _initSharedPreferences();
  }


  _fetchUserData() async {
    _userPreviewProvider.updateloginloader(false);
    print("widget.emailId; ${widget.emailId}");
    QuerySnapshot userData = await FirebaseFirestore.instance.collection('Users').where('email' , isEqualTo: widget.emailId).get();
    print("userData; ${userData.docs.first['UserName']}");
    print("UserEmail; ${userData.docs.first['email']}");
    print("userData.docs:  ${userData.docs.first.id}");

    _userPreviewProvider.userdocsUpdate(userData.docs.first.id);
    _userPreviewProvider.UserNameUpdate(userData.docs.first['UserName']);
    _userPreviewProvider.UserEmailUpdate(userData.docs.first['email']);
    // _userPreviewProvider.userdocs = await userData.docs.first.id;
    // _userPreviewProvider.UserName = await userData.docs.first['UserName'];
    // _userPreviewProvider.UserEmail = await userData.docs.first['email'];
    nameController.text = await userData.docs.first['UserName'];
    passwordController.text = await userData.docs.first['Password'];
    employerController.text = await userData.docs.first['Employer'];
    divisionOrSectionController.text = await userData.docs.first['Division_or_Section'];
    RoleController.text = await userData.docs.first['Role'];
    LocationController.text = await userData.docs.first['Location'];
    EmployeeNumberController.text = await userData.docs.first['Employee_Number'];
    LineManagerController.text = await userData.docs.first['Line_Manager'];
    _userPreviewProvider.updateloginloader(true);
  }

    @override
    Widget build(BuildContext context) {
      return Consumer<PreviewProvider>(
          builder: (c,previewProvider, _){
            return previewProvider.getloginloader == false ? loadingView(previewProvider.getloginloader) : Scaffold(
              // appBar: DashboardCommonWidgets().CommonAppBar(context,true,false,false,emailID: widget.emailId,showSettings: widget.isClientLogeddin,showLogout: true),
              // appBar: DashboardCommonWidgets().CommonAppBar(context,true,true,true,emailID: "fenilpatel120501@gmail.com",showSettings: true,showLogout: true),
                onDrawerChanged: (isOpened) {

                },
                // key: _scaffoldKey,
                drawerEnableOpenDragGesture: true ,
                drawerDragStartBehavior: DragStartBehavior.start,
                // appBar:AppHelper().CustomAppBar(context),
                drawerScrimColor: Colors.black26,
                // drawer: Drawer(
                //   elevation: 50,
                //   child: ListView(
                //     children: [
                //       SideMenuScreen(),
                //     ],
                //   ),
                // ),
                appBar: AppBar(
                  leading: InkWell(
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (context) => Consumer<PreviewProvider>(
                            builder: (c,previewProvider, _){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                title: Row(
                                  children: [
                                    Icon(Icons.warning_rounded, color: Colors.deepPurple, size: 60),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Logout Confirmation',
                                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Are you sure you want to log out?",
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                              fontSize: 16.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap:  () async {
                                            // Navigator.pop(context);
                                            // print("Dialog closed");
                                            // setState(() {
                                            //   logout(context);
                                            // });
                                            // context.go('/userLogin');
                                            previewProvider.userlogout(context);
                                            print("Navigated to login screen"); // Debugging: Check if navigation is triggered
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 12),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: Text("Log out",style: TextStyle(color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,),),
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: InkWell(
                                          onTap : (){
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 12),

                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: Text("Cancel",style: TextStyle(color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,),),
                                              )

                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              );
                              // return AlertDialog(
                              //   title: Text('Logout Confirmation'),
                              //   content: Text('Are you sure you want to log out?'),
                              //   actions: [
                              //     TextButton(
                              //       onPressed: () {
                              //         Navigator.of(context).pop(); // Close the dialog
                              //       },
                              //       child: Text('Cancel'),
                              //     ),
                              //     TextButton(
                              //       onPressed: () async {
                              //         // Navigator.pop(context);
                              //         // print("Dialog closed");
                              //         // setState(() {
                              //         //   logout(context);
                              //         // });
                              //         // context.go('/userLogin');
                              //         previewProvider.userlogout(context);
                              //         print("Navigated to login screen"); // Debugging: Check if navigation is triggered
                              //       },
                              //       child: Text('Logout'),
                              //     ),
                              //   ],
                              // );
                              },
                          )
                      );
                    },
                    child: Container(
                      child: Row(
                        children: [
                          SizedBox(width: 5,),
                          Icon(Icons.logout,color: Colors.white),
                          SizedBox(width: 5,),
                          Text("Logout",style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          )
                        ],),
                    ),
                  ),
                  leadingWidth: MediaQuery.of(context).size.width * .1,
                  backgroundColor: Colors.blue,
                  centerTitle: true,
                  title: Text("Solution Inclusion", style: GoogleFonts.montserrat(
                      textStyle: Theme.of(context).textTheme.headlineLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),),
                  actions: [
                    InkWell(
                      onTap: (){
                        page.jumpToPage(1);
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage("https://st3.depositphotos.com/19428878/36416/v/450/depositphotos_364169666-stock-illustration-default-avatar-profile-icon-vector.jpg"),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: previewProvider.UserName==null || previewProvider.UserEmail==null ? CircularProgressIndicator(color: Colors.white,): Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${previewProvider.UserName},",style: TextStyle(color: Colors.white),),
                                  Text("${previewProvider.UserEmail}",style: TextStyle(color: Colors.white),),
                                ],
                              )
                          ),
                          SizedBox(width: 15,)
                        ],
                      ),
                    ),

                  ],
                ),
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: page,
                        children: [
                          // DashBoardScreen(),
                          // EmployeePageView(),
                          // UserLogedInAboutMePage(AdminName: widget.emailId,Pagejump: false, sideMenu: sideMenu),
                          UserLogedInAboutMePage(AdminName: widget.emailId,tabindex: previewProvider.tabindex, sideMenu: sideMenu),
                          AboutMEScreen(previewProvider.userdocs),
                          // UserLogedInAboutMePage(AdminName: widget.emailId,),
                        ],
                      ),
                    ),
                  ],
                )
            );
          });
  }

  Widget EmployeePageView(){
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
            // width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Card(

              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text("Employee home page",style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.headlineLarge,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 10.0,bottom: 5),
                      //   child: Text("",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      //       color: Colors.grey,
                      //       fontWeight: FontWeight.w300
                      //
                      //   ),),
                      // ),
                      ///
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       InkWell(
                      //           onTap: (){
                      //             widget.Pagejump.jumpToPage(0);
                      //           },
                      //           child: Text("<<- Dashboard",
                      //             style: TextStyle(
                      //                 // decoration: TextDecoration.underline
                      //             ),
                      //           )),
                      //     ],
                      //   ),
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              // _navigateToTab(3);
                              // await showAddAddAboutMeDialogBox();
                              page.jumpToPage(1);
                              sideMenu.changePage(1);
                              _userPreviewProvider.pagechange(1);
                              ///
                              // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').where('AB_Status', isEqualTo: 'Draft').where("Email", isEqualTo: widget.AdminName).orderBy('AB_id', descending: true).limit(1).get();
                              //
                              // // Check if there are any documents
                              //
                              // print("querySnapshot :${querySnapshot}");
                              // print("querySnapshot :${querySnapshot.docs.length}");
                              //
                              // if (querySnapshot.docs.isNotEmpty) {
                              //   // Get the last document
                              //   DocumentSnapshot lastDocument = querySnapshot.docs.first;
                              //   print("lastDocument :$lastDocument");
                              //   showUserLogedInEditAboutMeDialogBox(lastDocument,0);
                              // }
                              // else{
                              //   _navigateToTab(0);
                              //   await showAddAddAboutMeDialogBox();
                              // }
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 60,
                              width: MediaQuery.of(context).size.width * 0.2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color:primaryColorOfApp, width: 1.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_box_outlined,color: Colors.black,size: 30,),
                                    SizedBox(width: 5,),
                                    Flexible(
                                      child: Text(
                                        // 'Thrivers',
                                        'Employee data',
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

                          Row(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  // sideMenu.changePage(3);
                                  page.jumpToPage(1);
                                  sideMenu.changePage(1);
                                  _userPreviewProvider.pagechange(2);
                                  // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').where('AB_Status', isEqualTo: 'Draft').where("Email", isEqualTo: widget.AdminName).orderBy('AB_id', descending: true).limit(1).get();
                                  //
                                  // // Check if there are any documents
                                  //
                                  // print("querySnapshot :${querySnapshot}");
                                  // print("querySnapshot :${querySnapshot.docs.length}");
                                  //
                                  // if (querySnapshot.docs.isNotEmpty) {
                                  //   // Get the last document
                                  //   DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                  //   print("lastDocument :$lastDocument");
                                  //   showUserLogedInEditAboutMeDialogBox(lastDocument,1);
                                  // }
                                  // else{
                                  //   _navigateToTab(1);
                                  //   await showAddAddAboutMeDialogBox();
                                  // }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  width: MediaQuery.of(context).size.width * 0.2,

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_add_outlined ,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),
                                        Flexible(
                                          child: Text(
                                            'Insight about me',
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

                              InkWell(
                                onTap: () async {
                                  page.jumpToPage(1);
                                  sideMenu.changePage(1);
                                  _userPreviewProvider.pagechange(3);
                                  // sideMenu.changePage(5);
                                  // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').where('AB_Status', isEqualTo: 'Draft').where("Email", isEqualTo: widget.AdminName).orderBy('AB_id', descending: true).limit(1).get();
                                  //
                                  // // Check if there are any documents
                                  //
                                  // print("querySnapshot :${querySnapshot}");
                                  // print("querySnapshot :${querySnapshot.docs.length}");
                                  //
                                  // if (querySnapshot.docs.isNotEmpty) {
                                  //   // Get the last document
                                  //   DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                  //   print("lastDocument :$lastDocument");
                                  //   showUserLogedInEditAboutMeDialogBox(lastDocument,2);
                                  // }
                                  // else{
                                  //   _navigateToTab(2);
                                  //   await showAddAddAboutMeDialogBox();
                                  // }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  width: MediaQuery.of(context).size.width * 0.2,

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.person_outline_outlined,color: Colors.black,size: 30,),
                                        Icon(Icons.edit_attributes,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),
                                        Flexible(
                                          child: Text(
                                            // 'User',
                                            'My attributes',
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

                              InkWell(
                                onTap: () async {
                                  page.jumpToPage(1);
                                  sideMenu.changePage(1);
                                  _userPreviewProvider.pagechange(4);
                                  // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').where('AB_Status', isEqualTo: 'Draft').where("Email", isEqualTo: widget.AdminName).orderBy('AB_id', descending: true).limit(1).get();
                                  //
                                  // // Check if there are any documents
                                  //
                                  // print("querySnapshot :${querySnapshot}");
                                  // print("querySnapshot :${querySnapshot.docs.length}");
                                  //
                                  // if (querySnapshot.docs.isNotEmpty) {
                                  //   // Get the last document
                                  //   DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                  //   print("lastDocument :$lastDocument");
                                  //   showUserLogedInEditAboutMeDialogBox(lastDocument,3);
                                  // }
                                  // else{
                                  //   _navigateToTab(3);
                                  //   await showAddAddAboutMeDialogBox();
                                  // }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  width: MediaQuery.of(context).size.width * 0.2,

                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.person_outline_outlined,color: Colors.black,size: 30,),
                                        Icon(Icons.sync_problem,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),
                                        Flexible(
                                          child: Text(
                                            // 'User',
                                            'My challenges',
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

                              InkWell(
                                onTap: () async {
                                  page.jumpToPage(1);
                                  sideMenu.changePage(1);
                                  _userPreviewProvider.pagechange(5);
                                  // sideMenu.changePage(6);
                                  // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').where('AB_Status', isEqualTo: 'Draft').where("Email", isEqualTo: widget.AdminName).orderBy('AB_id', descending: true).limit(1).get();
                                  //
                                  // // Check if there are any documents
                                  //
                                  // print("querySnapshot :${querySnapshot}");
                                  // print("querySnapshot :${querySnapshot.docs.length}");
                                  //
                                  // if (querySnapshot.docs.isNotEmpty) {
                                  //   // Get the last document
                                  //   DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                  //   print("lastDocument :$lastDocument");
                                  //   showUserLogedInEditAboutMeDialogBox(lastDocument,4);
                                  // } else{
                                  //   _navigateToTab(4);
                                  //   await showAddAddAboutMeDialogBox();
                                  // }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.article,color: Colors.black,size: 30,),
                                        Icon(Icons.checklist_rtl,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),

                                        Flexible(
                                          child: Text(
                                            // 'Solutions',
                                            'My solutions',
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

                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  page.jumpToPage(1);
                                  sideMenu.changePage(1);
                                  _userPreviewProvider.pagechange(6);
                                  // page.jumpToPage(1);
                                  // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').where('AB_Status', isEqualTo: 'Draft').where("Email", isEqualTo: widget.AdminName).orderBy('AB_id', descending: true).limit(1).get();
                                  //
                                  // // Check if there are any documents
                                  //
                                  // print("querySnapshot :${querySnapshot}");
                                  // print("querySnapshot :${querySnapshot.docs.length}");
                                  //
                                  // if (querySnapshot.docs.isNotEmpty) {
                                  //   // Get the last document
                                  //   DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                  //   print("lastDocument :$lastDocument");
                                  //   showUserLogedInEditAboutMeDialogBox(lastDocument,5);
                                  // }
                                  // else{
                                  //   _navigateToTab(5);
                                  //   await showAddAddAboutMeDialogBox();
                                  // }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.article,color: Colors.black,size: 30,),
                                        Icon(Icons.insert_drive_file,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),

                                        Flexible(
                                          child: Text(
                                            // 'Solutions',
                                            'Generate reports',
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

                              InkWell(
                                onTap: () async {
                                  page.jumpToPage(1);
                                  sideMenu.changePage(1);
                                  _userPreviewProvider.pagechange(7);
                                  // page.jumpToPage(1);
                                  // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').where('AB_Status', isEqualTo: 'Draft').where("Email", isEqualTo: widget.AdminName).orderBy('AB_id', descending: true).limit(1).get();
                                  //
                                  // // Check if there are any documents
                                  //
                                  // print("querySnapshot :${querySnapshot}");
                                  // print("querySnapshot :${querySnapshot.docs.length}");
                                  //
                                  // if (querySnapshot.docs.isNotEmpty) {
                                  //   // Get the last document
                                  //   DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                  //   print("lastDocument :$lastDocument");
                                  //   showUserLogedInEditAboutMeDialogBox(lastDocument,6);
                                  // }
                                  // else{
                                  //   // _navigateToTab(5);
                                  //   // await showAddAddAboutMeDialogBox();
                                  //   page.jumpToPage(1);
                                  //   print("page.jumpToPage(1)");
                                  // }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:primaryColorOfApp, width: 1.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Icon(Icons.person_outline_outlined,color: Colors.black,size: 30,),
                                        Icon(Icons.library_books_outlined,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),
                                        Flexible(
                                          child: Text(
                                            // 'User',
                                            'My library',
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
                            ],
                          ),


                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: InkWell(
                          //         onTap: () {},
                          //         child: Container(
                          //           margin: EdgeInsets.all(10),
                          //           height: 60,
                          //
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             border: Border.all(color:primaryColorOfApp, width: 1.0),
                          //             borderRadius: BorderRadius.circular(20.0),
                          //           ),
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //               children: [
                          //                 // Icon(Icons.article,color: Colors.black,size: 30,),
                          //                 Icon(Icons.medical_information_outlined,color: Colors.black,size: 30,),
                          //                 SizedBox(width: 5,),
                          //
                          //                 Expanded(
                          //                   child: Text(
                          //                     // 'Solutions',
                          //                     'Medical and Personal',
                          //                     overflow: TextOverflow.ellipsis,
                          //                     style: GoogleFonts.montserrat(
                          //                         textStyle:
                          //                         Theme.of(context).textTheme.titleLarge,
                          //                         color: Colors.black),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: InkWell(
                          //         onTap: () {},
                          //         child: Container(
                          //           margin: EdgeInsets.all(10),
                          //           height: 60,
                          //
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             border: Border.all(color:primaryColorOfApp, width: 1.0),
                          //             borderRadius: BorderRadius.circular(20.0),
                          //           ),
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //               children: [
                          //                 // Icon(Icons.article,color: Colors.black,size: 30,),
                          //                 Icon(Icons.perm_device_info_sharp,color: Colors.black,size: 30,),
                          //                 SizedBox(width: 5,),
                          //
                          //                 Expanded(
                          //                   child: Text(
                          //                     // 'Solutions',
                          //                     'Useful info',
                          //                     overflow: TextOverflow.ellipsis,
                          //                     style: GoogleFonts.montserrat(
                          //                         textStyle:
                          //                         Theme.of(context).textTheme.titleLarge,
                          //                         color: Colors.black),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                        ],
                      )
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


  Widget DashBoardScreen(){
    return Scaffold(
      // key: _scaffoldKey,
      backgroundColor: Colors.grey.withOpacity(0.2),
      //appBar:AppHelper().CustomAppBarForRetailHub(context),
      body:Container(
        // margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          // borderRadius: BorderRadius.circular(20),

          // image: DecorationImage(
          //   image: NetworkImage("https://e0.pxfuel.com/wallpapers/1/408/desktop-wallpaper-expo-2020-dubai-live-from-the-opening-ceremony.jpg"),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.3,
            child: Card(
              elevation: 20,
              color: Colors.blue.shade100,
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
                          color: Colors.black87,
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
                                    border: Border.all(color:Colors.blue, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.description,color: Colors.blue,size: 30,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            // 'Thrivers',
                                            'About ME',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                                textStyle:
                                                Theme.of(context).textTheme.titleLarge,
                                                color: Colors.blue),
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
                                  sideMenu.changePage(2);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color:Colors.blue, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.person,color: Colors.blue,size: 30,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            'Employee',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                                textStyle:
                                                Theme.of(context).textTheme.titleLarge,
                                                color: Colors.blue),
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
                        // InkWell(
                        //   onTap: () async{ // Make onTap callback async
                        //     print("Logout button tapped"); // Debugging: Check if the logout button is tapped
                        //     showDialog(
                        //       context: context,
                        //       builder: (context) => AlertDialog(
                        //         title: Text('Logout Confirmation'),
                        //         content: Text('Are you sure you want to log out?'),
                        //         actions: [
                        //           TextButton(
                        //             onPressed: () {
                        //               Navigator.of(context).pop(); // Close the dialog
                        //             },
                        //             child: Text('Cancel'),
                        //           ),
                        //           TextButton(
                        //             onPressed: () async {
                        //               Navigator.pop(context);
                        //               print("Dialog closed");
                        //               context.go('/userLogin');
                        //               print("Navigated to login screen"); // Debugging: Check if navigation is triggered
                        //             },
                        //             child: Text('Logout'),
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        //   child: Container(
                        //     margin: EdgeInsets.all(10),
                        //     height: 60,
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       border: Border.all(color:Colors.blue, width: 1.0),
                        //       borderRadius: BorderRadius.circular(10.0),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //         children: [
                        //           Icon(Icons.logout,color: Colors.blue,size: 30,),
                        //           SizedBox(width: 5,),
                        //           Expanded(
                        //             child: Text(
                        //               // 'Thrivers',
                        //               'Log out',
                        //               overflow: TextOverflow.ellipsis,
                        //               style: GoogleFonts.montserrat(
                        //                   textStyle:
                        //                   Theme.of(context).textTheme.titleLarge,
                        //                   color: Colors.blue),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        //
                        // ),
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
          displayMode: SideMenuDisplayMode.open,
          hoverColor: Colors.blue.withAlpha(50),
          selectedColor: Colors.blue,
          itemBorderRadius: BorderRadius.circular(0),
          selectedTitleTextStyle: const TextStyle(color: Colors.white),
          selectedIconColor: Colors.white,
          unselectedIconColor: Colors.blue,
          unselectedTitleTextStyle: TextStyle(color: Colors.blue),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          // backgroundColor: Colors.blueGrey[700]
        ),
        title: Column(
          children: [
            SizedBox(height: 20,),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 150,
                maxWidth: 150,
              ),
              child: Container(
                child: Text("SOLUTIONS",
                    style: GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.headlineSmall,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
              ),
            ),
            SizedBox(height: 20,),
            Divider(
              indent: 8.0,
              endIndent: 8.0,
            ),
          ],
        ),
        footer: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            ' My Wings Ltd',
            style: TextStyle(fontSize: 15),
          ),
        ),
        items:
        // widget.isClientLogeddin?
        [

          SideMenuItem(
            priority: 0,
            title: 'Dashboard',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Dashboard",
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.dashboard),
          ),
          // SideMenuItem(
          //   priority: 1,
          //   title: 'My Reports',
          //   //badgeColor: Colors.amber,
          //   // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //   tooltipContent: "My Reports",
          //   onTap: (page, _) {
          //     sideMenu.changePage(page);
          //     Navigator.pop(context);
          //   },
          //   icon: const Icon(Icons.list),
          // ),
          SideMenuItem(
            priority: 1,
            title: 'ABOUT ME',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "About ME",
            onTap: (page, _) {
              sideMenu.changePage(page);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.description),
          ),
          // SideMenuItem(
          //   priority: 2,
          //   title: 'Employee',
          //   //badgeColor: Colors.amber,
          //   // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
          //   tooltipContent: "Employee",
          //   onTap: (page, _) {
          //     sideMenu.changePage(page);
          //     Navigator.pop(context);
          //   },
          //   icon: const Icon(Icons.person),
          // ),
          SideMenuItem(
            priority: 3,
            title: 'Log Out',
            //badgeColor: Colors.amber,
            // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            tooltipContent: "Log Out",
            onTap: (page, _) {
              showDialog(
                context: context,
                builder: (context) => Consumer<PreviewProvider>(
                builder: (c,previewProvider, _){
                 return AlertDialog(
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
                      onPressed: () async {
                        // Navigator.pop(context);
                        // print("Dialog closed");
                        // setState(() {
                        //   logout(context);
                        // });
                        // context.go('/userLogin');
                        previewProvider.userlogout(context);
                        print("Navigated to login screen"); // Debugging: Check if navigation is triggered
                      },
                      child: Text('Logout'),
                    ),
                  ],
                );},
              )
              );
              },
            icon: const Icon(Icons.logout),
          ),


        ]


    );
  }

  Widget AboutMEScreen(userdocs){
    return Scaffold(
      // key: _scaffoldKey,
      backgroundColor: Colors.grey.withOpacity(0.2),
      //appBar:AppHelper().CustomAppBarForRetailHub(context),
      body:Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("My Details:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineMedium,)),
                  InkWell(
                    onTap: (){
                      page.jumpToPage(0);
                    },
                      child: Container(child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios),
                          SizedBox(width: 2,),
                          Text("Back", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineSmall,)),
                        ],
                      ))),
                ],
              ),
              // SizedBox(height: 10,),
              Divider(),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// --- NAME
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                      child: Text("Name:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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

                    /// --- PASSWORD

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                      child: Text("Password:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                    ),
                    TextFormField(
                      controller: passwordController,

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
                      obscureText: isVisible,
                      obscuringCharacter: "*",
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
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                isVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                            onTap: toggleVisibility,
                          ),
                        ),
                        labelStyle: GoogleFonts.montserrat(
                            textStyle: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),

                    /// --- Employer

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                      child: Text("Employer:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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

                    /// --- Division or section

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                      child: Text("Division or section:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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

                    /// --- Role

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                      child: Text("Role:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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

                    /// --- Location

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                      child: Text("Location:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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

                    /// --- Employee number

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                      child: Text("Employee number:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                    ),
                    TextField(
                      controller: EmployeeNumberController,
          
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

                    /// --- Line manager

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                      child: Text("Line manager:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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
                    InkWell(
                      onTap: () async {
                        // sideMenu.changePage(2);
                        ProgressDialog.show(context, "Updating User Details", Icons.update);
                        await ApiRepository().updateUserDetail({
                          "UserName": nameController.text,
                          "Password": passwordController.text,
                          "Employer": employerController.text,
                          "Division_or_Section": divisionOrSectionController.text,
                          "Role": RoleController.text,
                          "Location": LocationController.text,
                          "Employee_Number": EmployeeNumberController.text,
                          "Line_Manager": LineManagerController.text,

                        // nameController.text = await userData.docs.first['UserName'];
                        // employerController.text = await userData.docs.first['Employer'];
                        // divisionOrSectionController.text = await userData.docs.first['Division_or_Section'];
                        // RoleController.text = await userData.docs.first['Role'];
                        // LocationController.text = await userData.docs.first['Location'];
                        // EmployeeNumberController.text = await userData.docs.first['Employee_Number'];
                        // LineManagerController.text = await userData.docs.first['Line_Manager'];
                          /// Add more fields as needed
                        }, userdocs);

                        print("widget.emailId; ${widget.emailId}");

                        QuerySnapshot userData = await FirebaseFirestore.instance.collection('AboutMe')
                            .where('Email' , isEqualTo: widget.emailId)
                            .where('isPPS' , isEqualTo: true)
                            // .where('isOS' , isEqualTo: false).limit(1)
                            .get();
                        print("userData; ${userData.docs.first['User_Name']}");
                        print("userData.docs:  ${userData.docs.first.id}");

                        var documentId = await userData.docs.first.id;
                        ApiRepository().updateAboutMe({
                          'User_Name': nameController.text,
                          'Employer': employerController.text,
                          'Division_or_Section': divisionOrSectionController.text,
                          'Role': RoleController.text,
                          'Location': LocationController.text,
                          'Employee_Number': EmployeeNumberController.text,
                          'Line_Manager': LineManagerController.text,}, documentId);
                        // _loadDataForPage(1);
                        // Navigator.pop(context);
                        ProgressDialog.hide();
                      },
                      child: Container(
                        // margin: EdgeInsets.all(10),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(color:Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Update',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                                textStyle:
                                Theme.of(context).textTheme.titleMedium,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  int _perPage = 10;

  List<DocumentSnapshot> documents = [];
  bool _isLoadingMore = false;


  int _currentPage = 1; // Current page number
  int _totalPages = 31; // Total number of pages

  // Function to load next page

  void _loadNextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
        _isLoadingMore = true;
      });
      _loadDataForPage(_currentPage);
    }
  }

  // Function to load previous page

  void _loadPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _isLoadingMore = true;
      });
      _loadDataForPage(_currentPage);
    }
  }

  void _loadDataForPage(int page) {
    int startIndex = (page - 1) * _perPage;


    FirebaseFirestore.instance
        .collection('Thrivers')
        .orderBy('id')
        .startAfter([startIndex]) // Start after the specified document index
        .limit(_perPage)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        documents.clear();
        documents.addAll(querySnapshot.docs);
      });
    }).catchError((error) {
      print('Error loading data for page $page: $error');
      setState(() {
      });
    });
  }


  void showSolutionSelector() {
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Solutions'),
          content: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                child: TextField(
                  controller: searchbyCatcontroller,

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
                    suffixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.all(10),
                    labelText: "Search",
                    hintText: "Search",
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
              ),

              // Divider(),

              Container(
                height: MediaQuery.of(context).size.height * .65,
                width: MediaQuery.of(context).size.width * .6,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shrinkWrap: true,
                  itemCount: documents.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ThriversListTile(documents[index], index, documents),
                      ],
                    );
                  },
                ),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ElevatedButton(
              //       onPressed: (){
              //         setState(() {
              //           print('_loadPreviousPage');
              //           _loadPreviousPage();
              //         });
              //       },
              //       child: Text('Previous'),
              //     ),
              //     SizedBox(width: 10),
              //     Text('Page $_currentPage of $_totalPages'),
              //     SizedBox(width: 10),
              //     ElevatedButton(
              //       onPressed: (){
              //         setState(() {
              //           print('_loadNextPage');
              //           _loadNextPage();
              //         });
              //       },
              //       child: Text('Next'),
              //     ),
              //   ],
              // ),

            ],
          ),
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: Text('Close'),
          //   ),
          //   TextButton(
          //     onPressed: () {
          //       // Save selected solutions to the table
          //       // saveSelectedSolutions();
          //       Navigator.of(context).pop();
          //     },
          //     child: Text('Save'),
          //   ),
          // ],
          actions: [
            Consumer<UserAboutMEProvider>(
                builder: (context, userAboutMEProvider, _) {
                  return
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            userAboutMEProvider.clearSelectedSolutions();
                            userAboutMEProvider.isCheckedMap.clear();

                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width: MediaQuery.of(context).size.width * .3,

                            height: 60,
                            decoration: BoxDecoration(
                              //color: Colors.white,
                              border: Border.all(
                                //color:primaryColorOfApp ,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: Text(
                                'Close',
                                style: GoogleFonts.montserrat(
                                  textStyle:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .titleSmall,
                                  fontWeight: FontWeight.bold,
                                  //color: primaryColorOfApp
                                ),
                              ),
                            ),
                          ),

                        ),
                        SizedBox(width: 5, height: 5,),
                        InkWell(
                          onTap: (){
                            // solutions = userAboutMEProvider.getSelectedSolutions();
                            // _userAboutMEProvider.clearSelectedSolutions();
                            userAboutMEProvider.addsolutions();
                            // userAboutMEProvider.clearSelectedSolutions();

                            Navigator.pop(context);

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * .3,
                            padding: EdgeInsets.symmetric(horizontal: 15),
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
                                'Save',
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

                        )


                      ],
                    );
                })
          ],

        );
      },
    );
  }

  Widget ThriversListTile(DocumentSnapshot<Object?> thriversDetails, i, documentsss) {

    return Consumer<UserAboutMEProvider>(
        builder: (c,userAboutMEProvider, _){
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 10,),

              // Text(thriversDetails.id,style: Theme.of(context).textTheme.bodySmall),
              // Text("${i+1}.",style: Theme.of(context).textTheme.bodySmall),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text("SH0${thriversDetails['id']}",style: Theme.of(context).textTheme.bodySmall),
              ),

              SizedBox(width: 20,),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(thriversDetails['Name'],style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis),
                    Text(thriversDetails['Description'],style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2,),
                    SizedBox(height: 10),

                  ],
                ),
              ),

              SizedBox(width: 20,),

              Center(
                child: Checkbox(
                  activeColor: Colors.blue,
                  value: userAboutMEProvider.isCheckedForTileSoltuions(i), // Use the state from the provider
                  onChanged: (value) {
                    userAboutMEProvider.isClickedBoxSolution(value, i, thriversDetails);
                  },
                ),
              )

            ],
          );
        });

    // return CheckboxListTile(
    //
    //   title: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SizedBox(width: 10,),
    //         // Text(thriversDetails.id,style: Theme.of(context).textTheme.bodySmall),
    //         // Text("${i+1}.",style: Theme.of(context).textTheme.bodySmall),
    //         Padding(
    //           padding: const EdgeInsets.all(5.0),
    //           child: Text("SH0${thriversDetails['id']}",style: Theme.of(context).textTheme.bodySmall),
    //         ),
    //         SizedBox(width: 20,),
    //         Expanded(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(thriversDetails['Name'],style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis),
    //               Text(thriversDetails['Description'],style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2,),
    //               SizedBox(height: 10),
    //
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   value: selectedSolutions.contains(thriversDetails),
    //   onChanged: (bool? value) {
    //     setState(() {
    //       if (value != null && value) {
    //         selectedSolutions.add(SolutionModel(id: "SH0${thriversDetails['id']}", label: thriversDetails['Name'], description: thriversDetails['Description'], notes: "notes", attachments: "attachments", provider: "provider", inPlace: false, priority: "priority"));
    //
    //         print("selectedSolutions: ${selectedSolutions[0].id}");
    //         // print("selectedSolutions: ${selectedSolutions[1].id}");
    //         // print("selectedSolutions: ${selectedSolutions[2].id}");
    //       } else {
    //         selectedSolutions.remove(thriversDetails);
    //       }
    //     });
    //   },
    // );
  }


}
