import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/Provider/AddKeywordsProvider.dart';
import 'package:thrivers/Provider/previewProvider.dart';
import 'package:thrivers/Provider/provider_for_challenges.dart';
import 'package:thrivers/Provider/userAboutMeProvider.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';
import 'package:thrivers/model/challenges_table_model.dart';
import 'package:thrivers/model/soluton_table_model.dart';
import 'package:thrivers/screens/EditAboutMePage.dart';
import 'package:toastification/toastification.dart';




class AdminAboutMePage extends StatefulWidget {
  var AdminName;

  AdminAboutMePage({this.AdminName});

  @override
  State<AdminAboutMePage> createState() => _AdminAboutMePageState();
}

class _AdminAboutMePageState extends State<AdminAboutMePage> with TickerProviderStateMixin {

  PageController page = PageController();
  SideMenuController sideMenu = SideMenuController();
  int pageNumber = 0;



  TextEditingController nameController = TextEditingController();
  TextEditingController employerController = TextEditingController();
  TextEditingController divisionOrSectionController = TextEditingController();
  TextEditingController RoleController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  TextEditingController EmployeeNumberController = TextEditingController();
  TextEditingController LineManagerController = TextEditingController();
  TextEditingController mycircumstancesController = TextEditingController();
  TextEditingController AboutMeLabeltextController = TextEditingController();
  TextEditingController RefineController = TextEditingController();
  TextEditingController MystrengthsController = TextEditingController();
  TextEditingController myOrganisationController = TextEditingController();
  TextEditingController myOrganisation2Controller = TextEditingController();
  TextEditingController NotesController = TextEditingController();
  TextEditingController searchbyCatcontroller = TextEditingController();
  TextEditingController searchEmailcontroller = TextEditingController();

  TextEditingController searchChallengescontroller = TextEditingController();

  Timer? _debounce;
  String query = "";
  int _debouncetime = 1000;
  var selectAllAny = "All";



  late final AddKeywordProvider _addKeywordProvider;

  late final UserAboutMEProvider _userAboutMEProvider;

  late final ChallengesProvider _challengesProvider;

  late final PreviewProvider _previewProvider;

  List<SolutionModel> solutions = [];
  List<ChallengesModel> Challenges = [];


  var selectedEmail ;
  var resultString ;

  List<String> emailList = [];

  List<Map<String, dynamic>> solutionsList = [];
  List<Map<String, dynamic>> challengesList = [];

  var solutionlistAb = [];
  var Ab_idArray = [];
  var aboutMeList, aboutMeName;
  var id, Label,Impact,Final_description,Impact_on_me,Attachment;

  int _perPage = 10;

  List<DocumentSnapshot> documents = [];
  List<DocumentSnapshot> challengesdocuments = [];

  Future<void> fetchEmailList() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();

      // Extract emails from documents
      emailList = querySnapshot.docs.map((doc) => doc['email'] as String).toList();

      setState(() {});
    } catch (e) {
      print("Error fetching email list: $e");
    }
  }

  late TabController _tabController;

  int _previousTabIndex = 0;


  bool isInitialTyping = true;
  var documentId;

  List<DocumentSnapshot> dataList = [];


  @override
  void initState() {
    page = PageController(initialPage: 0??0);
    sideMenu.addListener((p0) {
      page.jumpToPage(p0);
    });
    _addKeywordProvider = Provider.of<AddKeywordProvider>(context, listen: false);
    _userAboutMEProvider = Provider.of<UserAboutMEProvider>(context, listen: false);
    _challengesProvider = Provider.of<ChallengesProvider>(context, listen: false);
    _previewProvider = Provider.of<PreviewProvider>(context, listen: false);
    _addKeywordProvider.loadDataForPage(_addKeywordProvider.currentPage);
    _challengesProvider.loadDataForPage(_challengesProvider.currentPage);
    // _loadDataForChallengesPage(_currentPage);
    fetchEmailList();
    super.initState();
    _addKeywordProvider.getdatasearch();
    _challengesProvider.getdatasearch();
    _tabController = TabController(length: 6, vsync: this); // Initialize the TabController
    _addKeywordProvider.lengthOfdocument = null;
    _challengesProvider.lengthOfdocument = null;
    getQuestions();
    newSelectCategories();
    getChatgptSettingsApiKey();
  }

  @override
  void dispose() {
    _tabController!.dispose(); // Dispose the TabController
    super.dispose();
  }

   _navigateToTab(int index) {
    _tabController.animateTo(index);
  }

  void refreshPage() {
    // Call setState or perform any actions to refresh the page
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: page,
        physics: NeverScrollableScrollPhysics(),
        children: [
          EmployeePageView(),
          MyReports(),
        ],
      ),
      // body: EmployeePageView(),
      // body: AboutMEScreen(),
    );
  }

  Widget AboutMEScreen(){
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *.9,

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("My Report", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineMedium,)),

                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              // showAddAddAboutMeDialogBox();
                              // Navigator.pop(context);
                              page.jumpToPage(0);
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('Add About Me',textAlign: TextAlign.center,style: GoogleFonts.montserrat(
                                    textStyle: Theme.of(context).textTheme.titleSmall,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),)),
                          ),
                        ),

                      ],
                    ),
                    // SizedBox(height: 10,),
                    Divider(),
                    SizedBox(height: 5,),

                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          // Container(
                          //     width: 50,
                          //     child: Center(
                          //         child: Text('No.',style: Theme.of(context).textTheme.titleMedium)
                          //     )
                          // ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Center(
                                child: Text('About Me Id',style: Theme.of(context).textTheme.titleSmall)
                            ),
                          ),

                          // Container(
                          //   width: 80,
                          //   child: Center(
                          //       child: Text('SH/CH Id',style: Theme.of(context).textTheme.titleMedium)
                          //   ),
                          // ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Center(
                                child: Text('Employer',style: Theme.of(context).textTheme.titleMedium)
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Center(
                                child: Text('User Name',style: Theme.of(context).textTheme.titleMedium)
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Center(
                                child: Text('Email',style: Theme.of(context).textTheme.titleMedium)
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Center(
                                child: Text('Title',style: Theme.of(context).textTheme.titleMedium)
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Center(
                                child: Text('Date',style: Theme.of(context).textTheme.titleMedium)
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Center(
                                child: Text('No. of Challenges',style: Theme.of(context).textTheme.titleMedium)
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Center(
                                child: Text('No. of Solutions',style: Theme.of(context).textTheme.titleMedium)
                            ),
                          ),

                          // Container(
                          //     width: 400,
                          //     child: Center(child:
                          //     Text('Description',style: Theme.of(context).textTheme.titleMedium)
                          //     )
                          // ),
                          // Container(
                          //     width: 150,
                          //     child: Center(child: Text('Notes',style: Theme.of(context).textTheme.titleMedium)
                          //     )
                          // ),
                          //
                          // Container(
                          //   width: 120,
                          //   child: Center(
                          //       child: Text('Attachments',style: Theme.of(context).textTheme.titleMedium)
                          //   ),
                          // ),
                          // Container(
                          //     width: 120,
                          //     child: Center(child: Text('Provider',style: Theme.of(context).textTheme.titleMedium)
                          //     )
                          // ),
                          // Container(
                          //     width: 120,
                          //     child: Center(child: Text('In Place',style: Theme.of(context).textTheme.titleMedium)
                          //     )
                          // ),

                          Container(
                              width: MediaQuery.of(context).size.width * 0.07,
                              child: Center(child: Text('',style: Theme.of(context).textTheme.titleMedium)
                              )
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 5,),

                    FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance.collection('AboutMe').orderBy("AB_id").get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          else {
                            // List<Map<String, dynamic>> dataList = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                             dataList = snapshot.data!.docs.toList();


                            // print("dataList : $dataList");
                            // solutionlistAb.clear();

                            // for(var i in dataList){
                            //   print("iiiiii: ${i['Solutions']}");
                            //
                            //
                            //   solutionlistAb.addAll(i['Solutions']);
                            //   Ab_idArray.add(i['AB_id']);
                            //   print(Ab_idArray);
                            //   // print("solutionlistAb.add(i): ${solutionlistAb}");
                            //  // aboutMeList = i['AB_id'];
                            //   aboutMeName = i['User_Name'];
                            // }

                           return Expanded(
                             child: ListView.builder(
                                  itemCount:dataList.length ,
                                  // shrinkWrap: true,
                                  // physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (c,i){
                                    // print("dataList[i]['Solutions']: ${dataList[i]}");
                                    int overallIndex = 0;
                                    for (int j = 0; j < i; j++) {
                                      overallIndex += (dataList[j]['Solutions'] as List).length;
                                    }
                             
                                       return Column(
                                               children: [
                                                 Container(
                                                   padding: EdgeInsets.all(10),
                                                   child: Row(
                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: [
                             
                                                           // Container(
                                                           //     width: 50,
                                                           //     child: Center(child: Text("${overallIndex}."))),
                             
                                                           Container(
                                                               width: MediaQuery.of(context).size.width * 0.08,
                                                               child: Center(child: Text("AB0${dataList[i]['AB_id'].toString()}",style: Theme.of(context).textTheme.bodySmall))),
                             
                                                       // Container(
                                                       //     width: 80,
                                                       //     child: Center(child: Text(dataList[i]['Solutions'][index]['id'].toString(), style: Theme.of(context).textTheme.bodySmall))),
                             
                                                       Container(
                                                           width: MediaQuery.of(context).size.width * 0.08,
                                                           // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                           child: Center(child: Text(dataList[i]['Employer'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                             
                                                       Container(
                                                           width: MediaQuery.of(context).size.width * 0.08,
                                                           // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                           child: Center(child: Text(dataList[i]['User_Name'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                             
                             
                                                       Container(
                                                           width: MediaQuery.of(context).size.width * 0.14,
                                                           // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                           child: Center(child: Text(dataList[i]['Email'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                             
                                                       // Container(
                                                       //   width: 250,
                                                       //     child: Center(child: Text(dataList[i]['Solutions'][index]['Label'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                             
                                                       Container(
                                                           width: MediaQuery.of(context).size.width * 0.14,
                                                           child: Center(child: Text(dataList[i]['About_Me_Label'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                             
                             
                                                       Container(
                                                           width: MediaQuery.of(context).size.width * 0.08,
                                                           // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                           child: Center(child: Text(dataList[i]['Created_Date'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                                                       Container(
                                                           width: MediaQuery.of(context).size.width * 0.08,
                                                           // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                           child: Center(child: Text(dataList[i]['Challenges'].length.toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                                                       Container(
                                                           width: MediaQuery.of(context).size.width * 0.08,
                                                           // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                           child: Center(child: Text(dataList[i]['Solutions'].length.toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                             
                                                           Container(
                                                               width: MediaQuery.of(context).size.width * 0.07,
                                                           child: Center(child: Row(
                                                             mainAxisAlignment: MainAxisAlignment.end,
                                                             children: [
                             
                                                               IconButton(
                                                                   iconSize: 25,
                                                                   color: primaryColorOfApp,
                                                                   onPressed: () async {
                                                                     showEditAboutMeDialogBox(dataList[i],0);
                                                                   },
                                                                   icon: Icon(Icons.edit,)),
                             
                                                               IconButton(
                                                                   iconSize: 25,
                                                                   color: primaryColorOfApp,
                                                                   onPressed: () async {
                                                                     ProgressDialog.show(context, "Deleting Users",Icons.person);
                                                                     await ApiRepository().DeleteSectionPreset(dataList[i].reference);
                                                                     setState(() {
                             
                                                                     });
                                                                     // _addKeywordProvider.loadDataForPage(1);
                                                                     // _addKeywordProvider.setFirstpageNo();
                                                                     ProgressDialog.hide();
                                                                   },
                                                                   icon: Icon(Icons.delete,)),
                                                               // SizedBox(width: 20,),
                                                             ],
                                                           ),
                                                           )),
                                                     ],
                                                   ),
                                                 ),
                                                 Divider(),
                                               ],
                                             );
                             
                              }),
                           );

                          }}
                    )

                  ],
                )
            ),
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     padding: EdgeInsets.all(20),
            //     margin: EdgeInsets.all(20),
            //     decoration: BoxDecoration(
            //       color: Colors.white.withOpacity(0.7),
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text("Details About Me", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineMedium,)),
            //         SizedBox(height: 10,),
            //
            //       ],
            //     )
            // ),
          ],
        ),
      ),
    );
  }

  Widget MyReports(){
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height *.9,

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("My Report", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineMedium,)),

                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              // showAddAddAboutMeDialogBox();
                              // Navigator.pop(context);
                              page.jumpToPage(0);
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('Home',textAlign: TextAlign.center,style: GoogleFonts.montserrat(
                                    textStyle: Theme.of(context).textTheme.titleSmall,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),)),
                          ),
                        ),

                      ],
                    ),
                    // SizedBox(height: 10,),
                    Divider(),
                    SizedBox(height: 5,),

                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          // Container(
                          //     width: 50,
                          //     child: Center(
                          //         child: Text('No.',style: Theme.of(context).textTheme.titleMedium)
                          //     )
                          // ),


                          // Container(
                          //   width: 80,
                          //   child: Center(
                          //       child: Text('SH/CH Id',style: Theme.of(context).textTheme.titleMedium)
                          //   ),
                          // ),

                          // Container(
                          //   width: MediaQuery.of(context).size.width * 0.08,
                          //   child: Center(
                          //       child: Text('About Me Id',style: Theme.of(context).textTheme.titleSmall)
                          //   ),
                          // ),
                          //
                          //
                          // Container(
                          //   width: MediaQuery.of(context).size.width * 0.08,
                          //   child: Center(
                          //       child: Text('Employer',style: Theme.of(context).textTheme.titleMedium)
                          //   ),
                          // ),
                          //
                          // Container(
                          //   width: MediaQuery.of(context).size.width * 0.08,
                          //   child: Center(
                          //       child: Text('User Name',style: Theme.of(context).textTheme.titleMedium)
                          //   ),
                          // ),
                          //
                          // Container(
                          //   width: MediaQuery.of(context).size.width * 0.14,
                          //   child: Center(
                          //       child: Text('Email',style: Theme.of(context).textTheme.titleMedium)
                          //   ),
                          // ),
                          //
                          Container(
                            width: MediaQuery.of(context).size.width * 0.14,
                            child: Center(
                                child: Text('Title',style: Theme.of(context).textTheme.titleMedium)
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Center(
                                child: Text('Date last modified',style: Theme.of(context).textTheme.titleMedium)
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: Center(
                                child: Text('Status',style: Theme.of(context).textTheme.titleMedium)
                            ),
                          ),

                          //
                          // Container(
                          //   width: MediaQuery.of(context).size.width * 0.08,
                          //   child: Center(
                          //       child: Text('No. of Solutions',style: Theme.of(context).textTheme.titleMedium)
                          //   ),
                          // ),

                          // Container(
                          //     width: 400,
                          //     child: Center(child:
                          //     Text('Description',style: Theme.of(context).textTheme.titleMedium)
                          //     )
                          // ),
                          // Container(
                          //     width: 150,
                          //     child: Center(child: Text('Notes',style: Theme.of(context).textTheme.titleMedium)
                          //     )
                          // ),
                          //
                          // Container(
                          //   width: 120,
                          //   child: Center(
                          //       child: Text('Attachments',style: Theme.of(context).textTheme.titleMedium)
                          //   ),
                          // ),
                          // Container(
                          //     width: 120,
                          //     child: Center(child: Text('Provider',style: Theme.of(context).textTheme.titleMedium)
                          //     )
                          // ),
                          // Container(
                          //     width: 120,
                          //     child: Center(child: Text('In Place',style: Theme.of(context).textTheme.titleMedium)
                          //     )
                          // ),

                          Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: Center(child: Text('',style: Theme.of(context).textTheme.titleMedium)
                              )
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 5,),

                    FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance.collection('AboutMe').orderBy("AB_id").get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          else {
                            // List<Map<String, dynamic>> dataList = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                             dataList = snapshot.data!.docs.toList();


                            // print("dataList : $dataList");
                            // solutionlistAb.clear();

                            // for(var i in dataList){
                            //   print("iiiiii: ${i['Solutions']}");
                            //
                            //
                            //   solutionlistAb.addAll(i['Solutions']);
                            //   Ab_idArray.add(i['AB_id']);
                            //   print(Ab_idArray);
                            //   // print("solutionlistAb.add(i): ${solutionlistAb}");
                            //  // aboutMeList = i['AB_id'];
                            //   aboutMeName = i['User_Name'];
                            // }

                           return Expanded(
                             child: ListView.builder(
                                  itemCount:dataList.length ,
                                  // shrinkWrap: true,
                                  // physics: AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (c,i){
                                    // print("dataList[i]['Solutions']: ${dataList[i]}");
                                    int overallIndex = 0;
                                    for (int j = 0; j < i; j++) {
                                      overallIndex += (dataList[j]['Solutions'] as List).length;
                                    }

                                       return Column(
                                               children: [
                                                 Container(
                                                   padding: EdgeInsets.all(10),
                                                   child: Row(
                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: [

                                                           // Container(
                                                           //     width: 50,
                                                           //     child: Center(child: Text("${overallIndex}."))),

                                                           // Container(
                                                           //     width: MediaQuery.of(context).size.width * 0.08,
                                                           //     child: Center(child: Text("AB0${dataList[i]['AB_id'].toString()}",style: Theme.of(context).textTheme.bodySmall))),

                                                       // Container(
                                                       //     width: 80,
                                                       //     child: Center(child: Text(dataList[i]['Solutions'][index]['id'].toString(), style: Theme.of(context).textTheme.bodySmall))),

                                                       // Container(
                                                       //     width: MediaQuery.of(context).size.width * 0.08,
                                                       //     // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                       //     child: Center(child: Text(dataList[i]['Employer'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                                                       //
                                                       // Container(
                                                       //     width: MediaQuery.of(context).size.width * 0.08,
                                                       //     // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                       //     child: Center(child: Text(dataList[i]['User_Name'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                                                       //
                                                       //
                                                       // Container(
                                                       //     width: MediaQuery.of(context).size.width * 0.14,
                                                       //     // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                       //     child: Center(child: Text(dataList[i]['Email'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                                                       //
                                                       // Container(
                                                       //   width: 250,
                                                       //     child: Center(child: Text(dataList[i]['Solutions'][index]['Label'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),

                                                       Container(
                                                           width: MediaQuery.of(context).size.width * 0.14,
                                                           child: Center(child: Text(dataList[i]['About_Me_Label'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),


                                                       Container(
                                                           width: MediaQuery.of(context).size.width * 0.15,
                                                           // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                           child: Center(child: Text(dataList[i]['Created_Date'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                                                       Container(
                                                           width: MediaQuery.of(context).size.width * 0.08,
                                                           // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                           child: Center(child: Text(dataList[i]['AB_Status'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                                                       // Container(
                                                       //     width: MediaQuery.of(context).size.width * 0.08,
                                                       //     // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                       //     child: Center(child: Text(dataList[i]['Solutions'].length.toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),

                                                           Container(
                                                               width: MediaQuery.of(context).size.width * 0.12,
                                                           child: Center(child: Row(
                                                             mainAxisAlignment: MainAxisAlignment.end,
                                                             children: [

                                                               (dataList[i]['AB_Status'].toString()=="Submitted") ?
                                                               IconButton(
                                                                   iconSize: 25,
                                                                   color: primaryColorOfApp,
                                                                   onPressed: () async {
                                                                     showReportViewPageDialogBox(dataList[i]);
                                                                   },
                                                                   icon: Icon(Icons.visibility,)) :

                                                               IconButton(
                                                                   iconSize: 25,
                                                                   color: primaryColorOfApp,
                                                                   onPressed: () async {
                                                                     showEditAboutMeDialogBox(dataList[i],0);
                                                                   },
                                                                   icon: Icon(Icons.edit,)),

                                                               IconButton(
                                                                   iconSize: 25,
                                                                   color: primaryColorOfApp,
                                                                   onPressed: () async {
                                                                     ProgressDialog.show(context, "Deleting Users",Icons.person);
                                                                     await ApiRepository().DeleteSectionPreset(dataList[i].reference);
                                                                     setState(() {

                                                                     });
                                                                     // _addKeywordProvider.loadDataForPage(1);
                                                                     // _addKeywordProvider.setFirstpageNo();
                                                                     ProgressDialog.hide();
                                                                   },
                                                                   icon: Icon(Icons.delete,)),
                                                               // SizedBox(width: 20,),
                                                             ],
                                                           ),
                                                           )),
                                                     ],
                                                   ),
                                                 ),
                                                 Divider(),
                                               ],
                                             );

                              }),
                           );

                          }}
                    )

                  ],
                )
            ),
            // Container(
            //     width: MediaQuery.of(context).size.width,
            //     padding: EdgeInsets.all(20),
            //     margin: EdgeInsets.all(20),
            //     decoration: BoxDecoration(
            //       color: Colors.white.withOpacity(0.7),
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text("Details About Me", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineMedium,)),
            //         SizedBox(height: 10,),
            //
            //       ],
            //     )
            // ),
          ],
        ),
      ),
    );
  }

  void showEmptyAlert(context,message) {
    showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(0.0)), //this right here
            child: Container(
              height: MediaQuery.of(context).size.height *0.2,
              width: MediaQuery.of(context).size.width *0.2,
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
                        Text(message,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                    SizedBox(height: 20,),
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

  void showAddAddAboutMeDialogBox() {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
              data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
              child:  Consumer<UserAboutMEProvider>(
                  builder: (c,userAboutMEProvider, _){
                    return
                      AlertDialog(
                        // insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery
                        //     .of(context)
                        //     .size
                        //     .width * 0.05),
                        ///
                        // actions: <Widget>[
                        //   // Row(
                        //   //   mainAxisAlignment: MainAxisAlignment.center,
                        //   //   children: [
                        //   //     InkWell(
                        //   //       onTap: (){
                        //   //         selectedEmail = null;
                        //   //         nameController.clear();
                        //   //         employerController.clear();
                        //   //         divisionOrSectionController.clear();
                        //   //         RoleController.clear();
                        //   //         LocationController.clear();
                        //   //         EmployeeNumberController.clear();
                        //   //         LineManagerController.clear();
                        //   //         mycircumstancesController.clear();
                        //   //         MystrengthsController.clear();
                        //   //         mycircumstancesController.clear();
                        //   //         solutionsList.clear();
                        //   //         _userAboutMEProvider.solutionss.clear();
                        //   //         Navigator.pop(context);
                        //   //       },
                        //   //       child: Container(
                        //   //         padding: EdgeInsets.symmetric(horizontal: 15),
                        //   //         width: MediaQuery.of(context).size.width * .3,
                        //   //         height: 60,
                        //   //         decoration: BoxDecoration(
                        //   //           //color: Colors.white,
                        //   //           border: Border.all(
                        //   //             //color:primaryColorOfApp ,
                        //   //               width: 1.0),
                        //   //           borderRadius: BorderRadius.circular(15.0),
                        //   //         ),
                        //   //         child: Center(
                        //   //           child: Text(
                        //   //             'Cancel',
                        //   //             style: GoogleFonts.montserrat(
                        //   //               textStyle:
                        //   //               Theme
                        //   //                   .of(context)
                        //   //                   .textTheme
                        //   //                   .titleSmall,
                        //   //               fontWeight: FontWeight.bold,
                        //   //               //color: primaryColorOfApp
                        //   //             ),
                        //   //           ),
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //     SizedBox(height: 5, width: 5,),
                        //   //     InkWell(
                        //   //       onTap: () async {
                        //   //         int x = 0;
                        //   //         x = x + 1;
                        //   //         var createdAt = DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now());
                        //   //
                        //   //         Map<String, dynamic> AboutMEDatas = {
                        //   //           // 'AB_id': x,
                        //   //           'Email': selectedEmail,
                        //   //           'User_Name': nameController.text,
                        //   //           'Employee': employerController.text,
                        //   //           'Division_or_Section': divisionOrSectionController.text,
                        //   //           'Role': RoleController.text,
                        //   //           'Location': LocationController.text,
                        //   //           'Employee_Number': EmployeeNumberController.text,
                        //   //           'Line_Manager': LineManagerController.text,
                        //   //           'My_Circumstance': mycircumstancesController.text,
                        //   //           'My_Strength': MystrengthsController.text,
                        //   //           'My_Organisation': mycircumstancesController.text,
                        //   //           'Solutions': solutionsList,
                        //   //           "Created_By": widget.AdminName,
                        //   //           "Created_Date": createdAt,
                        //   //           "Modified_By": "",
                        //   //           "Modified_Date": "",
                        //   //           // Add other fields as needed
                        //   //         };
                        //   //
                        //   //         String solutionJson = json.encode(AboutMEDatas);
                        //   //         print(solutionJson);
                        //   //
                        //   //         ProgressDialog.show(context, "Creating About Me", Icons.chair);
                        //   //         await ApiRepository().createAboutMe(AboutMEDatas);
                        //   //         ProgressDialog.hide();
                        //   //         selectedEmail = null;
                        //   //         nameController.clear();
                        //   //         employerController.clear();
                        //   //         divisionOrSectionController.clear();
                        //   //         RoleController.clear();
                        //   //         LocationController.clear();
                        //   //         EmployeeNumberController.clear();
                        //   //         LineManagerController.clear();
                        //   //         mycircumstancesController.clear();
                        //   //         MystrengthsController.clear();
                        //   //         mycircumstancesController.clear();
                        //   //         solutionsList.clear();
                        //   //         _userAboutMEProvider.solutionss.clear();
                        //   //         Navigator.pop(context);
                        //   //         setState(() {
                        //   //
                        //   //         });
                        //   //       },
                        //   //       child: Container(
                        //   //         padding: EdgeInsets.symmetric(horizontal: 15),
                        //   //         width: MediaQuery.of(context).size.width * .3,
                        //   //         height: 60,
                        //   //         decoration: BoxDecoration(
                        //   //           color: Colors.blue,
                        //   //           border: Border.all(
                        //   //               color: Colors.blue,
                        //   //               width: 2.0),
                        //   //           borderRadius: BorderRadius.circular(15.0),
                        //   //         ),
                        //   //         child: Center(
                        //   //           child: Text(
                        //   //             'Add',
                        //   //             style: GoogleFonts.montserrat(
                        //   //                 textStyle:
                        //   //                 Theme
                        //   //                     .of(context)
                        //   //                     .textTheme
                        //   //                     .titleSmall,
                        //   //                 fontWeight: FontWeight.bold,
                        //   //                 color: Colors.white),
                        //   //           ),
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //   ],
                        //   // ),
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       InkWell(
                        //         onTap: (){
                        //           // page.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                        //         },
                        //         child: Container(
                        //           padding: EdgeInsets.symmetric(horizontal: 15),
                        //           width: MediaQuery.of(context).size.width * .3,
                        //           height: 60,
                        //           decoration: BoxDecoration(
                        //             //color: Colors.white,
                        //             border: Border.all(
                        //               //color:primaryColorOfApp ,
                        //                 width: 1.0),
                        //             borderRadius: BorderRadius.circular(15.0),
                        //           ),
                        //           child: Center(
                        //             child: Text(
                        //               'Cancel',
                        //               style: GoogleFonts.montserrat(
                        //                 textStyle:
                        //                 Theme
                        //                     .of(context)
                        //                     .textTheme
                        //                     .titleSmall,
                        //                 fontWeight: FontWeight.bold,
                        //                 //color: primaryColorOfApp
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(height: 5, width: 5,),
                        //       InkWell(
                        //         onTap: () async{
                        //           page.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                        //         },
                        //         child: Container(
                        //           padding: EdgeInsets.symmetric(horizontal: 15),
                        //           width: MediaQuery.of(context).size.width * .3,
                        //           height: 60,
                        //           decoration: BoxDecoration(
                        //             color: Colors.blue,
                        //             border: Border.all(
                        //                 color: Colors.blue,
                        //                 width: 2.0),
                        //             borderRadius: BorderRadius.circular(15.0),
                        //           ),
                        //           child: Center(
                        //             child: Text(
                        //               'Next',
                        //               style: GoogleFonts.montserrat(
                        //                   textStyle:
                        //                   Theme
                        //                       .of(context)
                        //                       .textTheme
                        //                       .titleSmall,
                        //                   fontWeight: FontWeight.bold,
                        //                   color: Colors.white),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ],
                        ///
                        // title: Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 20.0),
                        //       child: Text(userAboutMEProvider.alertDialogTitle,
                        //           style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                        //               fontSize: 30,
                        //               color: Colors.black)),
                        //     ),
                        //
                        //     Container(
                        //       margin: const EdgeInsets.only(right: 20.0),
                        //       child: Row(
                        //         children: [
                        //           Text("Page no:",
                        //               style: GoogleFonts.montserrat(
                        //                   fontWeight: FontWeight.w900,
                        //                   fontSize: 16,
                        //                   color: Colors.black)
                        //           ),
                        //           SizedBox(width: 8,),
                        //           InkWell(
                        //             onTap: (){
                        //               page.jumpToPage(0);
                        //             },
                        //             child: Container(
                        //               padding: EdgeInsets.all(12),
                        //               decoration: (userAboutMEProvider.currentPageIndex == 0)  ? BoxDecoration(
                        //                   shape: BoxShape.circle,
                        //                   color: Colors.blue,
                        //                 // borderRadius: BorderRadius.circular(100)
                        //               ) : BoxDecoration(),
                        //               child: Text("1",
                        //                   style: GoogleFonts.montserrat(
                        //                       fontWeight: FontWeight.w600,
                        //                       fontSize:(userAboutMEProvider.currentPageIndex == 0) ? 22 : 16,
                        //                       color:(userAboutMEProvider.currentPageIndex == 0) ? Colors.white : Colors.black)),
                        //             ),
                        //           ),
                        //           SizedBox(width: 15,),
                        //           InkWell(
                        //             onTap: (){
                        //               page.jumpToPage(1);
                        //             },
                        //
                        //             child: Container(
                        //               padding: EdgeInsets.all(12),
                        //
                        //               decoration: (userAboutMEProvider.currentPageIndex == 1)  ? BoxDecoration(
                        //                   shape: BoxShape.circle,
                        //
                        //                   color: Colors.blue,
                        //                   // borderRadius: BorderRadius.circular(100)
                        //               ) : BoxDecoration(),
                        //               child: Text("2",
                        //                   style: GoogleFonts.montserrat(
                        //                       fontWeight: FontWeight.w600,
                        //                       fontSize:(userAboutMEProvider.currentPageIndex == 1) ? 22 : 16,
                        //                       color:(userAboutMEProvider.currentPageIndex == 1) ? Colors.white : Colors.black)),
                        //             ),
                        //           ),
                        //           SizedBox(width: 15,),
                        //           InkWell(
                        //             onTap: (){
                        //               // if(mycircumstancesController.text.isEmpty || MystrengthsController.text.isEmpty || myOrganisationController.text.isEmpty) {
                        //               //   if (mycircumstancesController.text.isEmpty) {
                        //               //     showEmptyAlert(context, "Add About me\nand my circumstance \non page 3");
                        //               //   }
                        //               //   else if (MystrengthsController.text.isEmpty) {
                        //               //     showEmptyAlert(context, "Add My strengths");
                        //               //   }
                        //               //   else if (myOrganisationController.text.isEmpty) {
                        //               //     showEmptyAlert(context, "Add My organisation");
                        //               //   }
                        //               // }
                        //               // else
                        //                 page.jumpToPage(2);
                        //
                        //             },
                        //
                        //             child: Container(
                        //               padding: EdgeInsets.all(12),
                        //
                        //               decoration: (userAboutMEProvider.currentPageIndex == 2)  ? BoxDecoration(
                        //                   shape: BoxShape.circle,
                        //                   color: Colors.blue,
                        //                   // borderRadius: BorderRadius.circular(100)
                        //               ) : BoxDecoration(),
                        //               child: Text("3",
                        //                   style: GoogleFonts.montserrat(
                        //                       fontWeight: FontWeight.w600,
                        //                       fontSize:(userAboutMEProvider.currentPageIndex == 2) ? 22 : 16,
                        //                       color:(userAboutMEProvider.currentPageIndex == 2) ? Colors.white : Colors.black)),
                        //             ),
                        //           ),
                        //           SizedBox(width: 15,),
                        //           InkWell(
                        //             onTap: (){
                        //               page.jumpToPage(3);
                        //             },
                        //             child: Container(
                        //               padding: EdgeInsets.all(12),
                        //
                        //               decoration: (userAboutMEProvider.currentPageIndex == 3)  ? BoxDecoration(
                        //                 shape: BoxShape.circle,
                        //                   color: Colors.blue,
                        //                   // borderRadius: BorderRadius.circular(100)
                        //               ) : BoxDecoration(),
                        //               child: Text("4",
                        //                   style: GoogleFonts.montserrat(
                        //                       fontWeight: FontWeight.w600,
                        //                       fontSize:(userAboutMEProvider.currentPageIndex == 3) ? 22 : 16,
                        //                       color:(userAboutMEProvider.currentPageIndex == 3) ? Colors.white : Colors.black)),
                        //             ),
                        //           ),
                        //           // SizedBox(width: 15,),
                        //         ],
                        //       ),
                        //     ),
                        //
                        //   ],
                        // ),
                        content: SizedBox(
                            width: double.maxFinite,
                            // child: PageView(
                            //   controller: page,
                            //   physics: NeverScrollableScrollPhysics(),
                            //   // scrollDirection: Axis.,
                            //   onPageChanged: (index){
                            //     if(index==0){
                            //       userAboutMEProvider.upadateTitle("1. Personal Info:",0);
                            //     }
                            //     if(index==1){
                            //       userAboutMEProvider.upadateTitle('2. Details:',1);
                            //     }
                            //     if(index==2){
                            //       userAboutMEProvider.upadateTitle('3. Challenges:',2);
                            //     }
                            //     if(index==3){
                            //       userAboutMEProvider.upadateTitle('4. Solutions:',3);
                            //     }
                            //   },
                            //   children: [
                            //     AboutmeFormpage(),
                            //     Detailspage(),
                            //     AddChallengesPage(),
                            //     AddSolutionsPage(),
                            //   ],
                            // )
                            child:DefaultTabController(
                              length: 6, // Number of tabs
                              child: Column(
                                children: [
                                  TabBar(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: _tabController,
                                    tabs: [
                                      Tab(text: "Employee data"),
                                      Tab(text: "Insights about me"),
                                      Tab(text: "My Challenges"),
                                      Tab(text: "My Solutions"),
                                      Tab(text: "Assesment Assistant"),
                                      Tab(text: "Generate report"),
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      controller: _tabController,
                                      children: [
                                        AboutmeFormpage(),
                                        Detailspage(),
                                        AddChallengesPage(),
                                        AddSolutionsPage(),
                                        AssesmentAssistant(),
                                        PreviewPage(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )

                      ),
                        icon: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: (){
                                selectedEmail = null;
                                nameController.clear();
                                employerController.clear();
                                divisionOrSectionController.clear();
                                RoleController.clear();
                                LocationController.clear();
                                EmployeeNumberController.clear();
                                LineManagerController.clear();
                                mycircumstancesController.clear();
                                MystrengthsController.clear();
                                mycircumstancesController.clear();
                                RefineController.clear();
                                solutionsList.clear();
                                _userAboutMEProvider.solutionss.clear();
                                _userAboutMEProvider.challengess.clear();
                                _userAboutMEProvider.combinedSolutionsResults.clear();
                                _userAboutMEProvider.combinedResults.clear();
                                _navigateToTab(0);
                                setState(() {

                                });
                                Navigator.pop(context);                              },
                                child: Text("Home",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline
                                  ),
                                )),
                          ],
                        ),
                        iconPadding: EdgeInsets.only(right: 15,top: 15),
                      );
                  })

          );
        }
    );
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
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Card(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     InkWell(
                    //         onTap: (){
                    //           Navigator.of(context).pop();
                    //         },
                    //         child: Text("<<- Dashboard",
                    //           style: TextStyle(
                    //               // decoration: TextDecoration.underline
                    //           ),
                    //         )),
                    //   ],
                    // ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  showAddAddAboutMeDialogBox();
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
                                        Icon(Icons.add_box_outlined,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            // 'Thrivers',
                                            'Employee Data',
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
                                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').orderBy('AB_id', descending: true).limit(1).get();

                                  // Check if there are any documents

                                  print("querySnapshot :${querySnapshot}");
                                  print("querySnapshot :${querySnapshot.docs.length}");

                                  if (querySnapshot.docs.isNotEmpty) {
                                    // Get the last document
                                    DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                    print("lastDocument :$lastDocument");
                                    showEditAboutMeDialogBox(lastDocument,1);
                                  }
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
                                        Icon(Icons.input ,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            'Insight About Me',
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
                                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').orderBy('AB_id', descending: true).limit(1).get();

                                  // Check if there are any documents

                                  print("querySnapshot :${querySnapshot}");
                                  print("querySnapshot :${querySnapshot.docs.length}");

                                  if (querySnapshot.docs.isNotEmpty) {
                                    // Get the last document
                                    DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                    print("lastDocument :$lastDocument");
                                    showEditAboutMeDialogBox(lastDocument,2);
                                  }
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
                                        Icon(Icons.sync_problem,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            // 'User',
                                            'My Challenges',
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
                                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').orderBy('AB_id', descending: true).limit(1).get();

                                  // Check if there are any documents

                                  print("querySnapshot :${querySnapshot}");
                                  print("querySnapshot :${querySnapshot.docs.length}");

                                  if (querySnapshot.docs.isNotEmpty) {
                                    // Get the last document
                                    DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                    print("lastDocument :$lastDocument");
                                    showEditAboutMeDialogBox(lastDocument,3);
                                  }
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
                                        Icon(Icons.checklist_rtl,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),

                                        Expanded(
                                          child: Text(
                                            // 'Solutions',
                                            'My Solutions',
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
                                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').orderBy('AB_id', descending: true).limit(1).get();

                                  // Check if there are any documents

                                  print("querySnapshot :${querySnapshot}");
                                  print("querySnapshot :${querySnapshot.docs.length}");

                                  if (querySnapshot.docs.isNotEmpty) {
                                    // Get the last document
                                    DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                    print("lastDocument :$lastDocument");
                                    showEditAboutMeDialogBox(lastDocument,4);
                                  }
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
                                        Icon(Icons.assistant_outlined,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),
                                        Expanded(
                                          child: Text(
                                            // 'User',
                                            'Assesment Assistance',
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
                                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').orderBy('AB_id', descending: true).limit(1).get();

                                  // Check if there are any documents

                                  print("querySnapshot :${querySnapshot}");
                                  print("querySnapshot :${querySnapshot.docs.length}");

                                  if (querySnapshot.docs.isNotEmpty) {
                                    // Get the last document
                                    DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                    print("lastDocument :$lastDocument");
                                    showEditAboutMeDialogBox(lastDocument,5);
                                  }
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
                                        Icon(Icons.insert_drive_file,color: Colors.black,size: 30,),
                                        SizedBox(width: 5,),

                                        Expanded(
                                          child: Text(
                                            // 'Solutions',
                                            'Generate Report',
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
                        InkWell(
                          onTap: () async {
                            // sideMenu.changePage(5);
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
                                  // Icon(Icons.person_outline_outlined,color: Colors.black,size: 30,),
                                  Icon(Icons.archive_outlined,color: Colors.black,size: 30,),
                                  SizedBox(width: 5,),
                                  Expanded(
                                    child: Text(
                                      // 'User',
                                      'Archive',
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

  Widget AboutmeFormpage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0),
          //   child: Text("1. Personal Info",
          //       style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
          //           fontSize: 30,
          //           color: Colors.black)),
          // ),
          // SizedBox(height: 10,),
          Container(
            height: MediaQuery.of(context).size.height * .68,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black)
            ),
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
      
      
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("1. Email:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                      ),
                      
                      // DropdownSearch<String>(
                      //   popupProps: PopupProps.menu(
                      //     showSelectedItems: true,
                      //     isFilterOnline: true,
                      //     searchDelay: Duration(milliseconds: 100),
                      //     searchFieldProps: TextFieldProps(
                      //         enableSuggestions: true,
                      //         decoration: InputDecoration(
                      //           contentPadding: EdgeInsets.all(10),
                      //           hintText: "Search Email",
                      //           labelText: "Search Email",
                      //           errorStyle: GoogleFonts.montserrat(
                      //               textStyle: Theme
                      //                   .of(context)
                      //                   .textTheme
                      //                   .bodyLarge,
                      //               fontWeight: FontWeight.w400,
                      //               color: Colors.redAccent),
                      //           focusedBorder: OutlineInputBorder(
                      //               borderSide: BorderSide(color: Colors.black),
                      //               borderRadius: BorderRadius.circular(15)),
                      //           border: OutlineInputBorder(
                      //               borderSide: BorderSide(color: Colors.black12),
                      //               borderRadius: BorderRadius.circular(15)),
                      //           labelStyle: GoogleFonts.montserrat(
                      //               textStyle: Theme
                      //                   .of(context)
                      //                   .textTheme
                      //                   .bodyLarge,
                      //               fontWeight: FontWeight.w400,
                      //               color: Colors.black),
                      //         ),
                      //         controller: searchEmailcontroller
                      //     ),
                      //     showSearchBox: true,
                      //   ),
                      //   // items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                      //   items: emailList,
                      //   dropdownDecoratorProps: DropDownDecoratorProps(
                      //     dropdownSearchDecoration: InputDecoration(
                      //       contentPadding: EdgeInsets.all(10),
                      //       errorStyle: GoogleFonts.montserrat(
                      //           textStyle: Theme
                      //               .of(context)
                      //               .textTheme
                      //               .bodyLarge,
                      //           fontWeight: FontWeight.w400,
                      //           color: Colors.redAccent),
                      //       focusedBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.black),
                      //           borderRadius: BorderRadius.circular(15)),
                      //       border: OutlineInputBorder(
                      //           borderSide: BorderSide(color: Colors.black12),
                      //           borderRadius: BorderRadius.circular(15)),
                      //       labelStyle: GoogleFonts.montserrat(
                      //           textStyle: Theme
                      //               .of(context)
                      //               .textTheme
                      //               .bodyLarge,
                      //           fontWeight: FontWeight.w400,
                      //           color: Colors.black),
                      //     ),
                      //   ),
                      //   onChanged: (val){
                      //     setState(() {
                      //       selectedEmail = val!;
                      //     });
                      //     print("selectedEmail:${selectedEmail}");
                      //
                      //   },
                      //   selectedItem: selectedEmail,
                      //
                      //
                      // ),
                      
                      Expanded(
                        flex: 4,
                        child: Consumer<AddKeywordProvider>(
                            builder: (c,addKeywordProvider, _){
                              return TypeAheadField(
                                noItemsFoundBuilder: (ctx){
                                  print("ccccc: $ctx");
                                  return Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          "Hit Enter to add: ${searchEmailcontroller.text}",
                                          // (ApiRepository().isValidEmail(searchEmailcontroller.text)) ? "Hit Enter to add: ${searchEmailcontroller.text}@gmail.com" : "Invalid email format. Please enter a valid email address.",
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                                        ),
                                      )
                                  );
                                },
                                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                    scrollbarTrackAlwaysVisible: true,
                                    scrollbarThumbAlwaysVisible: true,
                                    hasScrollbar: true,
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, )
                                ),
                                suggestionsCallback: (pattern) async {
                                  if (pattern.isEmpty) {
                                    // Return the full email list if the pattern is empty
                                    return emailList;
                                  } else {
                                    // Return filtered suggestions based on the input pattern
                                    return emailList.where((email) => email.contains(pattern)).toList();
                                  }
                                },
                                itemBuilder: (context, String suggestion) {
                                  return Container(
                                    // color: Colors.black,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(suggestion,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                                    ),
                                  );
                                },
                                onSuggestionSelected: (String suggestion) async {
                                 searchEmailcontroller.text = suggestion;
                                 selectedEmail = suggestion;
                                 _previewProvider.updateEmail(selectedEmail);
                                 if(selectedEmail != null){
                                   toastification.show(context: context,
                                       title: Text('Email Selected'),
                                       autoCloseDuration: Duration(milliseconds: 2500),
                                       alignment: Alignment.center,
                                       backgroundColor: Colors.green,
                                       foregroundColor: Colors.white,
                                       icon: Icon(Icons.check_circle, color: Colors.white,),
                                       animationDuration: Duration(milliseconds: 1000),
                                       showProgressBar: false
                                   );
                                 }
                                },
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: searchEmailcontroller,
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context).textTheme.bodyLarge,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                                  ),
                                  onSubmitted: (value) {
                                    if (ApiRepository().isValidEmail(value)) {
                                      searchEmailcontroller.text = value;
                                      selectedEmail = value;
                                      if(selectedEmail != null){
                                        toastification.show(context: context,
                                            title: Text('Email Selected'),
                                            autoCloseDuration: Duration(milliseconds: 2500),
                                            alignment: Alignment.center,
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            icon: Icon(Icons.check_circle, color: Colors.white,),
                                            animationDuration: Duration(milliseconds: 1000),
                                            showProgressBar: false
                                        );
                                      }
                        
                                    } else {
                                      toastification.show(context: context,
                                          title: Text('Invalid email format. Please enter a valid email address.'),
                                          autoCloseDuration: Duration(milliseconds: 2500),
                                          alignment: Alignment.center,
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icon(Icons.error, color: Colors.white,),
                                          animationDuration: Duration(milliseconds: 1000),
                                          showProgressBar: false
                                      );
                                    }
                                  },                            decoration:InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
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
                              );
                            }
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("2. Name:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: TextField(
                          controller: nameController,
                        
                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                            _previewProvider.updateName(value);
                            AboutMeLabeltextController.text = value;
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
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 10,),
                  
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("3. Employer:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                      ),
                      Expanded(
                        flex: 4,

                        child: TextField(
                          controller: employerController,
                              
                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                            _previewProvider.updateemployer(value);
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
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 10,),
                  
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("4. Division or section:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                      ),
                      Expanded(
                        flex: 4,

                        child: TextField(
                          controller: divisionOrSectionController,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                            _previewProvider.updatedivision(value);

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
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("5. Role:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                      ),
                      Expanded(
                        flex: 4,

                        child: TextField(
                          controller: RoleController,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                            _previewProvider.updaterole(value);

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
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("6. Location:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                      ),
                      Expanded(
                        flex: 4,

                        child: TextField(
                          controller: LocationController,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                            _previewProvider.updatelocation(value);

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
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("7. Employee number:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                      ),
                      Expanded(
                        flex: 4,

                        child: TextField(
                          controller: EmployeeNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                            _previewProvider.updateemployeeNumber(value);

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
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("8. Line manager:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                      ),
                      Expanded(
                        flex: 4,

                        child: TextField(
                          controller: LineManagerController,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                            _previewProvider.updatelinemanager(value);
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
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
      
                ],
              ),
            ),
          ),

          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // InkWell(
              //   onTap: (){
              //     // page.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
              //     selectedEmail = null;
              //             nameController.clear();
              //             employerController.clear();
              //             divisionOrSectionController.clear();
              //             RoleController.clear();
              //             LocationController.clear();
              //             EmployeeNumberController.clear();
              //             LineManagerController.clear();
              //             mycircumstancesController.clear();
              //             MystrengthsController.clear();
              //             mycircumstancesController.clear();
              //             solutionsList.clear();
              //             _userAboutMEProvider.solutionss.clear();
              //             _userAboutMEProvider.challengess.clear();
              //             _userAboutMEProvider.combinedResults.clear();
              //             _userAboutMEProvider.combinedSolutionsResults.clear();
              //             _userAboutMEProvider.isRecommendedChallengeCheckedMap.clear();
              //             _userAboutMEProvider.isRecommendedSolutionsCheckedMap.clear();
              //             generatedsolutionscategory.clear();
              //             generatedsolutionstags.clear();
              //             generatedtags.clear();
              //             generatedcategory.clear();
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 15),
              //     width: MediaQuery.of(context).size.width * .3,
              //     height: 60,
              //     decoration: BoxDecoration(
              //       //color: Colors.white,
              //       border: Border.all(
              //         //color:primaryColorOfApp ,
              //           width: 1.0),
              //       borderRadius: BorderRadius.circular(15.0),
              //     ),
              //     child: Center(
              //       child: Text(
              //         'Cancel',
              //         style: GoogleFonts.montserrat(
              //           textStyle:
              //           Theme
              //               .of(context)
              //               .textTheme
              //               .titleSmall,
              //           fontWeight: FontWeight.bold,
              //           //color: primaryColorOfApp
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 5, width: 5,),
              InkWell(
                onTap: () async{
                  // if(selectedEmail==null|| nameController.text.isEmpty || employerController.text.isEmpty || divisionOrSectionController.text.isEmpty || RoleController.text.isEmpty ||
                  //     LocationController.text.isEmpty || EmployeeNumberController.text.isEmpty || LineManagerController.text.isEmpty ){
                  //   if(selectedEmail==null){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(nameController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(employerController.text.isEmpty ){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(divisionOrSectionController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(RoleController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(LocationController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(EmployeeNumberController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  //   if(LineManagerController.text.isEmpty){
                  //     showEmptyAlert(context, "Select Email Id");
                  //   }
                  // }
                  // page.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

                  int x = 0;
                  x = x + 1;
                  var createdAt = DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now());

                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('AboutMe')
                      .orderBy('Created_Date', descending: true)
                      .limit(1)
                      .get();
                  final abc =   querySnapshot.docs.first;
                  print("AB_id; ${abc['AB_id']}");
                  print("AB_id; ${abc['AB_id'].runtimeType}");
                  var ids = abc['AB_id'] + 1;

                  Map<String, dynamic> AboutMEDatas = {
                    'AB_id': ids,
                    'Email': selectedEmail,
                    'User_Name': nameController.text,
                    'Employer': employerController.text,
                    'Division_or_Section': divisionOrSectionController.text,
                    'Role': RoleController.text,
                    'Location': LocationController.text,
                    'Employee_Number': EmployeeNumberController.text,
                    'Line_Manager': LineManagerController.text,
                    'About_Me_Label': nameController.text,
                    'My_Circumstance': mycircumstancesController.text,
                    'My_Strength': MystrengthsController.text,
                    'My_Organisation': myOrganisationController.text,
                    'My_Challenges_Organisation': myOrganisation2Controller.text,
                    'AB_Status' : "Drafted",
                    'Solutions': solutionsList,
                    'Challenges': challengesList,
                    "Created_By": widget.AdminName,
                    "Created_Date": createdAt,
                    "Modified_By": "",
                    "Modified_Date": "",
                    // Add other fields as needed
                  };

                  String solutionJson = json.encode(AboutMEDatas);
                  print(solutionJson);

                  ProgressDialog.show(context, "Creating About Me", Icons.chair);
                  documentId = await ApiRepository().createAboutMe(AboutMEDatas);
                  ProgressDialog.hide();
                  if (documentId != null) {
                    _navigateToTab(1);
                    print("Document ID: $documentId");
                  } else {
                    // Handle error if document creation failed
                  }
                  // print("ApiRepository().documentId : ${ApiRepository().documentId}");
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width * .2,
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
                      'Save and Next',
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget AssesmentAssistant() {
    return SingleChildScrollView();
  }

  Widget Detailspage() {
    return SingleChildScrollView(
      child:Consumer<UserAboutMEProvider>(
          builder: (c,userAboutMEProvider, _){
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 5,),
                // Padding(
                //   padding: const EdgeInsets.only(left: 20.0),
                //   child: Text("2. Details",
                //       style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                //           fontSize: 30,
                //           color: Colors.black)),
                // ),
                SizedBox(height: 10,),

                Container(
                  height: MediaQuery.of(context).size.height * .68,
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black)
                  ),
                  // height: MediaQuery.of(context).size.height * .7,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                        //   child: Text("Title: ", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,fontWeight: FontWeight.w600)),
                        // ),
                        //
                        // TextField(
                        //   controller: AboutMeLabeltextController,
                        //   onChanged: (value) {
                        //     _previewProvider.updatetitle(value);
                        //   },
                        //   style: GoogleFonts.montserrat(
                        //       textStyle: Theme
                        //           .of(context)
                        //           .textTheme
                        //           .bodyLarge,
                        //       fontWeight: FontWeight.w400,
                        //       color: Colors.black),
                        //   decoration: InputDecoration(
                        //     contentPadding: EdgeInsets.all(10),
                        //     // labelText: "Name",
                        //     hintText: "About Me Title",
                        //     errorStyle: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.bodyLarge,
                        //         fontWeight: FontWeight.w400,
                        //         color: Colors.redAccent),
                        //     focusedBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(color: Colors.black),
                        //         borderRadius: BorderRadius.circular(15)),
                        //     border: OutlineInputBorder(
                        //         borderSide: BorderSide(color: Colors.black12),
                        //         borderRadius: BorderRadius.circular(15)),
                        //     labelStyle: GoogleFonts.montserrat(
                        //         textStyle: Theme
                        //             .of(context)
                        //             .textTheme
                        //             .bodyLarge,
                        //         fontWeight: FontWeight.w400,
                        //         color: Colors.black),
                        //   ),
                        // ),
                        /// AB title

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("1. About me and my circumstances:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                        TextField(
                          controller: mycircumstancesController,
                          maxLines: 3,
                          // cursorColor: primaryColorOfApp,
                          // onChanged: (value) {
                          //   if (value.isNotEmpty) {
                          //     final lines = value.split('\n');
                          //
                          //     for (int i = 0; i < lines.length; i++) {
                          //       if (lines[i].trim().isNotEmpty && !lines[i].startsWith('-')) {
                          //         lines[i] = '- ' + lines[i];
                          //       }
                          //     }
                          //
                          //     mycircumstancesController.text = lines.join('\n');
                          //     mycircumstancesController.selection = TextSelection.fromPosition(
                          //       TextPosition(offset: mycircumstancesController.text.length),
                          //     );
                          //     _previewProvider.updatemystrength(value);
                          //
                          //   } else {
                          //     isInitialTyping = true; // Reset when the text field becomes empty
                          //   }
                          // },

                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              final lines = value.split('\n');

                              for (int i = 0; i < lines.length; i++) {
                                if (lines[i].trim().isNotEmpty && !lines[i].startsWith('-')) {
                                  lines[i] = '- ' + lines[i];
                                }
                              }

                              // Combine lines with '\n'
                              final modifiedText = lines.join('\n');

                              // Calculate new cursor position based on changes in text
                              final newTextLength = modifiedText.length;
                              final cursorPosition = mycircumstancesController.selection.baseOffset +
                                  (newTextLength - value.length);

                              // Update text and cursor position
                              mycircumstancesController.value = mycircumstancesController.value.copyWith(
                                text: modifiedText,
                                selection: TextSelection.fromPosition(
                                  TextPosition(offset: cursorPosition),
                                ),
                              );

                              _previewProvider.updatemycircumstance(value);
                            } else {
                              isInitialTyping = true; // Reset when the text field becomes empty
                            }
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
                            // hintText: "Anything you want to share about eg\nYour family circumstances\nWhere you live\nYour education and professional qualifications\nYour life stages or life events\nYour ethnicity, faith, identification\nWhat matters most to you in life",
                            hintText: "Anything you want to share about eg, Your family circumstances, Where you live, Your education and professional qualifications, Your life stages or life events, Your ethnicity, faith, identification, What matters most to you in life",
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
                        // SizedBox(width: 10,),
                        // VerticalDivider(),
                        // SizedBox(width: 10,),
                        SizedBox(height: 10,),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("2. My strengths that I want to have the opportunity to use in my role:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                        TextField(
                          controller: MystrengthsController,

                          maxLines: 3,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              final lines = value.split('\n');

                              for (int i = 0; i < lines.length; i++) {
                                if (lines[i].trim().isNotEmpty && !lines[i].startsWith('-')) {
                                  lines[i] = '- ' + lines[i];
                                }
                              }

                              // Combine lines with '\n'
                              final modifiedText = lines.join('\n');

                              // Calculate new cursor position based on changes in text
                              final newTextLength = modifiedText.length;
                              final cursorPosition = MystrengthsController.selection.baseOffset +
                                  (newTextLength - value.length);

                              // Update text and cursor position
                              MystrengthsController.value = MystrengthsController.value.copyWith(
                                text: modifiedText,
                                selection: TextSelection.fromPosition(
                                  TextPosition(offset: cursorPosition),
                                ),
                              );

                              _previewProvider.updatemystrength(value);
                            } else {
                              isInitialTyping = true; // Reset when the text field becomes empty
                            }
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
                            hintText: "What do you view as your strengths, passions and values that you hope and want to be able to deploy in your role at work - create a list",
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

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("3. What I value about [my organisation] and workplace environment that helps me perform to my best:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                        TextField(
                          controller: myOrganisationController,

                          maxLines: 3,


                          // onChanged: (value) {
                          //   if (value.isNotEmpty) {
                          //     final lines = value.split('\n');
                          //     final lastLine = lines.last;
                          //
                          //     if (isInitialTyping || (lastLine.trimLeft().startsWith('• ') && !lastLine.contains('• '))) {
                          //       isInitialTyping = false;
                          //       myOrganisationController.text = value.replaceAll('\n', '\n• ');
                          //       myOrganisationController.selection = TextSelection.fromPosition(
                          //         TextPosition(offset: myOrganisationController.text.length),
                          //       );
                          //     } else if (value.endsWith('\n')) {
                          //       // If the last character entered is a newline, append a bullet point
                          //       myOrganisationController.text += '• ';
                          //       myOrganisationController.selection = TextSelection.fromPosition(
                          //         TextPosition(offset: myOrganisationController.text.length),
                          //       );
                          //     }
                          //   } else {
                          //     isInitialTyping = true; // Reset when the text field becomes empty
                          //   }
                          // },

                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              final lines = value.split('\n');

                              for (int i = 0; i < lines.length; i++) {
                                if (lines[i].trim().isNotEmpty && !lines[i].startsWith('-')) {
                                  lines[i] = '- ' + lines[i];
                                }
                              }

                              // Combine lines with '\n'
                              final modifiedText = lines.join('\n');

                              // Calculate new cursor position based on changes in text
                              final newTextLength = modifiedText.length;
                              final cursorPosition = myOrganisationController.selection.baseOffset +
                                  (newTextLength - value.length);

                              // Update text and cursor position
                              myOrganisationController.value = myOrganisationController.value.copyWith(
                                text: modifiedText,
                                selection: TextSelection.fromPosition(
                                  TextPosition(offset: cursorPosition),
                                ),
                              );

                              _previewProvider.updatemyorganization(value);
                            } else {
                              isInitialTyping = true; // Reset when the text field becomes empty
                            }
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
                            hintText: "What things does your organisation do that helps you; what do you appreciate exists; it could be a policy, something about the culture or environment that you would like to show your appreciation for and maye would like to see more of - create a list",
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("4. What I find challenging about [My Organisation] and the workplace environment that makes it harder for me to perform my best:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                        TextField(
                          controller: myOrganisation2Controller,
                          keyboardType: TextInputType.multiline,
                          // onSubmitted: (_) => userAboutMEProvider.handleEnter(myOrganisation2Controller),

                          maxLines: 3,

                          // cursorColor: primaryColorOfApp,
                          // onChanged: (value) {
                          //   if (value.isNotEmpty) {
                          //     final lines = value.split('\n');
                          //
                          //     for (int i = 0; i < lines.length; i++) {
                          //       if (lines[i].trim().isNotEmpty && !lines[i].startsWith('-')) {
                          //         lines[i] = '- ' + lines[i];
                          //       }
                          //     }
                          //
                          //     myOrganisation2Controller.text = lines.join('\n');
                          //     myOrganisation2Controller.selection = TextSelection.fromPosition(
                          //       TextPosition(offset: myOrganisation2Controller.text.length),
                          //     );
                          //     _previewProvider.updatemychallenge(value);
                          //
                          //   } else {
                          //     isInitialTyping = true; // Reset when the text field becomes empty
                          //   }
                          // },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              final lines = value.split('\n');

                              for (int i = 0; i < lines.length; i++) {
                                if (lines[i].trim().isNotEmpty && !lines[i].startsWith('-')) {
                                  lines[i] = '- ' + lines[i];
                                }
                              }

                              // Combine lines with '\n'
                              final modifiedText = lines.join('\n');

                              // Calculate new cursor position based on changes in text
                              final newTextLength = modifiedText.length;
                              final cursorPosition = myOrganisation2Controller.selection.baseOffset +
                                  (newTextLength - value.length);

                              // Update text and cursor position
                              myOrganisation2Controller.value = myOrganisation2Controller.value.copyWith(
                                text: modifiedText,
                                selection: TextSelection.fromPosition(
                                  TextPosition(offset: cursorPosition),
                                ),
                              );

                              _previewProvider.updatemychallenge(value);
                            } else {
                              isInitialTyping = true; // Reset when the text field becomes empty
                            }
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
                            hintText: "What things does your organisation do that hinders you; what do you wish didn’t exists; it could be a policy, something about the culture or environment that makes work harder for you and if possible you would like to see less of - create a list",
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

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Row (
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // InkWell(
                    //   onTap: (){
                    //     // page.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                    //     _navigateToTab(0);
                    //     // Navigator.pop(context);
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 15),
                    //     width: MediaQuery.of(context).size.width * .3,
                    //     height: 60,
                    //     decoration: BoxDecoration(
                    //       //color: Colors.white,
                    //       border: Border.all(
                    //         //color:primaryColorOfApp ,
                    //           width: 1.0),
                    //       borderRadius: BorderRadius.circular(15.0),
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         'Back',
                    //         style: GoogleFonts.montserrat(
                    //           textStyle:
                    //           Theme
                    //               .of(context)
                    //               .textTheme
                    //               .titleSmall,
                    //           fontWeight: FontWeight.bold,
                    //           //color: primaryColorOfApp
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 5, width: 5,),
                    InkWell(
                      onTap: () async{

                        // if(mycircumstancesController.text.isEmpty || MystrengthsController.text.isEmpty || myOrganisationController.text.isEmpty){
                        //   if(mycircumstancesController.text.isEmpty){
                        //     showEmptyAlert(context,"Add About me\nand my circumstance");
                        //   }
                        //   else if(MystrengthsController.text.isEmpty){
                        //     showEmptyAlert(context,"Add My strengths");
                        //   }
                        //   else if(myOrganisationController.text.isEmpty){
                        //     showEmptyAlert(context,"Add My organisation");
                        //   }
                        // }
                         {
                          var q1 = "1. About me and my circumstance: ${mycircumstancesController.text}";
                          var q2 = "2. My strengths that I want to have the opportunity to use in my role: ${MystrengthsController.text}";
                          var q3 = "3. What I value about [my organisation] and workplace environment that helps me perform to my best: ${myOrganisationController.text}";
                          //
                          // var defaulttext,defaulttextq2 ;
                          // defaulttext = q1+" "+ q2+" " +q3;//"${q1}+${q2}\n${q3}" ;
                          // // defaulttext = defaulttext +""+ "where xxx = ${originaltextEditingController.text.toString()}";
                          // defaulttext = "Generate tags in a one list with from :$defaulttext";
                          // // defaulttextq2 =  defaulttext + " and select category from "+"${resultString}";
                          // defaulttextq2 =  "These is a category list : ${resultString} . Choose the categories that describe this text : $defaulttext.";

                          var defaulttext = "Generate tags in a one list with ',' from :$q1 $q2 $q3";
                          //
                          // var defaulttext =  q1+""+q2+" "+q3 + " where yyy is "+mycircumstancesController.text+" "+ MystrengthsController.text +" "+myOrganisationController.text;


                          var defaulttextq2 = "These are the category list: $resultString. Choose the categories that describe this text: $defaulttext.";

                          // print(defaulttext);
                          print("defaulttextq2 $defaulttextq2");
                          // await getChatResponse(defaulttext,defaulttextq2);

                          // await getRelatedChallenges(generatedtags, generatedcategory);

                          // await page.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                          Map<String, dynamic> AboutMEDatas = {
                            'About_Me_Label': AboutMeLabeltextController.text,
                            'My_Circumstance': mycircumstancesController.text,
                            'My_Strength': MystrengthsController.text,
                            'My_Organisation': myOrganisationController.text,
                            'My_Challenges_Organisation': myOrganisation2Controller.text,
                            // Add other fields as needed
                          };

                          String solutionJson = json.encode(AboutMEDatas);
                          print(solutionJson);

                          ProgressDialog.show(context, "Saving", Icons.save);
                          await ApiRepository().updateAboutMe(AboutMEDatas,documentId);
                          ProgressDialog.hide();
                          await _navigateToTab(2);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.width * .2,
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
                            'Save and Next',
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
                    ),
                  ],
                ),

              ],
            );
  })
    );
  }

  Widget RecommendedChallengesListTile(challengesData, i, documentsss){

    return SingleChildScrollView(
        child: Consumer<UserAboutMEProvider>(
            builder: (c,userAboutMEProvider, _){
              // addKeywordProvider.getcategoryAndKeywords();
              // addKeywordProvider.newgetSource();
              // addKeywordProvider.getThriversStatus();
              ChallengesModel challengesModel;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text("CH0${challengesData['id']}.",
                      Text("${challengesData['Label']}",
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black)),
                      // Checkbox(
                      //   activeColor: Colors.blue,
                      //   value: userAboutMEProvider.isRecommendedcCheckedForTileChallenge(documentsss![i]), // Use the state from the provider
                      //   // value: userAboutMEProvider.challengess[i].isChecked, // Use the state from the provider
                      //   onChanged: (value) {
                      //     userAboutMEProvider.isRecommendedClickedBoxChallenge(value, i, documentsss![i] );
                      //   },
                      //
                      // ),

                      Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                NewViewDialog(challengesData['Label'],challengesData['Description'],challengesData['Impact'],challengesData['Final_description'], challengesData['Keywords'],challengesData['tags'],challengesData['id'],challengesData, userAboutMEProvider.isRecommendedChallengeCheckedMap,userAboutMEProvider.isRecommendedAddedChallenge);
                              },
                              icon: Icon(Icons.info_outline, color: Colors.blue,)
                          ),
                          SizedBox(width: 8),
                          (userAboutMEProvider.isRecommendedChallengeCheckedMap[challengesData['id']] == true) ? Text(
                            'Added',
                            style: GoogleFonts.montserrat(
                              textStyle:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .titleSmall,
                              fontStyle: FontStyle.italic,
                              color:Colors.green ,
                            ),
                          ) : InkWell(
                            onTap: (){
                              userAboutMEProvider.isRecommendedAddedChallenge(true,  documentsss![i]);
                              toastification.show(
                                context: context,
                                  title: Text('${challengesData['Label']} added successfully'),
                                autoCloseDuration:const Duration(seconds: 3),
                                  alignment: Alignment.bottomCenter,
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icon(Icons.check_circle, color: Colors.white,),
                                  animationDuration:const Duration(milliseconds: 300),
                                  showProgressBar: false,
                              );

                              // toastification.show(
                              //   context: context,
                              //   type: ToastificationType.success,
                              //   autoCloseDuration: const Duration(seconds: 5),
                              //   title: Text('${challengesData['Label']}'),
                              //   // you can also use RichText widget for title and description parameters
                              //   description: RichText(text: const TextSpan(text: 'added successfully')),
                              //   alignment: Alignment.bottomCenter,
                              //   animationDuration: const Duration(milliseconds: 300),
                              //   icon: const Icon(Icons.check),
                              //   primaryColor: Colors.green,
                              //   backgroundColor: Colors.white,
                              //   foregroundColor: Colors.black,
                              //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              //   margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              //   borderRadius: BorderRadius.circular(12),
                              //   boxShadow: const [
                              //     BoxShadow(
                              //       color: Color(0x07000000),
                              //       blurRadius: 16,
                              //       offset: Offset(0, 16),
                              //       spreadRadius: 0,
                              //     )
                              //   ],
                              //   applyBlurEffect: true,
                              //   callbacks: ToastificationCallbacks(
                              //     onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
                              //     onCloseButtonTap: (toastItem) => print('Toast ${toastItem.id} close button tapped'),
                              //     onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
                              //     onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
                              //   ),
                              // );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              width: MediaQuery.of(context).size.width * .05,
                              // width: MediaQuery.of(context).size.width * .15,

                              // height: 60,
                              decoration: BoxDecoration(
                                color: Colors.blue ,
                                border: Border.all(
                                    color:Colors.blue ,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                child: Text(
                                  'Add',
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
                        ],
                      ),

                    ],
                  ),

                  // Text("${challengesData['Label']}",
                  //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                  //         fontSize: 25,
                  //         color: Colors.black)),

                  SizedBox(height: 5,),


                  Text("${challengesData['Final_description']}",
                      maxLines: 3,
                      style: GoogleFonts.montserrat(
                          // fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black)),
                  SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Impact : ",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black)),
                      SizedBox(height: 2,),
                      Expanded(
                        child: Text("${challengesData['Impact']}",
                            maxLines: 3,
                            style: GoogleFonts.montserrat(
                                // fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black)),
                      ),
                    ],
                  ),

                  // Text("Tags :",
                  //     style: GoogleFonts.montserrat(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //         color: Colors.black)),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Wrap(
                  //     spacing: 10,
                  //     runSpacing: 5,
                  //     crossAxisAlignment: WrapCrossAlignment.start,
                  //     alignment: WrapAlignment.start,
                  //     runAlignment: WrapAlignment.start,
                  //     children: (challengesData['tags'] as List<dynamic>).map<Widget>((item){
                  //       print("solutionDataitem: $item");
                  //       print("solutionData['tags']: ${challengesData['tags']}");
                  //       return Container(
                  //         height: 35,
                  //         // width: 200,
                  //         margin: EdgeInsets.only(bottom: 2),
                  //         padding: EdgeInsets.all(6),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //             color: Colors.blue
                  //         ),
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text("${item}", style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 14
                  //             ),),
                  //           ],
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                  //
                  // SizedBox(height: 5,),
                  //
                  // Text("Category :",
                  //     style: GoogleFonts.montserrat(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //         color: Colors.black)),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Wrap(
                  //     spacing: 10,
                  //     runSpacing: 5,
                  //     crossAxisAlignment: WrapCrossAlignment.start,
                  //     alignment: WrapAlignment.start,
                  //     runAlignment: WrapAlignment.start,
                  //     children: (challengesData['Keywords'] as List<dynamic>).map<Widget>((item){
                  //       print("solutionDataitem: $item");
                  //       print("solutionData['Keywords']: ${challengesData['Keywords']}");
                  //       return Container(
                  //         height: 35,
                  //         // width: 200,
                  //         margin: EdgeInsets.only(bottom: 2),
                  //         padding: EdgeInsets.all(6),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //             color: Colors.blue
                  //         ),
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text("${item}", style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 14
                  //             ),),
                  //           ],
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // )
                ],
              );
            })

    );
  }

  Widget RecommendedSolutionsListTile(solutionsData, i, documentsss){
    return SingleChildScrollView(
        child: Consumer<UserAboutMEProvider>(
            builder: (c,userAboutMEProvider, _){
              // addKeywordProvider.getcategoryAndKeywords();
              // addKeywordProvider.newgetSource();
              // addKeywordProvider.getThriversStatus();
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text("CH0${challengesData['id']}.",
                      Text("${solutionsData['Name']}",
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black)),
                      // Checkbox(
                      //   activeColor: Colors.blue,
                      //   value: userAboutMEProvider.isRecommendedcCheckedForTileSoltuions(documentsss![i]), // Use the state from the provider
                      //   onChanged: (value) {
                      //     userAboutMEProvider.isRecommendedClickedBoxSolutions(value, i, documentsss![i] );
                      //   },
                      // ),
                      // InkWell(
                      //   onTap: (){
                      //     userAboutMEProvider.isRecommendedAddedSolutions(true, documentsss![i]);
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      //     width: MediaQuery.of(context).size.width * .05,
                      //     // width: MediaQuery.of(context).size.width * .15,
                      //
                      //     // height: 60,
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue ,
                      //       border: Border.all(
                      //           color:Colors.blue ,
                      //           width: 1.0),
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //     child: Center(
                      //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                      //       child: Text(
                      //         'Add',
                      //         style: GoogleFonts.montserrat(
                      //           textStyle:
                      //           Theme
                      //               .of(context)
                      //               .textTheme
                      //               .titleSmall,
                      //           fontWeight: FontWeight.bold,
                      //           color:Colors.white ,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Row(
                        children: [

                          IconButton(
                              onPressed: (){
                                NewViewDialog(solutionsData['Name'],solutionsData['Description'],solutionsData['Impact'],solutionsData['Final_description'], solutionsData['Keywords'],solutionsData['tags'],solutionsData['id'],solutionsData,userAboutMEProvider.isRecommendedSolutionsCheckedMap,userAboutMEProvider.isRecommendedAddedSolutions);
                              },
                              icon: Icon(Icons.info_outline, color: Colors.blue,)
                          ),
                          SizedBox(width: 8),

                          (userAboutMEProvider.isRecommendedSolutionsCheckedMap[solutionsData['id']] == true) ? Text(
                            'Added',
                            style: GoogleFonts.montserrat(
                              textStyle:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .titleSmall,
                              fontStyle: FontStyle.italic,
                              color:Colors.green ,
                            ),
                          ) : InkWell(
                            onTap: (){
                              userAboutMEProvider.isRecommendedAddedSolutions(true, documentsss![i]);
                              toastification.show(context: context,
                                  title: Text('${solutionsData['Name']} added successfully'),
                                  autoCloseDuration: Duration(milliseconds: 2500),
                                  alignment: Alignment.center,
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icon(Icons.check_circle, color: Colors.white,),
                                  animationDuration: Duration(milliseconds: 1000),
                                  showProgressBar: false
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              width: MediaQuery.of(context).size.width * .05,
                              // width: MediaQuery.of(context).size.width * .15,

                              // height: 60,
                              decoration: BoxDecoration(
                                color: Colors.blue ,
                                border: Border.all(
                                    color:Colors.blue ,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                child: Text(
                                  'Add',
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
                        ],
                      ),
                    ],
                  ),

                  // Text("${challengesData['Label']}",
                  //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                  //         fontSize: 25,
                  //         color: Colors.black)),

                  SizedBox(height: 5,),

                  Text("${solutionsData['Final_description']}",
                      maxLines: 3,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black)
                  ),

                  SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Impact : ",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black)),
                      SizedBox(height: 10,),
                      Expanded(
                        child: Text("${solutionsData['Impact']}",
                        // child: Text("hasduhsuiehdfuijhrediogotryou9ot6uy9it9puy9pt6y9phiopjfgiohguirhgv78tirinbtg8irty8iyivh5rthuiht89uyioveugrfuynvubotniugrufygtiburiufgnvrtguihirh",
                            maxLines: 3,
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black)),
                      ),
                    ],
                  ),

                  // Text("Tags :",
                  //     style: GoogleFonts.montserrat(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //         color: Colors.black)),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Wrap(
                  //     spacing: 10,
                  //     runSpacing: 5,
                  //     crossAxisAlignment: WrapCrossAlignment.start,
                  //     alignment: WrapAlignment.start,
                  //     runAlignment: WrapAlignment.start,
                  //     children: (challengesData['tags'] as List<dynamic>).map<Widget>((item){
                  //       print("solutionDataitem: $item");
                  //       print("solutionData['tags']: ${challengesData['tags']}");
                  //       return Container(
                  //         height: 35,
                  //         // width: 200,
                  //         margin: EdgeInsets.only(bottom: 2),
                  //         padding: EdgeInsets.all(6),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //             color: Colors.blue
                  //         ),
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text("${item}", style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 14
                  //             ),),
                  //           ],
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // ),
                  //
                  // SizedBox(height: 5,),
                  //
                  // Text("Category :",
                  //     style: GoogleFonts.montserrat(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 15,
                  //         color: Colors.black)),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Wrap(
                  //     spacing: 10,
                  //     runSpacing: 5,
                  //     crossAxisAlignment: WrapCrossAlignment.start,
                  //     alignment: WrapAlignment.start,
                  //     runAlignment: WrapAlignment.start,
                  //     children: (challengesData['Keywords'] as List<dynamic>).map<Widget>((item){
                  //       print("solutionDataitem: $item");
                  //       print("solutionData['Keywords']: ${challengesData['Keywords']}");
                  //       return Container(
                  //         height: 35,
                  //         // width: 200,
                  //         margin: EdgeInsets.only(bottom: 2),
                  //         padding: EdgeInsets.all(6),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(15),
                  //             color: Colors.blue
                  //         ),
                  //         child: Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text("${item}", style: TextStyle(
                  //                 fontWeight: FontWeight.w700,
                  //                 fontSize: 14
                  //             ),),
                  //           ],
                  //         ),
                  //       );
                  //     }).toList(),
                  //   ),
                  // )

                ],

              );
            })

    );
  }

  Widget AddChallengesPage(){
    var tags = ["Engineer", "Problem-solving", "Mechanical Engineering", "Automotive Industry", "Innovation", "Communication", "Organization", "Collaboration", "Teamwork", "Professional" "Growth"];
    var keywords = ["Mental & Emotional", "Physical", "Life","Workspace", "Travel", "Communication"];
    var keywordss = ["Workspace", "Travel", "Communication"];

    // print("AddChallengesPage: ${combinedResults}");

    // print("RelatedChallengesdocuments: ${RelatedChallengesdocuments}");

    // _userAboutMEProvider.getRelatedChallenges(tags, keywords);

    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          child:Consumer<UserAboutMEProvider>(
              builder: (c,userAboutMEProvider, _){
                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(height: 5,),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20.0),
                    //   child: Text("3. My Challenges",
                    //       style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                    //           fontSize: 30,
                    //           color: Colors.black)),
                    // ),
                    SizedBox(height: 10,),
                    // SizedBox(height: 10,),

                    TextField(
                      controller: RefineController,
                      maxLines: 3,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final lines = value.split('\n');

                          for (int i = 0; i < lines.length; i++) {
                            if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                              lines[i] = '• ' + lines[i];
                            }
                          }

                          RefineController.text = lines.join('\n');
                          RefineController.selection = TextSelection.fromPosition(
                            TextPosition(offset: RefineController.text.length),);
                          userAboutMEProvider.updateisRefinetextChange(false);
                          print("isRefinetextChange: ${userAboutMEProvider.isRefinetextChange}");
                        } else {
                          isInitialTyping = true; // Reset when the text field becomes empty
                          userAboutMEProvider.updateisRefinetextChange(false);
                          print("isRefinetextChange: ${userAboutMEProvider.isRefinetextChange}");
                        }
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
                        hintText: "Describe your challenges",
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

                    // (userAboutMEProvider.isRefinetextChange==true) ?
                    //
                    // InkWell(
                    //   onTap:() async {
                    //
                    //     print("Refine.text: ${RefineController.text}");
                    //
                    //     var defaulttext = "Generate related tags using this line in a one list with ',' :${RefineController.text}";
                    //     //
                    //     // var defaulttext =  q1+""+q2+" "+q3 + " where yyy is "+mycircumstancesController.text+" "+ MystrengthsController.text +" "+myOrganisationController.text;
                    //
                    //
                    //     var defaulttextq2 = "These are the category list: $resultString. Choose the categories that describe this text: $defaulttext.";
                    //
                    //     // print(defaulttext);
                    //     print("defaulttextq2 $defaulttextq2");
                    //
                    //     await getChatKeywordsResponse(defaulttext,defaulttextq2);
                    //     //
                    //     await userAboutMEProvider.getRelatedChallenges(generatedtags, generatedcategory);
                    //     // await userAboutMEProvider.getRelatedChallenges(tags, keywords);
                    //
                    //   },
                    //   child:Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    //     // width: MediaQuery.of(context).size.width * .2,
                    //     width: MediaQuery.of(context).size.width * .15,
                    //
                    //     // height: 60,
                    //     decoration: BoxDecoration(
                    //       color:Colors.blue ,
                    //       border: Border.all(
                    //           color:Colors.blue ,
                    //           width: 1.0),
                    //       borderRadius: BorderRadius.circular(15.0),
                    //     ),
                    //     child: Center(
                    //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                    //       child: Text(
                    //         'Search',
                    //         style: GoogleFonts.montserrat(
                    //           textStyle:
                    //           Theme
                    //               .of(context)
                    //               .textTheme
                    //               .titleSmall,
                    //           fontWeight: FontWeight.bold,
                    //           color:Colors.white ,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                    // :
                    InkWell(
                      onTap:() async {
                        var defaulttext = "Refine this sentence and give it in proper sentence";

                        defaulttext = defaulttext +"=" +" ${RefineController.text}";

                        getChatRefineResponse(defaulttext);


                      },
                      child:Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        // width: MediaQuery.of(context).size.width * .2,
                        width: MediaQuery.of(context).size.width * .15,

                        // height: 60,
                        decoration: BoxDecoration(
                          color:Colors.blue ,
                          border: Border.all(
                              color:Colors.blue ,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          // child: Icon(Icons.add, size: 30,color: Colors.white,),
                          child: Text(
                            'Search',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        // (userAboutMEProvider.combinedResults.isEmpty) ?
                        // Container(
                        //   // height: 350,
                        //   height: MediaQuery.of(context).size.height * .5,
                        //   width: MediaQuery.of(context).size.width * .46,
                        //
                        //   child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                        //           child: Text("Shortlist (${userAboutMEProvider.combinedResults.length}):",
                        //             overflow: TextOverflow.ellipsis,
                        //             style: GoogleFonts.montserrat(
                        //                 textStyle: Theme.of(context).textTheme.titleLarge,
                        //                 fontWeight: FontWeight.bold,
                        //                 color: Colors.black),
                        //           ),
                        //         ),
                        //         SizedBox(height: 6,),
                        //       ]
                        //   ),
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.black),
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        // ) :
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text("Suggested Challenges (${userAboutMEProvider.combinedResults.length}):",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.titleLarge,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(height: 6,),
                              (userAboutMEProvider.combinedResults.isEmpty) ?
                              Container(
                                // height: 350,
                                height: MediaQuery.of(context).size.height * .48,
                                width: MediaQuery.of(context).size.width ,

                                child: Center(
                                  child: Text("No Suggestions Yet",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineLarge,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),),),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ) :
                              Container(
                                height: MediaQuery.of(context).size.height * .48,
                                // width: MediaQuery.of(context).size.width ,
                                decoration: BoxDecoration(
                                  border: (userAboutMEProvider.combinedResults.isEmpty) ?  Border.all(color: Colors.black) : Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  // width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * .389,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: userAboutMEProvider.combinedResults.length,
                                    itemBuilder: (c, i) {
                                      // relatedSolutionlength = relatedChallenges?.length;
                                      // print("relatedSolutionlength: ${combinedResults.length}");
                                      RelatedChallengesdocuments = userAboutMEProvider.combinedResults.toList();
                                      // print("solutionData: ${RelatedChallengesdocuments}");
                              
                                      DocumentSnapshot document = RelatedChallengesdocuments[i];
                              
                                      return (userAboutMEProvider.isRecommendedChallengeCheckedMap[document['id']] == true) ? Container() : Container(
                                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                          padding: EdgeInsets.all(12),
                                          width: 470,
                                          // height: 300,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black26),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: RecommendedChallengesListTile(document, i, RelatedChallengesdocuments)
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 20,),

                        // Text("Recommended Challenges :",
                        //   style: GoogleFonts.montserrat(
                        //     textStyle: Theme.of(context).textTheme.titleLarge,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.black),
                        // ),

                        // SizedBox(height: 10,),
                        // Consumer<UserAboutMEProvider>(
                        //   builder: (context, userAboutMEProvider, _) {
                        //     // solutions = userAboutMEProvider.getSelectedSolutions();
                        //     print("challengesssss : ${userAboutMEProvider.challengess}");
                        //
                        //     return (userAboutMEProvider.challengess.isEmpty) ?
                        //     Container(
                        //       height: 300,
                        //       child: Center(child: Text("Recommended Challenges", style:
                        //       GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.displaySmall,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.black),),),
                        //       decoration: BoxDecoration(
                        //         border: Border.all(color: Colors.black),
                        //         borderRadius: BorderRadius.circular(20),
                        //       ),
                        //     ) : Container(
                        //       height: 300,
                        //       decoration: BoxDecoration(
                        //         border: Border.all(color: Colors.black),
                        //         borderRadius: BorderRadius.circular(20),
                        //       ),
                        //       width: MediaQuery.of(context).size.width,
                        //       child:SingleChildScrollView(
                        //         child: DataTable(
                        //           // decoration: BoxDecoration(
                        //           //     border: Border.all(color: Colors.black),
                        //           //     borderRadius: BorderRadius.circular(15)
                        //           // ),
                        //           // horizontalMargin: 10,
                        //           dataRowMaxHeight:60 ,
                        //           headingTextStyle: GoogleFonts.montserrat(
                        //               textStyle: Theme.of(context).textTheme.titleMedium,
                        //               fontWeight: FontWeight.w500,
                        //               color: Colors.black),
                        //           columnSpacing: 15,
                        //           columns: [
                        //             DataColumn(
                        //                 label: Container(
                        //                     width: 60,
                        //                     child: Center(
                        //                         child: Text('ID')
                        //                     )
                        //                 )
                        //             ),
                        //             DataColumn(
                        //               label: Container(
                        //                 width: 180,
                        //                 child: Center(
                        //                     child: Text('Label',)
                        //                 ),
                        //               ),
                        //             ),
                        //             DataColumn(
                        //               label: Container(
                        //                 // width: 400,
                        //                   child: Center(child:
                        //                   Text('Description')
                        //                   )
                        //               ),
                        //             ),
                        //             DataColumn(
                        //                 label: Container(
                        //                   // width: 140,
                        //                     child: Center(child: Text('Confirm/Cancel')
                        //                     )
                        //                 )
                        //             ),
                        //
                        //             // DataColumn(
                        //             //     label: Center(
                        //             //         child: Text('Attachments')
                        //             //     )
                        //             // ),
                        //             // DataColumn(
                        //             //     label: Container(
                        //             //         width: 120,
                        //             //         child: Center(child: Text('Provider')
                        //             //         )
                        //             //     )
                        //             // ),
                        //             // DataColumn(label: Container(
                        //             //     width: 60,
                        //             //     child: Center(child: Text('In Place')
                        //             //     )
                        //             // )
                        //             // ),
                        //             // DataColumn(label: Container(
                        //             //     width: 140,
                        //             //     child: Center(child: Text('Priority')
                        //             //     )
                        //             // )
                        //             // ),
                        //           ],
                        //           rows: userAboutMEProvider.challengess.map((challenge) {
                        //             int index = userAboutMEProvider.challengess.indexOf(challenge);
                        //
                        //
                        //             // print(jsonString);
                        //
                        //             return DataRow(
                        //               cells: [
                        //                 DataCell(
                        //                     Container(
                        //                         width: 60,
                        //                         child: Center(
                        //                           child: Text(challenge.id, style: GoogleFonts.montserrat(
                        //                               textStyle: Theme.of(context).textTheme.bodySmall,
                        //                               fontWeight: FontWeight.w600,
                        //                               color: Colors.black),),
                        //                         ))),
                        //                 DataCell(
                        //                     Container(
                        //                         width: 180,
                        //                         child: Center(
                        //                           child: Text(challenge.label,
                        //                               overflow: TextOverflow.ellipsis,maxLines: 2,
                        //                               style: GoogleFonts.montserrat(
                        //                                   textStyle: Theme.of(context).textTheme.bodySmall,
                        //                                   fontWeight: FontWeight.w600,
                        //                                   color: Colors.black)
                        //                           ),
                        //                         ))),
                        //                 DataCell(
                        //                     Container(
                        //                       // width: 400,
                        //                         child: Center(
                        //                           child: Text(challenge.description,
                        //                               overflow: TextOverflow.ellipsis,maxLines: 2,
                        //                               style: GoogleFonts.montserrat(
                        //                                   textStyle: Theme.of(context).textTheme.bodySmall,
                        //                                   fontWeight: FontWeight.w600,
                        //                                   color: Colors.black)
                        //                           ),
                        //                         ))),
                        //                 DataCell(
                        //                   Container(
                        //                     // height: 100,
                        //                     margin: EdgeInsets.all(5),
                        //                     // width: 140,
                        //                     child: Center(
                        //                       // child: (userAboutMEProvider.isConfirm==true) ?
                        //                         child: (challenge.isConfirmed==true) ?
                        //                         Text('Confirmed',
                        //                           style: TextStyle(color: Colors.green),
                        //                         )
                        //                             :
                        //                         Row(
                        //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //                           children: [
                        //                             IconButton(
                        //                               onPressed: () {
                        //                                 showconfirmrDialogBox(challenge.id, challenge.label,challenge.description, challenge.Source, challenge.Status,challenge.tags,challenge.CreatedBy,
                        //                                     challenge.CreatedDate,challenge.ModifiedBy,challenge.ModifiedDate,challenge.OriginalDescription,challenge.Impact,challenge.Final_description,
                        //                                     challenge.Category,challenge.Keywords,challenge.PotentialStrengths,challenge.HiddenStrengths, index,userAboutMEProvider.challengess);
                        //                                 print("solution.isConfirmed: ${challenge.isConfirmed}");
                        //                               },
                        //                               icon: Icon(Icons.check, color: Colors.green),
                        //                             ),
                        //                             IconButton(
                        //                               onPressed: () {
                        //                                 userAboutMEProvider.removeChallenge(index);
                        //                               },
                        //                               icon: Icon(Icons.close, color: Colors.red),
                        //                             )
                        //                             //      :
                        //
                        //
                        //                           ],
                        //                         )
                        //                     ),
                        //                   ),
                        //                 ),
                        //
                        //                 // DataCell(
                        //                 //   Container(
                        //                 //     // height: 100,
                        //                 //     margin: EdgeInsets.all(5),
                        //                 //     width: 140,
                        //                 //     child: Center(
                        //                 //       child: TextField(
                        //                 //         maxLines: 4,
                        //                 //         controller: TextEditingController(text: solution.notes),
                        //                 //         onChanged: (value) {
                        //                 //         },
                        //                 //         style: GoogleFonts.montserrat(
                        //                 //             textStyle: Theme
                        //                 //                 .of(context)
                        //                 //                 .textTheme
                        //                 //                 .bodySmall,
                        //                 //             fontWeight: FontWeight.w400,
                        //                 //             color: Colors.black),
                        //                 //         decoration: InputDecoration(
                        //                 //           contentPadding: EdgeInsets.all(10),
                        //                 //           // labelText: "Name",
                        //                 //           hintText: "Notes",
                        //                 //           errorStyle: GoogleFonts.montserrat(
                        //                 //               textStyle: Theme
                        //                 //                   .of(context)
                        //                 //                   .textTheme
                        //                 //                   .bodyLarge,
                        //                 //               fontWeight: FontWeight.w400,
                        //                 //               color: Colors.redAccent),
                        //                 //           focusedBorder: OutlineInputBorder(
                        //                 //               borderSide: BorderSide(color: Colors.black),
                        //                 //               borderRadius: BorderRadius.circular(5)),
                        //                 //           border: OutlineInputBorder(
                        //                 //               borderSide: BorderSide(color: Colors.black12),
                        //                 //               borderRadius: BorderRadius.circular(5)),
                        //                 //           labelStyle: GoogleFonts.montserrat(
                        //                 //               textStyle: Theme
                        //                 //                   .of(context)
                        //                 //                   .textTheme
                        //                 //                   .bodyLarge,
                        //                 //               fontWeight: FontWeight.w400,
                        //                 //               color: Colors.black),
                        //                 //         ),
                        //                 //       ),
                        //                 //     ),
                        //                 //   ),), // Empty cell for Notes
                        //
                        //                 // DataCell(
                        //                 //     Container(
                        //                 //       child: IconButton(
                        //                 //         onPressed: (){
                        //                 //
                        //                 //         },
                        //                 //         icon: Icon(Icons.add),
                        //                 //       ),
                        //                 //     )),  // Empty cell for Attachments
                        //                 // DataCell(
                        //                 //   Container(
                        //                 //     width: 120,
                        //                 //     child: DropdownButton(
                        //                 //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                        //                 //       // value: selectedProvider,
                        //                 //       value: selectedProviderValues[index],
                        //                 //       onChanged: (newValue) {
                        //                 //         // userAboutMEProvider.updatevalue(selectedProviderValues[index], newValue.toString());
                        //                 //         setState(() {
                        //                 //           // selectedProvider = newValue.toString();
                        //                 //           selectedProviderValues[index] = newValue.toString();
                        //                 //         });
                        //                 //       },
                        //                 //       items: provider.map((option) {
                        //                 //         return DropdownMenuItem(
                        //                 //           value: option,
                        //                 //           child: Text(option, overflow: TextOverflow.ellipsis,maxLines: 2,),
                        //                 //         );
                        //                 //       }).toList(),
                        //                 //     ),
                        //                 //   ),
                        //                 // ),  // Empty cell for Provider
                        //                 // DataCell(
                        //                 //   Container(
                        //                 //     width: 60,
                        //                 //     child: DropdownButton(
                        //                 //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                        //                 //       value: selectedInPlaceValues[index],
                        //                 //       // value: selectedInPlace,
                        //                 //       onChanged: (newValue) {
                        //                 //         setState(() {
                        //                 //           selectedInPlaceValues[index] = newValue.toString();
                        //                 //           // selectedInPlace = newValue.toString();
                        //                 //         });
                        //                 //       },
                        //                 //       items: InPlace.map((option) {
                        //                 //         return DropdownMenuItem(
                        //                 //           value: option,
                        //                 //           child: Text(option),
                        //                 //         );
                        //                 //       }).toList(),
                        //                 //     ),
                        //                 //   ),
                        //                 // ),  // Empty cell for In Place
                        //                 // DataCell(
                        //                 //   Container(
                        //                 //     width: 140,
                        //                 //     // child:  DropdownButton(
                        //                 //     //   style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                        //                 //     //   value: selectedPriorityValues[index],
                        //                 //     //   // value: selectedPriority,
                        //                 //     //   onChanged: (newValue) {
                        //                 //     //     setState(() {
                        //                 //     //       selectedPriorityValues[index] = newValue.toString();
                        //                 //     //
                        //                 //     //       print("$index: ${selectedPriorityValues[index]} ");
                        //                 //     //       // selectedPriority = newValue.toString();
                        //                 //     //     });
                        //                 //     //   },
                        //                 //     //   items: Priority.map((option) {
                        //                 //     //     return DropdownMenuItem(
                        //                 //     //       value: option,
                        //                 //     //       child: Text(option, overflow: TextOverflow.ellipsis,),
                        //                 //     //     );
                        //                 //     //   }).toList(),
                        //                 //     // ),
                        //                 //     child:  DropdownButtonFormField(
                        //                 //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                        //                 //       decoration: InputDecoration(
                        //                 //
                        //                 //         hintText: 'Priority',
                        //                 //       ),
                        //                 //       value: userAboutMEProvider.selectedPriorityValues[index],
                        //                 //       onChanged: (newValue) {
                        //                 //         userAboutMEProvider.updateSelectedPriorityValues(index, newValue);
                        //                 //         print('priority ${index} and ${userAboutMEProvider.selectedPriorityValues}');
                        //                 //       },
                        //                 //       icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
                        //                 //       items: selectedPriorityValues.map<DropdownMenuItem<String>>((String value) {
                        //                 //         // String displayedText = value;
                        //                 //         // if (displayedText.length > 5) {
                        //                 //         //   // Limit the displayed text to 10 characters and add ellipsis
                        //                 //         //   displayedText = displayedText.substring(0, 5) + '..';
                        //                 //         // }
                        //                 //         return DropdownMenuItem<String>(
                        //                 //           value: value,
                        //                 //           child: Text(value, overflow: TextOverflow.ellipsis,),
                        //                 //         );
                        //                 //       }).toList(),
                        //                 //     ),
                        //                 //   ),
                        //                 // ),  // Empty cell for Priority
                        //
                        //               ],
                        //             );
                        //           }).toList(),
                        //         ),
                        //       ),
                        //
                        //     );
                        //   },
                        // ),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text("Basket of challenges (${userAboutMEProvider.challengess.length}):",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.titleLarge,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Consumer<UserAboutMEProvider>(
                                builder: (context, userAboutMEProvider, _) {
                                  // print("challengesssss : ${userAboutMEProvider.challengess}");


                                  return (userAboutMEProvider.challengess.isEmpty) ?
                                  Container(
                                    // height: 350,
                                    height: MediaQuery.of(context).size.height * .48,
                                    width: MediaQuery.of(context).size.width ,

                                    child: Center(
                                      child: Text("No Challenges Added Yet",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineLarge,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),),),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ) : Container(
                                    // height: 350,
                                    height: MediaQuery.of(context).size.height * .48,
                                    // width: MediaQuery.of(context).size.width * .46,

                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    // width: MediaQuery.of(context).size.width,
                                    child:SingleChildScrollView(
                                      child: DataTable(
                                        dataRowMaxHeight:60 ,
                                        headingTextStyle: GoogleFonts.montserrat(
                                            textStyle: Theme.of(context).textTheme.titleMedium,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                        // border: TableBorder.all(color: Colors.black),
                                        columnSpacing: 15,
                                        columns: [

                                          // DataColumn(
                                          //   label: Container(
                                          //     // color: Colors.blue,
                                          //     // width: 60,
                                          //     child: Text('Id.',textAlign: TextAlign.center,),
                                          //   ),
                                          //
                                          // ),
                                          DataColumn(
                                            label: Container(
                                              // width: 180,
                                              child: Text('Title',),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Container(
                                              // width: 250,
                                              child: Text('Impact',),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Container(
                                              // width: 400,
                                                child: Text('Description')
                                            ),
                                          ),
                                          DataColumn(
                                              label: Container(
                                                // width: 140,
                                                  child: Text('Confirm/Cancel')
                                              )
                                          ),
                                        ],
                                        rows: userAboutMEProvider.challengess.map((challenge) {
                                          int index = userAboutMEProvider.challengess.indexOf(challenge);
                                          // print(jsonString);
                                          return DataRow(
                                            cells: [
                                              // DataCell(
                                              //     Container(
                                              //       // width: 60,
                                              //       //   child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                              //            child: Text("${challenge.id}.", style: GoogleFonts.montserrat(
                                              //             textStyle: Theme.of(context).textTheme.bodySmall,
                                              //             fontWeight: FontWeight.w600,
                                              //             color: Colors.black),))
                                              // ),
                                              DataCell(
                                                  Container(
                                                    child: Text(challenge.label,
                                                        overflow: TextOverflow.ellipsis,maxLines: 2,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: Theme.of(context).textTheme.bodySmall,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black)
                                                    ),
                                                  )),
                                              DataCell(
                                                  Container(
                                                    // width: 250,
                                                      child: Text(challenge.Impact,
                                                          overflow: TextOverflow.ellipsis,maxLines: 2,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: Theme.of(context).textTheme.bodySmall,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black)
                                                      ))),
                                              DataCell(
                                                  Container(
                                                    // width: 400,
                                                      child: Text(challenge.Final_description,
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
                                                  // width: 140,
                                                  child: (challenge.isConfirmed==true) ?
                                                  Text('Confirmed',
                                                    style: TextStyle(color: Colors.green),
                                                  )
                                                      :
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          // (challenge.Keywords.isEmpty || challenge.tags.isEmpty) ? toastification.show(context: context,
                                                          // title: Text('Cannot View this Challenge'),
                                                          // autoCloseDuration: Duration(milliseconds: 2500),
                                                          //   alignment: Alignment.center,
                                                          //   backgroundColor: Colors.blue,
                                                          //   foregroundColor: Colors.white,
                                                          //   animationDuration: Duration(milliseconds: 1000),
                                                          //   showProgressBar: false
                                                          // )
                                                          // :
                                                          NewViewDialog(challenge.label,challenge.description,challenge.Impact,challenge.Final_description,
                                                              challenge.Keywords,challenge.tags,challenge.id, challenge, userAboutMEProvider.isRecommendedChallengeCheckedMap,userAboutMEProvider.isRecommendedAddedChallenge);
                                                          print("challenge.isConfirmed: ${challenge.isConfirmed}");
                                                        },
                                                        icon: Icon(Icons.visibility, color: Colors.blue),
                                                      ),
                                                      SizedBox(width: 6,),
                                                      IconButton(
                                                        onPressed: () {
                                                          showconfirmChallengeDialogBox(challenge.id, challenge.label,challenge.description, challenge.Source, challenge.Status,challenge.tags,challenge.CreatedBy,
                                                              challenge.CreatedDate,challenge.ModifiedBy,challenge.ModifiedDate,challenge.OriginalDescription,challenge.Impact,challenge.Final_description,
                                                              challenge.Category,challenge.Keywords,challenge.PotentialStrengths,challenge.HiddenStrengths, index,userAboutMEProvider.challengess,challenge.notes);
                                                          print("challenge.isConfirmed: ${challenge.isConfirmed}");
                                                        },
                                                        icon: Icon(Icons.check, color: Colors.green),
                                                      ),
                                                      SizedBox(width: 6,),
                                                      IconButton(
                                                        onPressed: () {
                                                          userAboutMEProvider.removeChallenge(index,challenge);
                                                          // userAboutMEProvider.removeRecommendedChallenge(challenge.id);
                                                          // userAboutMEProvider.removeRecommendedChallenge(challenge.id);
                                                          // userAboutMEProvider.isRecommendedcCheckedForTileChallenge(index);
                                                          // userAboutMEProvider.removeRecommendedChallenge(index);
                                                          // userAboutMEProvider.isRecommendedChallengeCheckedMap[index] = false;;
                                                        },
                                                        icon: Icon(Icons.close, color: Colors.red),
                                                      )
                                                      //      :


                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),

                                  );
                                },
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),


                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // InkWell(
                        //   onTap: (){
                        //     // page.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                        //     _navigateToTab(1);
                        //     // Navigator.pop(context);
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(horizontal: 15),
                        //     width: MediaQuery.of(context).size.width * .3,
                        //     height: 60,
                        //     decoration: BoxDecoration(
                        //       //color: Colors.white,
                        //       border: Border.all(
                        //         //color:primaryColorOfApp ,
                        //           width: 1.0),
                        //       borderRadius: BorderRadius.circular(15.0),
                        //     ),
                        //     child: Center(
                        //       child: Text(
                        //         'Back',
                        //         style: GoogleFonts.montserrat(
                        //           textStyle:
                        //           Theme
                        //               .of(context)
                        //               .textTheme
                        //               .titleSmall,
                        //           fontWeight: FontWeight.bold,
                        //           //color: primaryColorOfApp
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap:(){
                                showChallengesSelector();
                              },
                              child:Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                // width: MediaQuery.of(context).size.width * .2,
                                width: MediaQuery.of(context).size.width * .22,

                                // height: 60,
                                decoration: BoxDecoration(
                                  color:Colors.blue ,
                                  border: Border.all(
                                      color:Colors.blue ,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Center(
                                  // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                  child: Text(
                                    'Browse additional challenges',
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
                            SizedBox(width: 15,),
                            InkWell(
                              onTap:(){
                                showAddChallengesDialogBox();
                              },
                              child:Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                // width: MediaQuery.of(context).size.width * .2,
                                width: MediaQuery.of(context).size.width * .15,

                                // height: 60,
                                decoration: BoxDecoration(
                                  // color:Colors.blue ,
                                  border: Border.all(
                                      color:Colors.blue ,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Center(
                                  // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                  child: Text(
                                    'Create My Own',
                                    style: GoogleFonts.montserrat(
                                      textStyle:
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .titleSmall,
                                      fontWeight: FontWeight.bold,
                                      color:Colors.blue ,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15,),

                          ],
                        ),
                        SizedBox(height: 5, width: 5,),
                        InkWell(
                          onTap: () async{

                            await userAboutMEProvider.getRelatedSolutions(generatedsolutionstags, generatedsolutionscategory);
                            // await userAboutMEProvider.getRelatedSolutions(tags, keywordss);

                            // await page.animateToPage(3, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);

                            Map<String, dynamic> AboutMEDatas = {

                              'Challenges': challengesList,

                            };

                            String solutionJson = json.encode(AboutMEDatas);
                            print(solutionJson);

                            ProgressDialog.show(context, "Saving", Icons.save);
                            await ApiRepository().updateAboutMe(AboutMEDatas,documentId);
                            ProgressDialog.hide();

                            await _navigateToTab(3);

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width: MediaQuery.of(context).size.width * .2,
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
                                'Save and Next',
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
                        ),
                      ],
                    ),
                  ],
                );
              })
      ),
    );
  }

  Widget AddSolutionsPage(){
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
          child:Consumer<UserAboutMEProvider>(
              builder: (c,userAboutMEProvider, _){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: 5,),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20.0),
                    //   child: Text("4. My Solutions",
                    //       style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                    //           fontSize: 30,
                    //           color: Colors.black)),
                    // ),

                    SizedBox(height: 10,),


                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                child: Text("Suggested Solutions (${userAboutMEProvider.combinedSolutionsResults.length}):",
                                  style: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.titleLarge,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(height: 10,),
                              (userAboutMEProvider.combinedSolutionsResults.isEmpty) ?
                              Container(
                                // height: 350,
                                height: MediaQuery.of(context).size.height * .6,
                                width: MediaQuery.of(context).size.width ,

                                child: Center(
                                  child: Text("No Suggestions Yet",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineLarge,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),),),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ) :
                              Container(
                                height: MediaQuery.of(context).size.height * .6,
                                // width: MediaQuery.of(context).size.width * .46,
                                decoration: BoxDecoration(
                                  border: (userAboutMEProvider.combinedSolutionsResults.isEmpty) ?  Border.all(color: Colors.black) : Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * .5,
                                  // width: MediaQuery.of(context).size.width * .46,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: userAboutMEProvider.combinedSolutionsResults.length,
                                    itemBuilder: (c, i) {
                                      // relatedSolutionlength = relatedChallenges?.length;
                                      // print("relatedSolutionlength: ${combinedResults.length}");
                                      RelatedSolutionsdocuments = userAboutMEProvider.combinedSolutionsResults.toList();
                                      // print("solutionData: ${RelatedChallengesdocuments}");

                                      DocumentSnapshot document = RelatedSolutionsdocuments[i];

                                      return (userAboutMEProvider.isRecommendedSolutionsCheckedMap[document['id']] == true) ? Container() :  Container(
                                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                          padding: EdgeInsets.all(12),
                                          width: 470,
                                          // height: 300,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black26),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: RecommendedSolutionsListTile(document, i, RelatedSolutionsdocuments)
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 20,),

                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                child: Text("Basket of Solutions (${userAboutMEProvider.editsolutionss.length}): ",
                                  style: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.titleLarge,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
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
                              
                                  return (userAboutMEProvider.solutionss.isEmpty) ?
                                  Container(
                                    height: MediaQuery.of(context).size.height * .6,
                                    // width: MediaQuery.of(context).size.width * .46,
                                    child: Center(child: Text("No Solutions Added Yet", style:
                                    GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.displaySmall,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),),),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ) : Container(
                                    height: MediaQuery.of(context).size.height * .6,
                                    // width: MediaQuery.of(context).size.width * .46,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    // width: MediaQuery.of(context).size.width,
                                    child:SingleChildScrollView(
                                      child: DataTable(
                                        dataRowMaxHeight:60 ,
                                        headingTextStyle: GoogleFonts.montserrat(
                                            textStyle: Theme.of(context).textTheme.titleMedium,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                        columnSpacing: 15,
                                        columns: [
                                          // DataColumn(
                                          //   label: Container(
                                          //     // color: Colors.blue,
                                          //     // width: 60,
                                          //     child: Text('Id.',textAlign: TextAlign.center,),
                                          //   ),
                                          //
                                          // ),
                                          DataColumn(
                                            label: Container(
                                              // width: 180,
                                              child: Text('Label',),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text('Impact',),
                                          ),
                                          DataColumn(
                                            label: Container(
                                              // width: 400,
                                                child: Text('Description')
                                            ),
                                          ),
                                          DataColumn(
                                              label: Container(
                                                // width: 140,
                                                  child: Text('Confirm/Cancel')
                                              )
                                          ),
                              
                              
                                        ],
                              
                                        rows: userAboutMEProvider.solutionss.map((solution) {
                                          int index = userAboutMEProvider.solutionss.indexOf(solution);
                              
                              
                                          // print(jsonString);
                              
                                          return DataRow(
                                            cells: [
                                              // DataCell(
                                              //     Container(
                                              //       // width: 60,
                                              //       child: Text("${solution.id}.", style: GoogleFonts.montserrat(
                                              //         // child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                              //             textStyle: Theme.of(context).textTheme.bodySmall,
                                              //             fontWeight: FontWeight.w600,
                                              //             color: Colors.black),))),
                                              DataCell(
                                                  Container(
                                                    // width: 180,
                                                      child: Text(solution.label,
                                                          overflow: TextOverflow.ellipsis,maxLines: 2,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: Theme.of(context).textTheme.bodySmall,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black)
                                                      ))),
                                              DataCell(
                                                  Container(
                                                    // width: 400,
                                                      child: Text(solution.Impact,
                                                          overflow: TextOverflow.ellipsis,maxLines: 2,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: Theme.of(context).textTheme.bodySmall,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black)
                                                      ))),
                                              DataCell(
                                                  Container(
                                                    // width: 400,
                                                      child: Text(solution.Final_description,
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
                                                  // width: 140,
                                                  child: (solution.isConfirmed==true) ?
                                                  Text('Confirmed',
                                                    style: TextStyle(color: Colors.green),
                                                  )
                                                      :
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                         NewViewDialog(solution.label, solution.description, solution.Impact, solution.Final_description, solution.Keywords, solution.tags, solution.id,solution,userAboutMEProvider.isRecommendedSolutionsCheckedMap,userAboutMEProvider.isRecommendedAddedSolutions);
                                                        },
                                                        icon: Icon(Icons.visibility, color: Colors.blue),
                                                      ),
                                                      SizedBox(width: 15,),
                                                      IconButton(
                                                        onPressed: () {
                                                          showconfirmSolutionsDialogBox(solution.id, solution.label,solution.description, solution.Source, solution.Status,solution.tags,solution.CreatedBy,
                                                              solution.CreatedDate,solution.ModifiedBy,solution.ModifiedDate,solution.OriginalDescription,solution.Impact,solution.Final_description,
                                                              solution.Category,solution.Keywords,"","", index,userAboutMEProvider.solutionss,solution.notes);
                                                          print("solution.isConfirmed: ${solution.isConfirmed}");
                                                        },
                                                        icon: Icon(Icons.check, color: Colors.green),
                                                      ),
                                                      SizedBox(width: 15,),
                                                      IconButton(
                                                        onPressed: () {
                                                          userAboutMEProvider.removeSolution(index,solution);
                                                        },
                                                        icon: Icon(Icons.close, color: Colors.red),
                                                      )
                                                      //      :
                              
                              
                                                    ],
                                                  ),
                                                ),
                                              ),
                              
                                              // DataCell(
                                              //   Container(
                                              //     // height: 100,
                                              //     margin: EdgeInsets.all(5),
                                              //     width: 140,
                                              //     child: Center(
                                              //       child: TextField(
                                              //         maxLines: 4,
                                              //         controller: TextEditingController(text: solution.notes),
                                              //         onChanged: (value) {
                                              //         },
                                              //         style: GoogleFonts.montserrat(
                                              //             textStyle: Theme
                                              //                 .of(context)
                                              //                 .textTheme
                                              //                 .bodySmall,
                                              //             fontWeight: FontWeight.w400,
                                              //             color: Colors.black),
                                              //         decoration: InputDecoration(
                                              //           contentPadding: EdgeInsets.all(10),
                                              //           // labelText: "Name",
                                              //           hintText: "Notes",
                                              //           errorStyle: GoogleFonts.montserrat(
                                              //               textStyle: Theme
                                              //                   .of(context)
                                              //                   .textTheme
                                              //                   .bodyLarge,
                                              //               fontWeight: FontWeight.w400,
                                              //               color: Colors.redAccent),
                                              //           focusedBorder: OutlineInputBorder(
                                              //               borderSide: BorderSide(color: Colors.black),
                                              //               borderRadius: BorderRadius.circular(5)),
                                              //           border: OutlineInputBorder(
                                              //               borderSide: BorderSide(color: Colors.black12),
                                              //               borderRadius: BorderRadius.circular(5)),
                                              //           labelStyle: GoogleFonts.montserrat(
                                              //               textStyle: Theme
                                              //                   .of(context)
                                              //                   .textTheme
                                              //                   .bodyLarge,
                                              //               fontWeight: FontWeight.w400,
                                              //               color: Colors.black),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),), // Empty cell for Notes
                              
                                              // DataCell(
                                              //     Container(
                                              //       child: IconButton(
                                              //         onPressed: (){
                                              //
                                              //         },
                                              //         icon: Icon(Icons.add),
                                              //       ),
                                              //     )),  // Empty cell for Attachments
                                              // DataCell(
                                              //   Container(
                                              //     width: 120,
                                              //     child: DropdownButton(
                                              //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                              //       // value: selectedProvider,
                                              //       value: selectedProviderValues[index],
                                              //       onChanged: (newValue) {
                                              //         // userAboutMEProvider.updatevalue(selectedProviderValues[index], newValue.toString());
                                              //         setState(() {
                                              //           // selectedProvider = newValue.toString();
                                              //           selectedProviderValues[index] = newValue.toString();
                                              //         });
                                              //       },
                                              //       items: provider.map((option) {
                                              //         return DropdownMenuItem(
                                              //           value: option,
                                              //           child: Text(option, overflow: TextOverflow.ellipsis,maxLines: 2,),
                                              //         );
                                              //       }).toList(),
                                              //     ),
                                              //   ),
                                              // ),  // Empty cell for Provider
                                              // DataCell(
                                              //   Container(
                                              //     width: 60,
                                              //     child: DropdownButton(
                                              //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                              //       value: selectedInPlaceValues[index],
                                              //       // value: selectedInPlace,
                                              //       onChanged: (newValue) {
                                              //         setState(() {
                                              //           selectedInPlaceValues[index] = newValue.toString();
                                              //           // selectedInPlace = newValue.toString();
                                              //         });
                                              //       },
                                              //       items: InPlace.map((option) {
                                              //         return DropdownMenuItem(
                                              //           value: option,
                                              //           child: Text(option),
                                              //         );
                                              //       }).toList(),
                                              //     ),
                                              //   ),
                                              // ),  // Empty cell for In Place
                                              // DataCell(
                                              //   Container(
                                              //     width: 140,
                                              //     // child:  DropdownButton(
                                              //     //   style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                              //     //   value: selectedPriorityValues[index],
                                              //     //   // value: selectedPriority,
                                              //     //   onChanged: (newValue) {
                                              //     //     setState(() {
                                              //     //       selectedPriorityValues[index] = newValue.toString();
                                              //     //
                                              //     //       print("$index: ${selectedPriorityValues[index]} ");
                                              //     //       // selectedPriority = newValue.toString();
                                              //     //     });
                                              //     //   },
                                              //     //   items: Priority.map((option) {
                                              //     //     return DropdownMenuItem(
                                              //     //       value: option,
                                              //     //       child: Text(option, overflow: TextOverflow.ellipsis,),
                                              //     //     );
                                              //     //   }).toList(),
                                              //     // ),
                                              //     child:  DropdownButtonFormField(
                                              //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                              //       decoration: InputDecoration(
                                              //
                                              //         hintText: 'Priority',
                                              //       ),
                                              //       value: userAboutMEProvider.selectedPriorityValues[index],
                                              //       onChanged: (newValue) {
                                              //         userAboutMEProvider.updateSelectedPriorityValues(index, newValue);
                                              //         print('priority ${index} and ${userAboutMEProvider.selectedPriorityValues}');
                                              //       },
                                              //       icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
                                              //       items: selectedPriorityValues.map<DropdownMenuItem<String>>((String value) {
                                              //         // String displayedText = value;
                                              //         // if (displayedText.length > 5) {
                                              //         //   // Limit the displayed text to 10 characters and add ellipsis
                                              //         //   displayedText = displayedText.substring(0, 5) + '..';
                                              //         // }
                                              //         return DropdownMenuItem<String>(
                                              //           value: value,
                                              //           child: Text(value, overflow: TextOverflow.ellipsis,),
                                              //         );
                                              //       }).toList(),
                                              //     ),
                                              //   ),
                                              // ),  // Empty cell for Priority
                              
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                              
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // InkWell(
                        //   onTap: (){
                        //     // page.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                        //     _navigateToTab(2);
                        //     // Navigator.pop(context);
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(horizontal: 15),
                        //     width: MediaQuery.of(context).size.width * .3,
                        //     height: 60,
                        //     decoration: BoxDecoration(
                        //       //color: Colors.white,
                        //       border: Border.all(
                        //         //color:primaryColorOfApp ,
                        //           width: 1.0),
                        //       borderRadius: BorderRadius.circular(15.0),
                        //     ),
                        //     child: Center(
                        //       child: Text(
                        //         'Back',
                        //         style: GoogleFonts.montserrat(
                        //           textStyle:
                        //           Theme
                        //               .of(context)
                        //               .textTheme
                        //               .titleSmall,
                        //           fontWeight: FontWeight.bold,
                        //           //color: primaryColorOfApp
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap:(){
                                showSolutionSelectors();
                              },
                              child:Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                // width: MediaQuery.of(context).size.width * .2,
                                width: MediaQuery.of(context).size.width * .22,

                                // height: 60,
                                decoration: BoxDecoration(
                                  color:Colors.blue ,
                                  border: Border.all(
                                      color:Colors.blue ,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Center(
                                  // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                  child: Text(
                                    'Browse additional solutions',
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
                            SizedBox(width: 15,),
                            InkWell(
                              onTap:(){
                                showAddThriverDialogBox();
                              },
                              child:Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                // width: MediaQuery.of(context).size.width * .2,
                                width: MediaQuery.of(context).size.width * .15,

                                // height: 60,
                                decoration: BoxDecoration(
                                  // color:Colors.blue ,
                                  border: Border.all(
                                      color:Colors.blue ,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Center(
                                  // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                  child: Text(
                                    'Create My Own',
                                    style: GoogleFonts.montserrat(
                                      textStyle:
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .titleSmall,
                                      fontWeight: FontWeight.bold,
                                      color:Colors.blue ,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15,),

                          ],
                        ),

                        SizedBox(height: 5, width: 5,),
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                // page.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                                _navigateToTab(5);

                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                width: MediaQuery.of(context).size.width * .2,
                                height: 60,
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  border: Border.all(
                                      color: Colors.blue,
                                      width: 2.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Center(
                                  child: Text(
                                    'Preview',
                                    style: GoogleFonts.montserrat(
                                        textStyle: Theme.of(context).textTheme.titleSmall,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5, width: 5,),
                            InkWell(
                              onTap: () async {
                                // page.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                                ///
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     InkWell(
                                //       onTap: (){
                                //         selectedEmail = null;
                                //         nameController.clear();
                                //         employerController.clear();
                                //         divisionOrSectionController.clear();
                                //         RoleController.clear();
                                //         LocationController.clear();
                                //         EmployeeNumberController.clear();
                                //         LineManagerController.clear();
                                //         mycircumstancesController.clear();
                                //         MystrengthsController.clear();
                                //         mycircumstancesController.clear();
                                //         solutionsList.clear();
                                //         _userAboutMEProvider.solutionss.clear();
                                //         Navigator.pop(context);
                                //       },
                                //       child: Container(
                                //         padding: EdgeInsets.symmetric(horizontal: 15),
                                //         width: MediaQuery.of(context).size.width * .3,
                                //         height: 60,
                                //         decoration: BoxDecoration(
                                //           //color: Colors.white,
                                //           border: Border.all(
                                //             //color:primaryColorOfApp ,
                                //               width: 1.0),
                                //           borderRadius: BorderRadius.circular(15.0),
                                //         ),
                                //         child: Center(
                                //           child: Text(
                                //             'Cancel',
                                //             style: GoogleFonts.montserrat(
                                //               textStyle:
                                //               Theme
                                //                   .of(context)
                                //                   .textTheme
                                //                   .titleSmall,
                                //               fontWeight: FontWeight.bold,
                                //               //color: primaryColorOfApp
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(height: 5, width: 5,),
                                //     InkWell(
                                //       onTap: () async {
                                //         int x = 0;
                                //         x = x + 1;
                                //         var createdAt = DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now());
                                //
                                //         Map<String, dynamic> AboutMEDatas = {
                                //           // 'AB_id': x,
                                //           'Email': selectedEmail,
                                //           'User_Name': nameController.text,
                                //           'Employee': employerController.text,
                                //           'Division_or_Section': divisionOrSectionController.text,
                                //           'Role': RoleController.text,
                                //           'Location': LocationController.text,
                                //           'Employee_Number': EmployeeNumberController.text,
                                //           'Line_Manager': LineManagerController.text,
                                //           'My_Circumstance': mycircumstancesController.text,
                                //           'My_Strength': MystrengthsController.text,
                                //           'My_Organisation': mycircumstancesController.text,
                                //           'Solutions': solutionsList,
                                //           "Created_By": widget.AdminName,
                                //           "Created_Date": createdAt,
                                //           "Modified_By": "",
                                //           "Modified_Date": "",
                                //           // Add other fields as needed
                                //         };
                                //
                                //         String solutionJson = json.encode(AboutMEDatas);
                                //         print(solutionJson);
                                //
                                //         ProgressDialog.show(context, "Creating About Me", Icons.chair);
                                //         await ApiRepository().createAboutMe(AboutMEDatas);
                                //         ProgressDialog.hide();
                                //         selectedEmail = null;
                                //         nameController.clear();
                                //         employerController.clear();
                                //         divisionOrSectionController.clear();
                                //         RoleController.clear();
                                //         LocationController.clear();
                                //         EmployeeNumberController.clear();
                                //         LineManagerController.clear();
                                //         mycircumstancesController.clear();
                                //         MystrengthsController.clear();
                                //         mycircumstancesController.clear();
                                //         solutionsList.clear();
                                //         _userAboutMEProvider.solutionss.clear();
                                //         Navigator.pop(context);
                                //         setState(() {
                                //
                                //         });
                                //       },
                                //       child: Container(
                                //         padding: EdgeInsets.symmetric(horizontal: 15),
                                //         width: MediaQuery.of(context).size.width * .3,
                                //         height: 60,
                                //         decoration: BoxDecoration(
                                //           color: Colors.blue,
                                //           border: Border.all(
                                //               color: Colors.blue,
                                //               width: 2.0),
                                //           borderRadius: BorderRadius.circular(15.0),
                                //         ),
                                //         child: Center(
                                //           child: Text(
                                //             'Add',
                                //             style: GoogleFonts.montserrat(
                                //                 textStyle:
                                //                 Theme
                                //                     .of(context)
                                //                     .textTheme
                                //                     .titleSmall,
                                //                 fontWeight: FontWeight.bold,
                                //                 color: Colors.white),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),

                                int x = 0;
                                x = x + 1;
                                var createdAt = DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now());

                                Map<String, dynamic> AboutMEDatass = {
                                  // 'AB_id': x,
                                  'Email': selectedEmail,
                                  'User_Name': nameController.text,
                                  'Employer': employerController.text,
                                  'Division_or_Section': divisionOrSectionController.text,
                                  'Role': RoleController.text,
                                  'Location': LocationController.text,
                                  'Employee_Number': EmployeeNumberController.text,
                                  'Line_Manager': LineManagerController.text,
                                  'About_Me_Label': AboutMeLabeltextController.text,
                                  'My_Circumstance': mycircumstancesController.text,
                                  'My_Strength': MystrengthsController.text,
                                  'My_Organisation': myOrganisationController.text,
                                  'My_Challenges_Organisation': myOrganisation2Controller.text,
                                  'Solutions': solutionsList,
                                  'Challenges': challengesList,
                                  "Created_By": widget.AdminName,
                                  "Created_Date": createdAt,
                                  "Modified_By": "",
                                  "Modified_Date": "",
                                  // Add other fields as needed
                                };

                                Map<String, dynamic> AboutMEDatas = {
                                  'Solutions': solutionsList,
                                };

                                String solutionJson = json.encode(AboutMEDatas);
                                print(solutionJson);

                                ProgressDialog.show(context, "Saving", Icons.save);
                                await ApiRepository().updateAboutMe(AboutMEDatas,documentId);
                                ProgressDialog.hide();

                                // ProgressDialog.show(context, "Creating About Me", Icons.chair);
                                // await ApiRepository().createAboutMe(AboutMEDatas);
                                // ProgressDialog.hide();
                                _navigateToTab(5);

                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                width: MediaQuery.of(context).size.width * .2,
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
                                    'Finish',
                                    style: GoogleFonts.montserrat(
                                        textStyle: Theme.of(context).textTheme.titleSmall,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),


                      ],
                    ),
                  ],
                );
              })
      ),
    );
  }

  Widget PreviewPage() {
    return Consumer<PreviewProvider>(
        builder: (c,previewProvider, _){
          return  Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  // SizedBox(height: 20,),
                  Divider(color: Colors.black26,),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("1. Personal Info",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("1. Email: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.email==null ? "" : previewProvider.email}",
                                  style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("2. Name: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.name==null ? "" : previewProvider.name}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("3. Employer: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.employer==null ? "" : previewProvider.employer}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("4. Division or section: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.division==null ? "" : previewProvider.division}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Text("5. Role: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.role==null ? "" : previewProvider.role}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Text("6. Location: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.location==null ? "" : previewProvider.location}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("7. Employee number: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.employeeNumber==null ? "" : previewProvider.employeeNumber}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("8. Line manager:",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.linemanager==null ? "" : previewProvider.linemanager}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("2. Details",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text("Title: ",
                              //     style: GoogleFonts.montserrat(textStyle: Theme
                              //         .of(context)
                              //         .textTheme
                              //         .titleMedium,)),
                              // Text("${previewProvider.title==null ? "" : previewProvider.title}",
                              //     style: GoogleFonts.montserrat(textStyle: Theme
                              //         .of(context)
                              //         .textTheme
                              //         .bodyLarge,fontWeight: FontWeight.w700)),

                              Text("Title: ", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),

                              Expanded(
                                child: TextField(
                                  controller: AboutMeLabeltextController,
                                  onChanged: (value) {
                                    _previewProvider.updatetitle(value);
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
                                    hintText: "About Me Title",
                                    errorStyle: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.bodyLarge,
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

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("1. About Me and My circumstances: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mycircumstance==null ? "" : previewProvider.mycircumstance}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("2. My strengths that I want to have the opportunity to use in my role: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mystrength==null ? "" : previewProvider.mystrength}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),

                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("3. What I value about [my organisation] and workplace environment that helps me perform to my best: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.myorganization==null ? "" : previewProvider.myorganization}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),

                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("4. What I find challenging about [My Organisation] and the workplace environment that makes it harder for me to perform my best: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mychallenge==null ? "" : previewProvider.mychallenge}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),

                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("3. Challenge",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Consumer<PreviewProvider>(
                          builder: (context, previewProvider, _) {
                            // solutions = userAboutMEProvider.getSelectedSolutions();
                            print("PreviewChallengesList : ${previewProvider.PreviewChallengesList}");


                            return Container(
                              // height: MediaQuery.of(context).size.height * .6,
                              width: MediaQuery.of(context).size.width ,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // width: MediaQuery.of(context).size.width,
                              child:SingleChildScrollView(
                                child: DataTable(
                                  dataRowMaxHeight:60 ,
                                  headingTextStyle: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.titleMedium,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  columnSpacing: 15,
                                  columns: [
                                    DataColumn(
                                      label: Container(
                                        // color: Colors.blue,
                                        // width: 60,
                                        child: Text('Id',textAlign: TextAlign.center,),
                                      ),

                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 180,
                                        child: Text('Label',),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text('Impact',),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Description')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Impact on me')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Attachment')
                                      ),
                                    ),


                                  ],

                                  rows: previewProvider.PreviewChallengesList.map((solution) {
                                    int index = previewProvider.PreviewChallengesList.indexOf(solution);


                                    // print(jsonString);

                                    id = solution['id'];
                                    Label = solution['Label'];
                                    Impact = solution['Impact'];
                                    Final_description = solution['Final_description'];
                                    Impact_on_me = solution['Impact_on_me'];
                                    Attachment = solution['Attachment'];

                                    return DataRow(
                                      cells: [
                                        DataCell(
                                            Container(
                                              // width: 60,
                                              child: Text("CH0${solution['id']}.", style: GoogleFonts.montserrat(
                                                // child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                                    textStyle: Theme.of(context).textTheme.bodySmall,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),))),
                                        DataCell(
                                            Container(
                                              // width: 180,
                                                child: Text(solution['Label'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Impact'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Final_description'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),

                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Impact_on_me'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),

                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Attachment'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),

                                        // DataCell(
                                        //   Container(
                                        //     // height: 100,
                                        //     margin: EdgeInsets.all(5),
                                        //     width: 140,
                                        //     child: Center(
                                        //       child: TextField(
                                        //         maxLines: 4,
                                        //         controller: TextEditingController(text: solution.notes),
                                        //         onChanged: (value) {
                                        //         },
                                        //         style: GoogleFonts.montserrat(
                                        //             textStyle: Theme
                                        //                 .of(context)
                                        //                 .textTheme
                                        //                 .bodySmall,
                                        //             fontWeight: FontWeight.w400,
                                        //             color: Colors.black),
                                        //         decoration: InputDecoration(
                                        //           contentPadding: EdgeInsets.all(10),
                                        //           // labelText: "Name",
                                        //           hintText: "Notes",
                                        //           errorStyle: GoogleFonts.montserrat(
                                        //               textStyle: Theme
                                        //                   .of(context)
                                        //                   .textTheme
                                        //                   .bodyLarge,
                                        //               fontWeight: FontWeight.w400,
                                        //               color: Colors.redAccent),
                                        //           focusedBorder: OutlineInputBorder(
                                        //               borderSide: BorderSide(color: Colors.black),
                                        //               borderRadius: BorderRadius.circular(5)),
                                        //           border: OutlineInputBorder(
                                        //               borderSide: BorderSide(color: Colors.black12),
                                        //               borderRadius: BorderRadius.circular(5)),
                                        //           labelStyle: GoogleFonts.montserrat(
                                        //               textStyle: Theme
                                        //                   .of(context)
                                        //                   .textTheme
                                        //                   .bodyLarge,
                                        //               fontWeight: FontWeight.w400,
                                        //               color: Colors.black),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),), // Empty cell for Notes

                                        // DataCell(
                                        //     Container(
                                        //       child: IconButton(
                                        //         onPressed: (){
                                        //
                                        //         },
                                        //         icon: Icon(Icons.add),
                                        //       ),
                                        //     )),  // Empty cell for Attachments
                                        // DataCell(
                                        //   Container(
                                        //     width: 120,
                                        //     child: DropdownButton(
                                        //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //       // value: selectedProvider,
                                        //       value: selectedProviderValues[index],
                                        //       onChanged: (newValue) {
                                        //         // userAboutMEProvider.updatevalue(selectedProviderValues[index], newValue.toString());
                                        //         setState(() {
                                        //           // selectedProvider = newValue.toString();
                                        //           selectedProviderValues[index] = newValue.toString();
                                        //         });
                                        //       },
                                        //       items: provider.map((option) {
                                        //         return DropdownMenuItem(
                                        //           value: option,
                                        //           child: Text(option, overflow: TextOverflow.ellipsis,maxLines: 2,),
                                        //         );
                                        //       }).toList(),
                                        //     ),
                                        //   ),
                                        // ),  // Empty cell for Provider
                                        // DataCell(
                                        //   Container(
                                        //     width: 60,
                                        //     child: DropdownButton(
                                        //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //       value: selectedInPlaceValues[index],
                                        //       // value: selectedInPlace,
                                        //       onChanged: (newValue) {
                                        //         setState(() {
                                        //           selectedInPlaceValues[index] = newValue.toString();
                                        //           // selectedInPlace = newValue.toString();
                                        //         });
                                        //       },
                                        //       items: InPlace.map((option) {
                                        //         return DropdownMenuItem(
                                        //           value: option,
                                        //           child: Text(option),
                                        //         );
                                        //       }).toList(),
                                        //     ),
                                        //   ),
                                        // ),  // Empty cell for In Place
                                        // DataCell(
                                        //   Container(
                                        //     width: 140,
                                        //     // child:  DropdownButton(
                                        //     //   style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //     //   value: selectedPriorityValues[index],
                                        //     //   // value: selectedPriority,
                                        //     //   onChanged: (newValue) {
                                        //     //     setState(() {
                                        //     //       selectedPriorityValues[index] = newValue.toString();
                                        //     //
                                        //     //       print("$index: ${selectedPriorityValues[index]} ");
                                        //     //       // selectedPriority = newValue.toString();
                                        //     //     });
                                        //     //   },
                                        //     //   items: Priority.map((option) {
                                        //     //     return DropdownMenuItem(
                                        //     //       value: option,
                                        //     //       child: Text(option, overflow: TextOverflow.ellipsis,),
                                        //     //     );
                                        //     //   }).toList(),
                                        //     // ),
                                        //     child:  DropdownButtonFormField(
                                        //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //       decoration: InputDecoration(
                                        //
                                        //         hintText: 'Priority',
                                        //       ),
                                        //       value: userAboutMEProvider.selectedPriorityValues[index],
                                        //       onChanged: (newValue) {
                                        //         userAboutMEProvider.updateSelectedPriorityValues(index, newValue);
                                        //         print('priority ${index} and ${userAboutMEProvider.selectedPriorityValues}');
                                        //       },
                                        //       icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
                                        //       items: selectedPriorityValues.map<DropdownMenuItem<String>>((String value) {
                                        //         // String displayedText = value;
                                        //         // if (displayedText.length > 5) {
                                        //         //   // Limit the displayed text to 10 characters and add ellipsis
                                        //         //   displayedText = displayedText.substring(0, 5) + '..';
                                        //         // }
                                        //         return DropdownMenuItem<String>(
                                        //           value: value,
                                        //           child: Text(value, overflow: TextOverflow.ellipsis,),
                                        //         );
                                        //       }).toList(),
                                        //     ),
                                        //   ),
                                        // ),  // Empty cell for Priority

                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),

                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("4. Solutions",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Consumer<PreviewProvider>(
                          builder: (context, previewProvider, _) {
                            print("PreviewSolutionList : ${previewProvider.PreviewSolutionList}");


                            return Container(
                              // height: 350,
                              // height: MediaQuery.of(context).size.height * .48,
                              width: MediaQuery.of(context).size.width,

                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // width: MediaQuery.of(context).size.width,
                              child:SingleChildScrollView(
                                child: DataTable(
                                  dataRowMaxHeight:60 ,
                                  headingTextStyle: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.titleMedium,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  // border: TableBorder.all(color: Colors.black),
                                  columnSpacing: 15,
                                  columns: [

                                    DataColumn(
                                      label: Container(
                                        // color: Colors.blue,
                                        // width: 60,
                                        child: Text('Id',textAlign: TextAlign.center,),
                                      ),

                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 180,
                                        child: Text('label',),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 250,
                                        child: Text('Impact',),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Description')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Provider')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('In Place')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Attachment')
                                      ),
                                    ),
                                  ],
                                  rows: previewProvider.PreviewSolutionList.map((challenge) {
                                    int index = previewProvider.PreviewSolutionList.indexOf(challenge);
                                    // print(jsonString);
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                            Container(
                                              // width: 60,
                                              //   child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                                child: Text("SH0${challenge['id']}.", style: GoogleFonts.montserrat(
                                                    textStyle: Theme.of(context).textTheme.bodySmall,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),))
                                        ),
                                        DataCell(
                                            Container(
                                              child: Text(challenge['Label'],
                                                  overflow: TextOverflow.ellipsis,maxLines: 2,
                                                  style: GoogleFonts.montserrat(
                                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black)
                                              ),
                                            )),
                                        DataCell(
                                            Container(
                                              // width: 250,
                                                child: Text(challenge["Impact"],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Final_description'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Provider']==null ? "" : challenge['Provider'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['InPlace']==null ? "" : challenge['InPlace'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Attachment']==null ? "" : challenge['Attachment'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),

                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Text("5. Preview",
                        //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                        //         fontSize: 30,
                        //         color: Colors.black)),
                        InkWell(
                          onTap: () async {

                            var createdAt = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());

                            Map<String, dynamic> AboutMEDatas = {
                              'About_Me_Label': AboutMeLabeltextController.text + " $createdAt",
                              'AB_Status' : "Submitted"
                            };

                            String solutionJson = json.encode(AboutMEDatas);
                            print(solutionJson);

                            ProgressDialog.show(context, "Submiting", Icons.save);
                            await ApiRepository().updateAboutMe(AboutMEDatas,documentId);

                            ProgressDialog.hide();
                            downloadAboutMePdf(challengesList,solutionsList);

                            selectedEmail = null;
                            nameController.clear();
                            employerController.clear();
                            divisionOrSectionController.clear();
                            RoleController.clear();
                            LocationController.clear();
                            EmployeeNumberController.clear();
                            LineManagerController.clear();
                            mycircumstancesController.clear();
                            MystrengthsController.clear();
                            mycircumstancesController.clear();
                            RefineController.clear();
                            solutionsList.clear();
                            _userAboutMEProvider.solutionss.clear();
                            _userAboutMEProvider.challengess.clear();
                            _userAboutMEProvider.combinedSolutionsResults.clear();
                            _userAboutMEProvider.combinedResults.clear();
                            Navigator.pop(context);
                            setState(() {
                              page.jumpToPage(1);
                            });
                          },
                          child:Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            width: MediaQuery.of(context).size.width * .15,
                            decoration: BoxDecoration(
                              color:Colors.blue ,
                              border: Border.all(
                                  color:Colors.blue ,
                                  width: 1.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: Text(
                                'Submit',
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget ReportViewPage(aboutMeData) {
    return Consumer<PreviewProvider>(
        builder: (c,previewProvider, _){

          return  Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text("5. Preview",
                  //           style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                  //               fontSize: 30,
                  //               color: Colors.black)),
                  //       InkWell(
                  //         onTap: (){
                  //           downloadAboutMePdf(challengesList,solutionsList);
                  //         },
                  //         child:Container(
                  //           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  //           width: MediaQuery.of(context).size.width * .15,
                  //           decoration: BoxDecoration(
                  //             color:Colors.blue ,
                  //             border: Border.all(
                  //                 color:Colors.blue ,
                  //                 width: 1.0),
                  //             borderRadius: BorderRadius.circular(15.0),
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               'Download Pdf',
                  //               style: GoogleFonts.montserrat(
                  //                 textStyle:
                  //                 Theme
                  //                     .of(context)
                  //                     .textTheme
                  //                     .titleSmall,
                  //                 fontWeight: FontWeight.bold,
                  //                 color:Colors.white ,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 20,),
                  Divider(color: Colors.black26,),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("1. Personal Info",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("1. Email: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.email==null ? "" : previewProvider.email}",
                                  style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("2. Name: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.name==null ? "" : previewProvider.name}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("3. Employer: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.employer==null ? "" : previewProvider.employer}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("4. Division or section: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.division==null ? "" : previewProvider.division}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Text("5. Role: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.role==null ? "" : previewProvider.role}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Text("6. Location: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.location==null ? "" : previewProvider.location}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("7. Employee number: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.employeeNumber==null ? "" : previewProvider.employeeNumber}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("8. Line manager:",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.linemanager==null ? "" : previewProvider.linemanager}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("2. Details",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Title: ",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,)),
                              Text("${previewProvider.title==null ? "" : previewProvider.title}",
                                  style: GoogleFonts.montserrat(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 10.0, horizontal: 5),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       // Text("Title: ",
                        //       //     style: GoogleFonts.montserrat(textStyle: Theme
                        //       //         .of(context)
                        //       //         .textTheme
                        //       //         .titleMedium,)),
                        //       // Text("${previewProvider.title==null ? "" : previewProvider.title}",
                        //       //     style: GoogleFonts.montserrat(textStyle: Theme
                        //       //         .of(context)
                        //       //         .textTheme
                        //       //         .bodyLarge,fontWeight: FontWeight.w700)),
                        //
                        //       Text("Title: ", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        //
                        //       Expanded(
                        //         child: TextField(
                        //           controller: AboutMeLabeltextController,
                        //           onChanged: (value) {
                        //             _previewProvider.updatetitle(value);
                        //           },
                        //           style: GoogleFonts.montserrat(
                        //               textStyle: Theme
                        //                   .of(context)
                        //                   .textTheme
                        //                   .bodyLarge,
                        //               fontWeight: FontWeight.w400,
                        //               color: Colors.black),
                        //           decoration: InputDecoration(
                        //             contentPadding: EdgeInsets.all(10),
                        //             // labelText: "Name",
                        //             hintText: "About Me Title",
                        //             errorStyle: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.bodyLarge,
                        //                 fontWeight: FontWeight.w400,
                        //                 color: Colors.redAccent),
                        //             focusedBorder: OutlineInputBorder(
                        //                 borderSide: BorderSide(color: Colors.black),
                        //                 borderRadius: BorderRadius.circular(15)),
                        //             border: OutlineInputBorder(
                        //                 borderSide: BorderSide(color: Colors.black12),
                        //                 borderRadius: BorderRadius.circular(15)),
                        //             labelStyle: GoogleFonts.montserrat(
                        //                 textStyle: Theme
                        //                     .of(context)
                        //                     .textTheme
                        //                     .bodyLarge,
                        //                 fontWeight: FontWeight.w400,
                        //                 color: Colors.black),
                        //           ),
                        //         ),
                        //       ),
                        //
                        //     ],
                        //   ),
                        // ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("1. About Me and My circumstances: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mycircumstance==null ? "" : previewProvider.mycircumstance}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("2. My strengths that I want to have the opportunity to use in my role: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mystrength==null ? "" : previewProvider.mystrength}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),

                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("3. What I value about [my organisation] and workplace environment that helps me perform to my best: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.myorganization==null ? "" : previewProvider.myorganization}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),

                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("4. What I find challenging about [My Organisation] and the workplace environment that makes it harder for me to perform my best: ",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mychallenge==null ? "" : previewProvider.mychallenge}",
                              style: GoogleFonts.montserrat(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,fontWeight: FontWeight.w700)),

                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("3. Challenge",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Consumer<PreviewProvider>(
                          builder: (context, previewProvider, _) {
                            // solutions = userAboutMEProvider.getSelectedSolutions();
                            print("PreviewChallengesList : ${previewProvider.PreviewChallengesList}");


                            return Container(
                              // height: MediaQuery.of(context).size.height * .6,
                              width: MediaQuery.of(context).size.width ,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // width: MediaQuery.of(context).size.width,
                              child:SingleChildScrollView(
                                child: DataTable(
                                  dataRowMaxHeight:60 ,
                                  headingTextStyle: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.titleMedium,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  columnSpacing: 15,
                                  columns: [
                                    DataColumn(
                                      label: Container(
                                        // color: Colors.blue,
                                        // width: 60,
                                        child: Text('Id',textAlign: TextAlign.center,),
                                      ),

                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 180,
                                        child: Text('Label',),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text('Impact',),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Description')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Impact on me')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Attachment')
                                      ),
                                    ),


                                  ],

                                  rows: previewProvider.PreviewChallengesList.map((solution) {
                                    int index = previewProvider.PreviewChallengesList.indexOf(solution);


                                    // print(jsonString);


                                    return DataRow(
                                      cells: [
                                        DataCell(
                                            Container(
                                              // width: 60,
                                                child: Text("CH0${solution['id']}.", style: GoogleFonts.montserrat(
                                                  // child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                                    textStyle: Theme.of(context).textTheme.bodySmall,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),))),
                                        DataCell(
                                            Container(
                                              // width: 180,
                                                child: Text(solution['Label'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Impact'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Final_description'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),

                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Impact_on_me'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),

                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(solution['Attachment'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),

                                        // DataCell(
                                        //   Container(
                                        //     // height: 100,
                                        //     margin: EdgeInsets.all(5),
                                        //     width: 140,
                                        //     child: Center(
                                        //       child: TextField(
                                        //         maxLines: 4,
                                        //         controller: TextEditingController(text: solution.notes),
                                        //         onChanged: (value) {
                                        //         },
                                        //         style: GoogleFonts.montserrat(
                                        //             textStyle: Theme
                                        //                 .of(context)
                                        //                 .textTheme
                                        //                 .bodySmall,
                                        //             fontWeight: FontWeight.w400,
                                        //             color: Colors.black),
                                        //         decoration: InputDecoration(
                                        //           contentPadding: EdgeInsets.all(10),
                                        //           // labelText: "Name",
                                        //           hintText: "Notes",
                                        //           errorStyle: GoogleFonts.montserrat(
                                        //               textStyle: Theme
                                        //                   .of(context)
                                        //                   .textTheme
                                        //                   .bodyLarge,
                                        //               fontWeight: FontWeight.w400,
                                        //               color: Colors.redAccent),
                                        //           focusedBorder: OutlineInputBorder(
                                        //               borderSide: BorderSide(color: Colors.black),
                                        //               borderRadius: BorderRadius.circular(5)),
                                        //           border: OutlineInputBorder(
                                        //               borderSide: BorderSide(color: Colors.black12),
                                        //               borderRadius: BorderRadius.circular(5)),
                                        //           labelStyle: GoogleFonts.montserrat(
                                        //               textStyle: Theme
                                        //                   .of(context)
                                        //                   .textTheme
                                        //                   .bodyLarge,
                                        //               fontWeight: FontWeight.w400,
                                        //               color: Colors.black),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),), // Empty cell for Notes

                                        // DataCell(
                                        //     Container(
                                        //       child: IconButton(
                                        //         onPressed: (){
                                        //
                                        //         },
                                        //         icon: Icon(Icons.add),
                                        //       ),
                                        //     )),  // Empty cell for Attachments
                                        // DataCell(
                                        //   Container(
                                        //     width: 120,
                                        //     child: DropdownButton(
                                        //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //       // value: selectedProvider,
                                        //       value: selectedProviderValues[index],
                                        //       onChanged: (newValue) {
                                        //         // userAboutMEProvider.updatevalue(selectedProviderValues[index], newValue.toString());
                                        //         setState(() {
                                        //           // selectedProvider = newValue.toString();
                                        //           selectedProviderValues[index] = newValue.toString();
                                        //         });
                                        //       },
                                        //       items: provider.map((option) {
                                        //         return DropdownMenuItem(
                                        //           value: option,
                                        //           child: Text(option, overflow: TextOverflow.ellipsis,maxLines: 2,),
                                        //         );
                                        //       }).toList(),
                                        //     ),
                                        //   ),
                                        // ),  // Empty cell for Provider
                                        // DataCell(
                                        //   Container(
                                        //     width: 60,
                                        //     child: DropdownButton(
                                        //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //       value: selectedInPlaceValues[index],
                                        //       // value: selectedInPlace,
                                        //       onChanged: (newValue) {
                                        //         setState(() {
                                        //           selectedInPlaceValues[index] = newValue.toString();
                                        //           // selectedInPlace = newValue.toString();
                                        //         });
                                        //       },
                                        //       items: InPlace.map((option) {
                                        //         return DropdownMenuItem(
                                        //           value: option,
                                        //           child: Text(option),
                                        //         );
                                        //       }).toList(),
                                        //     ),
                                        //   ),
                                        // ),  // Empty cell for In Place
                                        // DataCell(
                                        //   Container(
                                        //     width: 140,
                                        //     // child:  DropdownButton(
                                        //     //   style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //     //   value: selectedPriorityValues[index],
                                        //     //   // value: selectedPriority,
                                        //     //   onChanged: (newValue) {
                                        //     //     setState(() {
                                        //     //       selectedPriorityValues[index] = newValue.toString();
                                        //     //
                                        //     //       print("$index: ${selectedPriorityValues[index]} ");
                                        //     //       // selectedPriority = newValue.toString();
                                        //     //     });
                                        //     //   },
                                        //     //   items: Priority.map((option) {
                                        //     //     return DropdownMenuItem(
                                        //     //       value: option,
                                        //     //       child: Text(option, overflow: TextOverflow.ellipsis,),
                                        //     //     );
                                        //     //   }).toList(),
                                        //     // ),
                                        //     child:  DropdownButtonFormField(
                                        //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                                        //       decoration: InputDecoration(
                                        //
                                        //         hintText: 'Priority',
                                        //       ),
                                        //       value: userAboutMEProvider.selectedPriorityValues[index],
                                        //       onChanged: (newValue) {
                                        //         userAboutMEProvider.updateSelectedPriorityValues(index, newValue);
                                        //         print('priority ${index} and ${userAboutMEProvider.selectedPriorityValues}');
                                        //       },
                                        //       icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
                                        //       items: selectedPriorityValues.map<DropdownMenuItem<String>>((String value) {
                                        //         // String displayedText = value;
                                        //         // if (displayedText.length > 5) {
                                        //         //   // Limit the displayed text to 10 characters and add ellipsis
                                        //         //   displayedText = displayedText.substring(0, 5) + '..';
                                        //         // }
                                        //         return DropdownMenuItem<String>(
                                        //           value: value,
                                        //           child: Text(value, overflow: TextOverflow.ellipsis,),
                                        //         );
                                        //       }).toList(),
                                        //     ),
                                        //   ),
                                        // ),  // Empty cell for Priority

                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),

                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("4. Solutions",
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black)),
                        ),
                        Consumer<PreviewProvider>(
                          builder: (context, previewProvider, _) {
                            print("PreviewSolutionList : ${previewProvider.PreviewSolutionList}");


                            return Container(
                              // height: 350,
                              // height: MediaQuery.of(context).size.height * .48,
                              width: MediaQuery.of(context).size.width,

                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // width: MediaQuery.of(context).size.width,
                              child:SingleChildScrollView(
                                child: DataTable(
                                  dataRowMaxHeight:60 ,
                                  headingTextStyle: GoogleFonts.montserrat(
                                      textStyle: Theme.of(context).textTheme.titleMedium,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  // border: TableBorder.all(color: Colors.black),
                                  columnSpacing: 15,
                                  columns: [

                                    DataColumn(
                                      label: Container(
                                        // color: Colors.blue,
                                        // width: 60,
                                        child: Text('Id',textAlign: TextAlign.center,),
                                      ),

                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 180,
                                        child: Text('label',),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 250,
                                        child: Text('Impact',),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Description')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Provider')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('In Place')
                                      ),
                                    ),
                                    DataColumn(
                                      label: Container(
                                        // width: 400,
                                          child: Text('Attachment')
                                      ),
                                    ),
                                  ],
                                  rows: previewProvider.PreviewSolutionList.map((challenge) {
                                    int index = previewProvider.PreviewSolutionList.indexOf(challenge);
                                    // print(jsonString);
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                            Container(
                                              // width: 60,
                                              //   child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                                child: Text("SH0${challenge['id']}.", style: GoogleFonts.montserrat(
                                                    textStyle: Theme.of(context).textTheme.bodySmall,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),))
                                        ),
                                        DataCell(
                                            Container(
                                              child: Text(challenge['Label'],
                                                  overflow: TextOverflow.ellipsis,maxLines: 2,
                                                  style: GoogleFonts.montserrat(
                                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black)
                                              ),
                                            )),
                                        DataCell(
                                            Container(
                                              // width: 250,
                                                child: Text(challenge["Impact"],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Final_description'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Provider']==null ? "" : challenge['Provider'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['InPlace']==null ? "" : challenge['InPlace'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                        DataCell(
                                            Container(
                                              // width: 400,
                                                child: Text(challenge['Attachment']==null ? "" : challenge['Attachment'],
                                                    overflow: TextOverflow.ellipsis,maxLines: 2,
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black)
                                                ))),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),

                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),

                ],
              ),
            ),
          );
        });
  }

  void showEditAboutMeDialogBox(aboutMeData, int tabindex) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return EditAboutMEScreen(aboutMeData:  aboutMeData, refreshPage: refreshPage, AdminName: widget.AdminName, tabindex: tabindex, page: page);
          // return Theme(
          //     data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
          //     child:  Consumer<UserAboutMEProvider>(
          //         builder: (c,userAboutMEProvider, _){
          //           return
          //             AlertDialog(
          //               content: SizedBox(
          //                   width: double.maxFinite,
          //
          //                   child:DefaultTabController(
          //                     length: 4, // Number of tabs
          //                     child: Column(
          //                       children: [
          //                         TabBar(
          //                           physics: NeverScrollableScrollPhysics(),
          //                           controller: _tabController,
          //                           tabs: [
          //                             Tab(text: "Personal Info"),
          //                             Tab(text: "Details"),
          //                             Tab(text: "Challenges"),
          //                             Tab(text: "Solutions"),
          //                             // Tab(text: "PreviewPage"),
          //                           ],
          //                         ),
          //                         Expanded(
          //                           child: TabBarView(
          //                             physics: NeverScrollableScrollPhysics(),
          //                             controller: _tabController,
          //                             children: [
          //                               EditAboutMe().AboutmeFormpage(context,aboutMeData,emailList),
          //                               EditAboutMe().Detailspage(context, aboutMeData),
          //                               AddChallengesPage(),
          //                               AddSolutionsPage(),
          //                               // PreviewPage(context),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   )
          //
          //               ),
          //               icon: Row(
          //                 mainAxisAlignment: MainAxisAlignment.end,
          //                 children: [
          //                   InkWell(
          //                       onTap: (){
          //                         selectedEmail = null;
          //                         nameController.clear();
          //                         employerController.clear();
          //                         divisionOrSectionController.clear();
          //                         RoleController.clear();
          //                         LocationController.clear();
          //                         EmployeeNumberController.clear();
          //                         LineManagerController.clear();
          //                         mycircumstancesController.clear();
          //                         MystrengthsController.clear();
          //                         mycircumstancesController.clear();
          //                         RefineController.clear();
          //                         solutionsList.clear();
          //                         _userAboutMEProvider.solutionss.clear();
          //                         _userAboutMEProvider.challengess.clear();
          //                         _userAboutMEProvider.combinedSolutionsResults.clear();
          //                         _userAboutMEProvider.combinedResults.clear();
          //                         _navigateToTab(0);
          //                         Navigator.pop(context);                              },
          //                       child: Icon(Icons.close)),
          //                 ],
          //               ),
          //               iconPadding: EdgeInsets.only(right: 15,top: 8),
          //             );
          //         })
          //
          // );
        }
    );
  }

  void showReportViewPageDialogBox(aboutMeData) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          selectedEmail = aboutMeData['Email']==null ? "" : aboutMeData['Email'];
          _previewProvider.email = selectedEmail;
          searchEmailcontroller.text = aboutMeData['Email']==null ? "" : aboutMeData['Email'];
          // _previewProvider.email = selectedEmail;
          nameController.text = aboutMeData['User_Name']==null ? "" : aboutMeData['User_Name'];
          _previewProvider.name = nameController.text;
          employerController.text = aboutMeData['Employer']==null ? "" : aboutMeData['Employer'];
          _previewProvider.employer = employerController.text;
          divisionOrSectionController.text = aboutMeData['Division_or_Section']==null ? "" : aboutMeData['Division_or_Section'];
          _previewProvider.division = divisionOrSectionController.text;
          RoleController.text = aboutMeData['Role']==null ? "" : aboutMeData['Role'];
          _previewProvider.role = RoleController.text;
          LocationController.text = aboutMeData['Location']==null ? "" : aboutMeData['Location'];
          _previewProvider.location = LocationController.text;
          EmployeeNumberController.text = aboutMeData['Employee_Number']==null ? "" : aboutMeData['Employee_Number'];
          _previewProvider.employeeNumber = EmployeeNumberController.text;
          LineManagerController.text = aboutMeData['Line_Manager']==null ? "" : aboutMeData['Line_Manager'];
          _previewProvider.linemanager = LineManagerController.text;

          // documentId = aboutMeData.id;

          print("aboutMeData['Email']: ${aboutMeData['Email']}");
          print("documentId: ${documentId}");
          return Theme(
              data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
              child:  AlertDialog(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                  content: ReportViewPage(aboutMeData))
          );
          // return Theme(
          //     data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
          //     child:  Consumer<UserAboutMEProvider>(
          //         builder: (c,userAboutMEProvider, _){
          //           return
          //             AlertDialog(
          //               content: SizedBox(
          //                   width: double.maxFinite,
          //
          //                   child:DefaultTabController(
          //                     length: 4, // Number of tabs
          //                     child: Column(
          //                       children: [
          //                         TabBar(
          //                           physics: NeverScrollableScrollPhysics(),
          //                           controller: _tabController,
          //                           tabs: [
          //                             Tab(text: "Personal Info"),
          //                             Tab(text: "Details"),
          //                             Tab(text: "Challenges"),
          //                             Tab(text: "Solutions"),
          //                             // Tab(text: "PreviewPage"),
          //                           ],
          //                         ),
          //                         Expanded(
          //                           child: TabBarView(
          //                             physics: NeverScrollableScrollPhysics(),
          //                             controller: _tabController,
          //                             children: [
          //                               EditAboutMe().AboutmeFormpage(context,aboutMeData,emailList),
          //                               EditAboutMe().Detailspage(context, aboutMeData),
          //                               AddChallengesPage(),
          //                               AddSolutionsPage(),
          //                               // PreviewPage(context),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   )
          //
          //               ),
          //               icon: Row(
          //                 mainAxisAlignment: MainAxisAlignment.end,
          //                 children: [
          //                   InkWell(
          //                       onTap: (){
          //                         selectedEmail = null;
          //                         nameController.clear();
          //                         employerController.clear();
          //                         divisionOrSectionController.clear();
          //                         RoleController.clear();
          //                         LocationController.clear();
          //                         EmployeeNumberController.clear();
          //                         LineManagerController.clear();
          //                         mycircumstancesController.clear();
          //                         MystrengthsController.clear();
          //                         mycircumstancesController.clear();
          //                         RefineController.clear();
          //                         solutionsList.clear();
          //                         _userAboutMEProvider.solutionss.clear();
          //                         _userAboutMEProvider.challengess.clear();
          //                         _userAboutMEProvider.combinedSolutionsResults.clear();
          //                         _userAboutMEProvider.combinedResults.clear();
          //                         _navigateToTab(0);
          //                         Navigator.pop(context);                              },
          //                       child: Icon(Icons.close)),
          //                 ],
          //               ),
          //               iconPadding: EdgeInsets.only(right: 15,top: 8),
          //             );
          //         })
          //
          // );
        }
    );
  }

  Future<void> exportToPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context){
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 5),
              child: pw.Text("1. Personal Info",)
          ),

          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text("1. Email: ",),

                pw.Text("${selectedEmail}",),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text("2. Name: ",),

                pw.Text("${nameController.text}",),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text("3. Employer: ",),

                pw.Text(
                  "${employerController.text}",),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text("4. Division or section: ",),

                pw.Text(
                  "${divisionOrSectionController.text}",),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,

              children: [
                pw.Text("5. Role: ",),

                pw.Text("${RoleController.text}",),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,

              children: [
                pw.Text("6. Location: ",),

                pw.Text(
                  "${LocationController.text}",),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text("7. Employee number: ",),

                pw.Text("${EmployeeNumberController.text}",),
              ],
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text("8. Line manager:",),

                pw.Text(
                  "${LineManagerController.text}",),
              ],
            ),
          ),
        ],
      );




        },
      ),
    );
    await pdf.save();
    // final output = await getTemporaryDirectory();
    // final file = File('${output.path}/example.pdf');
    // await file.writeAsBytes(await pdf.save());
    // print("file_path ${file.path}");
    // final output = await getExternalStorageDirectory();
    // final file = File('${output?.path}/site_report${DateTime.now()}.pdf');
    // await file.writeAsBytes(await pdf.save());
    // print("file ${file.path}");
    // Fluttertoast.showToast(
    //   msg: 'PDF saved successfully ${file.path}',
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.green,
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // );
    // // Open the saved PDF file
    // if (await file.exists()) {
    //   // Use platform-specific code to open the PDF file
    //   // Here, we are using the platform's default PDF viewer
    //   await OpenFilex.open(file.path); // Import 'package:open_file/open_file.dart';
    // }
  }

  Future<Uint8List> makePdf(List<Map<String, dynamic>> dataList, List<Map<String, dynamic>> dataList2) async {
    final pdf = pw.Document();

    pdf.addPage(
        pw.MultiPage(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(15),
          build: (context) {
            List<pw.TableRow> ChallengetableRows = generateChallengeTableRows(dataList);
            List<pw.TableRow> SolutiontableRows = generateSolutionTableRows(dataList2);

            return [
              pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5),
                  child: pw.Center (child: pw.Text("About Me",style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 26)))
              ),

              pw.Divider(),

            pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 5),
                child: pw.Text("1. Personal Info",style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24))
            ),

            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("1. Email: ",),

                  pw.Text("${selectedEmail ?? ""}",),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("2. Name: ",),

                  pw.Text("${nameController.text}",),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("3. Employer: ",),

                  pw.Text(
                    "${employerController.text}",),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("4. Division or section: ",),

                  pw.Text(
                    "${divisionOrSectionController.text}",),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,

                children: [
                  pw.Text("5. Role: ",),

                  pw.Text("${RoleController.text}",),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,

                children: [
                  pw.Text("6. Location: ",),

                  pw.Text(
                    "${LocationController.text}",),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 5),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("7. Employee number: ",),

                  pw.Text("${EmployeeNumberController.text}",),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("8. Line manager:",),

                  pw.Text(
                    "${LineManagerController.text}",),


                ],
              ),
            ),

            pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 5),
                child: pw.Text("2. Details",style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24))
            ),

            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Title: ",),

                  pw.Text(
                    "${AboutMeLabeltextController.text}",),

                ],
              ),
            ),

            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child:
              pw.Text("1. About me and my circumstance: ",),),

            pw.Text(
              "${mycircumstancesController.text}",),


            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child:
              pw.Text("2. My strengths that I want to have the opportunity to use in my role: ",),),

            pw.Text(
              "${MystrengthsController.text}",),

            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child:
              pw.Text("3. What I value about [my organisation] and workplace environment that helps me perform to my best: ",),),

            pw.Text(
              "${myOrganisationController.text}",),

            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 8),
              child:
              pw.Text("4: What I find challenging about [My Organisatio] and the workplace environment that makes it harder for me to perform my best: ",),),

            pw.Text(
              "${myOrganisation2Controller.text}",),

            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 5,
              ),
              child: pw.Text(
                "3. Challenges",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),


            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    pw.Container(
                      width: 40,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Id'),
                    ),
                    pw.Container(
                      width: 120,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Label'),
                    ),
                    pw.Container(
                      width: 120,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Impact'),
                    ),
                    pw.Container(
                      width: 150,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Description'),
                    ),
                    pw.Container(
                      width: 120,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Impact on me'),
                    ),
                    pw.Container(
                      width: 110,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Attachment'),
                    ),
                    // Add more cells as needed
                  ],
                ),
                ...ChallengetableRows,
                // Add more rows as needed

            // Add Table Rows from dataList
              ],
            ),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 5,
                ),
                child: pw.Text(
                  "4. Solutions",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),


              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Container(
                        width: 40,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Id'),
                      ),
                      pw.Container(
                        width: 110,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Label'),
                      ),
                      pw.Container(
                        width: 100,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Impact'),
                      ),
                      pw.Container(
                        width: 120,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Description'),
                      ),
                      pw.Container(
                        width: 110,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Provider'),
                      ),
                      pw.Container(
                        width: 90,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('InPlace'),
                      ),
                      pw.Container(
                        width: 110,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Attachment'),
                      ),
                      // Add more cells as needed
                    ],
                  ),
                  ...SolutiontableRows,
                  // Add more rows as needed

                  // Add Table Rows from dataList
                ],
              ),
          ];
        },));
    return pdf.save();
  }

  Future<Uint8List> makePdfs(List<Map<String, dynamic>> dataList) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          List<pw.Widget> widgets = [];

          // Add Table Header
          widgets.add(
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Id', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('Label', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('Impact', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('Final Description', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('Impact on Me', textAlign: pw.TextAlign.center)),
                pw.Expanded(child: pw.Text('Attachment', textAlign: pw.TextAlign.center)),
              ],
            ),
          );

          // Add Table Rows from dataList
          for (var item in dataList) {
            widgets.add(
              pw.Row(
                children: [
                  pw.Expanded(child: pw.Text("${item['id'] }"?? '', textAlign: pw.TextAlign.center)),
                  pw.Expanded(child: pw.Text(item['Label'] ?? '', textAlign: pw.TextAlign.center)),
                  pw.Expanded(child: pw.Text(item['Impact'] ?? '', textAlign: pw.TextAlign.center)),
                  pw.Expanded(child: pw.Text(item['Final_description'] ?? '', textAlign: pw.TextAlign.center)),
                  pw.Expanded(child: pw.Text(item['Impact_on_me'] ?? '', textAlign: pw.TextAlign.center)),
                  pw.Expanded(child: pw.Text(item['Attachment'] ?? '', textAlign: pw.TextAlign.center)),
                ],
              ),
            );
          }

          return [pw.Column(children: widgets)];
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> makePdfss(List<Map<String, dynamic>> dataList) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(8),
        build: (context) {
          List<pw.TableRow> tableRows = [];
          tableRows.add(
            pw.TableRow(
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Id'),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Label'),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Impact'),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Final Description'),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Impact on Me'),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Attachment'),
                ),
              ],
            ),
          );

          // Add Table Rows from dataList
          for (var item in dataList) {
            tableRows.add(
              pw.TableRow(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("${item['id']}" ?? ''),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(item['Label'] ?? ''),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(item['Impact'] ?? ''),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(item['Final_description'] ?? ''),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(item['Impact_on_me'] ?? ''),
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(item['Attachment'] ?? ''),
                  ),
                ],
              ),
            );
          }

          return [
            pw.Table(
            border: pw.TableBorder.all(),
            children: tableRows,
          )
          ];
        },
      ),
    );

    return pdf.save();
  }

  List<pw.TableRow> generateChallengeTableRows(List<Map<String, dynamic>> dataList) {
    List<pw.TableRow> tableRows = [];

    // Add Table Rows from dataList
    for (var item in dataList) {
      tableRows.add(
        pw.TableRow(
          children: [
            pw.Container(
              width: 40,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("${item['id']}."),
            ),
            pw.Container(
              width: 120,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(item['Label']),
            ),
            pw.Container(
              width: 120,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(item['Impact']),
            ),
            pw.Container(
              width: 150,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(item['Final_description']),
            ),
            pw.Container(
              width: 120,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(item['Impact_on_me']),
            ),
            pw.Container(
              width: 110,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(item['Attachment']),
            ),
          ],
        ),
      );
    }

    return tableRows;
  }

  List<pw.TableRow> generateSolutionTableRows(List<Map<String, dynamic>> dataList) {
    List<pw.TableRow> tableRows = [];

    // Add Table Rows from dataList
    for (var item in dataList) {
      tableRows.add(
        pw.TableRow(
          children: [
            pw.Container(
              width: 40,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("${item['id']}.", maxLines: 1),
            ),
            pw.Container(
              width: 110,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(item['Label']),
            ),
            pw.Container(
              width: 100,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(item['Impact'], maxLines: 2),
            ),
            pw.Container(
              width: 120,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(item['Final_description'], maxLines: 2,),
            ),
            pw.Container(
              width: 110,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(item['Provider'] ?? ""),
            ),
            pw.Container(
              width: 90,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(item['InPlace'] ?? ""),
            ),

            pw.Container(
              width: 110,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(item['Attachment']),
            ),
          ],
        ),
      );
    }

    return tableRows;
  }

  Future<Uint8List> generateAboutMePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5),
                  child: pw.Text("1. Personal Info",style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24))
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text("1. Email: ",),

                    pw.Text("${selectedEmail}",),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text("2. Name: ",),

                    pw.Text("${nameController.text}",),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text("3. Employer: ",),

                    pw.Text(
                      "${employerController.text}",),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text("4. Division or section: ",),

                    pw.Text(
                      "${divisionOrSectionController.text}",),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,

                  children: [
                    pw.Text("5. Role: ",),

                    pw.Text("${RoleController.text}",),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,

                  children: [
                    pw.Text("6. Location: ",),

                    pw.Text(
                      "${LocationController.text}",),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 5),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text("7. Employee number: ",),

                    pw.Text("${EmployeeNumberController.text}",),
                  ],
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text("8. Line manager:",),

                    pw.Text(
                      "${LineManagerController.text}",),


                  ],
                ),
              ),

              pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5),
                  child: pw.Text("2. Details",style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24))
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text("Title: ",),

                    pw.Text(
                      "${AboutMeLabeltextController.text}",),

                  ],
                ),
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child:
                    pw.Text("1. About me and my circumstance: ",),),

                    pw.Text(
                      "${mycircumstancesController.text}",),


              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child:
                pw.Text("2. My strengths that I want to have the opportunity to use in my role: ",),),

              pw.Text(
                "${MystrengthsController.text}",),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child:
                pw.Text("3. What I value about [my organisation] and workplace environment that helps me perform to my best: ",),),

              pw.Text(
                "${myOrganisationController.text}",),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 8),
                child:
                pw.Text("4: What I find challenging about [My Organisatio] and the workplace environment that makes it harder for me to perform my best: ",),),

              pw.Text(
                "${myOrganisation2Controller.text}",),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> downloadAboutMePdf(dataList,dataList2) async {
    // final Uint8List pdfBytes = await generateAboutMePdf();
    final Uint8List pdfBytes = await makePdf(dataList,dataList2);
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "about_me.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);
  }



  List<dynamic> editKeywordssss = [];
  List<dynamic> edittags = [];
  List<dynamic> SolutionseditKeywordssss = [];
  List<dynamic> Solutionsedittags = [];

  void ViewChallengesDialog(documentReference,Id, Name, Description, newvalues, keywords,
      createdat,createdby,tags, modifiedBy,modifiedDate,insideId,documents,i) {


    DateTime dateTime = createdat.toDate();


    final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");


    String formattedDate = formatter.format(dateTime);

    print("ViewChallengesDialog: $insideId");
    print("ViewChallengesDialog: ${insideId.runtimeType}");


    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
            child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery
                    .of(context)
                    .size
                    .width * 0.08, vertical: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04),
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close)),
                  ],
                ),
                iconPadding: EdgeInsets.only(top: 8, right: 16),
                content:   SizedBox(
                    width: double.maxFinite,
                    child: Consumer<
                        UserAboutMEProvider>(
                        builder: (c, userAboutMEProvider, _) {
                          return StatefulBuilder(
                              builder: (context,innerState) {
                                return FutureBuilder (
                                    future: fetchDetails(documentReference),
                                    builder: (ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        // If we got an error
                                        if (snapshot.hasError) {
                                          return Text(
                                              snapshot.error.toString(),
                                              style: GoogleFonts.montserrat(
                                                  textStyle:
                                                  Theme.of(context).textTheme.bodyLarge,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black)
                                          );

                                          // if we got our data
                                        }
                                        else if (snapshot.hasData) {
                                          DocumentSnapshot? doc = snapshot.data;

                                          var name = userAboutMEProvider.previewname==null ? doc?.get("Label") : userAboutMEProvider.previewname;
                                          var Description = userAboutMEProvider.previewDescription==null ? doc?.get("Description") : userAboutMEProvider.previewDescription;
                                          var OriginalDescription = doc?.get('Original Description');
                                          var FinalDescription = userAboutMEProvider.previewFinalDescription==null ? doc?.get('Final_description') : userAboutMEProvider.previewFinalDescription;
                                          var Impact = userAboutMEProvider.previewImpact==null ? doc?.get('Impact') : userAboutMEProvider.previewImpact;

                                          var Category = doc?.get("Category");
                                          var Source = (doc?.get("Source") == "" ||doc?.get("Source") == null )?"MTH RfA email 20240130":doc?.get("Source");
                                          var Status = (doc?.get("Challenge Status") == "" ||doc?.get("Challenge Status") == null ) ? 'New' : doc?.get("Challenge Status");

                                          editKeywordssss =userAboutMEProvider.previewKeywordssss.isEmpty ? doc?.get("Keywords") : userAboutMEProvider.previewKeywordssss;
                                          edittags = userAboutMEProvider.previewtags.isEmpty ? doc?.get("tags") : userAboutMEProvider.previewtags;

                                          _challengesProvider.addkeywordsList(editKeywordssss);
                                          _challengesProvider.addProviderEditTagsList(edittags);

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    // height: 400,
                                                    padding: EdgeInsets.all(20),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey),
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            (name==""|| name==null) ? Container() : Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(name,
                                                                    style: GoogleFonts.montserrat(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 20,
                                                                        color: Colors.black)
                                                                ),
                                                                Consumer<UserAboutMEProvider>(
                                                                    builder: (c,userAboutMEProvider, _){
                                                                      return
                                                                        (userAboutMEProvider.isRecommendedChallengeCheckedMap[insideId] == true) ? Text(
                                                                          'Added',
                                                                          style: GoogleFonts.montserrat(
                                                                            textStyle:
                                                                            Theme
                                                                                .of(context)
                                                                                .textTheme
                                                                                .titleSmall,
                                                                            fontStyle: FontStyle.italic,
                                                                            color:Colors.green ,
                                                                          ),
                                                                        ) : InkWell(
                                                                          onTap: (){
                                                                            userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                                                            toastification.show(context: context,
                                                                                title: Text('${name} added successfully'),
                                                                                autoCloseDuration: Duration(milliseconds: 2500),
                                                                                alignment: Alignment.center,
                                                                                backgroundColor: Colors.green,
                                                                                foregroundColor: Colors.white,
                                                                                icon: Icon(Icons.check_circle, color: Colors.white,),
                                                                                animationDuration: Duration(milliseconds: 1000),
                                                                                showProgressBar: false
                                                                            );
                                                                          },
                                                                          child: Container(
                                                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                            width: MediaQuery.of(context).size.width * .05,
                                                                            // width: MediaQuery.of(context).size.width * .15,
                                                  
                                                                            // height: 60,
                                                                            decoration: BoxDecoration(
                                                                              color:Colors.blue ,
                                                                              border: Border.all(
                                                                                  color:Colors.blue ,
                                                                                  width: 1.0),
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                            ),
                                                                            child: Center(
                                                                              // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                              child: Text(
                                                                                'Add',
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
                                                                        );
                                                                    })
                                                                ,
                                                              ],
                                                            ),
                                                            SizedBox(height: 5,),
                                                            (FinalDescription==""|| FinalDescription==null) ? Container() :  Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                // Text("Description: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                                Flexible(child: Text(FinalDescription,  style: GoogleFonts.montserrat(
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 20,
                                                                    color: Colors.black),
                                                                  maxLines: null,)),
                                                              ],
                                                            ),
                                                            SizedBox(height: 10,),
                                                  
                                                            (Impact==""|| Impact==null) ? Container() :  Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                // Text("Impact: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                                Flexible(child: Text(Impact,  style: GoogleFonts.montserrat(
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 20,
                                                                    fontStyle: FontStyle.italic,
                                                                    color: Colors.grey),
                                                                  maxLines: null,)),
                                                              ],
                                                            ),
                                                  
                                                            SizedBox(height: 10,),
                                                  
                                                            (Description==""|| Description==null) ? Container() :  Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                // Text("Description: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                                Flexible(child: Text(Description,  style: GoogleFonts.montserrat(
                                                                  // fontWeight: FontWeight.w600,
                                                                    fontSize: 16,
                                                                    color: Colors.black),
                                                                  maxLines: null,)),
                                                              ],
                                                            ),
                                                  
                                                            SizedBox(height: 10,),
                                                  
                                                  
                                                  
                                                  
                                                            (_challengesProvider.keywords==""|| _challengesProvider.keywords==null||_challengesProvider.keywords.isEmpty) ? Container() :
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                // Text("Category: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                                Flexible(
                                                                  child: Consumer<ChallengesProvider>(
                                                                      builder: (c,addKeywordProvider, _){
                                                                        return Align(
                                                                          alignment: Alignment.centerLeft,
                                                                          child: Wrap(
                                                                            spacing: 10,
                                                                            runSpacing: 10,
                                                                            crossAxisAlignment: WrapCrossAlignment.start,
                                                                            alignment: WrapAlignment.start,
                                                                            runAlignment: WrapAlignment.start,
                                                                            children: addKeywordProvider.keywords.map((item){
                                                                              print("item: $item");
                                                                              print("addKeywordProvider.keywords: ${addKeywordProvider.keywords}");
                                                                              return InkWell(
                                                                                onTap: (){
                                                                                  searchChallengescontroller.text = item;
                                                                                  _challengesProvider.loadDataForPageSearchFilter(item);
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  height: 50,
                                                                                  // width: 200,
                                                                                  margin: EdgeInsets.only(bottom: 10),
                                                                                  padding: EdgeInsets.all(8),
                                                                                  decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                      color: Color(0xFF00ACC1)
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(item, style: TextStyle(
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Colors.white
                                                                                      ),),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                          ),
                                                                        );
                                                                      }),
                                                                ),
                                                              ],
                                                            ),
                                                  
                                                            SizedBox(height: 10),
                                                  
                                                            (_challengesProvider.ProviderEditTags==""|| _challengesProvider.ProviderEditTags==null||_challengesProvider.ProviderEditTags.isEmpty) ? Container() :  Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                // Text("Tags: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                  
                                                                Flexible(
                                                                  child: Consumer<ChallengesProvider>(
                                                                      builder: (c,addKeywordProvider, _){
                                                                        return Align(
                                                                          alignment: Alignment.centerLeft,
                                                                          child: Wrap(
                                                                            spacing: 10,
                                                                            runSpacing: 10,
                                                                            crossAxisAlignment: WrapCrossAlignment.start,
                                                                            alignment: WrapAlignment.start,
                                                                            runAlignment: WrapAlignment.start,
                                                                            children: addKeywordProvider.ProviderEditTags.map((item){
                                                                              return InkWell(
                                                                                onTap: (){
                                                                                  searchChallengescontroller.text = item;
                                                                                  _challengesProvider.loadDataForPageSearchFilter(item);
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  height: 50,
                                                                                  // width: 200,
                                                                                  padding: EdgeInsets.all(8),
                                                                                  decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                      color: Colors.teal
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(item, style: TextStyle(
                                                                                          fontWeight: FontWeight.w700,
                                                                                          color: Colors.white
                                                                                      ),),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                          ),
                                                                        );
                                                  
                                                                      }),
                                                                ),
                                                              ],
                                                            ),
                                                  
                                                          ]
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 15,),
                                                Flexible(
                                                  child: Container(
                                                    // height: 400,
                                                    padding: EdgeInsets.all(15),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey),
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Container(
                                                            height: 170 ,
                                                            child: FutureBuilder(
                                                              future: getRelatedSolutions(tags, keywords),
                                                              builder: (context, snapshot) {
                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                  return Container(
                                                                      width: MediaQuery.of(context).size.width,
                                                                      child: Container(
                                                                          height: 20, // Adjust the height as needed
                                                                          width: 20,
                                                                          child: Center(
                                                                              child: CircularProgressIndicator()
                                                                          )
                                                                      )
                                                                  ); // Display a loading indicator while fetching data
                                                                } else if (snapshot.hasError) {
                                                                  return Text('Error: ${snapshot.error}');
                                                                } else {
                                                                  // List<DocumentSnapshot<Object?>>? relatedSolutions = snapshot.data;
                                                                  List<DocumentSnapshot<Map<String, dynamic>>>? relatedSolutions = snapshot.data?.cast<DocumentSnapshot<Map<String, dynamic>>>();
                                                  
                                                                  // print("relatedSolutions: $relatedSolutions");
                                                  
                                                                  return Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                                                        child: Text("Related Solutions (${relatedSolutions?.length})",
                                                                            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                                color: Colors.black)
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: ListView.builder(
                                                                          scrollDirection: Axis.horizontal,
                                                                          shrinkWrap: true,
                                                                          itemCount: relatedSolutions?.length,
                                                                          itemBuilder: (c, i) {
                                                                            // relatedSolutionlength = relatedSolutions?.length;
                                                                            // print("relatedSolutionlength: $relatedSolutionlength");
                                                                            var solutionData = relatedSolutions?[i].data() as Map<String, dynamic>;
                                                                            print("solutionData: ${solutionData}");
                                                                            return Container(
                                                                              margin: EdgeInsets.symmetric(horizontal: 15),
                                                                              padding: EdgeInsets.all(12),
                                                                              width: 330,
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: Colors.black),
                                                                                borderRadius: BorderRadius.circular(20),
                                                                              ),
                                                                              child: SingleChildScrollView(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Flexible(
                                                                                          child: Text("${solutionData['Name']}",
                                                                                              maxLines: null,
                                                                                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                                  fontSize: 18,
                                                                                                  color: Colors.black)),
                                                                                        ),
                                                                                        SizedBox(width: 5,),
                                                                                        // InkWell(
                                                                                        //   onTap: (){
                                                                                        //     _userAboutMEProvider.isRecommendedAddedSolutions(true, relatedSolutions![i]);
                                                                                        //   },
                                                                                        //   child: Container(
                                                                                        //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                        //     width: MediaQuery.of(context).size.width * .05,
                                                                                        //     // width: MediaQuery.of(context).size.width * .15,
                                                                                        //
                                                                                        //     // height: 60,
                                                                                        //     decoration: BoxDecoration(
                                                                                        //       color: Colors.blue ,
                                                                                        //       border: Border.all(
                                                                                        //           color:Colors.blue ,
                                                                                        //           width: 1.0),
                                                                                        //       borderRadius: BorderRadius.circular(8.0),
                                                                                        //     ),
                                                                                        //     child: Center(
                                                                                        //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                        //       child: Text(
                                                                                        //         'Add',
                                                                                        //         style: GoogleFonts.montserrat(
                                                                                        //           textStyle:
                                                                                        //           Theme
                                                                                        //               .of(context)
                                                                                        //               .textTheme
                                                                                        //               .titleSmall,
                                                                                        //           fontWeight: FontWeight.bold,
                                                                                        //           color:Colors.white ,
                                                                                        //         ),
                                                                                        //       ),
                                                                                        //     ),
                                                                                        //   ),
                                                                                        // ),
                                                                                        Consumer<UserAboutMEProvider>(
                                                                                            builder: (c,userAboutMEProvider, _){
                                                                                              return
                                                                                                (userAboutMEProvider.isRecommendedSolutionsCheckedMap[solutionData['id']] == true) ? Text(
                                                                                                  'Added',
                                                                                                  style: GoogleFonts.montserrat(
                                                                                                    textStyle:
                                                                                                    Theme
                                                                                                        .of(context)
                                                                                                        .textTheme
                                                                                                        .titleSmall,
                                                                                                    fontStyle: FontStyle.italic,
                                                                                                    color:Colors.green ,
                                                                                                  ),
                                                                                                ) : InkWell(
                                                                                                  onTap: (){
                                                                                                    // userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                                                                                    userAboutMEProvider.isRecommendedAddedSolutions(true, relatedSolutions![i]);
                                                                                                    toastification.show(context: context,
                                                                                                        title: Text('${solutionData['Name']} added successfully'),
                                                                                                        autoCloseDuration: Duration(milliseconds: 2500),
                                                                                                        alignment: Alignment.center,
                                                                                                        backgroundColor: Colors.green,
                                                                                                        foregroundColor: Colors.white,
                                                                                                        icon: Icon(Icons.check_circle, color: Colors.white,),
                                                                                                        animationDuration: Duration(milliseconds: 1000),
                                                                                                        showProgressBar: false
                                                                                                    );
                                                  
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                                    width: MediaQuery.of(context).size.width * .05,
                                                                                                    // width: MediaQuery.of(context).size.width * .15,
                                                  
                                                                                                    // height: 60,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color:Colors.blue ,
                                                                                                      border: Border.all(
                                                                                                          color:Colors.blue ,
                                                                                                          width: 1.0),
                                                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                                                    ),
                                                                                                    child: Center(
                                                                                                      // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                                      child: Text(
                                                                                                        'Add',
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
                                                                                                );
                                                                                            })
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(height: 5,),
                                                                                    // Icon(Icons.add, color: Colors.blue, size: 24,),
                                                                                    Text("${solutionData['Final_description']}",
                                                                                        maxLines: 3,
                                                                                        style: GoogleFonts.montserrat(
                                                                                            fontSize: 15,
                                                                                            color: Colors.black)),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                  
                                                          SizedBox(height: 20,),
                                                          Container(
                                                            height: 170 ,
                                                            child: FutureBuilder(
                                                              future: getRelatedChallenges(tags, keywords),
                                                              builder: (context, snapshot) {
                                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                                  return Container(
                                                                      width: MediaQuery.of(context).size.width,
                                                                      child: Container(
                                                                          height: 20, // Adjust the height as needed
                                                                          width: 20,
                                                                          child: Center(
                                                                              child: CircularProgressIndicator()
                                                                          )
                                                                      )
                                                                  ); // Display a loading indicator while fetching data
                                                                } else if (snapshot.hasError) {
                                                                  return Text('Error: ${snapshot.error}');
                                                                } else {
                                                                  // List<DocumentSnapshot<Object?>>? relatedSolutions = snapshot.data;
                                                  
                                                                  List<DocumentSnapshot<Map<String, dynamic>>>? relatedChallenges = snapshot.data?.cast<DocumentSnapshot<Map<String, dynamic>>>();
                                                  
                                                                  // print("relatedSolutions: $relatedSolutions");
                                                  
                                                                  return Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal: 15.0, vertical: 8),
                                                                        child: Text("Related Challenges (${relatedChallenges?.length})",
                                                                            style: GoogleFonts.montserrat(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                                color: Colors.black)
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: ListView.builder(
                                                                          scrollDirection: Axis.horizontal,
                                                                          shrinkWrap: true,
                                                                          itemCount: relatedChallenges?.length,
                                                                          itemBuilder: (c, i) {
                                                                            // relatedSolutionlength = relatedChallenges?.length;
                                                                            // print("relatedSolutionlength: $relatedSolutionlength");
                                                                            var challengesData = relatedChallenges?[i].data() as Map<String, dynamic>;
                                                                            print(
                                                                                "solutionData: ${challengesData}");
                                                                            return InkWell(
                                                                              // onTap: (){
                                                                              //   userAboutMEProvider.updateChallengePreview(
                                                                              //       challengesData['Label'],
                                                                              //       challengesData['Description'],
                                                                              //       challengesData['Final_description'],
                                                                              //       challengesData['Impact'],
                                                                              //       challengesData['Keywords'],
                                                                              //       challengesData['tags']);
                                                                              //   // NewViewDialog(challengesData['Label'], challengesData['Description'], challengesData['Impact'],
                                                                              //   //     challengesData['Final_description'], challengesData['Keywords'], challengesData['tags'],
                                                                              //   //     challengesData['id'], challengesData, userAboutMEProvider.isRecommendedChallengeCheckedMap);
                                                                              // },
                                                                              child: Container(
                                                                                margin: EdgeInsets.symmetric(horizontal: 15),
                                                                                padding: EdgeInsets.all(12),
                                                                                width: 330,
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(
                                                                                      color: Colors.black),
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                ),
                                                                                child: SingleChildScrollView(
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Flexible(
                                                                                            child: Text(
                                                                                                "${challengesData['Label']}",
                                                                                                style: GoogleFonts.montserrat(
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    fontSize: 18,
                                                                                                    color: Colors.black)),
                                                                                          ),
                                                                                          // InkWell(
                                                                                          //   onTap: (){
                                                                                          //     _userAboutMEProvider.isRecommendedAddedChallenge(true,  relatedChallenges![i]);
                                                                                          //   },
                                                                                          //   child: Container(
                                                                                          //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                          //     width: MediaQuery.of(context).size.width * .05,
                                                                                          //     // width: MediaQuery.of(context).size.width * .15,
                                                                                          //
                                                                                          //     // height: 60,
                                                                                          //     decoration: BoxDecoration(
                                                                                          //       color:Colors.blue ,
                                                                                          //       border: Border.all(
                                                                                          //           color:Colors.blue ,
                                                                                          //           width: 1.0),
                                                                                          //       borderRadius: BorderRadius.circular(8.0),
                                                                                          //     ),
                                                                                          //     child: Center(
                                                                                          //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                          //       child: Text(
                                                                                          //         'Add',
                                                                                          //         style: GoogleFonts.montserrat(
                                                                                          //           textStyle:
                                                                                          //           Theme
                                                                                          //               .of(context)
                                                                                          //               .textTheme
                                                                                          //               .titleSmall,
                                                                                          //           fontWeight: FontWeight.bold,
                                                                                          //           color:Colors.white ,
                                                                                          //         ),
                                                                                          //       ),
                                                                                          //     ),
                                                                                          //   ),
                                                                                          // ),
                                                  
                                                                                          (userAboutMEProvider.isRecommendedChallengeCheckedMap[challengesData['id']] == true)
                                                                                              ? Text('Added',
                                                                                            style: GoogleFonts.montserrat(
                                                                                              textStyle: Theme.of(context).textTheme.titleSmall,
                                                                                              fontStyle: FontStyle.italic,
                                                                                              color: Colors.green,
                                                                                            ),
                                                                                          )
                                                                                              : InkWell(
                                                                                            onTap: () {
                                                                                              // userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                                                                              userAboutMEProvider.isRecommendedAddedChallenge(true, relatedChallenges![i]);
                                                                                              toastification.show(
                                                                                                  context: context,
                                                                                                  title: Text('${challengesData['Label']} added successfully'),
                                                                                                  autoCloseDuration: Duration(milliseconds: 2500),
                                                                                                  alignment: Alignment.center,
                                                                                                  backgroundColor: Colors.green,
                                                                                                  foregroundColor: Colors.white,
                                                                                                  icon: Icon(Icons.check_circle,
                                                                                                    color: Colors.white,),
                                                                                                  animationDuration: Duration(milliseconds: 1000),
                                                                                                  showProgressBar: false
                                                                                              );
                                                                                            },
                                                                                            child: Container(
                                                                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                              width: MediaQuery.of(context).size.width * .05,
                                                                                              // width: MediaQuery.of(context).size.width * .15,
                                                  
                                                                                              // height: 60,
                                                                                              decoration: BoxDecoration(
                                                                                                color: Colors.blue,
                                                                                                border: Border.all(
                                                                                                    color: Colors.blue,
                                                                                                    width: 1.0),
                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                              ),
                                                                                              child: Center(
                                                                                                // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                                child: Text('Add',
                                                                                                  style: GoogleFonts.montserrat(
                                                                                                    textStyle:
                                                                                                    Theme.of(
                                                                                                        context).textTheme.titleSmall,
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    color: Colors.white,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 5,),
                                                                                      // Text("${challengesData['Label']}",
                                                                                      //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                      //         fontSize: 18,
                                                                                      //         color: Colors.black)),
                                                                                      Text("${challengesData['Final_description']}",
                                                                                          maxLines: 3,
                                                                                          style: GoogleFonts.montserrat(
                                                                                              fontSize: 15,
                                                                                              color: Colors.black)
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                  
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          );
                                        }
                                      }
                                      return Container(
                                        width: MediaQuery.of(context).size.width * .6,
                                        height: MediaQuery.of(context).size.height * .5,

                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColorOfApp,
                                          ),
                                        ),
                                      );
                                    });
                              });
                        })
                )
            ),
          );
          // });
        }
    );
  }

  void NewViewDialog(Name, Description, Impact, FinalDescription, keywords, tags, insideId,document,isTrueOrFalse,AddButton){


    final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");

    // String formattedDate = formatter.format(dateTime);

    _challengesProvider.addkeywordsList(keywords);
    _challengesProvider.addProviderEditTagsList(tags);

    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
            child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery
                    .of(context)
                    .size
                    .width * 0.08, vertical: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04),
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close)),
                  ],
                ),
                iconPadding: EdgeInsets.only(top: 8, right: 16),
                content:   SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Column(
                                      children: [
                                        Flexible(
                                          // flex: 2,
                                          child: Container(
                                            // height: 400,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    (Name==""|| Name==null) ? Container() : Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        // Text("Label: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                        Text(Name,
                                                            style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold,
                                                            fontSize: 20,
                                                            color: Colors.black)
                                                        ),
                                                        // IconButton(onPressed: (){
                                                        //   Navigator.pop(context);
                                                        // },
                                                        //     icon:Icon(Icons.close)
                                                        // ),
                                                        Consumer<UserAboutMEProvider>(
                                                            builder: (c,userAboutMEProvider, _){
                                                              return
                                                                (isTrueOrFalse[insideId] == true) ? Text(
                                                                  'Added',
                                                                  style: GoogleFonts.montserrat(
                                                                    textStyle:
                                                                    Theme
                                                                        .of(context)
                                                                        .textTheme
                                                                        .titleSmall,
                                                                    fontStyle: FontStyle.italic,
                                                                    color:Colors.green ,
                                                                  ),
                                                                ) : InkWell(
                                                                  onTap: (){
                                                                    AddButton(true, document);
                                                                  },
                                                                  child: Container(
                                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                    width: MediaQuery.of(context).size.width * .05,
                                                                    // width: MediaQuery.of(context).size.width * .15,

                                                                    // height: 60,
                                                                    decoration: BoxDecoration(
                                                                      color:Colors.blue ,
                                                                      border: Border.all(
                                                                          color:Colors.blue ,
                                                                          width: 1.0),
                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                    ),
                                                                    child: Center(
                                                                      // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                      child: Text(
                                                                        'Add',
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
                                                                );
                                                            })
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    (FinalDescription==""|| FinalDescription==null) ? Container() :  Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Description: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                        Flexible(child: Text(FinalDescription,  style: GoogleFonts.montserrat(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 20,
                                                            color: Colors.black),
                                                          maxLines: null,)),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),

                                                    (Impact==""|| Impact==null) ? Container() :  Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Impact: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                        Flexible(child: Text(Impact,  style: GoogleFonts.montserrat(
                                                            fontWeight: FontWeight.w500,
                                                            fontStyle: FontStyle.italic,
                                                            fontSize: 20,
                                                            color: Colors.grey),
                                                          maxLines: null,)),
                                                      ],
                                                    ),

                                                    SizedBox(height: 10,),

                                                    (Description==""|| Description==null) ? Container() :  Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Description: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                        Flexible(child: Text(Description,  style: GoogleFonts.montserrat(
                                                            // fontWeight: FontWeight.w600,
                                                            fontSize: 16,
                                                            color: Colors.black),
                                                          maxLines: null,)),
                                                      ],
                                                    ),

                                                    SizedBox(height: 10,),




                                                    (_challengesProvider.keywords==""|| _challengesProvider.keywords==null||_challengesProvider.keywords.isEmpty) ? Container() :
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Category: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                        Flexible(
                                                          child: Consumer<ChallengesProvider>(
                                                              builder: (c,addKeywordProvider, _){
                                                                return Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Wrap(
                                                                    spacing: 10,
                                                                    runSpacing: 10,
                                                                    crossAxisAlignment: WrapCrossAlignment.start,
                                                                    alignment: WrapAlignment.start,
                                                                    runAlignment: WrapAlignment.start,
                                                                    children: addKeywordProvider.keywords.map((item){
                                                                      print("item: $item");
                                                                      print("addKeywordProvider.keywords: ${addKeywordProvider.keywords}");
                                                                      return InkWell(
                                                                        onTap: (){
                                                                          if(_tabController.index == 2){
                                                                            searchChallengescontroller.text = item;
                                                                            _challengesProvider.loadDataForPageSearchFilter(item);
                                                                            // Navigator.pop(context);
                                                                            showChallengesSelector();
                                                                          }
                                                                          if(_tabController.index == 3){
                                                                            searchbyCatcontroller.text = item;
                                                                            _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString());
                                                                            // Navigator.pop(context);
                                                                            showSolutionSelectors();
                                                                          }
                                                                        },
                                                                        child: Container(
                                                                          height: 50,
                                                                          // width: 200,
                                                                          margin: EdgeInsets.only(bottom: 10),
                                                                          padding: EdgeInsets.all(8),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: Color(0xFF00ACC1)
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(item, style: TextStyle(
                                                                                  fontWeight: FontWeight.w700,
                                                                                color: Colors.white
                                                                              ),),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                );
                                                              }),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(height: 10),

                                                    (_challengesProvider.ProviderEditTags==""|| _challengesProvider.ProviderEditTags==null||_challengesProvider.ProviderEditTags.isEmpty) ? Container() :  Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Tags: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),

                                                        Flexible(
                                                          child: Consumer<ChallengesProvider>(
                                                              builder: (c,addKeywordProvider, _){
                                                                return Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Wrap(
                                                                    spacing: 10,
                                                                    runSpacing: 10,
                                                                    crossAxisAlignment: WrapCrossAlignment.start,
                                                                    alignment: WrapAlignment.start,
                                                                    runAlignment: WrapAlignment.start,
                                                                    children: addKeywordProvider.ProviderEditTags.map((item){
                                                                      return InkWell(
                                                                        onTap: (){
                                                                          if(_tabController.index == 2){
                                                                            searchChallengescontroller.text = item;
                                                                            _challengesProvider.loadDataForPageSearchFilter(item);
                                                                            // Navigator.pop(context);
                                                                            showChallengesSelector();
                                                                          }
                                                                          if(_tabController.index == 3){
                                                                            searchbyCatcontroller.text = item;
                                                                            _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString());
                                                                            // Navigator.pop(context);
                                                                            showSolutionSelectors();
                                                                          }

                                                                        },
                                                                        child: Container(
                                                                          height: 50,
                                                                          // width: 200,
                                                                          padding: EdgeInsets.all(8),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: Colors.teal
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(item, style: TextStyle(
                                                                                  fontWeight: FontWeight.w700,
                                                                                 color: Colors.white
                                                                              ),),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                );

                                                              }),
                                                        ),
                                                      ],
                                                    ),

                                                  ]
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        Flexible(
                                          // flex: 1,
                                          child: Container(
                                            // height: 400,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    height: 170 ,
                                                    child: FutureBuilder(
                                                      future: getRelatedSolutions(tags, keywords),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return Container(
                                                              width: 330,
                                                              child: Container(
                                                                  height: 20, // Adjust the height as needed
                                                                  width: 20,
                                                                  child: Center(
                                                                      child: CircularProgressIndicator()
                                                                  )
                                                              )
                                                          ); // Display a loading indicator while fetching data
                                                        } else if (snapshot.hasError) {
                                                          return Text('Error: ${snapshot.error}');
                                                        } else {
                                                          // List<DocumentSnapshot<Object?>>? relatedSolutions = snapshot.data;
                                                          List<DocumentSnapshot<Map<String, dynamic>>>? relatedSolutions = snapshot.data?.cast<DocumentSnapshot<Map<String, dynamic>>>();

                                                          // print("relatedSolutions: $relatedSolutions");

                                                          return Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                                                child: Text("Related Solutions (${relatedSolutions?.length})",
                                                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                        fontSize: 20,
                                                                        color: Colors.black)
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: ListView.builder(
                                                                  scrollDirection: Axis.horizontal,
                                                                  shrinkWrap: true,
                                                                  itemCount: relatedSolutions?.length,
                                                                  itemBuilder: (c, i) {
                                                                    // relatedSolutionlength = relatedSolutions?.length;
                                                                    // print("relatedSolutionlength: $relatedSolutionlength");
                                                                    var solutionData = relatedSolutions?[i].data() as Map<String, dynamic>;
                                                                    print("solutionData: ${solutionData}");
                                                                    return Container(
                                                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                                                      padding: EdgeInsets.all(12),
                                                                      width: 330,
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.black),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      child: SingleChildScrollView(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Text("${solutionData['Name']}",
                                                                                      maxLines: null,
                                                                                      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                          fontSize: 18,
                                                                                          color: Colors.black)),
                                                                                ),
                                                                                SizedBox(width: 5,),
                                                                                // InkWell(
                                                                                //   onTap: (){
                                                                                //     _userAboutMEProvider.isRecommendedAddedSolutions(true, relatedSolutions![i]);
                                                                                //   },
                                                                                //   child: Container(
                                                                                //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                //     width: MediaQuery.of(context).size.width * .05,
                                                                                //     // width: MediaQuery.of(context).size.width * .15,
                                                                                //
                                                                                //     // height: 60,
                                                                                //     decoration: BoxDecoration(
                                                                                //       color:Colors.blue ,
                                                                                //       border: Border.all(
                                                                                //           color:Colors.blue ,
                                                                                //           width: 1.0),
                                                                                //       borderRadius: BorderRadius.circular(8.0),
                                                                                //     ),
                                                                                //     child: Center(
                                                                                //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                //       child: Text(
                                                                                //         'Add',
                                                                                //         style: GoogleFonts.montserrat(
                                                                                //           textStyle:
                                                                                //           Theme
                                                                                //               .of(context)
                                                                                //               .textTheme
                                                                                //               .titleSmall,
                                                                                //           fontWeight: FontWeight.bold,
                                                                                //           color:Colors.white ,
                                                                                //         ),
                                                                                //       ),
                                                                                //     ),
                                                                                //   ),
                                                                                // ),
                                                                                Consumer<UserAboutMEProvider>(
                                                                                    builder: (c,userAboutMEProvider, _){
                                                                                      return
                                                                                        (userAboutMEProvider.isRecommendedSolutionsCheckedMap[solutionData['id']] == true) ? Text(
                                                                                          'Added',
                                                                                          style: GoogleFonts.montserrat(
                                                                                            textStyle:
                                                                                            Theme
                                                                                                .of(context)
                                                                                                .textTheme
                                                                                                .titleSmall,
                                                                                            fontStyle: FontStyle.italic,
                                                                                            color:Colors.green ,
                                                                                          ),
                                                                                        ) : InkWell(
                                                                                          onTap: (){
                                                                                            // userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                                                                            userAboutMEProvider.isRecommendedAddedSolutions(true, relatedSolutions![i]);
                                                                                            toastification.show(context: context,
                                                                                                title: Text('${solutionData['Name']} added successfully'),
                                                                                                autoCloseDuration: Duration(milliseconds: 2500),
                                                                                                alignment: Alignment.center,
                                                                                                backgroundColor: Colors.green,
                                                                                                foregroundColor: Colors.white,
                                                                                                icon: Icon(Icons.check_circle, color: Colors.white,),
                                                                                                animationDuration: Duration(milliseconds: 1000),
                                                                                                showProgressBar: false
                                                                                            );
                                                                                          },
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                            width: MediaQuery.of(context).size.width * .05,
                                                                                            // width: MediaQuery.of(context).size.width * .15,

                                                                                            // height: 60,
                                                                                            decoration: BoxDecoration(
                                                                                              color:Colors.blue ,
                                                                                              border: Border.all(
                                                                                                  color:Colors.blue ,
                                                                                                  width: 1.0),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            child: Center(
                                                                                              // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                              child: Text(
                                                                                                'Add',
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
                                                                                        );
                                                                                    })
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 5,),
                                                                            // Icon(Icons.add, color: Colors.blue, size: 24,),
                                                                            Text("${solutionData['Final_description']}",
                                                                                maxLines: 3,
                                                                                style: GoogleFonts.montserrat(
                                                                                    fontSize: 15,
                                                                                    color: Colors.black)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 20,),
                                                  Container(
                                                    height: 170 ,
                                                    child: FutureBuilder(
                                                      future: getRelatedChallenges(tags, keywords),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return Container(
                                                              width: 330,
                                                              child: Container(
                                                                  height: 20, // Adjust the height as needed
                                                                  width: 20,
                                                                  child: Center(
                                                                      child: CircularProgressIndicator()
                                                                  )
                                                              )
                                                          ); // Display a loading indicator while fetching data
                                                        } else if (snapshot.hasError) {
                                                          return Text('Error: ${snapshot.error}');
                                                        } else {
                                                          // List<DocumentSnapshot<Object?>>? relatedSolutions = snapshot.data;
                                                          List<DocumentSnapshot<Map<String, dynamic>>>? relatedChallenges = snapshot.data?.cast<DocumentSnapshot<Map<String, dynamic>>>();

                                                          // print("relatedSolutions: $relatedSolutions");

                                                          return Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                                                child: Text("Related Challenges (${relatedChallenges?.length})",
                                                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                        fontSize: 20,
                                                                        color: Colors.black)
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: ListView.builder(
                                                                  scrollDirection: Axis.horizontal,
                                                                  shrinkWrap: true,
                                                                  itemCount: relatedChallenges?.length,
                                                                  itemBuilder: (c, i) {
                                                                    // relatedSolutionlength = relatedChallenges?.length;
                                                                    // print("relatedSolutionlength: $relatedSolutionlength");
                                                                    var challengesData = relatedChallenges?[i].data() as Map<String, dynamic>;
                                                                    print("solutionData: ${challengesData}");
                                                                    return Container(
                                                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                                                      padding: EdgeInsets.all(12),
                                                                      width: 330,
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.black),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      child: SingleChildScrollView(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Text("${challengesData['Label']}",
                                                                                      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                          fontSize: 18,
                                                                                          color: Colors.black)),
                                                                                ),
                                                                                // InkWell(
                                                                                //   onTap: (){
                                                                                //     _userAboutMEProvider.isRecommendedAddedChallenge(true,  relatedChallenges![i]);
                                                                                //   },
                                                                                //   child: Container(
                                                                                //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                //     width: MediaQuery.of(context).size.width * .05,
                                                                                //     // width: MediaQuery.of(context).size.width * .15,
                                                                                //
                                                                                //     // height: 60,
                                                                                //     decoration: BoxDecoration(
                                                                                //       color:Colors.blue ,
                                                                                //       border: Border.all(
                                                                                //           color:Colors.blue ,
                                                                                //           width: 1.0),
                                                                                //       borderRadius: BorderRadius.circular(8.0),
                                                                                //     ),
                                                                                //     child: Center(
                                                                                //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                //       child: Text(
                                                                                //         'Add',
                                                                                //         style: GoogleFonts.montserrat(
                                                                                //           textStyle:
                                                                                //           Theme
                                                                                //               .of(context)
                                                                                //               .textTheme
                                                                                //               .titleSmall,
                                                                                //           fontWeight: FontWeight.bold,
                                                                                //           color:Colors.white ,
                                                                                //         ),
                                                                                //       ),
                                                                                //     ),
                                                                                //   ),
                                                                                // ),
                                                                                Consumer<UserAboutMEProvider>(
                                                                                    builder: (c,userAboutMEProvider, _){
                                                                                      return
                                                                                        (userAboutMEProvider.isRecommendedChallengeCheckedMap[challengesData['id']] == true) ? Text(
                                                                                          'Added',
                                                                                          style: GoogleFonts.montserrat(
                                                                                            textStyle:
                                                                                            Theme
                                                                                                .of(context)
                                                                                                .textTheme
                                                                                                .titleSmall,
                                                                                            fontStyle: FontStyle.italic,
                                                                                            color:Colors.green ,
                                                                                          ),
                                                                                        ) : InkWell(
                                                                                          onTap: (){
                                                                                            // userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                                                                            userAboutMEProvider.isRecommendedAddedChallenge(true, relatedChallenges![i]);
                                                                                            toastification.show(context: context,
                                                                                                title: Text('${challengesData['Label']} added successfully'),
                                                                                                autoCloseDuration: Duration(milliseconds: 2500),
                                                                                                alignment: Alignment.center,
                                                                                                backgroundColor: Colors.green,
                                                                                                foregroundColor: Colors.white,
                                                                                                icon: Icon(Icons.check_circle, color: Colors.white,),
                                                                                                animationDuration: Duration(milliseconds: 1000),
                                                                                                showProgressBar: false
                                                                                            );

                                                                                          },
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                            width: MediaQuery.of(context).size.width * .05,
                                                                                            // width: MediaQuery.of(context).size.width * .15,

                                                                                            // height: 60,
                                                                                            decoration: BoxDecoration(
                                                                                              color:Colors.blue ,
                                                                                              border: Border.all(
                                                                                                  color:Colors.blue ,
                                                                                                  width: 1.0),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            child: Center(
                                                                                              // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                              child: Text(
                                                                                                'Add',
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
                                                                                        );
                                                                                    })

                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 5,),
                                                                            // Text("${challengesData['Label']}",
                                                                            //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                            //         fontSize: 18,
                                                                            //         color: Colors.black)),
                                                                            Text("${challengesData['Final_description']}",
                                                                                maxLines: 3,
                                                                                style: GoogleFonts.montserrat(
                                                                                    fontSize: 15,
                                                                                    color: Colors.black)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                )
            ),
          );
          // });
        }
    );
  }

  void ViewSolutionsDialog(documentReference,Id, Name, Description, newvalues, keywords, createdat, createdby,tags, modifiedBy,modifiedDate,insideId,documentsss){


    DateTime dateTime = createdat.toDate();


    final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");


    String formattedDate = formatter.format(dateTime);


    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
            child: AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery
                    .of(context)
                    .size
                    .width * 0.08, vertical: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04),
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.close)),
                  ],
                ),
                iconPadding: EdgeInsets.only(top: 8, right: 16),
                content:   SizedBox(
                  width: double.maxFinite,
                  child: StatefulBuilder(
                      builder: (context,innerState) {
                        return FutureBuilder (
                            future: fetchDetails(documentReference),
                            builder: (ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                // If we got an error
                                if (snapshot.hasError) {
                                  return Text(
                                      snapshot.error.toString(),
                                      style: GoogleFonts.montserrat(
                                          textStyle:
                                          Theme.of(context).textTheme.bodyLarge,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)
                                  );

                                  // if we got our data
                                }
                                else if (snapshot.hasData) {
                                  DocumentSnapshot? doc = snapshot.data;

                                  var name = doc?.get("Name");
                                  // var Description = doc?.get("Description");
                                  // var OriginalDescription = doc?.get('Original Description');
                                  var FinalDescription = doc?.get('Final_description');
                                  var Impact = doc?.get('Impact');

                                  // var Category = doc?.get("Category");
                                  // var Source = (doc?.get("Source") == "" ||doc?.get("Source") == null )?"MTH RfA email 20240130":doc?.get("Source");
                                  // var Status = (doc?.get("Challenge Status") == "" ||doc?.get("Challenge Status") == null ) ? 'New' : doc?.get("Challenge Status");

                                  SolutionseditKeywordssss = doc?.get("Keywords");
                                  Solutionsedittags = doc?.get("tags");

                                  _addKeywordProvider.addkeywordsList(SolutionseditKeywordssss);
                                  _addKeywordProvider.addProviderEditTagsList(Solutionsedittags);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Column(
                                      children: [
                                        Flexible(
                                          // flex: 2,
                                          child: Container(
                                            // height: 400,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    // (Source==""|| Source==null) ? Container() :  Row(
                                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                                    //   children: [
                                                    //     Text("Source: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                    //     Text(Source, style: TextStyle(fontSize: 20,),),
                                                    //
                                                    //   ],
                                                    // ),
                                                    // SizedBox(height: 10,),
                                                    // (Status==""|| Status==null) ? Container() :  Row(
                                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                                    //   children: [
                                                    //     Text("Challenge Status: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                    //     Text(Status, style: TextStyle(fontSize: 20, ),),
                                                    //
                                                    //   ],
                                                    // ),
                                                    // SizedBox(height: 10,),
                                                    (name==""|| name==null) ? Container() : Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        // Text("Label: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                        Text(name,
                                                            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                            fontSize: 20,
                                                            color: Colors.black)),

                                                        // IconButton(onPressed: (){
                                                        //   Navigator.pop(context);
                                                        // },
                                                        //     icon:Icon(Icons.close)
                                                        // ),



                                                        Consumer<UserAboutMEProvider>(
                                                            builder: (c,userAboutMEProvider, _){
                                                              return
                                                                (userAboutMEProvider.isRecommendedSolutionsCheckedMap[insideId] == true) ? Text(
                                                                  'Added',
                                                                  style: GoogleFonts.montserrat(
                                                                    textStyle:
                                                                    Theme
                                                                        .of(context)
                                                                        .textTheme
                                                                        .titleSmall,
                                                                    fontStyle: FontStyle.italic,
                                                                    color:Colors.green ,
                                                                  ),
                                                                ) : InkWell(
                                                                  onTap: (){
                                                                    userAboutMEProvider.isRecommendedAddedSolutions(true,documentsss);
                                                                    toastification.show(context: context,
                                                                        title: Text('${name} added successfully'),
                                                                        autoCloseDuration: Duration(milliseconds: 2500),
                                                                        alignment: Alignment.center,
                                                                        backgroundColor: Colors.green,
                                                                        foregroundColor: Colors.white,
                                                                        icon: Icon(Icons.check_circle, color: Colors.white,),
                                                                        animationDuration: Duration(milliseconds: 1000),
                                                                        showProgressBar: false
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                    width: MediaQuery.of(context).size.width * .05,
                                                                    // width: MediaQuery.of(context).size.width * .15,

                                                                    // height: 60,
                                                                    decoration: BoxDecoration(
                                                                      color:Colors.blue ,
                                                                      border: Border.all(
                                                                          color:Colors.blue ,
                                                                          width: 1.0),
                                                                      borderRadius: BorderRadius.circular(8.0),
                                                                    ),
                                                                    child: Center(
                                                                      // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                      child: Text(
                                                                        'Add',
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
                                                                );
                                                            })

                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    (FinalDescription==""|| FinalDescription==null) ? Container() :  Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Description: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                        Flexible(child: Text(FinalDescription,  style: GoogleFonts.montserrat(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 20,
                                                            color: Colors.black),
                                                          maxLines: null,)),
                                                      ],
                                                    ),

                                                    SizedBox(height: 5,),

                                                    (Impact==""|| Impact==null) ? Container() :  Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Impact: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                        Flexible(child: Text(Impact,  style: GoogleFonts.montserrat(
                                                            fontWeight: FontWeight.w500,
                                                            fontStyle: FontStyle.italic,
                                                            fontSize: 20,
                                                            color: Colors.grey),
                                                          maxLines: null,)),
                                                      ],
                                                    ),

                                                    SizedBox(height: 10,),


                                                    (Description==""|| Description==null) ? Container() :  Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Description: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                        Flexible(child: Text(Description,  style: GoogleFonts.montserrat(
                                                            // fontWeight: FontWeight.w400,
                                                            fontSize: 16,
                                                            color: Colors.black),
                                                          maxLines: null,)),
                                                      ],
                                                    ),

                                                    SizedBox(height: 10,),




                                                    (_addKeywordProvider.keywords==""|| _addKeywordProvider.keywords==null||_addKeywordProvider.keywords.isEmpty) ? Container() :
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Category: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                        Flexible(
                                                          child: Consumer<AddKeywordProvider>(
                                                              builder: (c,addKeywordProvider, _){
                                                                return Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Wrap(
                                                                    spacing: 10,
                                                                    runSpacing: 10,
                                                                    crossAxisAlignment: WrapCrossAlignment.start,
                                                                    alignment: WrapAlignment.start,
                                                                    runAlignment: WrapAlignment.start,
                                                                    children: addKeywordProvider.keywords.map((item){
                                                                      print("item: $item");
                                                                      print("addKeywordProvider.keywords: ${addKeywordProvider.keywords}");
                                                                      return InkWell(
                                                                        onTap: (){
                                                                          searchbyCatcontroller.text = item;
                                                                          _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString());
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Container(
                                                                          height: 50,
                                                                          // width: 200,
                                                                          margin: EdgeInsets.only(bottom: 10),
                                                                          padding: EdgeInsets.all(8),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              // color: Colors.lightGreen
                                                                              color: Color(0xFF00ACC1)
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(item, style: TextStyle(
                                                                                  fontWeight: FontWeight.w700,
                                                                                color: Colors.white
                                                                              ),),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                );
                                                              }),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(height: 10),

                                                    (_addKeywordProvider.ProviderEditTags==""|| _addKeywordProvider.ProviderEditTags==null||_addKeywordProvider.ProviderEditTags.isEmpty) ? Container() :  Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        // Text("Tags: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),

                                                        Flexible(
                                                          child: Consumer<AddKeywordProvider>(
                                                              builder: (c,addKeywordProvider, _){
                                                                return Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Wrap(
                                                                    spacing: 10,
                                                                    runSpacing: 10,
                                                                    crossAxisAlignment: WrapCrossAlignment.start,
                                                                    alignment: WrapAlignment.start,
                                                                    runAlignment: WrapAlignment.start,
                                                                    // children: addKeywordProvider.ProviderEditTags.map((item){
                                                                    children: addKeywordProvider.ProviderEditTags.map((item){
                                                                      return InkWell(
                                                                        onTap: (){
                                                                          searchbyCatcontroller.text = item;
                                                                          _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString());
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Container(
                                                                          height: 50,
                                                                          // width: 200,
                                                                          padding: EdgeInsets.all(8),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: Colors.teal
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(item, style: TextStyle(
                                                                                  fontWeight: FontWeight.w700,
                                                                                color: Colors.white
                                                                              ),),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                );

                                                              }),
                                                        ),
                                                      ],
                                                    ),

                                                  ]
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        Flexible(
                                          // flex: 1,
                                          child: Container(
                                            // height: 400,
                                            padding: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    height: 170 ,
                                                    child: FutureBuilder(
                                                      future: getRelatedSolutions(tags, keywords),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return Container(
                                                              width: MediaQuery.of(context).size.width,
                                                              child: Container(
                                                                  height: 20, // Adjust the height as needed
                                                                  width: 20,
                                                                  child: Center(
                                                                      child: CircularProgressIndicator()
                                                                  )
                                                              )
                                                          ); // Display a loading indicator while fetching data
                                                        } else if (snapshot.hasError) {
                                                          return Text('Error: ${snapshot.error}');
                                                        } else {
                                                          // List<DocumentSnapshot<Object?>>? relatedSolutions = snapshot.data;
                                                          List<DocumentSnapshot<Map<String, dynamic>>>? relatedSolutions = snapshot.data?.cast<DocumentSnapshot<Map<String, dynamic>>>();

                                                          // print("relatedSolutions: $relatedSolutions");

                                                          return Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                                                child: Text("Related Solutions (${relatedSolutions?.length})",
                                                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                        fontSize: 20,
                                                                        color: Colors.black)
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: ListView.builder(
                                                                  scrollDirection: Axis.horizontal,
                                                                  shrinkWrap: true,
                                                                  itemCount: relatedSolutions?.length,
                                                                  itemBuilder: (c, i) {
                                                                    // relatedSolutionlength = relatedSolutions?.length;
                                                                    // print("relatedSolutionlength: $relatedSolutionlength");
                                                                    var solutionData = relatedSolutions?[i].data() as Map<String, dynamic>;
                                                                    print("solutionData: ${solutionData}");
                                                                    return Container(
                                                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                                                      padding: EdgeInsets.all(12),
                                                                      width: 330,
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.black),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      child: SingleChildScrollView(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Text("${solutionData['Name']}",
                                                                                      maxLines: null,
                                                                                      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                          fontSize: 18,
                                                                                          color: Colors.black)),
                                                                                ),
                                                                                SizedBox(width: 5,),

                                                                                // InkWell(
                                                                                //   onTap: (){
                                                                                //     _userAboutMEProvider.isRecommendedAddedSolutions(true,relatedSolutions![i]);
                                                                                //   },
                                                                                //   child: Container(
                                                                                //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                //     width: MediaQuery.of(context).size.width * .05,
                                                                                //     // width: MediaQuery.of(context).size.width * .15,
                                                                                //
                                                                                //     // height: 60,
                                                                                //     decoration: BoxDecoration(
                                                                                //       color:Colors.blue ,
                                                                                //       border: Border.all(
                                                                                //           color:Colors.blue ,
                                                                                //           width: 1.0),
                                                                                //       borderRadius: BorderRadius.circular(8.0),
                                                                                //     ),
                                                                                //     child: Center(
                                                                                //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                //       child: Text(
                                                                                //         'Add',
                                                                                //         style: GoogleFonts.montserrat(
                                                                                //           textStyle:
                                                                                //           Theme
                                                                                //               .of(context)
                                                                                //               .textTheme
                                                                                //               .titleSmall,
                                                                                //           fontWeight: FontWeight.bold,
                                                                                //           color:Colors.white ,
                                                                                //         ),
                                                                                //       ),
                                                                                //     ),
                                                                                //   ),
                                                                                // ),

                                                                                Consumer<UserAboutMEProvider>(
                                                                                    builder: (c,userAboutMEProvider, _){
                                                                                      return
                                                                                        (userAboutMEProvider.isRecommendedSolutionsCheckedMap[solutionData['id']] == true) ? Text(
                                                                                          'Added',
                                                                                          style: GoogleFonts.montserrat(
                                                                                            textStyle:
                                                                                            Theme
                                                                                                .of(context)
                                                                                                .textTheme
                                                                                                .titleSmall,
                                                                                            fontStyle: FontStyle.italic,
                                                                                            color:Colors.green ,
                                                                                          ),
                                                                                        ) : InkWell(
                                                                                          onTap: (){
                                                                                            // userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                                                                            userAboutMEProvider.isRecommendedAddedSolutions(true, relatedSolutions![i]);
                                                                                            toastification.show(context: context,
                                                                                                title: Text('${solutionData['Name']} added successfully'),
                                                                                                autoCloseDuration: Duration(milliseconds: 2500),
                                                                                                alignment: Alignment.center,
                                                                                                backgroundColor: Colors.green,
                                                                                                foregroundColor: Colors.white,
                                                                                                icon: Icon(Icons.check_circle, color: Colors.white,),
                                                                                                animationDuration: Duration(milliseconds: 1000),
                                                                                                showProgressBar: false
                                                                                            );

                                                                                          },
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                            width: MediaQuery.of(context).size.width * .05,
                                                                                            // width: MediaQuery.of(context).size.width * .15,

                                                                                            // height: 60,
                                                                                            decoration: BoxDecoration(
                                                                                              color:Colors.blue ,
                                                                                              border: Border.all(
                                                                                                  color:Colors.blue ,
                                                                                                  width: 1.0),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            child: Center(
                                                                                              // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                              child: Text(
                                                                                                'Add',
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
                                                                                        );
                                                                                    })

                                                                              ],
                                                                            ),

                                                                            SizedBox(height: 5,),
                                                                            // Icon(Icons.add, color: Colors.blue, size: 24,),
                                                                            Text("${solutionData['Final_description']}",
                                                                                maxLines: 3,
                                                                                style: GoogleFonts.montserrat(
                                                                                    fontSize: 15,
                                                                                    color: Colors.black)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 20,),
                                                  Container(
                                                    height: 170 ,
                                                    child: FutureBuilder(
                                                      future: getRelatedChallenges(tags, keywords),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                                          return Container(
                                                              width: MediaQuery.of(context).size.width,
                                                              // width: 330,
                                                              child: Container(
                                                                  height: 20, // Adjust the height as needed
                                                                  width: 20,
                                                                  child: Center(
                                                                      child: CircularProgressIndicator()
                                                                  )
                                                              )
                                                          ); // Display a loading indicator while fetching data
                                                        } else if (snapshot.hasError) {
                                                          return Text('Error: ${snapshot.error}');
                                                        } else {
                                                          // List<DocumentSnapshot<Object?>>? relatedSolutions = snapshot.data;
                                                          List<DocumentSnapshot<Map<String, dynamic>>>? relatedChallenges = snapshot.data?.cast<DocumentSnapshot<Map<String, dynamic>>>();

                                                          // print("relatedSolutions: $relatedSolutions");

                                                          return Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                                                child: Text("Related Challenges (${relatedChallenges?.length})",
                                                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                        fontSize: 20,
                                                                        color: Colors.black)
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: ListView.builder(
                                                                  scrollDirection: Axis.horizontal,
                                                                  shrinkWrap: true,
                                                                  itemCount: relatedChallenges?.length,
                                                                  itemBuilder: (c, i) {
                                                                    // relatedSolutionlength = relatedChallenges?.length;
                                                                    // print("relatedSolutionlength: $relatedSolutionlength");
                                                                    var challengesData = relatedChallenges?[i].data() as Map<String, dynamic>;
                                                                    print("solutionData: ${challengesData}");
                                                                    return Container(
                                                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                                                      padding: EdgeInsets.all(12),
                                                                      width: 330,
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.black),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      child: SingleChildScrollView(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Flexible(
                                                                                  child: Text("${challengesData['Label']}",
                                                                                      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                          fontSize: 18,
                                                                                          color: Colors.black)),
                                                                                ),
                                                                                // InkWell(
                                                                                //   onTap: (){
                                                                                //     _userAboutMEProvider.isRecommendedAddedChallenge(true, relatedChallenges![i]);
                                                                                //   },
                                                                                //   child: Container(
                                                                                //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                //     width: MediaQuery.of(context).size.width * .05,
                                                                                //     // width: MediaQuery.of(context).size.width * .15,
                                                                                //
                                                                                //     // height: 60,
                                                                                //     decoration: BoxDecoration(
                                                                                //       color:Colors.blue ,
                                                                                //       border: Border.all(
                                                                                //           color:Colors.blue ,
                                                                                //           width: 1.0),
                                                                                //       borderRadius: BorderRadius.circular(8.0),
                                                                                //     ),
                                                                                //     child: Center(
                                                                                //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                //       child: Text(
                                                                                //         'Add',
                                                                                //         style: GoogleFonts.montserrat(
                                                                                //           textStyle:
                                                                                //           Theme
                                                                                //               .of(context)
                                                                                //               .textTheme
                                                                                //               .titleSmall,
                                                                                //           fontWeight: FontWeight.bold,
                                                                                //           color:Colors.white ,
                                                                                //         ),
                                                                                //       ),
                                                                                //     ),
                                                                                //   ),
                                                                                // ),

                                                                                Consumer<UserAboutMEProvider>(
                                                                                    builder: (c,userAboutMEProvider, _){
                                                                                      return
                                                                                        (userAboutMEProvider.isRecommendedChallengeCheckedMap[challengesData['id']] == true) ? Text(
                                                                                          'Added',
                                                                                          style: GoogleFonts.montserrat(
                                                                                            textStyle:
                                                                                            Theme
                                                                                                .of(context)
                                                                                                .textTheme
                                                                                                .titleSmall,
                                                                                            fontStyle: FontStyle.italic,
                                                                                            color:Colors.green ,
                                                                                          ),
                                                                                        ) : InkWell(
                                                                                          onTap: (){
                                                                                            // userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                                                                            userAboutMEProvider.isRecommendedAddedChallenge(true, relatedChallenges![i]);
                                                                                            toastification.show(context: context,
                                                                                                title: Text('${challengesData['Label']} added successfully'),
                                                                                                autoCloseDuration: Duration(milliseconds: 2500),
                                                                                                alignment: Alignment.center,
                                                                                                backgroundColor: Colors.green,
                                                                                                foregroundColor: Colors.white,
                                                                                                icon: Icon(Icons.check_circle, color: Colors.white,),
                                                                                                animationDuration: Duration(milliseconds: 1000),
                                                                                                showProgressBar: false
                                                                                            );

                                                                                          },
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                            width: MediaQuery.of(context).size.width * .05,
                                                                                            // width: MediaQuery.of(context).size.width * .15,

                                                                                            // height: 60,
                                                                                            decoration: BoxDecoration(
                                                                                              color:Colors.blue ,
                                                                                              border: Border.all(
                                                                                                  color:Colors.blue ,
                                                                                                  width: 1.0),
                                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                                            ),
                                                                                            child: Center(
                                                                                              // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                                                                              child: Text(
                                                                                                'Add',
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
                                                                                        );
                                                                                    })

                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 5,),
                                                                            // Text("${challengesData['Label']}",
                                                                            //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                            //         fontSize: 18,
                                                                            //         color: Colors.black)),
                                                                            Text("${challengesData['Final_description']}",
                                                                                maxLines: 3,
                                                                                style: GoogleFonts.montserrat(
                                                                                    fontSize: 15,
                                                                                    color: Colors.black)),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                              return Container(
                                width: MediaQuery.of(context).size.width * .6,
                                height: MediaQuery.of(context).size.height * .5,

                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColorOfApp,
                                  ),
                                ),
                                );
                            });
                      }),
                )
            ),
          );
          // });
        }
    );
  }



  Future<List<DocumentSnapshot>> getRelatedSolutions(List<dynamic> tags, List<dynamic> keywords) async {
    // Assuming your Firestore collection is named "solutions"
    CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Thrivers');

    print("relatedd tagsss: $tags");
    // Perform a query based on tags and keywords
    QuerySnapshot tagsQuery = await solutionsCollection
        .where('tags', arrayContainsAny: tags).limit(10)
        .get();

    QuerySnapshot keywordsQuery = await solutionsCollection
        .where('Keywords', arrayContainsAny: keywords).limit(10)
        .get();

    // Combine the results of both queries
    List<DocumentSnapshot> tagsResults = tagsQuery.docs;
    List<DocumentSnapshot> keywordsResults = keywordsQuery.docs;

    // Use a set to avoid duplicate documents
    Set<DocumentSnapshot> combinedResults = Set.from(tagsResults);
    combinedResults.addAll(keywordsResults);

    return combinedResults.toList();
  }

  Future<List<DocumentSnapshot>> getRelatedChallenges(List<dynamic> tags, List<dynamic> keywords) async {
    // Assuming your Firestore collection is named "solutions"
    CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Challenges');

    print("relatedd tagsss: $tags");
    // Perform a query based on tags and keywords
    QuerySnapshot tagsQuery = await solutionsCollection
        .where('tags', arrayContainsAny: tags).limit(10)
        .get();

    QuerySnapshot keywordsQuery = await solutionsCollection
        .where('Keywords', arrayContainsAny: keywords).limit(10)
        .get();

    // Combine the results of both queries
    List<DocumentSnapshot> tagsResults = tagsQuery.docs;
    List<DocumentSnapshot> keywordsResults = keywordsQuery.docs;

    // Use a set to avoid duplicate documents
    Set<DocumentSnapshot> combinedResults = Set.from(tagsResults);
    combinedResults.addAll(keywordsResults);

    return combinedResults.toList();
  }

  Future<DocumentSnapshot> fetchDetails(DocumentReference docRef) async {
    return await docRef.get();
  }

  List _messages = [];
  var openAiApiKeyFromFirebase;

  var _openAI;


  Future<String> getChatgptSettingsApiKey() async {
    String apiKey = "";

    await FirebaseFirestore.instance.collection('ChatGpt-Settings').doc("OpenAI").get().then((value) {

      apiKey = value['APIKey'];
      openAiApiKeyFromFirebase = apiKey;
      _openAI = OpenAI.instance.build(

        token: openAiApiKeyFromFirebase,
        baseOption: HttpSetup(
          receiveTimeout: const Duration(
            seconds: 20,
          ),
        ),
        enableLog: true,
      );

    });
    return apiKey;

  }

  Future<String> newSelectCategories() async {
    List<String> matches = [];
    String documentId = "CUTs7fvcYX2dN9TnDj4c";
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('Keywords').doc("CUTs7fvcYX2dN9TnDj4c").get();

      if (docSnapshot.exists) {
        dynamic data = docSnapshot.data();
        // print(" docSnapshot.data $data");
        if (data != null && data.containsKey('Values')) {
          // You can use the document ID directly here
          // String key = data['Key'].toString().toLowerCase();
          List<String> values = data.containsKey('Values') ? data['Values'].cast<String>() : [];
          // print(" values ; $values");
          matches.addAll(values);
        }
      }
    } catch (e) {
      print("Error getting suggestions: $e");
    }
    resultString = matches.join(', ');
    print("resultString $resultString");
    return resultString;
  }

  List<dynamic> generatedtags = [];
  List<dynamic> generatedsolutionstags = [];
  List<dynamic> generatedcategory = [];
  List<dynamic> generatedsolutionscategory = [];


  Future<void> getChatRefineResponse(defaulttext) async {
    setState(() {
      _messages.insert(0, defaulttext);
      // _typingUsers.add(_gptChatUser);
    });
    ProgressDialog.show(context, "Refine", Icons.search);

    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: defaulttext);
    }).toList();
    final request = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory,
      maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() async {
          // String gptResponse = element.message!.content;
          // String responseContent = gptResponse.replaceAll(', ', ',');
          RefineController.text = element.message!.content;
          _userAboutMEProvider.updateisRefinetextChange(true);
          // generatedsolutionstags.addAll(generatedtags);

          ProgressDialog.hide();

          var defaulttext1 = "Generate related tags using this line in a one list with ',' :${RefineController.text}";
          //
          // var defaulttext =  q1+""+q2+" "+q3 + " where yyy is "+mycircumstancesController.text+" "+ MystrengthsController.text +" "+myOrganisationController.text;


          var defaulttextq2 = "These are the category list: $resultString. Choose the categories that describe this text: $defaulttext1.";

          // print(defaulttext);
          print("defaulttextq2 $defaulttextq2");

          await getChatKeywordsResponse(defaulttext1,defaulttextq2);
          //
          await _userAboutMEProvider.getRelatedChallenges(generatedtags, generatedcategory);
        });
        print("isRefinetextChange: ${_userAboutMEProvider.isRefinetextChange}");
        print("RefineController.text: ${RefineController.text}");
        print("response: ${element.message!.content}");
      }
    }



  }

  Future<void> getChatKeywordsResponse(defaulttext, defaulttextq2) async {
    setState(() {
      _messages.insert(0, defaulttext);
      // _typingUsers.add(_gptChatUser);
    });
    ProgressDialog.show(context, "Search", Icons.search);

    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: defaulttext);
    }).toList();
    final request = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory,
      maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          String gptResponse = element.message!.content;
          String responseContent = gptResponse.replaceAll(', ', ',');
          generatedtags = responseContent.split(',');
          generatedsolutionstags.addAll(generatedtags);
        });
        print("generatedtags: ${generatedtags}");
        print("response: ${element.message!.content}");
      }
    }

    List<Messages> _messagesHistory2 = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: defaulttextq2);
    }).toList();
    final request2 = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory2,
      maxToken: 200,
    );
    final response2 = await _openAI.onChatCompletion(request: request2);
    for (var element in response2!.choices) {
      if (element.message != null) {
        setState(() {
          String gptResponse = element.message!.content;
          print("gptResponse: $gptResponse");
          String responseContent = gptResponse.replaceAll(', ', ',');
          generatedcategory = responseContent.split(',');
          generatedsolutionscategory.addAll(generatedcategory);

        });
        print("generatedcategory: ${generatedcategory}");
        print("response: ${element.message!.content}");
      }
    }

    ProgressDialog.hide();

  }

  Future<void> getChatResponse(defaulttext, defaulttextq2) async {
    setState(() {
      _messages.insert(0, defaulttext);
      // _typingUsers.add(_gptChatUser);
    });
    ProgressDialog.show(context, "Clean", Icons.search);

    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: defaulttext);
    }).toList();
    final request = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory,
      maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          String gptResponse = element.message!.content;
          String responseContent = gptResponse.replaceAll(', ', ',');
          generatedtags = responseContent.split(',');
          generatedsolutionstags.addAll(generatedtags);
        });
        print("generatedtags: ${generatedtags}");
        print("response: ${element.message!.content}");
      }
    }

    List<Messages> _messagesHistory2 = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: defaulttextq2);
    }).toList();
    final request2 = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory2,
      maxToken: 200,
    );
    final response2 = await _openAI.onChatCompletion(request: request2);
    for (var element in response2!.choices) {
      if (element.message != null) {
        setState(() {
          String gptResponse = element.message!.content;
          print("gptResponse: $gptResponse");
          String responseContent = gptResponse.replaceAll(', ', ',');
          generatedcategory = responseContent.split(',');
          generatedsolutionscategory.addAll(generatedcategory);

        });
        print("generatedcategory: ${generatedcategory}");
        print("response: ${element.message!.content}");
      }
    }

    ProgressDialog.hide();

  }   ///backup



  List<DocumentSnapshot> RelatedChallengesdocuments = [];
  List<DocumentSnapshot> RelatedSolutionsdocuments = [];




  /*void showSolutionChallengesSelectorTabBar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 2,
          child: AlertDialog(
            actions: [
              Consumer<UserAboutMEProvider>(
                builder: (context, userAboutMEProvider, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          userAboutMEProvider.clearSelectedSolutions();
                          userAboutMEProvider.isCheckedMap.clear();
                          userAboutMEProvider.isCheckedMapchallenge.clear();

                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width * .3,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                            child: Text(
                              'Close',
                              style: GoogleFonts.montserrat(
                                textStyle:
                                Theme.of(context).textTheme.titleSmall,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5, height: 5),
                      InkWell(
                        onTap: () {
                          userAboutMEProvider.addsolutions();
                          userAboutMEProvider.clearSelectedSolutions();
                          userAboutMEProvider.isCheckedMap.clear();
                          userAboutMEProvider.isCheckedMapchallenge.clear();
                          Navigator.pop(context);
                          print("solutions: $solutions");
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .3,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(color: Colors.blue, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                            child: Text(
                              'Add',
                              style: GoogleFonts.montserrat(
                                textStyle:
                                Theme.of(context).textTheme.titleSmall,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              )
            ],
            // title: Text('Select Solutions'),
            title: Column(
              children: [
                TabBar(
                  labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black),
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Select Solutions',),
                    Tab(text: 'Select Challenges',),
                  ],
                  indicatorColor: Colors.blue,
                ),
                SizedBox(height: 10), // Add some spacing between TabBar and content
              ],
            ),

            content: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                  child: TextField(
                    controller: searchbyCatcontroller,
                    onChanged: (val){
                      print("valuse ${val}");
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(Duration(milliseconds: _debouncetime), () {
                        if (searchbyCatcontroller.text != "") {
                          ///here you perform your search
                          // _loadDataForPageFilter(1,'tags',_addKeywordProvider.searchbytag); //(searchTextbyCKEditingController.text.toString());
                          // _loadDataForPageSearchFilter(searchTextbyCKEditingController.text.toString(),selectAllAny);
                          //
                          // if(_tabController!.index==0){
                          //   _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString(),selectAllAny);
                          //   print("documentssssssss: ${_addKeywordProvider.documents}");
                          // }
                          // else if(_tabController!.index==1){
                          //   _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString(),selectAllAny);
                          //   print("challengesdocumentssssssss: ${_challengesProvider.challengesdocuments}");
                          // }
                          _handleTabSelection();
                        }
                        else {
                          _addKeywordProvider.loadDataForPage(1);
                          _addKeywordProvider.setFirstpageNo();
                          _challengesProvider.loadDataForPage(1);
                          _challengesProvider.setFirstpageNo();

                        }
                      });
                    },
                    style: GoogleFonts.montserrat(
                      textStyle: Theme.of(context).textTheme.bodyLarge,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      suffixIcon:  Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Consumer<ChallengesProvider>(
                          //     builder: (c,challengesProvider, _){
                          //       print("addKeywordProvider.lengthOfdocument :${challengesProvider.lengthOfdocument}");
                          //       return (challengesProvider.lengthOfdocument != null) ?
                          //       Text("(${challengesProvider.lengthOfdocument})",style: Theme.of(context).textTheme.bodyMedium)
                          //           : SizedBox();
                          //     }),
                          // Consumer<AddKeywordProvider>(
                          //     builder: (c,addKeywordProvider, _){
                          //       print("addKeywordProvider.lengthOfdocument :${addKeywordProvider.lengthOfdocument}");
                          //       return (addKeywordProvider.lengthOfdocument != null) ?
                          //       Text("(${addKeywordProvider.lengthOfdocument})",style: Theme.of(context).textTheme.bodyMedium)
                          //           : SizedBox();
                          //     }),
                          ///
                          // (_addKeywordProvider.lengthOfdocument != null) ?
                          // Text("(${_addKeywordProvider.lengthOfdocument})",style: Theme.of(context).textTheme.bodyMedium)
                          // :
                          SizedBox(width: 5,),
                          InkWell(
                            onTap: () {
                              searchbyCatcontroller.clear();
                              _addKeywordProvider.loadDataForPage(1);
                              _challengesProvider.loadDataForPage(1);
                              _addKeywordProvider.lengthOfdocument = null;
                              _challengesProvider.lengthOfdocument = null;
                            },
                            child: Icon(Icons.close),
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.all(10),
                      labelText: "Search",
                      hintText: "Search",
                      errorStyle: GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.bodyLarge,
                        fontWeight: FontWeight.w400,
                        color: Colors.redAccent,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelStyle: GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.bodyLarge,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                Divider(),
                Container(
                  height: MediaQuery.of(context).size.height * .6,
                  width: MediaQuery.of(context).size.width * .6,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Consumer<AddKeywordProvider>(
                          builder: (c,addKeywordProvider, _){
                            // addKeywordProvider.getcategoryAndKeywords();
                            // addKeywordProvider.newgetSource();
                            // addKeywordProvider.getThriversStatus();
                            return
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    (addKeywordProvider.isLoadingMore) ?
                                    Center(child: CircularProgressIndicator()) :
                                    ListView.separated(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      shrinkWrap: true,
                                      itemCount: addKeywordProvider.documents.length,
                                      separatorBuilder: (BuildContext context, int index) {
                                        return Divider();
                                      },
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            ThriversListTile(
                                                addKeywordProvider.documents[index], index, addKeywordProvider.documents),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                          }),

                      Consumer<ChallengesProvider>(
                          builder: (c,challengesProvider, _){

                            return
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    (challengesProvider.isLoadingMore) ?
                                    Center(child: CircularProgressIndicator()) :
                                    ListView.separated(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      shrinkWrap: true,
                                      itemCount: challengesProvider.challengesdocuments.length,
                                      separatorBuilder: (BuildContext context, int index) {
                                        return Divider();
                                      },
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            ChallengesListTile(
                                                challengesProvider.challengesdocuments[index], index, challengesProvider.challengesdocuments),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                          }),

                      // ListView.separated(
                      //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      //   shrinkWrap: true,
                      //   itemCount: challengesdocuments.length,
                      //   separatorBuilder: (BuildContext context, int index) {
                      //     return Divider();
                      //   },
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return Column(
                      //       children: [
                      //         ChallengesListTile(challengesdocuments[index], index, challengesdocuments),
                      //       ],
                      //     );
                      //   },
                      // ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }*/  /// this is tab of solution and challenges

  void showChallengesSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Challenges'),
              InkWell(
                onTap: (){
                  _challengesProvider.lengthOfdocument = null;
                  // challengesProvider.searchbytag.clear();
                  // challengesProvider.searchbycategory.clear();
                  searchChallengescontroller.clear();
                  _challengesProvider.loadDataForPage(1);
                  _challengesProvider.setFirstpageNo();
                  Navigator.pop(context);
                },
                  child: Icon(Icons.close))
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Consumer<ChallengesProvider>(
                builder: (c,challengesProvider, _){
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                        child: TextField(
                          controller: searchChallengescontroller,

                          onChanged: (val){
                            print("valuse ${val}");
                            if (_debounce?.isActive ?? false) _debounce?.cancel();
                            _debounce = Timer(Duration(milliseconds: _debouncetime), () {
                              if (searchChallengescontroller.text != "") {
                                ///here you perform your search
                                // _loadDataForPageFilter(1,'tags',_addKeywordProvider.searchbytag); //(searchTextbyCKEditingController.text.toString());
                                // _loadDataForPageSearchFilter(searchTextbyCKEditingController.text.toString(),selectAllAny);
                                //
                                // if(_tabController!.index==0){
                                //   _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString(),selectAllAny);
                                //   print("documentssssssss: ${_addKeywordProvider.documents}");
                                // }
                                // else if(_tabController!.index==1){
                                //   _challengesProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString(),selectAllAny);
                                //   print("challengesdocumentssssssss: ${_challengesProvider.challengesdocuments}");
                                // }
                                // _addKeywordProvider.loadDataForPageSearchFilter(searchChallengescontroller.text.toString());
                                _challengesProvider.loadDataForPageSearchFilter(searchChallengescontroller.text.toString());

                                // _handleTabSelection();
                              }
                              else {
                                // _addKeywordProvider.loadDataForPage(1);
                                // _addKeywordProvider.setFirstpageNo();
                                _challengesProvider.loadDataForPage(1);
                                _challengesProvider.setFirstpageNo();

                              }
                            });
                          },
                          style: GoogleFonts.montserrat(
                              textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                          decoration: InputDecoration(
                            suffixIcon:  Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                SizedBox(width: 5,),
                                InkWell(
                                  onTap: () {
                                    searchChallengescontroller.clear();
                                    // _addKeywordProvider.loadDataForPage(1);
                                    _challengesProvider.loadDataForPage(1);
                                    // _addKeywordProvider.lengthOfdocument = null;
                                    _challengesProvider.lengthOfdocument = null;
                                  },
                                  child: Icon(Icons.close),
                                ),
                              ],
                            ),
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
                      (challengesProvider.lengthOfdocument != null) ?

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                        child: Row(
                          children: [
                            Text("Search results: ${challengesProvider.lengthOfdocument}",style: Theme.of(context).textTheme.bodyMedium),
                            SizedBox(width: 5,),
                            InkWell(
                                onTap: (){
                                  challengesProvider.lengthOfdocument = null;
                                  // challengesProvider.searchbytag.clear();
                                  // challengesProvider.searchbycategory.clear();
                                  searchChallengescontroller.clear();
                                  challengesProvider.loadDataForPage(1);
                                  challengesProvider.setFirstpageNo();
                                },
                                child: Text("..clear all",style: TextStyle(color: Colors.blue))),
                          ],
                        ),
                      ) :

                      SizedBox(height: 10,),


                      Divider(
                        color: Colors.black,
                        height: 10,
                      ),

                      (challengesProvider.isLoadingMore) ?
                      Center(child: CircularProgressIndicator()) :
                      Flexible(
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shrinkWrap: true,
                          itemCount: challengesProvider.challengesdocuments.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return ChallengesListTile(index, challengesProvider.challengesdocuments);
                          },
                        ),
                      ),



                    ],
                  );
                }),
          ),
          // actions: [
          //   Consumer<UserAboutMEProvider>(
          //       builder: (context, userAboutMEProvider, _) {
          //         return
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               InkWell(
          //                 onTap: (){
          //                   userAboutMEProvider.clearSelectedChallenges();
          //                   userAboutMEProvider.isCheckedMapchallenge.clear();
          //
          //                   Navigator.of(context).pop();
          //                 },
          //                 child: Container(
          //                   padding: EdgeInsets.symmetric(horizontal: 15),
          //                   width: MediaQuery.of(context).size.width * .3,
          //
          //                   height: 60,
          //                   decoration: BoxDecoration(
          //                     //color: Colors.white,
          //                     border: Border.all(
          //                       //color:primaryColorOfApp ,
          //                         width: 1.0),
          //                     borderRadius: BorderRadius.circular(15.0),
          //                   ),
          //                   child: Center(
          //                     child: Text(
          //                       'Close',
          //                       style: GoogleFonts.montserrat(
          //                         textStyle:
          //                         Theme
          //                             .of(context)
          //                             .textTheme
          //                             .titleSmall,
          //                         fontWeight: FontWeight.bold,
          //                         //color: primaryColorOfApp
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //
          //               ),
          //               SizedBox(width: 5, height: 5,),
          //               InkWell(
          //                 onTap: (){
          //                   // solutions = userAboutMEProvider.getSelectedSolutions();
          //                   // _userAboutMEProvider.clearSelectedSolutions();
          //                   userAboutMEProvider.addchallenges();
          //                   userAboutMEProvider.clearSelectedChallenges();
          //                   userAboutMEProvider.isCheckedMapchallenge.clear();
          //                   // userAboutMEProvider.clearSelectedSolutions();
          //
          //                   Navigator.pop(context);
          //                   print("Challenges: $Challenges");
          //
          //                 },
          //                 child: Container(
          //                   width: MediaQuery.of(context).size.width * .3,
          //                   padding: EdgeInsets.symmetric(horizontal: 15),
          //                   height: 60,
          //                   decoration: BoxDecoration(
          //                     color: Colors.blue,
          //                     border: Border.all(
          //                         color: Colors.blue,
          //                         width: 2.0),
          //                     borderRadius: BorderRadius.circular(15.0),
          //                   ),
          //                   child: Center(
          //                     child: Text(
          //                       'Add',
          //                       style: GoogleFonts.montserrat(
          //                           textStyle:
          //                           Theme
          //                               .of(context)
          //                               .textTheme
          //                               .titleSmall,
          //                           fontWeight: FontWeight.bold,
          //                           color: Colors.white),
          //                     ),
          //                   ),
          //                 ),
          //
          //               )
          //
          //
          //             ],
          //           );
          //       })
          // ],

        );
      },
    );
  } ///this

  void showSolutionSelectors()  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // actions: [
          //   Consumer<UserAboutMEProvider>(
          //       builder: (context, userAboutMEProvider, _) {
          //         return
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               InkWell(
          //                 onTap: (){
          //                   userAboutMEProvider.clearSelectedSolutions();
          //                   userAboutMEProvider.isCheckedMap.clear();
          //                   // userAboutMEProvider.isCheckedMapchallenge.clear();
          //
          //                   Navigator.of(context).pop();
          //                 },
          //                 child: Container(
          //                   padding: EdgeInsets.symmetric(horizontal: 15),
          //                   width: MediaQuery.of(context).size.width * .3,
          //
          //                   height: 60,
          //                   decoration: BoxDecoration(
          //                     //color: Colors.white,
          //                     border: Border.all(
          //                       //color:primaryColorOfApp ,
          //                         width: 1.0),
          //                     borderRadius: BorderRadius.circular(15.0),
          //                   ),
          //                   child: Center(
          //                     child: Text(
          //                       'Close',
          //                       style: GoogleFonts.montserrat(
          //                         textStyle:
          //                         Theme
          //                             .of(context)
          //                             .textTheme
          //                             .titleSmall,
          //                         fontWeight: FontWeight.bold,
          //                         //color: primaryColorOfApp
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //
          //               ),
          //               SizedBox(width: 5, height: 5,),
          //               InkWell(
          //                 onTap: (){
          //                   // solutions = userAboutMEProvider.getSelectedSolutions();
          //                   // _userAboutMEProvider.clearSelectedSolutions();
          //                   userAboutMEProvider.addsolutions();
          //                   userAboutMEProvider.clearSelectedSolutions();
          //                   userAboutMEProvider.isCheckedMap.clear();
          //                   // userAboutMEProvider.isCheckedMapchallenge.clear();
          //
          //
          //                   Navigator.pop(context);
          //                   print("solutions: $solutions");
          //
          //                 },
          //                 child: Container(
          //                   width: MediaQuery.of(context).size.width * .3,
          //                   padding: EdgeInsets.symmetric(horizontal: 15),
          //                   height: 60,
          //                   decoration: BoxDecoration(
          //                     color: Colors.blue,
          //                     border: Border.all(
          //                         color: Colors.blue,
          //                         width: 2.0),
          //                     borderRadius: BorderRadius.circular(15.0),
          //                   ),
          //                   child: Center(
          //                     child: Text(
          //                       'Add',
          //                       style: GoogleFonts.montserrat(
          //                           textStyle:
          //                           Theme
          //                               .of(context)
          //                               .textTheme
          //                               .titleSmall,
          //                           fontWeight: FontWeight.bold,
          //                           color: Colors.white),
          //                     ),
          //                   ),
          //                 ),
          //
          //               )
          //
          //
          //             ],
          //           );
          //       })
          // ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Solutions'),
              InkWell(
                  onTap: (){
                    _addKeywordProvider.lengthOfdocument = null;
                    // addKeywordProvider.searchbytag.clear();
                    // addKeywordProvider.searchbycategory.clear();
                    searchChallengescontroller.clear();
                    searchbyCatcontroller.clear();
                    _addKeywordProvider.loadDataForPage(1);
                    _addKeywordProvider.setFirstpageNo();
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close))
            ],
          ),
            content: SizedBox(
              width: double.maxFinite,
              child: Consumer<AddKeywordProvider>(
                  builder: (c,addKeywordProvider, _){
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                          child: TextField(
                            controller: searchbyCatcontroller,
                            onChanged: (val){
                              print("valuse ${val}");
                              if (_debounce?.isActive ?? false) _debounce?.cancel();
                              _debounce = Timer(Duration(milliseconds: _debouncetime), () {
                                if (searchbyCatcontroller.text != "") {
                                  ///here you perform your search
                                  // _loadDataForPageFilter(1,'tags',_addKeywordProvider.searchbytag); //(searchTextbyCKEditingController.text.toString());
                                  // _loadDataForPageSearchFilter(searchTextbyCKEditingController.text.toString(),selectAllAny);
                                  //
                                  // if(_tabController!.index==0){
                                  //   _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString(),selectAllAny);
                                  //   print("documentssssssss: ${_addKeywordProvider.documents}");
                                  // }
                                  // else if(_tabController!.index==1){
                                  //   _challengesProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString(),selectAllAny);
                                  //   print("challengesdocumentssssssss: ${_challengesProvider.challengesdocuments}");
                                  // }
                                  _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString());

                                  // _handleTabSelection();
                                }
                                else {
                                  _addKeywordProvider.loadDataForPage(1);
                                  _addKeywordProvider.setFirstpageNo();
                                  // _challengesProvider.loadDataForPage(1);
                                  // _challengesProvider.setFirstpageNo();

                                }
                              });
                            },
                            style: GoogleFonts.montserrat(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              suffixIcon:  Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 5,),
                                  InkWell(
                                    onTap: () {
                                      searchbyCatcontroller.clear();
                                      _addKeywordProvider.loadDataForPage(1);
                                      // _challengesProvider.loadDataForPage(1);
                                      _addKeywordProvider.lengthOfdocument = null;
                                      // _challengesProvider.lengthOfdocument = null;
                                    },
                                    child: Icon(Icons.close),
                                  ),
                                ],
                              ),
                              contentPadding: EdgeInsets.all(10),
                              labelText: "Search",
                              hintText: "Search",
                              errorStyle: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.redAccent,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelStyle: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        (addKeywordProvider.lengthOfdocument != null) ?

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
                          child: Row(
                            children: [
                              Text("Search results: ${addKeywordProvider.lengthOfdocument}",style: Theme.of(context).textTheme.bodyMedium),
                              SizedBox(width: 5,),
                              InkWell(
                                  onTap: (){
                                    addKeywordProvider.lengthOfdocument = null;
                                    // addKeywordProvider.searchbytag.clear();
                                    // addKeywordProvider.searchbycategory.clear();
                                    searchChallengescontroller.clear();
                                    searchbyCatcontroller.clear();
                                    addKeywordProvider.loadDataForPage(1);
                                    addKeywordProvider.setFirstpageNo();
                                  },
                                  child: Text("..clear all",style: TextStyle(color: Colors.blue))),
                            ],
                          ),
                        ) :

                        SizedBox(height: 10,),
                        Divider(
                          color: Colors.black,
                          height: 10,
                        ),
                        (addKeywordProvider.isLoadingMore) ?
                        Center(child: CircularProgressIndicator()) :
                        Flexible(
                          child: ListView.separated(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shrinkWrap: true,
                            itemCount: addKeywordProvider.documents.length,
                            separatorBuilder: (BuildContext context, int index) {
                              return Divider();
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return ThriversListTile(index, addKeywordProvider.documents);
                            },
                          ),
                        ),

                      ],
                    );
                  }),
            )

        );
      },
    );
  } ///this

  Widget ThriversListTile(i, documentsss) {

    return Consumer<UserAboutMEProvider>(
        builder: (c,userAboutMEProvider, _){
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10,),

                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text("${i + 1}.",style: Theme.of(context).textTheme.bodyLarge),
                ),

                SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(documentsss![i]['Name'],style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis),
                      Text(documentsss![i]['Final_description'],style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2,),
                      SizedBox(height: 10),

                    ],
                  ),
                ),

                SizedBox(width: 20,),


                Row(
                  children: [
                    IconButton(
                        onPressed: (){
                          NewViewDialog(documentsss![i]['Name'],documentsss![i]['Description'],documentsss![i]['Impact'],documentsss![i]['Final_description'], documentsss![i]['Keywords'],documentsss![i]['tags'],documentsss![i]['id'],documentsss![i],userAboutMEProvider.isRecommendedSolutionsCheckedMap,userAboutMEProvider.isRecommendedAddedSolutions);
                        },
                        icon: Icon(Icons.info_outline, color: Colors.blue,)
                    ),
                    SizedBox(width: 8),
                    (userAboutMEProvider.isRecommendedSolutionsCheckedMap[documentsss![i]['id']] == true) ? Text(
                      'Added',
                      style: GoogleFonts.montserrat(
                        textStyle:
                        Theme
                            .of(context)
                            .textTheme
                            .titleSmall,
                        fontStyle: FontStyle.italic,
                        color:Colors.green ,
                      ),
                    ) : InkWell(
                      onTap: (){
                        userAboutMEProvider.isRecommendedAddedSolutions(true,documentsss![i]);
                        toastification.show(context: context,
                            title: Text('${documentsss![i]['Name']} added successfully'),
                            autoCloseDuration: Duration(milliseconds: 2500),
                            alignment: Alignment.center,
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icon(Icons.check_circle, color: Colors.white,),
                            animationDuration: Duration(milliseconds: 1000),
                            showProgressBar: false
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        width: MediaQuery.of(context).size.width * .05,
                        // width: MediaQuery.of(context).size.width * .15,

                        // height: 60,
                        decoration: BoxDecoration(
                          color: Colors.blue ,
                          border: Border.all(
                              color:Colors.blue ,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          // child: Icon(Icons.add, size: 30,color: Colors.white,),
                          child: Text(
                            'Add',
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
                  ],
                ),


              ],
            ),
          );
        });


  }

  Widget ChallengesListTile( i, documents) {

    return Consumer<UserAboutMEProvider>(
        builder: (c,userAboutMEProvider, _){
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          SizedBox(width: 10,),
          // Text(documents![i].id,style: Theme.of(context).textTheme.bodySmall),
          // Text("${i+1}.",style: Theme.of(context).textTheme.bodySmall),
          // Text("CH0${challengesDetails['id']}",style: Theme.of(context).textTheme.bodySmall),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text("${i + 1}.",style: Theme.of(context).textTheme.bodyLarge),
            ),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(documents![i]['Label'],style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis),
                Text(documents![i]['Final_description'],style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2,),
                SizedBox(height: 10),
              ],
            ),
          ),
          SizedBox(width: 30),

          // Center(
          //   child: Checkbox(
          //     activeColor: Colors.blue,
          //     value: userAboutMEProvider.isCheckedForTileChallenge(documents![i]), // Use the state from the provider
          //     onChanged: (value) {
          //       userAboutMEProvider.isClickedBoxChallenge(value, i, documents![i]);
          //     },
          //   ),
          // )
            Row(
              children: [


                IconButton(
                    onPressed: (){
                      NewViewDialog(documents![i]['Label'],documents![i]['Description'],documents![i]['Impact'],documents![i]['Final_description'], documents![i]['Keywords'],documents![i]['tags'],documents![i]['id'],documents![i], userAboutMEProvider.isRecommendedChallengeCheckedMap,userAboutMEProvider.isRecommendedAddedChallenge);
                    },
                    icon: Icon(Icons.info_outline, color: Colors.blue,)
                ),
                SizedBox(width: 8),

                (userAboutMEProvider.isRecommendedChallengeCheckedMap[documents![i]['id']] == true) ? Text(
                  'Added',
                  style: GoogleFonts.montserrat(
                    textStyle:
                    Theme
                        .of(context)
                        .textTheme
                        .titleSmall,
                    fontStyle: FontStyle.italic,
                    color:Colors.green ,
                  ),
                ) : InkWell(
                  onTap: (){
                    userAboutMEProvider.isRecommendedAddedChallenge(true, documents![i]);
                    toastification.show(context: context,
                        title: Text('${documents![i]['Label']} added successfully'),
                    autoCloseDuration: Duration(milliseconds: 2500),
                    alignment: Alignment.center,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: Icon(Icons.check_circle, color: Colors.white,),
                    animationDuration: Duration(milliseconds: 1000),
                    showProgressBar: false
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    width: MediaQuery.of(context).size.width * .05,
                    // width: MediaQuery.of(context).size.width * .15,

                    // height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue ,
                      border: Border.all(
                          color:Colors.blue ,
                          width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      // child: Icon(Icons.add, size: 30,color: Colors.white,),
                      child: Text(
                        'Add',
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
              ],
            ),


        ],
            ),
      );
    });
  }


  void showconfirmChallengeDialogBox(Id,label,description,source,ChallengeStatus,tags,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,OriginalDescription,
      Impact,Final_description,Category ,Keywords ,PotentialStrengths, HiddenStrengths, index, listname, Notes) {

    print("CreatedDate: $CreatedDate");

    DateTime dateTime = CreatedDate.toDate();


    // final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");
    final DateFormat formatter = DateFormat('yyyy-MM-dd, HH:mm:ss');

    // var createdAt = DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now());


    var formattedDate = formatter.format(dateTime);

    NotesController.text = Impact;

    print("Inside showconfirmrDialogBox");
    print("Id: CH0$Id");
    print("label: $label");
    print("description: $description");
    print("source: $source");
    print("Status: $ChallengeStatus");
    print("tags: ${tags}");
    print("CreatedBy: $CreatedBy");
    print("CreatedDate: $formattedDate");
    print("ModifiedBy: $ModifiedBy");
    print("ModifiedDate: $ModifiedDate");
    print("OriginalDescription: $OriginalDescription");
    print("Impact: $Impact");
    print("Final_description: $Final_description");
    print("Category: $Category");
    print("Keywords: $Keywords");
    print("PotentialStrengths: $PotentialStrengths");
    print("HiddenStrengths: $HiddenStrengths");
    print("Notes: $Notes");
    print("index: $index");
    print("listname: $listname");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<UserAboutMEProvider>(
              builder: (c,userAboutMEProvider, _){
                // addKeywordProvider.getcategoryAndKeywords();
                // addKeywordProvider.newgetSource();
                // addKeywordProvider.getThriversStatus();
                return Theme(
                  data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
                  child: AlertDialog(
                    insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery
                        .of(context)
                        .size
                        .width * 0.2),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              NotesController.clear();
                              userAboutMEProvider.selectedPriority = null;
                              userAboutMEProvider.selectedProvider = null;
                              userAboutMEProvider.selectedInPlace = null;
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              width: MediaQuery.of(context).size.width * .2,

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
                                  'Cancel',
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
                            onTap: () async {
                              // if(NotesController.text.isEmpty || userAboutMEProvider.selectedProvider == null || userAboutMEProvider.selectedInPlace == null
                              //     || userAboutMEProvider.selectedPriority == null ){
                              //   if(NotesController.text.isEmpty){
                              //     showEmptyAlert(context, "Add Notes");
                              //   }
                              //   else if(userAboutMEProvider.selectedProvider == null ){
                              //     showEmptyAlert(context, "Select Provider");
                              //   }
                              //   else if(userAboutMEProvider.selectedInPlace == null ){
                              //     showEmptyAlert(context, "Select In Place");
                              //   }
                              //   else if(userAboutMEProvider.selectedPriority == null){
                              //     showEmptyAlert(context, "Select Priority");
                              //   }
                              // }
                              // else
                              {
                                ProgressDialog.show(context, "Confirming", Icons.check_circle_outline);

                                if(userAboutMEProvider.aadhar != null) {
                             await userAboutMEProvider.uploadFile(
                                      userAboutMEProvider.fileBytes,
                                      userAboutMEProvider.aadhar);
                                }

                            Map<String, dynamic> solutionData = {
                              'id': Id,
                              'Label': label,
                              'Description': description,
                              'Source': source,
                              'Challenge Status': ChallengeStatus,
                              'tags': tags,
                              'Created By': CreatedBy,
                              'Created Date': formattedDate,
                              'Modified By': ModifiedBy,
                              'Modified Date': ModifiedDate,
                              'Original Description': OriginalDescription,
                              'Impact': Impact,
                              'Final_description': Final_description,
                              'Category': Category,
                              'Keywords': Keywords,
                              'Potential Strengths': PotentialStrengths,
                              'Hidden Strengths': HiddenStrengths,
                              'Impact_on_me': NotesController.text,
                              'Attachment_link': userAboutMEProvider.downloadURL==null ? null : userAboutMEProvider.downloadURL,
                              'Attachment': userAboutMEProvider.aadhar==null ? "" : userAboutMEProvider.aadhar
                            };

                                print("solutionData['Attachment']: ${solutionData['Attachment']}");

                                Map<String, dynamic> challengeData = {
                                  'id': Id,
                                  'Label': label,
                                  'Description': description,
                                  'Source': source,
                                  'Challenge Status': ChallengeStatus,
                                  'tags': tags,
                                  'Created By': CreatedBy,
                                  'Created Date': formattedDate,
                                  'Modified By': ModifiedBy,
                                  'Modified Date': ModifiedDate,
                                  'Original Description': OriginalDescription,
                                  'Impact': Impact,
                                  'Final_description': Final_description,
                                  'Category': Category,
                                  'Keywords': Keywords,
                                  'Potential Strengths': PotentialStrengths,
                                  'Hidden Strengths': HiddenStrengths,
                                  'Notes': Notes,
                                };

                                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                    .collection('Challenges')
                                    .orderBy('Created Date', descending: true)
                                    .limit(1)
                                    .get();
                                final abc =   querySnapshot.docs.first;
                                print("abccccc; ${abc['id']}");
                                print("abccccc; ${abc['id'].runtimeType}");
                                print("Idddddd; ${Id}");
                                print("Iddddd; ${Id.runtimeType}");
                                // var ids = abc['id'] + 1;

                                if(Id > abc['id']){
                                  print("Yes $Id is greater than ${abc['id']}. ");
                                  print("challengeData To Add Challenge: ${challengeData['id']}");

                                  ProgressDialog.show(context, "Adding a new Challenge", Icons.new_label_outlined);

                                  await ApiRepository().createchallenges(challengeData);

                                  ProgressDialog.hide();
                                }

                               else if(Id == abc['id']){
                                  print("Yes $Id is equal to ${abc['id']}. ");

                                  int newId = Id + 1;

                                  Map<String, dynamic> challengeNewData = {
                                    'id': newId,
                                    'Label': label,
                                    'Description': description,
                                    'Source': source,
                                    'Challenge Status': ChallengeStatus,
                                    'tags': tags,
                                    'Created By': CreatedBy,
                                    'Created Date': formattedDate,
                                    'Modified By': ModifiedBy,
                                    'Modified Date': ModifiedDate,
                                    'Original Description': OriginalDescription,
                                    'Impact': Impact,
                                    'Final_description': Final_description,
                                    'Category': Category,
                                    'Keywords': Keywords,
                                    'Potential Strengths': PotentialStrengths,
                                    'Hidden Strengths': HiddenStrengths,
                                    'Notes': Notes,
                                  };

                                  print("challengeNewData To Add Challenge: ${challengeNewData['id']}");


                                  ProgressDialog.show(context, "Adding a new Challenge", Icons.new_label_outlined);

                                  await ApiRepository().createchallenges(challengeData);

                                  ProgressDialog.hide();
                                }

                                print("tags: $tags");
                            print("Keywords: $Keywords");

                            generatedsolutionstags.addAll(tags);
                            generatedsolutionscategory.addAll(Keywords);

                            print("generatedsolutionstags: $generatedsolutionstags");

                            print("generatedsolutionscategory: $generatedsolutionscategory");


                               await userAboutMEProvider.confirmed(index, true, listname);

                                challengesList.add(solutionData);

                                  _previewProvider.PreviewChallengesList.add(solutionData);

                                ProgressDialog.hide();


                                // await userAboutMEProvider.uploadFile(userAboutMEProvider.fileBytes, userAboutMEProvider.aadhar);

                                // solutionData['Attachment'] = userAboutMEProvider.downloadURL;
                                //
                                // print("solutionData['Attachment'] ${solutionData['Attachment']}");


                                // setState(() {
                            //   isConfirmed = userAboutMEProvider.isConfirm;
                            //   solutionData['confirmed'] = isConfirmed;
                            // });

                            // print("solutionData['confirmed']: $isConfirmed");



                            print("solutionsList.length: ${solutionsList.length}");
                            print("solutionsList: ${solutionsList}");
                            NotesController.clear();
                            userAboutMEProvider.selectedPriority = null;
                            userAboutMEProvider.selectedProvider = null;
                            userAboutMEProvider.selectedInPlace = null;
                            userAboutMEProvider.aadhar = null;
                            userAboutMEProvider.fileBytes = null;
                            Navigator.pop(context);
                          }
                        },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .2,
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

                          ),
                        ],
                      ),

                    ],
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text("Edit/Confirm Challenge",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),

                      ],
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      //height: MediaQuery.of(context).size.height*0.5,
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[

                              ///
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 20.0),
                              //   child: Text("Id: ${Id}",
                              //       overflow: TextOverflow.ellipsis,
                              //       style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                              //           fontSize: 15,
                              //           color: Colors.black)),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text("${label}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Container(
                                  // width: 400,
                                  child: Text("${Final_description}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black)),
                                ),
                              ),

                              Divider(),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                                child: Text("* Edit as appropriate",
                                    style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400)),
                              ),
                              // SizedBox(height: 5,),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                child: Text("impact on me: ",
                                    style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,
                                    fontWeight: FontWeight.w600)),
                              ),

                              TextField(
                                maxLines: 4,
                                controller: NotesController,
                                cursorColor: primaryColorOfApp,

                                // readOnly: readonly,
                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                style: GoogleFonts.montserrat(
                                    textStyle: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyLarge,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  //errorText: userAccountSearchErrorText,
                                  contentPadding: EdgeInsets.all(15),
                                  helperStyle: TextStyle(color: Colors.red),
                                  // labelText: "Notes",

                                  /*prefixIcon: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Icon(Icons.question_mark_outlined,
                                                       // color: primaryColorOfApp
                                                          ),
                                                    ),*/

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
                                  //hintText: "e.g Abouzied",
                                  labelStyle: GoogleFonts.montserrat(
                                      textStyle: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyLarge,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ),

                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                    child: Text("Attachment :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                                  ),
                                  SizedBox(width: 10,),

                                  InkWell(
                                    onTap: (){
                                      userAboutMEProvider.pickFiles();
                                    },
                                    child: Container(
                                      // padding: EdgeInsets.all(20),
                                      child: Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${userAboutMEProvider.aadhar==null ? "" : userAboutMEProvider.aadhar}", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                                // child: Text("document.pdf", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                              ),


                            ]
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
    );
  }

  void showconfirmSolutionsDialogBox(Id,label,description,source,ChallengeStatus,tags,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,OriginalDescription,
      Impact,Final_description,Category ,Keywords ,PotentialStrengths, HiddenStrengths, index, listname,Notes)  {

    DateTime dateTime = CreatedDate.toDate();


    // final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");
    final DateFormat formatter = DateFormat('yyyy-MM-dd, HH:mm:ss');


    String formattedDate = formatter.format(dateTime);

    NotesController.text = Impact;

    print("Inside showconfirmrDialogBox");
    print("Id: SH0$Id");
    print("label: $label");
    print("description: $description");
    print("source: $source");
    print("Status: $ChallengeStatus");
    print("tags: ${tags}");
    print("CreatedBy: $CreatedBy");
    print("CreatedDate: $formattedDate");
    print("ModifiedBy: $ModifiedBy");
    print("ModifiedDate: $ModifiedDate");
    print("OriginalDescription: $OriginalDescription");
    print("Impact: $Impact");
    print("Final_description: $Final_description");
    print("Category: $Category");
    print("Keywords: $Keywords");
    print("PotentialStrengths: $PotentialStrengths");
    print("HiddenStrengths: $HiddenStrengths");
    print("Notes: $Notes");
    print("index: $index");
    print("listname: $listname");
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<UserAboutMEProvider>(
              builder: (c,userAboutMEProvider, _){
                // addKeywordProvider.getcategoryAndKeywords();
                // addKeywordProvider.newgetSource();
                // addKeywordProvider.getThriversStatus();
                return Theme(
                  data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
                  child: AlertDialog(
                    insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),

                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              NotesController.clear();
                              userAboutMEProvider.selectedPriority = null;
                              userAboutMEProvider.selectedProvider = null;
                              userAboutMEProvider.selectedInPlace = null;
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              width: MediaQuery.of(context).size.width * .2,

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
                                  'Cancel',
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
                            onTap: () async {
                              // if(NotesController.text.isEmpty || userAboutMEProvider.selectedProvider == null || userAboutMEProvider.selectedInPlace == null
                              //     || userAboutMEProvider.selectedPriority == null ){
                              //   if(NotesController.text.isEmpty){
                              //     showEmptyAlert(context, "Add Notes");
                              //   }
                              //   else if(userAboutMEProvider.selectedProvider == null ){
                              //     showEmptyAlert(context, "Select Provider");
                              //   }
                              //   else if(userAboutMEProvider.selectedInPlace == null ){
                              //     showEmptyAlert(context, "Select In Place");
                              //   }
                              //   else if(userAboutMEProvider.selectedPriority == null){
                              //     showEmptyAlert(context, "Select Priority");
                              //   }
                              // }
                              // else
                              {
                                ProgressDialog.show(context, "Confirming", Icons.check_circle_outline);

                                if(userAboutMEProvider.aadhar != null) {
                                  await userAboutMEProvider.uploadFile(
                                      userAboutMEProvider.fileBytes,
                                      userAboutMEProvider.aadhar);
                                }

                                Map<String, dynamic> solutionData = {
                                  'id': Id,
                                  'Label': label,
                                  'Description': description,
                                  'Source': source,
                                  'Challenge Status': ChallengeStatus,
                                  'tags': tags,
                                  'Created By': CreatedBy,
                                  'Created Date': formattedDate,
                                  'Modified By': ModifiedBy,
                                  'Modified Date': ModifiedDate,
                                  'Original Description': OriginalDescription,
                                  'Impact': Impact,
                                  'Final_description': Final_description,
                                  'Category': Category,
                                  'Keywords': Keywords,
                                  'Potential Strengths': PotentialStrengths,
                                  'Hidden Strengths': HiddenStrengths,
                                  'AboutMe_Notes': NotesController.text,
                                  'Provider': userAboutMEProvider.selectedProvider,
                                  'InPlace': userAboutMEProvider.selectedInPlace,
                                  // 'Priority': userAboutMEProvider.selectedPriority,
                                  // 'Attachment': downloadURLs,
                                  'Attachment_link': userAboutMEProvider.downloadURL==null ? null : userAboutMEProvider.downloadURL,
                                  'Attachment': userAboutMEProvider.aadhar==null ? "-" : userAboutMEProvider.aadhar
                                  // 'confirmed': false, // Add a 'confirmed' field
                                };

                                // String solutionJson = json.encode(solutionData);
                                // print(solutionJson);

                                Map<String, dynamic> solutionDataSaved = {
                                  'id': Id,
                                  'Name': label,
                                  'Description': description,
                                  'Source': source,
                                  'Thirver Status': ChallengeStatus,
                                  'tags': tags,
                                  'Created By': CreatedBy,
                                  'Created Date': formattedDate,
                                  'Modified By': ModifiedBy,
                                  'Modified Date': ModifiedDate,
                                  'Original Description': OriginalDescription,
                                  'Impact': Impact,
                                  'Final_description': Final_description,
                                  'Category': Category,
                                  'Keywords': Keywords,
                                  'Notes': Notes,
                                };

                                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                    .collection('Thrivers')
                                    .orderBy('Created Date', descending: true)
                                    .limit(1)
                                    .get();
                                final abcd =   querySnapshot.docs.first;
                                print("abcccccd; ${abcd['id']}");
                                print("abcccccd; ${abcd['id'].runtimeType}");
                                print("Idddddd; ${Id}");
                                print("Iddddd; ${Id.runtimeType}");
                                // var ids = abc['id'] + 1;

                                if(Id > abcd['id']){
                                  print("Yes $Id is greater than ${abcd['id']}. ");
                                  print("solutionDataSaved To Add Solutions: ${solutionDataSaved['id']}");

                                  ProgressDialog.show(context, "Adding a new Challenge", Icons.new_label_outlined);

                                  await ApiRepository().createThriversss(solutionDataSaved);

                                  ProgressDialog.hide();
                                }

                                else if(Id == abcd['id']){
                                  print("Yes $Id is equal to ${abcd['id']}. ");

                                  int newId = Id + 1;

                                  Map<String, dynamic> solutionNewDataSaved = {
                                    'id': newId,
                                    'Name': label,
                                    'Description': description,
                                    'Source': source,
                                    'Challenge Status': ChallengeStatus,
                                    'tags': tags,
                                    'Created By': CreatedBy,
                                    'Created Date': formattedDate,
                                    'Modified By': ModifiedBy,
                                    'Modified Date': ModifiedDate,
                                    'Original Description': OriginalDescription,
                                    'Impact': Impact,
                                    'Final_description': Final_description,
                                    'Category': Category,
                                    'Keywords': Keywords,
                                    'Notes': Notes,
                                  };

                                  print("solutionNewDataSaved To Add Solution: ${solutionNewDataSaved['id']}");


                                  ProgressDialog.show(context, "Adding a new Challenge", Icons.new_label_outlined);

                                  await ApiRepository().createThriversss(solutionNewDataSaved);

                                  ProgressDialog.hide();
                                }

                                print("tags: $tags");
                                print("Keywords: $Keywords");

                                generatedsolutionstags.addAll(tags);
                                generatedsolutionscategory.addAll(Keywords);

                                print(
                                    "generatedsolutionstags: $generatedsolutionstags");

                                print(
                                    "generatedsolutionscategory: $generatedsolutionscategory");

                                userAboutMEProvider.confirmed(index, true, listname);

                                // setState(() {
                                //   isConfirmed = userAboutMEProvider.isConfirm;
                                //   solutionData['confirmed'] = isConfirmed;
                                // });

                                // print("solutionData['confirmed']: $isConfirmed");

                                solutionsList.add(solutionData);
                                _previewProvider.PreviewSolutionList.add(solutionData);

                                ProgressDialog.hide();


                                print("solutionsList.length: ${solutionsList.length}");
                                print("solutionsList: ${solutionsList}");
                                NotesController.clear();
                                userAboutMEProvider.selectedPriority = null;
                                userAboutMEProvider.selectedProvider = null;
                                userAboutMEProvider.selectedInPlace = null;
                                userAboutMEProvider.aadhar = null;
                                userAboutMEProvider.fileBytes = null;
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .2,
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
                                  'Confirm',
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

                          ),
                        ],
                      ),
                    ],

                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text("Edit/Confirm Solution",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),

                      ],
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      //height: MediaQuery.of(context).size.height*0.5,
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[

                              ///

                              // Padding(
                              //   padding: const EdgeInsets.only(left: 20.0),
                              //   child: Text("Id: ${Id}",
                              //       overflow: TextOverflow.ellipsis,
                              //       style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                              //           fontSize: 15,
                              //           color: Colors.black)),
                              // ),

                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text("${label}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black)),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Container(
                                  // width: 400,
                                  child: Text("${Final_description}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black)),
                                ),
                              ),

                              Divider(),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                                child: Text("* Edit as appropriate",
                                    style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400)),
                              ),
                              // SizedBox(height: 5,),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                child: Text("How this solutions helps me :",
                                    style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,
                                        fontWeight: FontWeight.w600)),
                              ),

                              TextField(
                                maxLines: 4,
                                controller: NotesController,
                                cursorColor: primaryColorOfApp,

                                // readOnly: readonly,
                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                style: GoogleFonts.montserrat(
                                    textStyle: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyLarge,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  //errorText: userAccountSearchErrorText,
                                  contentPadding: EdgeInsets.all(25),
                                  // labelText: "Notes",
                                  hintText: "Notes",

                                  /*prefixIcon: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Icon(Icons.question_mark_outlined,
                                                       // color: primaryColorOfApp
                                                          ),
                                                    ),*/

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
                                  //hintText: "e.g Abouzied",
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


                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                child: Text("Provider :",
                                    style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,
                                        fontWeight: FontWeight.w600)),
                              ),

                              // DropdownButtonFormField(
                              //   style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
                              //   decoration: InputDecoration(
                              //     //errorText: userAccountSearchErrorText,
                              //     contentPadding: EdgeInsets.all(15),
                              //     // labelText: "Priority",
                              //     hintText: "Provider",
                              //
                              //
                              //     errorStyle: GoogleFonts.montserrat(
                              //         textStyle: Theme
                              //             .of(context)
                              //             .textTheme
                              //             .bodyLarge,
                              //         fontWeight: FontWeight.w400,
                              //         color: Colors.redAccent),
                              //
                              //     focusedBorder: OutlineInputBorder(
                              //         borderSide: BorderSide(color: Colors.black),
                              //         borderRadius: BorderRadius.circular(15)),
                              //     border: OutlineInputBorder(
                              //         borderSide: BorderSide(color: Colors.black12),
                              //         borderRadius: BorderRadius.circular(15)),
                              //     //hintText: "e.g Abouzied",
                              //     labelStyle: GoogleFonts.montserrat(
                              //         textStyle: Theme
                              //             .of(context)
                              //             .textTheme
                              //             .bodyLarge,
                              //         fontWeight: FontWeight.w400,
                              //         color: Colors.black),
                              //   ),
                              //   value: selectedProvider,
                              //   onChanged: (newValue) {
                              //    setState(() {
                              //      selectedProvider = newValue;
                              //    });
                              //   },
                              //   icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
                              //   items: provider.map<DropdownMenuItem<String>>((String value) {
                              //
                              //     return DropdownMenuItem<String>(
                              //       value: value,
                              //       child: Text(value, overflow: TextOverflow.ellipsis,),
                              //     );
                              //   }).toList(),
                              // ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: userAboutMEProvider.provider.map((String value) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * .18,
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          value: value,
                                          groupValue: userAboutMEProvider.selectedProvider,
                                          activeColor: Colors.blue,
                                          onChanged: (newValue) {
                                            // setState(() {
                                            //   selectedProvider = newValue;
                                            // });
                                            userAboutMEProvider.updateProvider(newValue);
                                          },
                                        ),
                                        Text(
                                          value,
                                          style: TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),

                              SizedBox(height: 10,),

                              (userAboutMEProvider.selectedProvider=="Request of my employer") ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                child: Text("In Place :",
                                    style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,
                                        fontWeight: FontWeight.w600)),
                              ) : Container(),

                              (userAboutMEProvider.selectedProvider=="Request of my employer") ?   Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: userAboutMEProvider.InPlace.map((String value) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * .18,
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          value: value,
                                          groupValue: userAboutMEProvider.selectedInPlace,
                                          activeColor: Colors.blue,
                                          onChanged: (newValue) {
                                            // setState(() {
                                            //   selectedProvider = newValue;
                                            // });
                                            userAboutMEProvider.updateInPlace(newValue);
                                          },
                                        ),
                                        Text(
                                          value,
                                          style: TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ) : Container(),


                              SizedBox(height: 10,),

                              // Padding(
                              //   padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                              //   child: Text("Priority :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,
                              //       fontWeight: FontWeight.w600)),
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: userAboutMEProvider.Priority.map((String value) {
                              //     return Container(
                              //       width: MediaQuery.of(context).size.width * .18,
                              //       child: Row(
                              //         children: [
                              //           Radio<String>(
                              //             value: value,
                              //             groupValue: userAboutMEProvider.selectedPriority,
                              //             activeColor: Colors.blue,
                              //             onChanged: (newValue) {
                              //               // setState(() {
                              //               //   selectedProvider = newValue;
                              //               // });
                              //               userAboutMEProvider.updatePriority(newValue);
                              //             },
                              //           ),
                              //           Flexible(
                              //             child: Text(
                              //               value,
                              //               style: TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis,),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     );
                              //   }).toList(),
                              // ),

                              SizedBox(height: 10,),

                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                    child: Text("Attachment :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                                  ),
                                  SizedBox(width: 10,),

                                  InkWell(
                                    onTap: (){
                                      userAboutMEProvider.pickFiles();
                                    },
                                    child: Container(
                                      // padding: EdgeInsets.all(20),
                                      child: Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${userAboutMEProvider.aadhar== null ? "" : userAboutMEProvider.aadhar}", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                              ),




                            ]
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
    );
  }


  TextEditingController finaltextcontroller = TextEditingController();
  TextEditingController finalSolutiontextcontroller = TextEditingController();
  TextEditingController ImpactAddChallengetextcontroller = TextEditingController();
  TextEditingController ImpactSolutiontextcontroller = TextEditingController();
  TextEditingController NotesAddChallengetextcontroller = TextEditingController();
  TextEditingController NotesSolutiontextcontroller = TextEditingController();
  TextEditingController challengesNameTextEditingController = TextEditingController();
  TextEditingController SolutionNameTextEditingController = TextEditingController();
  TextEditingController challengesOriginalDescriptionTextEditingController = TextEditingController();
  TextEditingController SolutionsOriginalDescriptionTextEditingController = TextEditingController();

  var q1,q2,q3,q4,q5;

  getQuestions() async {
    await FirebaseFirestore.instance.collection('Questions').doc("BuRiTTm0t4mBkTeTso7S").get().then((value) {
      q1 = value['Question 1'];
      q2 = value['Question 2'];
      q3 = value['Question 3'];
      q4 = value['Question 4'];
      q5 = value['Question 5'];
    });
  }

  void showAddChallengesDialogBox() {



    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(

        context: context,
        builder: (BuildContext context) {
          return Consumer<ChallengesProvider>(
              builder: (c,challengeProvider, _){
                challengeProvider.getcategoryAndKeywords();
                return Theme(
                  data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
                  child: AlertDialog(
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              challengesNameTextEditingController.clear();
                              finaltextcontroller.clear();
                              challengeProvider.keywordsssssclear();
                              challengeProvider.ProviderTagsclear();
                              ImpactAddChallengetextcontroller.clear();
                              NotesAddChallengetextcontroller.clear();

                              // controller.clearAllSelection();
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
                                  'Cancel',
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
                            onTap: () async {
                              ////ApiRepository().updateSecurityPINFor(userAccountId,newPinTextEditingController.text);

                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('Challenges')
                                  .orderBy('Created Date', descending: true)
                                  .limit(1)
                                  .get();
                              final abc =   querySnapshot.docs.first;
                              print("abccccc; ${abc['id']}");
                              print("abccccc; ${abc['id'].runtimeType}");
                              var ids = abc['id'] + 1;


                              ProgressDialog.show(context, "Creating a Challenge", Icons.chair);

                              // await ApiRepository().createchallenges({
                              //   "Source" : selectedEmail,
                              //   "Challenge Status" : "New",
                              //   "tags": challengeProvider.ProviderTags,
                              //   "Created By": widget.AdminName,
                              //   "Created Date": DateTime.now(),
                              //   "Modified By": "",
                              //   "Modified Date": "",
                              //   'Label': challengesNameTextEditingController.text,
                              //   // 'Description': thriverDescTextEditingController.text,
                              //   'Description': _controller.document.toPlainText(),
                              //   'Original Description': originaltextEditingController.text,
                              //   // 'Details': _controller.document.insert(0, addDetailsController.text.toString()),
                              //   // 'Category': addKeywordProvider.selectedValue.toString(),
                              //   'Category': "Thrivers Category",
                              //   'Keywords': challengeProvider.keywordsssss,
                              //   "Notes" :  NotesAddChallengetextcontroller.text,
                              //   'Final_description': finaltextcontroller.text,
                              //   'Impact': ImpactAddChallengetextcontroller.text,
                              //
                              //
                              //   // 'Associated Thrivers': "",
                              //   // 'Associated Challenges': "",
                              // });

                              Map<String, dynamic> ChallengesData = {
                                'id': ids,
                                'Label': challengesNameTextEditingController.text,
                                // 'Description': _controller.document.toPlainText(),
                                'Description': "Description",
                                'Source': selectedEmail,
                                'Challenge Status': "New",
                                // 'tags': challengeProvider.ProviderTags,
                                'tags': [],
                                'Created By': widget.AdminName,
                                // 'Created Date': formattedDate,
                                'Created Date': Timestamp.now(),
                                'Modified By': '',
                                'Modified Date': '',
                                // 'Original Description': originaltextEditingController.text,
                                'Original Description': 'Original Description',
                                'Impact': ImpactAddChallengetextcontroller.text,
                                'Final_description': finaltextcontroller.text,
                                'Category': 	"Challenge Category",
                                // 'Keywords': challengeProvider.keywordsssss,
                                'Keywords': [],
                                'Potential Strengths': "",
                                'Hidden Strengths': '',
                                'Notes': '',
                              };

                              print("ChallengesData['id']: ${ChallengesData['id']}");
                              print("ChallengesData['Label']: ${ChallengesData['Label']}");
                              print("ChallengesData Created Date: ${ChallengesData['Created Date']}");

                              _userAboutMEProvider.manuallyAddChallenge(ChallengesData);

                              ProgressDialog.hide();
                              // _challengesProvider.loadDataForPage(1);
                              // _challengesProvider.setFirstpageNo();

                              Navigator.pop(context);
                              challengesNameTextEditingController.clear();
                              challengeProvider.keywordsssssclear();
                              challengeProvider.ProviderTagsclear();
                              challengeProvider.selectsourceItems = null;
                              challengeProvider.selectThriversStatusItems = null;
                              finaltextcontroller.clear();
                              ImpactAddChallengetextcontroller.clear();
                              NotesAddChallengetextcontroller.clear();

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
                                  'Add',
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

                          ),
                        ],
                      ),

                    ],
                    insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery
                        .of(context)
                        .size
                        .width * 0.08, vertical: MediaQuery
                        .of(context)
                        .size
                        .height * 0.08),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("New Challenge",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        ),
                        //Text("(ID:TH0010) ",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                      ],
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      //height: MediaQuery.of(context).size.height*0.5,
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[

                              Padding(
                                /// Original Description
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: challengesOriginalDescriptionTextEditingController,
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
                                          //errorText: userAccountSearchErrorText,
                                          contentPadding: EdgeInsets.all(25),
                                          labelText: "Original Description",
                                          hintText: "Original Description",


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
                                          //hintText: "e.g Abouzied",
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
                                    SizedBox(width: 10,),
                                    InkWell(
                                      // onTap: () async {
                                      //   var defaulttext ="";
                                      //   // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                                      //   defaulttext =  q2;
                                      //   defaulttext =  defaulttext + " where yyy is "+finaltextcontroller.text.toString();
                                      //   var defaulttextq3 ="";
                                      //   // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                                      //   defaulttextq3 =  q3;
                                      //   defaulttextq3 =  defaulttextq3 + " where yyy is "+finaltextcontroller.text.toString();
                                      //
                                      //   var defaulttextq4 ="";
                                      //   // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                                      //   defaulttextq4 =  q4;
                                      //   defaulttextq4 =  defaulttextq4 + " where yyy is "+finaltextcontroller.text.toString();
                                      //   defaulttextq4 =  defaulttextq4 + " and select tags from "+"${resultString}";
                                      //
                                      //
                                      //   var defaulttextq5 ="";
                                      //   defaulttextq5 =  q5;
                                      //   defaulttextq5 =  defaulttextq5 + " where yyy is "+finaltextcontroller.text.toString();
                                      //
                                      //   // defaulttext =defaulttext +" 3."+ "  $q3 "+originaltextEditingController.text.toString();
                                      //   // defaulttext =defaulttext +" 4."+ "  $q4 "+originaltextEditingController.text.toString();
                                      //   // defaulttext =defaulttext +" 5."+ "  $q5 "+originaltextEditingController.text.toString();
                                      //   await getChatResponsenew(defaulttext,defaulttextq3,defaulttextq4,defaulttextq5);
                                      //
                                      // },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * .1,
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
                                            'Generate',
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
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                /// Name
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: challengesNameTextEditingController,
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
                                    //errorText: userAccountSearchErrorText,
                                    contentPadding: EdgeInsets.all(25),
                                    labelText: "Label",
                                    hintText: "Label",


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
                                    //hintText: "e.g Abouzied",
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

                              Padding(


                                /// Final Description
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  maxLines: null,
                                  controller: finaltextcontroller,
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
                                    //errorText: userAccountSearchErrorText,
                                    contentPadding: EdgeInsets.all(25),
                                    labelText: "Final Description",
                                    hintText: "Final Description",


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
                                    //hintText: "e.g Abouzied",
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

                              Padding(
                                /// Impact
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: ImpactAddChallengetextcontroller,

                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                                  ],
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
                                    //errorText: userAccountSearchErrorText,
                                    contentPadding: EdgeInsets.all(25),
                                    labelText: "Impact",
                                    hintText: "Impact",

                                    /*prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.question_mark_outlined,
                                 // color: primaryColorOfApp
                                  ),
                              ),*/

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
                                    //hintText: "e.g Abouzied",
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

                              Padding(
                                /// Notes
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: NotesAddChallengetextcontroller,

                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                                  ],
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
                                    //errorText: userAccountSearchErrorText,
                                    contentPadding: EdgeInsets.all(25),
                                    labelText: "Notes",
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
                                        borderRadius: BorderRadius.circular(15)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(15)),
                                    //hintText: "e.g Abouzied",
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

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("* Note: Please confirm the Challenge in order to save it.",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w300
                                ),
                                ),
                              ),


                              // Container(
                              //   padding: EdgeInsets.only(left: 10),
                              //   child: SizedBox(
                              //     child: Row(
                              //       children: [
                              //         Expanded(
                              //           flex: 4,
                              //           child: TextField(
                              //             controller: originaltextEditingController,
                              //             cursorColor: primaryColorOfApp,
                              //             style: GoogleFonts.montserrat(
                              //                 textStyle: Theme
                              //                     .of(context)
                              //                     .textTheme
                              //                     .bodyLarge,
                              //                 fontWeight: FontWeight.w400,
                              //                 color: Colors.black),
                              //             decoration: InputDecoration(
                              //               //errorText: userAccountSearchErrorText,
                              //               contentPadding: EdgeInsets.all(25),
                              //               labelText: "Original Description",
                              //               hintText: "Original Description",
                              //
                              //
                              //               errorStyle: GoogleFonts.montserrat(
                              //                   textStyle: Theme
                              //                       .of(context)
                              //                       .textTheme
                              //                       .bodyLarge,
                              //                   fontWeight: FontWeight.w400,
                              //                   color: Colors.redAccent),
                              //
                              //               focusedBorder: OutlineInputBorder(
                              //                   borderSide: BorderSide(color: Colors.black),
                              //                   borderRadius: BorderRadius.circular(15)),
                              //               border: OutlineInputBorder(
                              //                   borderSide: BorderSide(color: Colors.black12),
                              //                   borderRadius: BorderRadius.circular(15)),
                              //               //hintText: "e.g Abouzied",
                              //               labelStyle: GoogleFonts.montserrat(
                              //                   textStyle: Theme
                              //                       .of(context)
                              //                       .textTheme
                              //                       .bodyLarge,
                              //                   fontWeight: FontWeight.w400,
                              //                   color: Colors.black),
                              //             ),
                              //           ),
                              //         ),
                              //
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              //
                              // InkWell(
                              //   onTap: ()async{
                              //     var defaulttext ;
                              //     defaulttext = q1;
                              //     defaulttext = defaulttext +""+ "where xxx = ${originaltextEditingController.text.toString()}";
                              //     print(defaulttext);
                              //     await getChallengeCleanResponse(defaulttext);
                              //   },
                              //   child: Container(
                              //     margin: EdgeInsets.only(top: 20,left: 10,right: 10, bottom: 10),
                              //     width: 200,
                              //     height: 60,
                              //     decoration: BoxDecoration(
                              //       color:Colors.blue,
                              //       border: Border.all(
                              //           color:Colors.blue,
                              //           width: 2.0),
                              //       borderRadius: BorderRadius.circular(10.0),
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         'Clean',
                              //         style: GoogleFonts.montserrat(
                              //             textStyle:
                              //             Theme.of(context).textTheme.titleSmall,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white),
                              //       ),
                              //     ),
                              //   ),
                              //
                              // ),
                              //
                              //
                              // Padding(
                              //
                              //
                              //   /// Final Description
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: TextField(
                              //     maxLines: null,
                              //     controller: finaltextcontroller,
                              //     // cursorColor: primaryColorOfApp,
                              //
                              //     onChanged: (value) {
                              //
                              //     },
                              //     style: GoogleFonts.montserrat(
                              //         textStyle: Theme
                              //             .of(context)
                              //             .textTheme
                              //             .bodyLarge,
                              //         fontWeight: FontWeight.w400,
                              //         color: Colors.black),
                              //     decoration: InputDecoration(
                              //       //errorText: userAccountSearchErrorText,
                              //       contentPadding: EdgeInsets.all(25),
                              //       labelText: "Final Description",
                              //       hintText: "Final Description",
                              //
                              //
                              //       errorStyle: GoogleFonts.montserrat(
                              //           textStyle: Theme
                              //               .of(context)
                              //               .textTheme
                              //               .bodyLarge,
                              //           fontWeight: FontWeight.w400,
                              //           color: Colors.redAccent),
                              //
                              //       focusedBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.black),
                              //           borderRadius: BorderRadius.circular(15)),
                              //       border: OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.black12),
                              //           borderRadius: BorderRadius.circular(15)),
                              //       //hintText: "e.g Abouzied",
                              //       labelStyle: GoogleFonts.montserrat(
                              //           textStyle: Theme
                              //               .of(context)
                              //               .textTheme
                              //               .bodyLarge,
                              //           fontWeight: FontWeight.w400,
                              //           color: Colors.black),
                              //     ),
                              //   ),
                              // ),
                              // InkWell(
                              //   onTap: () async {
                              //     var defaulttext ="";
                              //     // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                              //     defaulttext =  q2;
                              //     defaulttext =  defaulttext + " where yyy is "+finaltextcontroller.text.toString();
                              //     var defaulttextq3 ="";
                              //     // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                              //     defaulttextq3 =  q3;
                              //     defaulttextq3 =  defaulttextq3 + " where yyy is "+finaltextcontroller.text.toString();
                              //
                              //     var defaulttextq4 ="";
                              //     // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                              //     defaulttextq4 =  q4;
                              //     defaulttextq4 =  defaulttextq4 + " where yyy is "+finaltextcontroller.text.toString();
                              //     defaulttextq4 =  defaulttextq4 + " and select tags from "+"${resultString}";
                              //
                              //
                              //     var defaulttextq5 ="";
                              //     defaulttextq5 =  q5;
                              //     defaulttextq5 =  defaulttextq5 + " where yyy is "+finaltextcontroller.text.toString();
                              //
                              //     await getChallengeExpandResponse(defaulttext,defaulttextq3,defaulttextq4,defaulttextq5);
                              //
                              //   },
                              //   child: Container(
                              //     margin: EdgeInsets.all(10),
                              //     width: 200,
                              //     height: 60,
                              //     decoration: BoxDecoration(
                              //       color:Colors.blue,
                              //       border: Border.all(
                              //           color:Colors.blue,
                              //           width: 2.0),
                              //       borderRadius: BorderRadius.circular(10.0),
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         'Expand',
                              //         style: GoogleFonts.montserrat(
                              //             textStyle:
                              //             Theme.of(context).textTheme.titleSmall,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white),
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              ///  Details
                              // Container(
                              //   /// Details
                              //   margin: const EdgeInsets.all(8.0),
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(10),
                              //       border: Border.all(color: Colors.black, width: 1)
                              //   ),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Container(
                              //         padding: EdgeInsets.all(10),
                              //         child: QuillEditor.basic(
                              //           configurations: QuillEditorConfigurations(
                              //             maxHeight: 200,
                              //             padding: EdgeInsets.only(left: 10, top: 10),
                              //             controller: _controller,
                              //             readOnly: false,
                              //             sharedConfigurations: const QuillSharedConfigurations(
                              //               locale: Locale('en'),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       Divider(),
                              //       QuillToolbar.simple(
                              //         configurations: QuillSimpleToolbarConfigurations(
                              //           controller: _controller,
                              //           sharedConfigurations: const QuillSharedConfigurations(
                              //             locale: Locale('en'),
                              //           ),
                              //         ),
                              //       ),
                              //
                              //     ],
                              //   ),
                              // ),

                              ///Category & Subcategory

                              // Consumer<ChallengesProvider>(
                              //     builder: (c,challengeProvider, _){
                              //       return Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: TypeAheadField(
                              //           noItemsFoundBuilder: (c){
                              //             // print("ccccc: $c");
                              //             return Container(
                              //                 child: Padding(
                              //                   padding: const EdgeInsets.all(15.0),
                              //                   child: Text("No Keywords Found",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                              //                 )
                              //             );
                              //           },
                              //           suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              //               scrollbarTrackAlwaysVisible: true,
                              //               scrollbarThumbAlwaysVisible: true,
                              //               hasScrollbar: true,
                              //               borderRadius: BorderRadius.circular(5),
                              //               color: Colors.white,
                              //               constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, )
                              //           ),
                              //           suggestionsCallback: (value) async {
                              //             // return await KeywordServices.getSuggestions(value, (addKeywordProvider.newselectedValue == null) ? addKeywordProvider.selectedValue : addKeywordProvider.newselectedValue);
                              //             // return await KeywordServices.getSuggestions(value, 'Thrivers Category');
                              //             return await ChallengeCategoryServices.getSuggestions(value);
                              //           },
                              //           itemBuilder: (context, String suggestion) {
                              //             // print('selected multiple items before newselectedValue ${suggestion}');
                              //             // print('selected multiple items after newselectedValue ${addKeywordProvider.newKeyValues} ');
                              //             return Container(
                              //               // color: Colors.black,
                              //               child: Padding(
                              //                 padding: const EdgeInsets.all(15.0),
                              //                 child: Text(suggestion,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                              //               ),
                              //             );
                              //           },
                              //           direction: AxisDirection.up,
                              //           onSuggestionSelected: (String suggestion) {
                              //             // print('onSuggestionSelected before  ${addKeywordProvider.keywordsssss}');
                              //             // addKeywordProvider.addkeywordschip(suggestion,editKeywordssss);
                              //             challengeProvider.addkeywordschip(suggestion,challengeProvider.keywordsssss);
                              //             // print('onSuggestionSelected after  ${addKeywordProvider.keywordsssss}');
                              //             keywordscontroller.clear();
                              //           },
                              //           textFieldConfiguration: TextFieldConfiguration(
                              //             controller: keywordscontroller,
                              //             // onSubmitted: (text) {
                              //             //   addKeywordProvider.addkeywordschip(tagscontroller.text.toString(),editKeywordssss);
                              //             //   // addKeywordProvider.addkeywordschip(addKeywordProvider.newselectedValue);
                              //             // },
                              //             style: GoogleFonts.poppins(
                              //               textStyle: Theme.of(context).textTheme.bodyLarge,
                              //               color: Colors.black,
                              //               fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                              //             ),
                              //             decoration: InputDecoration(
                              //               //errorText: userAccountSearchErrorText,
                              //               contentPadding: EdgeInsets.all(25),
                              //               labelText: "Select Category",
                              //               hintText: "Select Category",
                              //               /*prefixIcon: Padding(
                              //                                           padding: const EdgeInsets.all(8.0),
                              //                                           child: Icon(Icons.question_mark_outlined,
                              //                                             //color: primaryColorOfApp
                              //                                             ),
                              //                                         ),*/
                              //               errorStyle: GoogleFonts.montserrat(
                              //                   textStyle: Theme.of(context).textTheme.bodyLarge,
                              //                   fontWeight: FontWeight.w400,
                              //                   color: Colors.redAccent),
                              //
                              //               focusedBorder: OutlineInputBorder(
                              //                   borderSide: BorderSide(color: Colors.black),
                              //                   borderRadius: BorderRadius.circular(15)),
                              //               border: OutlineInputBorder(
                              //                   borderSide: BorderSide(color: Colors.black12),
                              //                   borderRadius: BorderRadius.circular(15)),
                              //               //hintText: "e.g Abouzied",
                              //               labelStyle: GoogleFonts.montserrat(
                              //                   textStyle: Theme.of(context).textTheme.bodyLarge,
                              //                   fontWeight: FontWeight.w400,
                              //                   color: Colors.black),
                              //             ),
                              //           ),
                              //         ),
                              //       );}
                              // ),
                              //
                              //
                              // Consumer<ChallengesProvider>(
                              //     builder: (c,challengesProvider, _){
                              //       return Padding(
                              //         padding: const EdgeInsets.only(left: 15.0),
                              //         child: Align(
                              //           alignment: Alignment.centerLeft,
                              //           child: Wrap(
                              //             spacing: 10,
                              //             runSpacing: 10,
                              //             crossAxisAlignment: WrapCrossAlignment.start,
                              //             alignment: WrapAlignment.start,
                              //             runAlignment: WrapAlignment.start,
                              //             children: challengesProvider.keywordsssss.map((item){
                              //               // children: editKeywordssss.map((item){
                              //               //   print("item: $item");
                              //               //   print("addKeywordProvider.keywordsssss: ${addKeywordProvider.keywordsssss}");
                              //               return Container(
                              //                 height: 50,
                              //                 // width: 200,
                              //                 padding: EdgeInsets.all(8),
                              //                 margin: EdgeInsets.symmetric(vertical: 8),
                              //                 decoration: BoxDecoration(
                              //                     borderRadius: BorderRadius.circular(15),
                              //                     color: Colors.blue
                              //                 ),
                              //                 child: Row(
                              //                   mainAxisSize: MainAxisSize.min,
                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                   children: [
                              //                     Flexible(
                              //                       child: Text(item, style: TextStyle(
                              //                         fontWeight: FontWeight.w700,
                              //                       ),
                              //                         overflow: TextOverflow.ellipsis,
                              //                         // softWrap: true,
                              //                         // maxLines: 1,
                              //                       ),
                              //                     ),
                              //                     IconButton(
                              //                         onPressed: ()async{
                              //                           // addKeywordProvider.newKeywordsList.remove(item);
                              //                           // _addKeywordProvider.removekeywords(item);
                              //                           _challengesProvider.keywordsssss.remove(item);
                              //                         },
                              //                         icon: Icon(Icons.close,size: 20, color: Colors.white,)
                              //                     ),
                              //                   ],
                              //                 ),
                              //               );
                              //             }).toList(),
                              //           ),
                              //         ),
                              //       );
                              //     }),
                              //
                              //
                              // Padding(
                              //   padding: const EdgeInsets.all(10.0),
                              //   child: TypeAheadField(
                              //     noItemsFoundBuilder: (c){
                              //       return Container(
                              //           child: Padding(
                              //             padding: const EdgeInsets.all(15.0),
                              //             child: Text("Add Tag: '${tagscontroller.text}'",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                              //             ),
                              //           )
                              //       );
                              //     },
                              //     direction: AxisDirection.up,
                              //     suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              //         scrollbarTrackAlwaysVisible: true,
                              //         scrollbarThumbAlwaysVisible: true,
                              //         hasScrollbar: true,
                              //         borderRadius: BorderRadius.circular(5),
                              //         // color: Colors.white,
                              //         constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, )
                              //     ),
                              //     suggestionsCallback: (value) async {
                              //       return await TagServices.getSuggestions(value);
                              //     },
                              //
                              //     itemBuilder: (context, String suggestion) {
                              //       return Container(
                              //         // color: Colors.black,
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(15.0),
                              //           child: Text(suggestion,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                              //         ),
                              //       );
                              //     },
                              //     onSuggestionSelected: (String suggestion) {
                              //       // print("Im selectedf $suggestion" );
                              //       // print("Im selectedf ${tagscontroller.text}" );
                              //       // setState(() {
                              //       // tagscontroller.text = suggestion;
                              //       _challengesProvider.addtags(suggestion,_challengesProvider.ProviderTags);
                              //       // print("fenil tags added: $_addKeywordProvider.ProviderTags");
                              //
                              //       // });
                              //     },
                              //     textFieldConfiguration: TextFieldConfiguration(
                              //       controller: tagscontroller,
                              //       onSubmitted: (text) {
                              //         _challengesProvider.addtags(text,_challengesProvider.ProviderTags);
                              //         tagscontroller.clear();
                              //         // print("tags: $tags");
                              //       },
                              //       style: GoogleFonts.poppins(
                              //         textStyle: Theme.of(context).textTheme.bodyLarge,
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                              //       ),
                              //       decoration: InputDecoration(
                              //         //errorText: userAccountSearchErrorText,
                              //         contentPadding: EdgeInsets.all(25),
                              //         labelText: "Tags",
                              //         hintText: "Tags",
                              //         prefixIcon: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Icon(Icons.tag,color: primaryColorOfApp,),
                              //         ),
                              //         suffixIcon: IconButton(
                              //           icon: Icon(Icons.add, size: 20, color: primaryColorOfApp,),
                              //           onPressed: () {
                              //             _challengesProvider.addtags(tagscontroller.text.toString(),_challengesProvider.ProviderTags);
                              //           },
                              //         ),
                              //         errorStyle: GoogleFonts.montserrat(
                              //             textStyle: Theme
                              //                 .of(context)
                              //                 .textTheme
                              //                 .bodyLarge,
                              //             fontWeight: FontWeight.w400,
                              //             color: Colors.redAccent),
                              //
                              //         focusedBorder: OutlineInputBorder(
                              //             borderSide: BorderSide(color: Colors.black),
                              //             borderRadius: BorderRadius.circular(15)),
                              //         border: OutlineInputBorder(
                              //             borderSide: BorderSide(color: Colors.black12),
                              //             borderRadius: BorderRadius.circular(15)),
                              //         //hintText: "e.g Abouzied",
                              //         labelStyle: GoogleFonts.montserrat(
                              //             textStyle: Theme
                              //                 .of(context)
                              //                 .textTheme
                              //                 .bodyLarge,
                              //             fontWeight: FontWeight.w400,
                              //             color: Colors.black),
                              //       ),
                              //
                              //     ),
                              //   ),
                              // ),
                              //
                              // Consumer<ChallengesProvider>(
                              //     builder: (c,challengesProvider, _){
                              //       return Padding(
                              //         padding: const EdgeInsets.only(left: 15.0),
                              //         child: Align(
                              //           alignment: Alignment.centerLeft,
                              //           child: Wrap(
                              //             spacing: 10,
                              //             runSpacing: 10,
                              //             crossAxisAlignment: WrapCrossAlignment.start,
                              //             alignment: WrapAlignment.start,
                              //             runAlignment: WrapAlignment.start,
                              //             children: challengesProvider.ProviderTags.map((item){
                              //               return Container(
                              //                 height: 50,
                              //                 // width: 200,
                              //                 padding: EdgeInsets.all(8),
                              //                 margin: EdgeInsets.symmetric(vertical: 8),
                              //                 decoration: BoxDecoration(
                              //                     borderRadius: BorderRadius.circular(15),
                              //                     color: Colors.blue
                              //                 ),
                              //                 child: Row(
                              //                   mainAxisSize: MainAxisSize.min,
                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                   children: [
                              //                     Text(item, style: TextStyle(
                              //                         fontWeight: FontWeight.w700
                              //                     ),),
                              //                     IconButton(
                              //                         onPressed: (){
                              //                           // setState(() {
                              //                           challengesProvider.removetags(item);
                              //                           // });
                              //                         },
                              //                         icon: Icon(Icons.close,size: 20, color: Colors.white,)
                              //                     ),
                              //                   ],
                              //                 ),
                              //               );
                              //             }).toList(),
                              //           ),
                              //         ),
                              //       );
                              //
                              //     }),

                              ///

                              // Padding(
                              //   /// PotentialStrengths
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: TextField(
                              //     controller: PotentialStrengthstextcontroller,
                              //
                              //     inputFormatters: [
                              //       FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                              //     ],
                              //     // cursorColor: primaryColorOfApp,
                              //     onChanged: (value) {
                              //
                              //     },
                              //     style: GoogleFonts.montserrat(
                              //         textStyle: Theme
                              //             .of(context)
                              //             .textTheme
                              //             .bodyLarge,
                              //         fontWeight: FontWeight.w400,
                              //         color: Colors.black),
                              //     decoration: InputDecoration(
                              //       //errorText: userAccountSearchErrorText,
                              //       contentPadding: EdgeInsets.all(25),
                              //       labelText: "Potential Strengths",
                              //       hintText: "Potential Strengths",
                              //
                              //       errorStyle: GoogleFonts.montserrat(
                              //           textStyle: Theme
                              //               .of(context)
                              //               .textTheme
                              //               .bodyLarge,
                              //           fontWeight: FontWeight.w400,
                              //           color: Colors.redAccent),
                              //
                              //       focusedBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.black),
                              //           borderRadius: BorderRadius.circular(15)),
                              //       border: OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.black12),
                              //           borderRadius: BorderRadius.circular(15)),
                              //       //hintText: "e.g Abouzied",
                              //       labelStyle: GoogleFonts.montserrat(
                              //           textStyle: Theme
                              //               .of(context)
                              //               .textTheme
                              //               .bodyLarge,
                              //           fontWeight: FontWeight.w400,
                              //           color: Colors.black),
                              //     ),
                              //   ),
                              // ),
                              //
                              // Padding(
                              //   /// HiddenStrengths
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: TextField(
                              //     controller: HiddenStrengthstextcontroller,
                              //
                              //     inputFormatters: [
                              //       FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                              //     ],
                              //     // cursorColor: primaryColorOfApp,
                              //     onChanged: (value) {
                              //
                              //     },
                              //     style: GoogleFonts.montserrat(
                              //         textStyle: Theme
                              //             .of(context)
                              //             .textTheme
                              //             .bodyLarge,
                              //         fontWeight: FontWeight.w400,
                              //         color: Colors.black),
                              //     decoration: InputDecoration(
                              //       //errorText: userAccountSearchErrorText,
                              //       contentPadding: EdgeInsets.all(25),
                              //       labelText: "Hidden Strengths",
                              //       hintText: "Hidden Strengths",
                              //
                              //       errorStyle: GoogleFonts.montserrat(
                              //           textStyle: Theme
                              //               .of(context)
                              //               .textTheme
                              //               .bodyLarge,
                              //           fontWeight: FontWeight.w400,
                              //           color: Colors.redAccent),
                              //
                              //       focusedBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.black),
                              //           borderRadius: BorderRadius.circular(15)),
                              //       border: OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.black12),
                              //           borderRadius: BorderRadius.circular(15)),
                              //       //hintText: "e.g Abouzied",
                              //       labelStyle: GoogleFonts.montserrat(
                              //           textStyle: Theme
                              //               .of(context)
                              //               .textTheme
                              //               .bodyLarge,
                              //           fontWeight: FontWeight.w400,
                              //           color: Colors.black),
                              //     ),
                              //   ),
                              // ),


                            ]
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
    );
  }

  void showAddThriverDialogBox() {


    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(

        context: context,
        builder: (BuildContext context) {
          return Consumer<AddKeywordProvider>(
              builder: (c,addKeywordProvider, _){
                addKeywordProvider.getcategoryAndKeywords();

                // addKeywordProvider.newgetSource();
                // addKeywordProvider.getThriversStatus();

                return Theme(
                  data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
                  child: AlertDialog(
                    insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery
                        .of(context)
                        .size
                        .width * 0.08, vertical: MediaQuery
                        .of(context)
                        .size
                        .height * 0.08),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              SolutionNameTextEditingController.clear();
                              finalSolutiontextcontroller.clear();
                              ImpactSolutiontextcontroller.clear();
                              NotesSolutiontextcontroller.clear();
                              // addKeywordProvider.selectedValue.clear();
                              addKeywordProvider.keywordsssssclear();
                              addKeywordProvider.ProviderTagsclear();
                              // controller.clearAllSelection();
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
                                  'Cancel',
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
                            onTap: () async {
                              ////ApiRepository().updateSecurityPINFor(userAccountId,newPinTextEditingController.text);

                              // print('createdAt: $createdAt');
                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('Thrivers')
                                  .orderBy('Created Date', descending: true)
                                  .limit(1)
                                  .get();
                              final abc =   querySnapshot.docs.first;
                              print("abccccc; ${abc['id']}");
                              print("abccccc; ${abc['id'].runtimeType}");
                              var ids = abc['id'] + 1;
                              ProgressDialog.show(context, "Creating a Thriver", Icons.chair);
                              // await ApiRepository().createThriversss({
                              //   "id": ids,
                              //   "Source" : addKeywordProvider.selectsourceItems,
                              //   "Thirver Status" : addKeywordProvider.selectThriversStatusItems,
                              //   "tags": addKeywordProvider.ProviderTags,
                              //   "Created By": widget.AdminName,
                              //   "Created Date": DateTime.now(),
                              //   "Modified By": "",
                              //   "Modified Date": "",
                              //   'Name': SolutionNameTextEditingController.text,
                              //   // 'Description': thriverDescTextEditingController.text,
                              //   'Description': _controller.document.toPlainText(),
                              //   'Original Description': originaltextEditingController.text,
                              //   'Final_description': finaltextcontroller.text,
                              //   'Impact': ImpactSolutiontextcontroller.text,
                              //   // 'Details': _controller.document.insert(0, addDetailsController.text.toString()),
                              //   // 'Category': addKeywordProvider.selectedValue.toString(),
                              //   'Category': "Thrivers Category",
                              //   'Keywords': addKeywordProvider.keywordsssss,
                              //   "Notes" :  NotesSolutiontextcontroller.text
                              //   // 'Associated Thrivers': "",
                              //   // 'Associated Challenges': ""
                              // });
                              Map<String, dynamic> SolutionData = {
                                'id': ids,
                                'Name': SolutionNameTextEditingController.text,
                                // 'Description': _controllerSolution.document.toPlainText(),
                                'Description': "Description",
                                'Source': selectedEmail,
                                'Thirver Status': "New",
                                // 'tags': addKeywordProvider.ProviderTags,
                                'tags': [],
                                'Created By': widget.AdminName,
                                // 'Created Date': formattedDate,
                                'Created Date': Timestamp.now(),
                                'Modified By': '',
                                'Modified Date': '',
                                // 'Original Description': originalSolutiontextEditingController.text,
                                'Original Description': 'Original Description',
                                'Impact': ImpactSolutiontextcontroller.text,
                                'Final_description': finalSolutiontextcontroller.text,
                                'Category': 	"Solution Category",
                                // 'Keywords': addKeywordProvider.keywordsssss,
                                'Keywords': [],
                                'Notes': NotesSolutiontextcontroller.text,
                              };

                              print("SolutionData: ${SolutionData['Name']}");
                              print("SolutionData Created Date: ${SolutionData['Created Date']}");

                              _userAboutMEProvider.manuallyAddSolution(SolutionData);

                              ProgressDialog.hide();
                              Navigator.pop(context);
                              SolutionNameTextEditingController.clear();
                              finalSolutiontextcontroller.clear();
                              ImpactSolutiontextcontroller.clear();
                              NotesSolutiontextcontroller.clear();
                              // addKeywordProvider.selectedValue.clear();
                              addKeywordProvider.keywordsssssclear();
                              addKeywordProvider.ProviderTagsclear();
                              addKeywordProvider.selectsourceItems = null;
                              addKeywordProvider.selectThriversStatusItems = null;
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
                                  'Add',
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

                          ),
                        ],
                      ),

                    ],
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("New Solution",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
                        ),

                        //Text("(ID:TH0010) ",style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                      ],
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      //height: MediaQuery.of(context).size.height*0.5,
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[


                              Padding(
                                /// Original Description
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: SolutionsOriginalDescriptionTextEditingController,
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
                                          //errorText: userAccountSearchErrorText,
                                          contentPadding: EdgeInsets.all(25),
                                          labelText: "Original Description",
                                          hintText: "Original Description",


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
                                          //hintText: "e.g Abouzied",
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
                                    SizedBox(width: 10,),
                                    InkWell(
                                      // onTap: () async {
                                      //   var defaulttext ="";
                                      //   // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                                      //   defaulttext =  q2;
                                      //   defaulttext =  defaulttext + " where yyy is "+finaltextcontroller.text.toString();
                                      //   var defaulttextq3 ="";
                                      //   // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                                      //   defaulttextq3 =  q3;
                                      //   defaulttextq3 =  defaulttextq3 + " where yyy is "+finaltextcontroller.text.toString();
                                      //
                                      //   var defaulttextq4 ="";
                                      //   // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                                      //   defaulttextq4 =  q4;
                                      //   defaulttextq4 =  defaulttextq4 + " where yyy is "+finaltextcontroller.text.toString();
                                      //   defaulttextq4 =  defaulttextq4 + " and select tags from "+"${resultString}";
                                      //
                                      //
                                      //   var defaulttextq5 ="";
                                      //   defaulttextq5 =  q5;
                                      //   defaulttextq5 =  defaulttextq5 + " where yyy is "+finaltextcontroller.text.toString();
                                      //
                                      //   // defaulttext =defaulttext +" 3."+ "  $q3 "+originaltextEditingController.text.toString();
                                      //   // defaulttext =defaulttext +" 4."+ "  $q4 "+originaltextEditingController.text.toString();
                                      //   // defaulttext =defaulttext +" 5."+ "  $q5 "+originaltextEditingController.text.toString();
                                      //   await getChatResponsenew(defaulttext,defaulttextq3,defaulttextq4,defaulttextq5);
                                      //
                                      // },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * .1,
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
                                            'Generate',
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
                                    ),
                                  ],
                                ),
                              ),


                              Padding(
                                /// Name
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: SolutionNameTextEditingController,

                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                                  ],
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
                                    //errorText: userAccountSearchErrorText,
                                    contentPadding: EdgeInsets.all(25),
                                    labelText: "Label",
                                    hintText: "Label",

                                    /*prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.question_mark_outlined,
                                 // color: primaryColorOfApp
                                  ),
                              ),*/

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
                                    //hintText: "e.g Abouzied",
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

                              Padding(


                                /// Final Description
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  // maxLines: null,
                                  // maxLines: 2,
                                  controller: finalSolutiontextcontroller,
                                  // cursorColor: primaryColorOfApp,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                                  ],
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
                                    //errorText: userAccountSearchErrorText,
                                    contentPadding: EdgeInsets.all(25),
                                    labelText: "Description",
                                    hintText: "Description",



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
                                    //hintText: "e.g Abouzied",
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

                              Padding(
                                /// Impact
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: ImpactSolutiontextcontroller,

                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                                  ],
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
                                    //errorText: userAccountSearchErrorText,
                                    contentPadding: EdgeInsets.all(25),
                                    labelText: "Impact",
                                    hintText: "Impact",

                                    /*prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.question_mark_outlined,
                                 // color: primaryColorOfApp
                                  ),
                              ),*/

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
                                    //hintText: "e.g Abouzied",
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


                              Padding(
                                /// Notes
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: NotesSolutiontextcontroller,

                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                                  ],
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
                                    //errorText: userAccountSearchErrorText,
                                    contentPadding: EdgeInsets.all(25),
                                    labelText: "Notes",
                                    hintText: "Notes",

                                    /*prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.question_mark_outlined,
                                 // color: primaryColorOfApp
                                  ),
                              ),*/

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
                                    //hintText: "e.g Abouzied",
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

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("* Note: Please confirm the Solution in order to save it.",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w300
                                  ),
                                ),
                              ),


                              // SizedBox(height: 10,),
                              //
                              // Container(
                              //   padding: EdgeInsets.only(left: 10),
                              //   child: SizedBox(
                              //     child: Row(
                              //       children: [
                              //         Expanded(
                              //           flex: 4,
                              //           child: TextField(
                              //             maxLines: 2,
                              //             controller: originalSolutiontextEditingController,
                              //             cursorColor: primaryColorOfApp,
                              //
                              //             // readOnly: readonly,
                              //             // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              //             style: GoogleFonts.montserrat(
                              //                 textStyle: Theme
                              //                     .of(context)
                              //                     .textTheme
                              //                     .bodyLarge,
                              //                 fontWeight: FontWeight.w400,
                              //                 color: Colors.black),
                              //             decoration: InputDecoration(
                              //               //errorText: userAccountSearchErrorText,
                              //               contentPadding: EdgeInsets.all(25),
                              //               labelText: "Original Description",
                              //               hintText: "Original Description",
                              //
                              //               /*prefixIcon: Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Icon(Icons.question_mark_outlined,
                              //    // color: primaryColorOfApp
                              //     ),
                              // ),*/
                              //
                              //               errorStyle: GoogleFonts.montserrat(
                              //                   textStyle: Theme
                              //                       .of(context)
                              //                       .textTheme
                              //                       .bodyLarge,
                              //                   fontWeight: FontWeight.w400,
                              //                   color: Colors.redAccent),
                              //
                              //               focusedBorder: OutlineInputBorder(
                              //                   borderSide: BorderSide(color: Colors.black),
                              //                   borderRadius: BorderRadius.circular(15)),
                              //               border: OutlineInputBorder(
                              //                   borderSide: BorderSide(color: Colors.black12),
                              //                   borderRadius: BorderRadius.circular(15)),
                              //               //hintText: "e.g Abouzied",
                              //               labelStyle: GoogleFonts.montserrat(
                              //                   textStyle: Theme
                              //                       .of(context)
                              //                       .textTheme
                              //                       .bodyLarge,
                              //                   fontWeight: FontWeight.w400,
                              //                   color: Colors.black),
                              //             ),
                              //           ),
                              //         ),
                              //
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              //
                              //
                              // InkWell(
                              //   onTap: ()async{
                              //
                              //     // print(q1);
                              //     // print(originaltextEditingController.text.toString());
                              //
                              //
                              //     var defaulttext ;
                              //     defaulttext = q1;
                              //     defaulttext = defaulttext +""+ "where xxx = ${originalSolutiontextEditingController.text.toString()}";
                              //     print(defaulttext);
                              //     // await getChatSolutionCleanResponse(defaulttext);
                              //     await getChatSolutionCleanResponse(defaulttext);
                              //
                              //   },
                              //   child: Container(
                              //     margin: EdgeInsets.only(top: 20,left: 10,right: 10, bottom: 10),
                              //     width: 200,
                              //     height: 60,
                              //     decoration: BoxDecoration(
                              //       color:Colors.blue,
                              //       border: Border.all(
                              //           color:Colors.blue,
                              //           width: 2.0),
                              //       borderRadius: BorderRadius.circular(10.0),
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         'Clean',
                              //         style: GoogleFonts.montserrat(
                              //             textStyle:
                              //             Theme.of(context).textTheme.titleSmall,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white),
                              //       ),
                              //     ),
                              //   ),
                              //
                              // ),
                              //
                              //
                              // InkWell(
                              //   onTap: () async {
                              //     var defaulttext ="";
                              //     // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                              //     defaulttext =  q2;
                              //     defaulttext =  defaulttext + " where yyy is "+finalSolutiontextcontroller.text.toString();
                              //     var defaulttextq3 ="";
                              //     // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                              //     defaulttextq3 =  q3;
                              //     defaulttextq3 =  defaulttextq3 + " where yyy is "+finalSolutiontextcontroller.text.toString();
                              //
                              //     var defaulttextq4 ="";
                              //     // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                              //     defaulttextq4 =  q4;
                              //     defaulttextq4 =  defaulttextq4 + " where yyy is "+finalSolutiontextcontroller.text.toString();
                              //     defaulttextq4 =  defaulttextq4 + " and select tags from "+"${resultString}";
                              //
                              //
                              //     var defaulttextq5 ="";
                              //     defaulttextq5 =  q5;
                              //     defaulttextq5 =  defaulttextq5 + " where yyy is "+finalSolutiontextcontroller.text.toString();
                              //
                              //     // defaulttext =defaulttext +" 3."+ "  $q3 "+originaltextEditingController.text.toString();
                              //     // defaulttext =defaulttext +" 4."+ "  $q4 "+originaltextEditingController.text.toString();
                              //     // defaulttext =defaulttext +" 5."+ "  $q5 "+originaltextEditingController.text.toString();
                              //     await getSolutionExpandResponse(defaulttext,defaulttextq3,defaulttextq4,defaulttextq5);
                              //
                              //   },
                              //   child: Container(
                              //     margin: EdgeInsets.all(10),
                              //     width: 200,
                              //     height: 60,
                              //     decoration: BoxDecoration(
                              //       color:Colors.blue,
                              //       border: Border.all(
                              //           color:Colors.blue,
                              //           width: 2.0),
                              //       borderRadius: BorderRadius.circular(10.0),
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         'Expand',
                              //         style: GoogleFonts.montserrat(
                              //             textStyle:
                              //             Theme.of(context).textTheme.titleSmall,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // Container(
                              //   /// Details
                              //   margin: const EdgeInsets.all(8.0),
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(10),
                              //       border: Border.all(color: Colors.black, width: 1)
                              //   ),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Container(
                              //         padding: EdgeInsets.all(10),
                              //         child: QuillEditor.basic(
                              //           configurations: QuillEditorConfigurations(
                              //             // placeholder: "Expanded Description",
                              //             maxContentWidth: null,
                              //             maxHeight: 200,
                              //             padding: EdgeInsets.only(left: 10, top: 10),
                              //             controller: _controllerSolution,
                              //             readOnly: false,
                              //             // minHeight: 100,
                              //             sharedConfigurations: const QuillSharedConfigurations(
                              //               locale: Locale('en'),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       Divider(),
                              //       QuillToolbar.simple(
                              //         configurations: QuillSimpleToolbarConfigurations(
                              //           controller: _controllerSolution,
                              //           sharedConfigurations: const QuillSharedConfigurations(
                              //             locale: Locale('en'),
                              //           ),
                              //         ),
                              //       ),
                              //
                              //     ],
                              //   ),
                              // ),

                              // Consumer<AddKeywordProvider>(
                              //     builder: (c,addKeywordProvider, _){
                              //       return Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: TypeAheadField(
                              //           noItemsFoundBuilder: (c){
                              //             print("ccccc: $c");
                              //             return Container(
                              //                 child: Padding(
                              //                   padding: const EdgeInsets.all(15.0),
                              //                   child: Text("No Keywords Found",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                              //                 )
                              //             );
                              //           },
                              //           suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              //               scrollbarTrackAlwaysVisible: true,
                              //               scrollbarThumbAlwaysVisible: true,
                              //               hasScrollbar: true,
                              //               borderRadius: BorderRadius.circular(5),
                              //               color: Colors.white,
                              //               constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, )
                              //           ),
                              //           suggestionsCallback: (value) async {
                              //             // return await KeywordServices.getSuggestions(value, (addKeywordProvider.newselectedValue == null) ? addKeywordProvider.selectedValue : addKeywordProvider.newselectedValue);
                              //             // return await KeywordServices.getSuggestions(value, 'Thrivers Category');
                              //             return await KeywordServicessss.getSuggestions(value);
                              //           },
                              //           itemBuilder: (context, String suggestion) {
                              //             // print('selected multiple items before newselectedValue ${suggestion}');
                              //             // print('selected multiple items after newselectedValue ${addKeywordProvider.newKeyValues} ');
                              //             return Container(
                              //               // color: Colors.black,
                              //               child: Padding(
                              //                 padding: const EdgeInsets.all(15.0),
                              //                 child: Text(suggestion,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                              //               ),
                              //             );
                              //           },
                              //           direction: AxisDirection.up,
                              //           onSuggestionSelected: (String suggestion) {
                              //             // print('onSuggestionSelected before  ${addKeywordProvider.keywordsssss}');
                              //             // addKeywordProvider.addkeywordschip(suggestion,editKeywordssss);
                              //             addKeywordProvider.addkeywordschip(suggestion,addKeywordProvider.keywordsssss);
                              //             // print('onSuggestionSelected after  ${addKeywordProvider.keywordsssss}');
                              //
                              //
                              //             keywordsSolutioncontroller.clear();
                              //           },
                              //           textFieldConfiguration: TextFieldConfiguration(
                              //             controller: keywordsSolutioncontroller,
                              //             // onSubmitted: (text) {
                              //             //   addKeywordProvider.addkeywordschip(tagscontroller.text.toString(),editKeywordssss);
                              //             //   // addKeywordProvider.addkeywordschip(addKeywordProvider.newselectedValue);
                              //             // },
                              //             style: GoogleFonts.poppins(
                              //               textStyle: Theme.of(context).textTheme.bodyLarge,
                              //               color: Colors.black,
                              //               fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                              //             ),
                              //             decoration: InputDecoration(
                              //               //errorText: userAccountSearchErrorText,
                              //               contentPadding: EdgeInsets.all(25),
                              //               labelText: "Select Category",
                              //               hintText: "Select Category",
                              //               /*prefixIcon: Padding(
                              //                                           padding: const EdgeInsets.all(8.0),
                              //                                           child: Icon(Icons.question_mark_outlined,
                              //                                             //color: primaryColorOfApp
                              //                                             ),
                              //                                         ),*/
                              //               errorStyle: GoogleFonts.montserrat(
                              //                   textStyle: Theme.of(context).textTheme.bodyLarge,
                              //                   fontWeight: FontWeight.w400,
                              //                   color: Colors.redAccent),
                              //
                              //               focusedBorder: OutlineInputBorder(
                              //                   borderSide: BorderSide(color: Colors.black),
                              //                   borderRadius: BorderRadius.circular(15)),
                              //               border: OutlineInputBorder(
                              //                   borderSide: BorderSide(color: Colors.black12),
                              //                   borderRadius: BorderRadius.circular(15)),
                              //               //hintText: "e.g Abouzied",
                              //               labelStyle: GoogleFonts.montserrat(
                              //                   textStyle: Theme.of(context).textTheme.bodyLarge,
                              //                   fontWeight: FontWeight.w400,
                              //                   color: Colors.black),
                              //             ),
                              //           ),
                              //         ),
                              //       );}
                              // ),
                              //
                              // // SizedBox(height: 16),
                              //
                              // Consumer<AddKeywordProvider>(
                              //     builder: (c,addKeywordProvider, _){
                              //       return Padding(
                              //         padding: const EdgeInsets.only(left: 15.0),
                              //         child: Align(
                              //           alignment: Alignment.centerLeft,
                              //           child: Wrap(
                              //             spacing: 10,
                              //             runSpacing: 10,
                              //             crossAxisAlignment: WrapCrossAlignment.start,
                              //             alignment: WrapAlignment.start,
                              //             runAlignment: WrapAlignment.start,
                              //             children: addKeywordProvider.keywordsssss.map((item){
                              //               // children: editKeywordssss.map((item){
                              //               //   print("item: $item");
                              //               //   print("addKeywordProvider.keywordsssss: ${addKeywordProvider.keywordsssss}");
                              //               return Container(
                              //                 height: 50,
                              //                 // width: 200,
                              //                 padding: EdgeInsets.all(8),
                              //                 margin: EdgeInsets.symmetric(vertical: 8),
                              //                 decoration: BoxDecoration(
                              //                     borderRadius: BorderRadius.circular(15),
                              //                     color: Colors.blue
                              //                 ),
                              //                 child: Row(
                              //                   mainAxisSize: MainAxisSize.min,
                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                   children: [
                              //                     Flexible(
                              //                       child: Text(item, style: TextStyle(
                              //                         fontWeight: FontWeight.w700,
                              //                       ),
                              //                         overflow: TextOverflow.ellipsis,
                              //                         // softWrap: true,
                              //                         // maxLines: 1,
                              //                       ),
                              //                     ),
                              //                     IconButton(
                              //                         onPressed: ()async{
                              //                           // addKeywordProvider.newKeywordsList.remove(item);
                              //                           // _addKeywordProvider.removekeywords(item);
                              //                           _addKeywordProvider.keywordsssss.remove(item);
                              //                         },
                              //                         icon: Icon(Icons.close,size: 20, color: Colors.white,)
                              //                     ),
                              //                   ],
                              //                 ),
                              //               );
                              //             }).toList(),
                              //           ),
                              //         ),
                              //       );
                              //     }),
                              //
                              //
                              //
                              // Padding(
                              //   padding: const EdgeInsets.all(10.0),
                              //   child: TypeAheadField(
                              //     noItemsFoundBuilder: (c){
                              //       return Container(
                              //           child: Padding(
                              //             padding: const EdgeInsets.all(15.0),
                              //             child: Text("Add Tag: '${tagsSolutioncontroller.text}'",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                              //             ),
                              //           )
                              //       );
                              //     },
                              //     direction: AxisDirection.up,
                              //     suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              //         scrollbarTrackAlwaysVisible: true,
                              //         scrollbarThumbAlwaysVisible: true,
                              //         hasScrollbar: true,
                              //         borderRadius: BorderRadius.circular(5),
                              //         // color: Colors.white,
                              //         constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, )
                              //     ),
                              //     suggestionsCallback: (value) async {
                              //       return await TagServices.getSuggestions(value);
                              //     },
                              //
                              //     itemBuilder: (context, String suggestion) {
                              //       return Container(
                              //         // color: Colors.black,
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(15.0),
                              //           child: Text(suggestion,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                              //         ),
                              //       );
                              //     },
                              //     onSuggestionSelected: (String suggestion) {
                              //       print("Im selectedf $suggestion" );
                              //       print("Im selectedf ${tagsSolutioncontroller.text}" );
                              //       // setState(() {
                              //       tagsSolutioncontroller.text = suggestion;
                              //       _addKeywordProvider.addtags(tagsSolutioncontroller.text.toString(),_addKeywordProvider.ProviderTags);
                              //       tagsSolutioncontroller.clear();
                              //       //
                              //
                              //       // });
                              //     },
                              //     textFieldConfiguration: TextFieldConfiguration(
                              //       controller: tagscontroller,
                              //       onSubmitted: (text) {
                              //         _addKeywordProvider.addtags(text,_addKeywordProvider.ProviderTags);
                              //         tagsSolutioncontroller.clear();
                              //         // print("tags: $tags");
                              //       },
                              //       style: GoogleFonts.poppins(
                              //         textStyle: Theme.of(context).textTheme.bodyLarge,
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                              //       ),
                              //       decoration: InputDecoration(
                              //         //errorText: userAccountSearchErrorText,
                              //         contentPadding: EdgeInsets.all(25),
                              //         labelText: "Tags",
                              //         hintText: "Tags",
                              //         prefixIcon: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Icon(Icons.tag,color: primaryColorOfApp,),
                              //         ),
                              //         suffixIcon: IconButton(
                              //           icon: Icon(Icons.add, size: 20, color: primaryColorOfApp,),
                              //           onPressed: () {
                              //             _addKeywordProvider.addtags(tagsSolutioncontroller.text.toString(),_addKeywordProvider.ProviderTags);
                              //           },
                              //         ),
                              //         errorStyle: GoogleFonts.montserrat(
                              //             textStyle: Theme
                              //                 .of(context)
                              //                 .textTheme
                              //                 .bodyLarge,
                              //             fontWeight: FontWeight.w400,
                              //             color: Colors.redAccent),
                              //
                              //         focusedBorder: OutlineInputBorder(
                              //             borderSide: BorderSide(color: Colors.black),
                              //             borderRadius: BorderRadius.circular(15)),
                              //         border: OutlineInputBorder(
                              //             borderSide: BorderSide(color: Colors.black12),
                              //             borderRadius: BorderRadius.circular(15)),
                              //         //hintText: "e.g Abouzied",
                              //         labelStyle: GoogleFonts.montserrat(
                              //             textStyle: Theme
                              //                 .of(context)
                              //                 .textTheme
                              //                 .bodyLarge,
                              //             fontWeight: FontWeight.w400,
                              //             color: Colors.black),
                              //       ),
                              //
                              //     ),
                              //   ),
                              // ),
                              //
                              //
                              //
                              // Consumer<AddKeywordProvider>(
                              //     builder: (c,addKeywordProvider, _){
                              //       return Padding(
                              //         padding: const EdgeInsets.only(left: 15.0),
                              //         child: Align(
                              //           alignment: Alignment.centerLeft,
                              //           child: Wrap(
                              //             spacing: 10,
                              //             runSpacing: 10,
                              //             crossAxisAlignment: WrapCrossAlignment.start,
                              //             alignment: WrapAlignment.start,
                              //             runAlignment: WrapAlignment.start,
                              //             children: addKeywordProvider.ProviderTags.map((item){
                              //               return Container(
                              //                 height: 50,
                              //                 // width: 200,
                              //                 padding: EdgeInsets.all(8),
                              //                 margin: EdgeInsets.symmetric(vertical: 8),
                              //                 decoration: BoxDecoration(
                              //                     borderRadius: BorderRadius.circular(15),
                              //                     color: Colors.blue
                              //                 ),
                              //                 child: Row(
                              //                   mainAxisSize: MainAxisSize.min,
                              //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                   children: [
                              //                     Text(item, style: TextStyle(
                              //                         fontWeight: FontWeight.w700
                              //                     ),),
                              //                     IconButton(
                              //                         onPressed: (){
                              //                           // setState(() {
                              //                           addKeywordProvider.removetags(item);
                              //                           // });
                              //                         },
                              //                         icon: Icon(Icons.close,size: 20, color: Colors.white,)
                              //                     ),
                              //                   ],
                              //                 ),
                              //               );
                              //             }).toList(),
                              //           ),
                              //         ),
                              //       );
                              //
                              //     }),
                            ]
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
    );
  }

}


//    return DataTable(
//   decoration: BoxDecoration(
//       border: Border.all(color: Colors.black),
//       borderRadius: BorderRadius.circular(15)
//   ),
//   // horizontalMargin: 10,
//   dataRowMaxHeight: 60,
//   headingTextStyle: GoogleFonts.montserrat(
//       textStyle: Theme
//           .of(context)
//           .textTheme
//           .titleMedium,
//       fontWeight: FontWeight.w500,
//       color: Colors.black),
//   // border: TableBorder.all(color: Colors.black),
//   // showBottomBorder: true,
//   // dataRowHeight: 100,
//   // headingRowHeight: 80,
//   // border: TableBorder.symmetric(inside: BorderSide(color: Colors.black38)),
//   columnSpacing: 20,
//
//   columns: [
//     DataColumn(
//         label: Container(
//             width: 50,
//             child: Center(
//                 child: Text('No.')
//             )
//         )
//     ),
//     DataColumn(
//       label: Container(
//         width: 120,
//         child: Center(
//             child: Text('About Me Id',)
//         ),
//       ),
//     ),
//     DataColumn(
//       label: Container(
//         width: 120,
//         child: Center(
//             child: Text('SH/CH Id',)
//         ),
//       ),
//     ),
//     DataColumn(
//       label: Container(
//         width: 160,
//         child: Center(
//             child: Text('User Name',)
//         ),
//       ),
//     ),
//
//     DataColumn(
//       label: Container(
//         width: 180,
//         child: Center(
//             child: Text('Label',)
//         ),
//       ),
//     ),
//     DataColumn(
//       label: Container(
//           width: 300,
//           child: Center(child:
//           Text('Description')
//           )
//       ),
//     ),
//     DataColumn(
//         label: Container(
//             width: 160,
//             child: Center(child: Text('Notes')
//             )
//         )
//     ),
//
//     DataColumn(
//         label: Center(
//             child: Text('Attachments')
//         )
//     ),
//     DataColumn(
//         label: Container(
//             width: 120,
//             child: Center(child: Text('Provider')
//             )
//         )
//     ),
//     DataColumn(label: Container(
//         width: 80,
//         child: Center(child: Text('In Place')
//         )
//     )
//     ),
//     DataColumn(label: Container(
//         width: 160,
//         child: Center(child: Text('Priority')
//         )
//     )
//     ),
//   ],
//   rows: List<DataRow>.generate(
//     dataList[i]['Solutions'].length,
//         (index) {
//       // List<Map<String, dynamic>> solutionsList =
//       //     dataList[index]['Solutions'] ?? <Map<String, dynamic>>[];
//       print('solutions ab print $solutionlistAb');
//       return DataRow(
//         cells: [
//           DataCell(
//               Container(
//                   width: 50,
//                   child: Center(child: Text((index + 1).toString())))),
//           DataCell(Container(
//               width: 120,
//               child: Center(child: Text("AB0${dataList[i]['AB_id'].toString()}")))),
//           // child: Center(child: Text("AB01")))),
//           DataCell(Container(
//               width: 120,
//               child: Center(child: Text(dataList[i]['Solutions'][index]['id'].toString())))),
//           DataCell(Container(
//               width: 160,
//               // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
//               child: Center(child: Text(aboutMeName)))),
//           DataCell(Container(
//               width: 180,
//               child: Center(child: Text(dataList[i]['Solutions'][index]['Label'].toString())))),
//           DataCell(Container(
//               width: 300,
//               child: Center(child: Text(dataList[i]['Solutions'][index]['Description'].toString())))),
//           DataCell(Container(
//               width: 160,
//               child: Center(child: Text(dataList[i]['Solutions'][index]['Notes'].toString())))),
//           DataCell(Container(
//               child: Center(child: Text(dataList[i]['Solutions'][index]['Attachment'].toString())))),
//           DataCell(Container(
//               width: 120,
//               child: Center(child: Text(dataList[i]['Solutions'][index]['Provider'].toString())))),
//           DataCell(Container(
//               width: 80,
//               child: Center(child: Text(dataList[i]['Solutions'][index]['InPlace'].toString())))),
//           DataCell(Container(
//               width: 160,
//               child: Center(child: Text(dataList[i]['Solutions'][index]['Priority'].toString())))),
//         ],
//       );
//     },
//   ),
// );

///

//               StreamBuilder(
//                 stream: productsCollection
//                     .where('Name', isGreaterThanOrEqualTo: searchbyCatcontroller.text)
//                     // .where('Name', isLessThanOrEqualTo: searchbyCatcontroller.text + '\uf8ff').limit(10).snapshots(),
//                     .where('Name', isLessThanOrEqualTo: searchbyCatcontroller.text + '\uf8ff').snapshots(),
//                 builder: (ctx,AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//                   if (streamSnapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return Center(
//                         child: CircularProgressIndicator(
//                           //color: primaryColorOfApp,
//                         ));
//                   }
//
//                   documents = (streamSnapshot.data?.docs)??[];
//
//                   if (streamSnapshot.data == null || streamSnapshot.data!.docs.isEmpty) {
//                     print('No documents found in the stream.');
//                     return Center(child: Text("No Thriver is Added Yet", style: Theme.of(context).textTheme.displaySmall,));
//                   } else {
//                     documents = streamSnapshot.data!.docs;
//                     for (var doc in documents) {
//                       // Your logic here
//                       print('Document ID: ${doc.id}');
//                     }
//                   }
//
//
//
//
//                   //todo Documents list added to filterTitle
//                   // String searchText = searchTextEditingController.text.toLowerCase();
//                   String searchTexts = searchbyCatcontroller.text.toLowerCase();
//                   // if (searchText.length > 0) {
//                   //   documents = documents.where((element) {
//                   //     return element.get('Name').toString().toLowerCase()
//                   //         .contains(searchText.toLowerCase());
//                   //   }).toList();
//                   // }
//                   // if (searchTexts.length > 0) {
//                   //   documents = documents.where((element) {
//                   //     return element
//                   //         .get('Category')
//                   //         .toString()
//                   //         .toLowerCase()
//                   //         .contains(searchTexts.toLowerCase());
//                   //   }).toList();
//                   // }
//                   // if (searchTexts.length > 0) {
//                   //   documents = documents.where((element) {
//                   //     return element
//                   //         .get('Keywords')
//                   //         .toString()
//                   //         .toLowerCase()
//                   //         .contains(searchTexts.toLowerCase());
//                   //   }).toList();
//                   // }
//         ///
//                   // if (searchTexts.length > 0 || selectAllAny == "Any") {
//                   // documents = documents.where((element) {
//                   // print("documentssssssss: $documents");
//                   //
//                   // String category = element.get('tags').toString().toLowerCase();
//                   // String keywords = element.get('Keywords').toString().toLowerCase();
//                   //
//                   // return category.contains(searchTexts) || keywords.contains(searchTexts);
//                   // }).toList();
//                   // }
//                   //
//                   // if (searchTexts.length > 0 || selectAllAny=="All") {
//                   //   documents = documents.where((element) {
//                   //     String Name = element.get('Name').toString().toLowerCase();
//                   //     String Description = element.get('Description').toString().toLowerCase();
//                   //     String category = element.get('tags').toString().toLowerCase();
//                   //     String keywords = element.get('Keywords').toString().toLowerCase();
//                   //     return Name.contains(searchTexts) || Description.contains(searchTexts) || category.contains(searchTexts) || keywords.contains(searchTexts);
//                   //   }).toList();
//                   // }
//         /// search<
//
//         //                   if (searchTexts.isNotEmpty && (selectAllAny == "Any" || selectAllAny == "All")) {
// //                     documents = documents.where((element) {
// //                       String name = element.get('Name').toString().toLowerCase();
// //                       String description = element.get('Description').toString().toLowerCase();
// //                       String category = element.get('tags').toString().toLowerCase();
// //                       String keywords = element.get('Keywords').toString().toLowerCase();
// //                       String original = element.get('Original Description').toString().toLowerCase();
// //
// //                       if (selectAllAny == "Any") {
// //                         return category.contains(searchTexts) || keywords.contains(searchTexts);
// //                       } else if (selectAllAny == "All") {
// //                         return name.contains(searchTexts) ||
// //                             description.contains(searchTexts) ||
// //                             category.contains(searchTexts) ||
// //                             original.contains(searchTexts) ||
// //                             keywords.contains(searchTexts);
// //                       }
// //
// //                       return false; // Default case
// //                     }).toList();
// //
// //                     if (documents.isEmpty) {
// //
// //                       print('No data found in text: $searchTexts');
// //
// //                       return Center(child: Text("No data found in text $searchTexts"));
// //                       // Display a message when no data is found
// //                     }
// //                   }
//
//         /// >search
//
//
//                   if (searchTexts.isNotEmpty) {
//                     List<String> searchWords = searchTexts.toLowerCase().split(' ');
//
//                     documents = documents.where((element) {
//                       String name = element.get('Name').toString().toLowerCase();
//                       String description = element.get('Description').toString().toLowerCase();
//                       String category = element.get('tags').toString().toLowerCase();
//                       String keywords = element.get('Keywords').toString().toLowerCase();
//                       String original = element.get('Original Description').toString().toLowerCase();
//
//                       // if (selectAllAny == "Any") {
//                       //   return searchWords.any((word) =>
//                       //   name.contains(word) ||
//                       //       description.contains(word) ||
//                       //       category.contains(word) ||
//                       //       original.contains(word) ||
//                       //       keywords.contains(word));
//                       // } else if (selectAllAny == "All") {
//
//                       return searchWords.every((word) =>
//                         name.contains(word) ||
//                             description.contains(word) ||
//                             category.contains(word) ||
//                             original.contains(word) ||
//                             keywords.contains(word));
//                       // }
//
//                       return false; // Default case
//                     }).toList();
//
//                     if (documents.isEmpty) {
//                       // print('No data found for search text: $searchTexts');
//                       return Center(child: Text("No data found for search text $searchTexts"));
//                       // Display a message when no data is found
//                     }
//                   }
//
//                   ///
//
//                   // if (_addKeywordProvider.searchbycategory.isNotEmpty || _addKeywordProvider.searchbytag.isNotEmpty) {
//                   //
//                   //   // print("searchbycat_addKeywordProvider in stream after: ${_addKeywordProvider.searchbycategory} and ${_addKeywordProvider.searchbytag}");
//                   //
//                   //   documents = documents.where((element) {
//                   //     List<String> Category = (element.get('Keywords') as List<dynamic>).whereType<String>().map((tag) => tag.toString()).toList();
//                   //     List<String> tags = (element.get('tags') as List<dynamic>).whereType<String>().map((tag) => tag.toString()).toList();
//                   //
//                   //
//                   //     // print('Tags in document: $Category');
//                   //     // print('Search tags: ${_addKeywordProvider.searchbycategory}');
//                   //
//                   //     if(_addKeywordProvider.searchbycategory.isNotEmpty && _addKeywordProvider.searchbytag.isEmpty){
//                   //       // print("if");
//                   //       return _addKeywordProvider.searchbycategory.every((tag) => Category.contains(tag));
//                   //     }
//                   //
//                   //     else if (_addKeywordProvider.searchbytag.isNotEmpty && _addKeywordProvider.searchbycategory.isEmpty){
//                   //       // print("else if");
//                   //       return _addKeywordProvider.searchbytag.every((tag) => tags.contains(tag));
//                   //     }
//                   //
//                   //       else return _addKeywordProvider.searchbycategory.every((tag) => Category.contains(tag)) && _addKeywordProvider.searchbytag.every((tag) => tags.contains(tag));
//                   //   }).toList();
//                   //
//                   //   if (documents.isEmpty) {
//                   //     // print('No data found for search text: ${_addKeywordProvider.searchbycategory.join('')} and ${_addKeywordProvider.searchbytag.join('')}');
//                   //     return Center(child: (_addKeywordProvider.searchbycategory.isNotEmpty && _addKeywordProvider.searchbytag.isEmpty) ?
//                   //
//                   //     Text("No data found for ${_addKeywordProvider.searchbycategory.join(', ')}") :
//                   //
//                   //     (_addKeywordProvider.searchbytag.isNotEmpty && _addKeywordProvider.searchbycategory.isEmpty) ?
//                   //
//                   //     Text("No data found for ${_addKeywordProvider.searchbytag.join(', ')}") :
//                   //
//                   //     Text("No data found for ${_addKeywordProvider.searchbycategory.join(', ')} and ${_addKeywordProvider.searchbytag.join(', ')}"));
//                   //     // Display a message when no data is found
//                   //   }
//                   //
//                   // }
//
//                   ///
//
//                   // if (_addKeywordProvider.searchbytag.isNotEmpty) {
//                   //
//                   //   print("searchbycat_addKeywordProvider in stream after: ${_addKeywordProvider.searchbytag}");
//                   //
//                   //   documents = documents.where((element) {
//                   //     List<String> tags = (element.get('tags') as List<dynamic>).whereType<String>().map((tag) => tag.toString()).toList();
//                   //     // String category = element.get('Keywords').toString().toLowerCase();
//                   //
//                   //     print('Tags in document: $tags');
//                   //     print('Search tags: ${_addKeywordProvider.searchbytag}');
//                   //
//                   //     return _addKeywordProvider.searchbytag.every((tag) => tags.contains(tag));
//                   //   }).toList();
//                   //
//                   //   if (documents.isEmpty) {
//                   //     print('No data found for search text: ${_addKeywordProvider.searchbytag}');
//                   //     return Center(child: Text("No data found for search text ${_addKeywordProvider.searchbytag}"));
//                   //     // Display a message when no data is found
//                   //   }
//                   // }
//
//
//                   documents.sort((a, b) {
//                     var idA = a['id'];
//                     // print("idA: $idA");
//                     var idB = b['id'];
//                     // print("idB: $idB");
//                     // int? numericA = int.tryParse(idA.substring(2));
//                     // int? numericB = int.tryParse(idB.substring(2));
//                     int? numericA = idA;
//                     int? numericB = idB;
//                     // If the conversion fails, default to comparing the strings
//                     if (numericA == null && numericB == null) {
//                       return idA.compareTo(idB);
//                     } else if (numericA == null) {
//                       return 1; // Place items with null numericA at the end
//                     } else if (numericB == null) {
//                       return -1; // Place items with null numericB at the end
//                     }
//
//                     return numericA.compareTo(numericB);
//                   });
//                   return Expanded(
//                     child: ListView.separated(
//                      // reverse: true,
//                       shrinkWrap: true,
//                       padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
//                       physics: BouncingScrollPhysics(),
//                       itemCount: documents.length,
//                       // itemCount: documents.length > 30 ? 30 : documents.length,
//                       separatorBuilder: (BuildContext context, int index) {
//                         return Divider();
//                       },
//                       itemBuilder: (BuildContext context, int index) {
//                         //print('Images ${documents[index]['Images'].length}');
//                         //todo Pass this time
//                         // print("documents[index] : ${documents[index]}");
//                         return Column(
//                           children: [
//                             ThriversListTile(documents[index], index, documents),
//                           ],
//                         );
//
//                       },
//                     ),
//                   );
//
//                 },
//               ),
