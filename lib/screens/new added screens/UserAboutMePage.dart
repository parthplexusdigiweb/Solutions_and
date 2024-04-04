import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thrivers/Provider/AddKeywordsProvider.dart';
import 'package:thrivers/Provider/userAboutMeProvider.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/model/soluton_table_model.dart';
import 'package:thrivers/screens/addthriverscreen.dart';
import 'package:thrivers/screens/not%20used%20screen/DashboardCommonWidgets.dart';

class UserAboutMePage extends StatefulWidget {

   bool isClientLogeddin;
    var emailId;

   UserAboutMePage({required this.isClientLogeddin, required this.emailId});

   @override
  State<UserAboutMePage> createState() => _UserAboutMePageState();
}

class _UserAboutMePageState extends State<UserAboutMePage> {
  late PageController page;
  SideMenuController sideMenu = SideMenuController();

  TextEditingController nameController = TextEditingController();
  TextEditingController employerController = TextEditingController();
  TextEditingController divisionOrSectionController = TextEditingController();
  TextEditingController RoleController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  TextEditingController EmployeeNumberController = TextEditingController();
  TextEditingController LineManagerController = TextEditingController();
  TextEditingController NotesController = TextEditingController();
  TextEditingController searchbyCatcontroller = TextEditingController();
  TextEditingController searchbyTagcontroller = TextEditingController();

  late final AddKeywordProvider _addKeywordProvider;
  late final UserAboutMEProvider _userAboutMEProvider;

  List<SolutionModel> solutions = [];

  var selectedProvider;
  var selectedInPlace;
  var selectedPriority ;

  List<String> provider = ['Me', 'Employer'];
  List<String> InPlace = ['Yes', 'No'];
  List<String> Priority = ['Must have', 'Nice to have', 'No Longer needed'];




  @override
  void initState() {
    page = PageController(initialPage: 0??0);
    sideMenu.addListener((p0) {
      print("Listener Executed");
      page.jumpToPage(p0);
    });
    _addKeywordProvider = Provider.of<AddKeywordProvider>(context, listen: false);
    _userAboutMEProvider = Provider.of<UserAboutMEProvider>(context, listen: false);
    _loadDataForPage(_currentPage);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: DashboardCommonWidgets().CommonAppBar(context,true,false,false,emailID: widget.emailId,showSettings: widget.isClientLogeddin,showLogout: true),
      appBar: DashboardCommonWidgets().CommonAppBar(context,true,false,false,emailID: "fenilpatel120501@gmail.com",showSettings: true,showLogout: true),

      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
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
                },
                icon: const Icon(Icons.dashboard),
              ),
              SideMenuItem(
                priority: 1,
                title: 'ABOUT ME',
                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "About ME",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.description),
              ),
              SideMenuItem(
                priority: 2,
                title: 'DETAILS',
                //badgeColor: Colors.amber,
                // badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
                tooltipContent: "DETAILS",
                onTap: (page, _) {
                  sideMenu.changePage(page);
                },
                icon: const Icon(Icons.details),
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
            ]

            //     : [
            //   SideMenuItem(
            //     priority: 0,
            //     title: 'Dashboard',
            //     onTap: (page, _) {
            //       sideMenu.changePage(page);
            //     },
            //     icon: const Icon(Icons.dashboard),
            //     //badgeColor: Colors.amber,
            //     //badgeContent: FaIcon(FontAwesomeIcons.triangleExclamation,color:Colors.black ,size: 10,),
            //     //tooltipContent: "Dashboard Is Under Construction!",
            //   ),
            //
            //   SideMenuItem(
            //     priority: 1,
            //     title: 'Tests',
            //     onTap: (page, _) {
            //       sideMenu.changePage(page);
            //     },
            //     icon: const Icon(Icons.note_alt_sharp),
            //     /*trailing: Container(
            //         decoration: const BoxDecoration(
            //             color: Colors.amber,
            //             borderRadius: BorderRadius.all(Radius.circular(6))),
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(
            //               vertical: 6.0, vertical: 3),
            //           child: Text(
            //             'New',
            //             style: TextStyle(fontSize: 11, color: Colors.grey[800]),
            //           ),
            //         )),*/
            //   ),
            //   SideMenuItem(
            //     priority: 2,
            //     title: 'Clients',
            //     onTap: (page, _) {
            //       sideMenu.changePage(page);
            //     },
            //     icon: const Icon(Icons.people),
            //   ),
            //
            //
            // ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                DashBoardScreen(),
                AboutMEScreen(),
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
            width: 470,
            height: 300,
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
                                        Icon(Icons.details,color: Colors.blue,size: 30,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            'Details',
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

  Widget AboutMEScreen(){
    var selectedPriorityValues = [
      'Must have',
      'Nice to have',
      'No longer needed'
    ];
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About Me", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineMedium,)),
            SizedBox(height: 10,),
            Divider(),
            Container(
              height: MediaQuery.of(context).size.height * .7,
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Add User Details:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineSmall,)),

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
                                // SizedBox(height: 10,),
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
                                // SizedBox(height: 10,),
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
                                // SizedBox(height: 10,),
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
                                // SizedBox(height: 10,),
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
                                // SizedBox(height: 10,),
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
                                // SizedBox(height: 10,),
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
                                // SizedBox(height: 10,),

                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          VerticalDivider(),
                          SizedBox(width: 10,),
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    print("ajskdnaskl");
                                    showSolutionSelector();
                                  },
                                  child:Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    width: MediaQuery.of(context).size.width * .2,

                                    height: 60,
                                    decoration: BoxDecoration(
                                      color:Colors.blue ,
                                      border: Border.all(
                                          color:Colors.blue ,
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Add Solutions',
                                        style: GoogleFonts.montserrat(
                                          textStyle:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .titleSmall,
                                          fontWeight: FontWeight.bold,
                                          color:Colors.white ,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Consumer<UserAboutMEProvider>(
                                  builder: (context, userAboutMEProvider, _) {
                                    // solutions = userAboutMEProvider.getSelectedSolutions();
                                    print("solutionssssss : ${userAboutMEProvider.solutionss}");

                                    List<String> selectedProviderValues = List.generate(userAboutMEProvider.solutionss.length, (index) => "Me");
                                    List<String> selectedInPlaceValues = List.generate(userAboutMEProvider.solutionss.length, (index) => "Yes");
                                    // List<String> selectedPriorityValues = List.generate(userAboutMEProvider.solutionss.length, (index) => "Must have");
                                    userAboutMEProvider.selectedPriorityValues = List.generate(userAboutMEProvider.solutionss.length, (ind) => 'Must have');

                                    return Container(
                                      height: 500,
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(10),
                                      //   border: Border.all(color: Colors.black87),
                                      // ),
                                      // child: ListView.builder(
                                      //   itemCount: userAboutMEProvider.solutionss.length,
                                      //   itemBuilder: (context, i) {
                                      //     return ListTile(
                                      //       leading: Text("${userAboutMEProvider.solutionss[i].id}", style: TextStyle(color: Colors.black)),
                                      //       title: Text("${userAboutMEProvider.solutionss[i].label}", style: TextStyle(color: Colors.black)),
                                      //       subtitle: Text("${userAboutMEProvider.solutionss[i].description}", style: TextStyle(color: Colors.black)),
                                      //     );
                                      //   },
                                      // ),
                                      child:SingleChildScrollView(
                                        child: DataTable(
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black),
                                              borderRadius: BorderRadius.circular(15)
                                          ),
                                          // horizontalMargin: 10,
                                          dataRowMaxHeight:60 ,
                                          headingTextStyle: GoogleFonts.montserrat(
                                              textStyle: Theme.of(context).textTheme.titleMedium,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                          // border: TableBorder.all(color: Colors.black),
                                          // showBottomBorder: true,
                                          // dataRowHeight: 100,
                                          // headingRowHeight: 80,
                                          border: TableBorder.symmetric(inside: BorderSide(color: Colors.black38)),
                                          columnSpacing: 20,

                                          columns: [
                                            DataColumn(
                                                label: Container(
                                                    width: 40,
                                                    child: Center(
                                                    child: Text('ID')
                                                )
                                                )
                                            ),
                                            DataColumn(
                                                label: Container(
                                                width: 160,
                                                child: Center(
                                                    child: Text('Label',)
                                                ),
                                                ),
                                            ),
                                            DataColumn(
                                              label: Container(
                                                width: 160,
                                                child: Center(child:
                                                Text('Description')
                                                )
                                              ),
                                            ),
                                            DataColumn(
                                                label: Container(
                                                width: 140,
                                                child: Center(child: Text('Notes')
                                                )
                                                )
                                            ),
                                            DataColumn(
                                                label: Center(
                                                    child: Text('Attachments')
                                                )
                                            ),
                                            DataColumn(
                                                label: Container(
                                                width: 120,
                                                child: Center(child: Text('Provider')
                                                )
                                                )
                                            ),
                                            DataColumn(label: Container(
                                                width: 60,
                                                child: Center(child: Text('In Place')
                                                )
                                            )
                                            ),
                                            DataColumn(label: Container(
                                                width: 140,
                                                child: Center(child: Text('Priority')
                                                )
                                            )
                                            ),
                                          ],
                                          rows: userAboutMEProvider.solutionss.map((solution) {
                                            int index = userAboutMEProvider.solutionss.indexOf(solution);
                                            return DataRow(
                                              cells: [
                                                DataCell(
                                                    Container(
                                                    width: 40,
                                                    child: Text(solution.id, style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black),))),
                                                DataCell(
                                                    Container(
                                                    width: 160,
                                                    child: Text(solution.label,
                                                      overflow: TextOverflow.ellipsis,maxLines: 2,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: Theme.of(context).textTheme.bodySmall,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black)
                                                    ))),
                                                DataCell(
                                                    Container(
                                                    width: 160,
                                                    child: Text(solution.description,
                                                      overflow: TextOverflow.ellipsis,maxLines: 2,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: Theme.of(context).textTheme.bodySmall,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black)
                                                    ))),
                                                DataCell(
                                                  Container(
                                                  // height: 100,
                                                    margin: EdgeInsets.all(5),
                                                  width: 140,
                                                  child: Center(
                                                    child: TextField(
                                                      maxLines: 4,
                                                      controller: TextEditingController(text: solution.notes),
                                                      onChanged: (value) {
                                                      },
                                                      style: GoogleFonts.montserrat(
                                                          textStyle: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .bodySmall,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.black),
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.all(10),
                                                        // labelText: "Name",
                                                        hintText: "Notes",
                                                        errorStyle: GoogleFonts.montserrat(
                                                            textStyle: Theme
                                                                .of(context)
                                                                .textTheme
                                                                .bodyLarge,
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.redAccent),
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.black),
                                                            borderRadius: BorderRadius.circular(5)),
                                                        border: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.black12),
                                                            borderRadius: BorderRadius.circular(5)),
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
                                                ),),  // Empty cell for Notes
                                                DataCell(
                                                    Container(
                                                      child: IconButton(
                                                        onPressed: (){

                                                          },
                                                        icon: Icon(Icons.add),
                                                  ),
                                                )),  // Empty cell for Attachments
                                                DataCell(
                                                  Container(
                                                  width: 120,
                                                    child: DropdownButton(
                                                      style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                                      // value: selectedProvider,
                                                      value: selectedProviderValues[index],
                                                      onChanged: (newValue) {
                                                        // userAboutMEProvider.updatevalue(selectedProviderValues[index], newValue.toString());
                                                        setState(() {
                                                          // selectedProvider = newValue.toString();
                                                          selectedProviderValues[index] = newValue.toString();
                                                        });
                                                      },
                                                      items: provider.map((option) {
                                                        return DropdownMenuItem(
                                                          value: option,
                                                          child: Text(option, overflow: TextOverflow.ellipsis,maxLines: 2,),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),  // Empty cell for Provider
                                                DataCell(
                                                  Container(
                                                    width: 60,
                                                    child: DropdownButton(
                                                      style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                                      value: selectedInPlaceValues[index],
                                                      // value: selectedInPlace,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          selectedInPlaceValues[index] = newValue.toString();
                                                          // selectedInPlace = newValue.toString();
                                                        });
                                                      },
                                                      items: InPlace.map((option) {
                                                        return DropdownMenuItem(
                                                          value: option,
                                                          child: Text(option),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),  // Empty cell for In Place
                                                DataCell(
                                                  Container(
                                                    width: 140,
                                                    // child:  DropdownButton(
                                                    //   style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                                    //   value: selectedPriorityValues[index],
                                                    //   // value: selectedPriority,
                                                    //   onChanged: (newValue) {
                                                    //     setState(() {
                                                    //       selectedPriorityValues[index] = newValue.toString();
                                                    //
                                                    //       print("$index: ${selectedPriorityValues[index]} ");
                                                    //       // selectedPriority = newValue.toString();
                                                    //     });
                                                    //   },
                                                    //   items: Priority.map((option) {
                                                    //     return DropdownMenuItem(
                                                    //       value: option,
                                                    //       child: Text(option, overflow: TextOverflow.ellipsis,),
                                                    //     );
                                                    //   }).toList(),
                                                    // ),
                                                    child:  DropdownButtonFormField(
                                                    style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                                      decoration: InputDecoration(

                                                          hintText: 'Priority',
                                                      ),
                                                      value: userAboutMEProvider.selectedPriorityValues[index],
                                                      onChanged: (newValue) {
                                                        userAboutMEProvider.updateSelectedPriorityValues(index, newValue);
                                                        print('priority ${index} and ${userAboutMEProvider.selectedPriorityValues}');
                                                      },
                                                      icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
                                                      items: selectedPriorityValues.map<DropdownMenuItem<String>>((String value) {
                                                        // String displayedText = value;
                                                        // if (displayedText.length > 5) {
                                                        //   // Limit the displayed text to 10 characters and add ellipsis
                                                        //   displayedText = displayedText.substring(0, 5) + '..';
                                                        // }
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text(value, overflow: TextOverflow.ellipsis,),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),  // Empty cell for Priority
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),

                                    );
                                  },
                                )

                                ///
                                //                                 DropdownSearch<String>.multiSelection(
                                //                                   items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                                //                                   popupProps: PopupPropsMultiSelection.menu(
                                //                                     showSelectedItems: true,
                                //                                     disabledItemFn: (String s) => s.startsWith('I'),
                                //                                   ),
                                //                                   onChanged: print,
                                //                                   selectedItems: ["Brazil"],
                                //                                 )
                              ],
                            ),

                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            )
          ],
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
                            print("solutions: $solutions");

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
