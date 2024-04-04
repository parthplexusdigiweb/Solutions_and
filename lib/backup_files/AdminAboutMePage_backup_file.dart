import 'dart:async';
import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/Provider/AddKeywordsProvider.dart';
import 'package:thrivers/Provider/provider_for_challenges.dart';
import 'package:thrivers/Provider/userAboutMeProvider.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';
import 'package:thrivers/model/challenges_table_model.dart';
import 'package:thrivers/model/soluton_table_model.dart';

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
  TextEditingController MystrengthsController = TextEditingController();
  TextEditingController myOrganisationController = TextEditingController();
  TextEditingController myOrganisation2Controller = TextEditingController();
  TextEditingController NotesController = TextEditingController();
  TextEditingController searchbyCatcontroller = TextEditingController();
  TextEditingController searchChallengescontroller = TextEditingController();
  TextEditingController searchEmailcontroller = TextEditingController();

  Timer? _debounce;
  String query = "";
  int _debouncetime = 1000;
  var selectAllAny = "All";



  late final AddKeywordProvider _addKeywordProvider;

  late final UserAboutMEProvider _userAboutMEProvider;

  late final ChallengesProvider _challengesProvider;

  List<SolutionModel> solutions = [];
  List<ChallengesModel> Challenges = [];


  var selectedEmail ;
  var resultString ;

  List<String> emailList = [];

  List<Map<String, dynamic>> solutionsList = [];

  var solutionlistAb = [];
  var Ab_idArray = [];
  var aboutMeList, aboutMeName;
  int _perPage = 10;

  List<DocumentSnapshot> documents = [];
  List<DocumentSnapshot> challengesdocuments = [];

  bool _isLoadingMore = false;


  int _currentPage = 1;
  int _totalPages = 31;

  // Function to load next page

  // Function to load previous page

  // void _loadDataForPage(int page) {
  //   int startIndex = (page - 1) * _perPage;
  //
  //
  //   FirebaseFirestore.instance
  //       .collection('Thrivers')
  //       .orderBy('id')
  //       .startAfter([startIndex]) // Start after the specified document index
  //       .limit(_perPage)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     setState(() {
  //       documents.clear();
  //       documents.addAll(querySnapshot.docs);
  //     });
  //   }).catchError((error) {
  //     print('Error loading data for page $page: $error');
  //     setState(() {
  //     });
  //   });
  // }

  void _loadDataForChallengesPage(int page) {
    int startIndex = (page - 1) * _perPage;


    FirebaseFirestore.instance
        .collection('Challenges')
        .orderBy('id')
        .startAfter([startIndex]) // Start after the specified document index
        .limit(_perPage)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        challengesdocuments.clear();
        challengesdocuments.addAll(querySnapshot.docs);
      });
    }).catchError((error) {
      print('Error loading data for page $page: $error');
      setState(() {
      });
    });
  }

  final CollectionReference productsCollection =
  FirebaseFirestore.instance.collection('Thrivers');


  Future<void>  _loadDataForPageSearchFilter(String search) async {
    print("_addKeywordProvider.searchbycategory ${search}");

    documents.clear();
    QuerySnapshot querySnapshot = await productsCollection.get();

    final docssssss = querySnapshot.docs;

    final filteredDocs = docssssss.where((element) {
      var name = element.get("Name").toLowerCase();
      var description = element.get("Description").toLowerCase();

      // return name.contains(search.toLowerCase()) || description.contains(search.toLowerCase());

      if(name.contains(search.toLowerCase())){
        print("inisde element name $name and element is $element");

        return true;
      }

      return false;

    }).toList();

    documents.addAll(filteredDocs);
  }


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


  void _handleTabSelection() {
    if (_tabController!.index == 0) {
      _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString());
    } else if (_tabController!.index == 1) {
      _challengesProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString());
      // searchbyCatcontroller.clear();
    }
    if (_previousTabIndex != _tabController!.index && !searchbyCatcontroller.text.isEmpty) {
      setState(() {
        searchbyCatcontroller.clear();
      });
    }

    // Update previous tab index
    _previousTabIndex = _tabController!.index;
  }

    bool newLine = false;
  bool isInitialTyping = true;


  @override
  void initState() {
    page = PageController(initialPage: 0??0);
    sideMenu.addListener((p0) {
      page.jumpToPage(p0);
    });
    _addKeywordProvider = Provider.of<AddKeywordProvider>(context, listen: false);
    _userAboutMEProvider = Provider.of<UserAboutMEProvider>(context, listen: false);
    _challengesProvider = Provider.of<ChallengesProvider>(context, listen: false);
    _addKeywordProvider.loadDataForPage(_addKeywordProvider.currentPage);
    _challengesProvider.loadDataForPage(_challengesProvider.currentPage);
    // _loadDataForChallengesPage(_currentPage);
    fetchEmailList();
    super.initState();
    _addKeywordProvider.getdatasearch();
    _challengesProvider.getdatasearch();
    _tabController = TabController(length: 5, vsync: this); // Initialize the TabController
    _addKeywordProvider.lengthOfdocument = null;
    _challengesProvider.lengthOfdocument = null;
    newSelectCategories();
    getChatgptSettingsApiKey();

    // myOrganisation2Controller.addListener(() {
    //   print('___${myOrganisation2Controller.text}');
    //   String note = myOrganisation2Controller.text;
    //   if (note.isNotEmpty && note.substring(note.length - 1) == '\u2022') {
    //     print('newline');
    //     setState(() {
    //       newLine = true;
    //     });
    //   } else {
    //     setState(() {
    //       newLine = false;
    //     });
    //   }
    // });
    //
    // myOrganisationController.addListener(() {
    //   print('___${myOrganisationController.text}');
    //   String note = myOrganisationController.text;
    //   if (note.isNotEmpty && note.substring(note.length - 1) == '\u2022') {
    //     print('newline');
    //     setState(() {
    //       newLine = true;
    //     });
    //   } else {
    //     setState(() {
    //       newLine = false;
    //     });
    //   }
    // });
    //
    // mycircumstancesController.addListener(() {
    //   print('___${mycircumstancesController.text}');
    //   String note = mycircumstancesController.text;
    //   if (note.isNotEmpty && note.substring(note.length - 1) == '\u2022') {
    //     print('newline');
    //     setState(() {
    //       newLine = true;
    //     });
    //   } else {
    //     setState(() {
    //       newLine = false;
    //     });
    //   }
    // });
    //
    // MystrengthsController.addListener(() {
    //   print('___${MystrengthsController.text}');
    //   String note = MystrengthsController.text;
    //   if (note.isNotEmpty && note.substring(note.length - 1) == '\u2022') {
    //     print('newline');
    //     setState(() {
    //       newLine = true;
    //     });
    //   } else {
    //     setState(() {
    //       newLine = false;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    _tabController!.dispose(); // Dispose the TabController
    super.dispose();
  }

   _navigateToTab(int index) {
    _tabController.animateTo(index);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AboutMEScreen(),
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
                        Text("About Me", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.headlineMedium,)),

                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              showAddAddAboutMeDialogBox(context);
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
                    SizedBox(height: 10,),
                    Divider(),
                    SizedBox(height: 25,),


                    SingleChildScrollView(
                      child: Center(
                        child:
                        FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance.collection('AboutMe').get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }
                              else {
                                List<Map<String, dynamic>> dataList = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
                                // print("dataList : $dataList");
                                solutionlistAb.clear();

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

                               return Column(
                                 children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(

                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Container(
                                              width: 50,
                                              child: Center(
                                                  child: Text('No.',style: Theme.of(context).textTheme.titleMedium)
                                              )
                                          ),
                                          Container(
                                            width: 120,
                                            child: Center(
                                                child: Text('About Me Id',style: Theme.of(context).textTheme.titleMedium)
                                            ),
                                          ),
                                          Container(
                                            width: 80,
                                            child: Center(
                                                child: Text('SH/CH Id',style: Theme.of(context).textTheme.titleMedium)
                                            ),
                                          ),
                                          Container(
                                            width: 160,
                                            child: Center(
                                                child: Text('User Name',style: Theme.of(context).textTheme.titleMedium)
                                            ),
                                          ),

                                          Container(
                                            width: 250,
                                            child: Center(
                                                child: Text('Label',style: Theme.of(context).textTheme.titleMedium)
                                            ),
                                          ),
                                          Container(
                                              width: 400,
                                              child: Center(child:
                                              Text('Description',style: Theme.of(context).textTheme.titleMedium)
                                              )
                                          ),
                                          Container(
                                              width: 150,
                                              child: Center(child: Text('Notes',style: Theme.of(context).textTheme.titleMedium)
                                              )
                                          ),

                                          Container(
                                            width: 120,
                                            child: Center(
                                                child: Text('Attachments',style: Theme.of(context).textTheme.titleMedium)
                                            ),
                                          ),
                                          Container(
                                              width: 120,
                                              child: Center(child: Text('Provider',style: Theme.of(context).textTheme.titleMedium)
                                              )
                                          ),
                                          Container(
                                              width: 80,
                                              child: Center(child: Text('In Place',style: Theme.of(context).textTheme.titleMedium)
                                              )
                                          ),
                                          Container(
                                              width: 160,
                                              child: Center(child: Text('Priority',style: Theme.of(context).textTheme.titleMedium)
                                              )
                                          ),

                                        ],
                                      ),
                                    ),
                                   SizedBox(height: 5,),
                                   // Divider(
                                   //   color: Colors.black,
                                   //   thickness: 2,
                                   // ),
                                   Container(
                                     height: MediaQuery.of(context).size.height *.65,
                                     child: ListView.builder(
                                          itemCount:dataList.length ,
                                          // shrinkWrap: true,
                                          // physics: AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (c,i){
                                            print(dataList[i]['Solutions']);
                                            int overallIndex = 0;
                                            for (int j = 0; j < i; j++) {
                                              overallIndex += (dataList[j]['Solutions'] as List).length;
                                            }

                                               return Column(
                                                 children: List.generate(
                                                   dataList[i]['Solutions'].length,
                                                       (index) {
                                                     // List<Map<String, dynamic>> solutionsList =
                                                     //     dataList[index]['Solutions'] ?? <Map<String, dynamic>>[];
                                                     // print('solutions ab print $solutionlistAb');
                                                         overallIndex++;
                                                         return Column(
                                                       children: [
                                                         Container(
                                                           padding: EdgeInsets.all(10),
                                                           child: Row(
                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                             children: [
                                                                   Container(
                                                                       width: 50,
                                                                       child: Center(child: Text("${overallIndex}."))),
                                                                   Container(
                                                                   width: 120,
                                                                   child: Center(child: Text("AB0${dataList[i]['AB_id'].toString()}",style: Theme.of(context).textTheme.bodySmall))),
                                                               // child: Center(child: Text("AB01")))),
                                                                   Container(
                                                                   width: 80,
                                                                   child: Center(child: Text(dataList[i]['Solutions'][index]['id'].toString(), style: Theme.of(context).textTheme.bodySmall))),
                                                                   Container(
                                                                   width: 160,
                                                                   // child: Center(child: Text(dataList[index]['User_Name'].toString())))),
                                                                   child: Center(child: Text(dataList[i]['User_Name'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                                                                   Container(
                                                                   width: 250,
                                                                   child: Center(child: Text(dataList[i]['Solutions'][index]['Label'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                                                                   Container(
                                                                   width: 400,
                                                                   height: 80,
                                                                   child: Center(child: Text(dataList[i]['Solutions'][index]['Description'].toString()))),

                                                               Container(
                                                                   width: 160,
                                                                   child: Center(child: Text(dataList[i]['Solutions'][index]['Notes'].toString()))),

                                                                   Container(
                                                                       width: 120,
                                                                       child: Center(child: Text(dataList[i]['Solutions'][index]['Attachment'].toString()))),
                                                                   Container(
                                                                   width: 120,
                                                                   child: Center(child: Text(dataList[i]['Solutions'][index]['Provider'].toString(),style: Theme.of(context).textTheme.titleMedium))),
                                                                   Container(
                                                                   width: 80,
                                                                   child: Center(child: Text(dataList[i]['Solutions'][index]['InPlace'].toString(),style: Theme.of(context).textTheme.titleMedium))),
                                                                   Container(
                                                                   width: 160,
                                                                   child: Center(child: Text(dataList[i]['Solutions'][index]['Priority'].toString(),style: Theme.of(context).textTheme.titleMedium))),
                                                             ],
                                                           ),
                                                         ),
                                                         Divider(),
                                                       ],
                                                     );
                                                   },
                                                 ),
                                               );

                                      }),
                                   ),
                                 ],
                               );

                              }}
                        )

                      ),
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


  void showAddAddAboutMeDialogBox(cox) {

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
                              length: 5, // Number of tabs
                              child: Column(
                                children: [
                                  TabBar(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: _tabController,
                                    tabs: [
                                      Tab(text: "Personal Info"),
                                      Tab(text: "Details"),
                                      Tab(text: "Challenges"),
                                      Tab(text: "Solutions"),
                                      Tab(text: "PreviewPage"),
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
                                        PreviewPage(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )

                      ),
                      );
                  })

          );
        }
    );
  }

  Widget AboutmeFormpage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text("1. Personal Info",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black)),
          ),
          SizedBox(height: 20,),
          Container(
            height: MediaQuery.of(context).size.height * .7,
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
      
      
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("1. Email:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                      isFilterOnline: true,
                      searchDelay: Duration(milliseconds: 100),
                      searchFieldProps: TextFieldProps(
                          enableSuggestions: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Search Email",
                            labelText: "Search Email",
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
                          controller: searchEmailcontroller
                      ),
                      showSearchBox: true,
                      disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    // items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                    items: emailList,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
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
                    onChanged: (val){
                      setState(() {
                        selectedEmail = val!;
                      });
                      print("selectedEmail:${selectedEmail}");
      
                    },
                    selectedItem: selectedEmail,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("2. Name:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
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
                    child: Text("3. Employer:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
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
                    child: Text("4. Division or section:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
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
                    child: Text("5. Role:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
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
                    child: Text("6. Location:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
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
                    child: Text("7. Employee number:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
                    controller: EmployeeNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      
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
                    child: Text("8. Line manager:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
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
      
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  // page.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
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
                          solutionsList.clear();
                          _userAboutMEProvider.solutionss.clear();
                          _userAboutMEProvider.challengess.clear();
                  Navigator.pop(context);
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
                  _navigateToTab(1);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width * .3,
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
                      'Next',
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

  Widget Detailspage() {
    return SingleChildScrollView(
      child:Consumer<UserAboutMEProvider>(
          builder: (c,userAboutMEProvider, _){
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text("2. Details",
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black)),
                ),
                SizedBox(height: 20,),
                Container(
                  height: MediaQuery.of(context).size.height * .7,
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

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                          child: Text("1. About me and my circumstances:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                        ),
                        TextField(
                          controller: mycircumstancesController,
                          maxLines: 5,
                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              final lines = value.split('\n');

                              for (int i = 0; i < lines.length; i++) {
                                if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                                  lines[i] = '• ' + lines[i];
                                }
                              }

                              mycircumstancesController.text = lines.join('\n');
                              mycircumstancesController.selection = TextSelection.fromPosition(
                                TextPosition(offset: mycircumstancesController.text.length),
                              );
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
                            hintText: "About me and my circumstances",
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

                          maxLines: 5,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              final lines = value.split('\n');

                              for (int i = 0; i < lines.length; i++) {
                                if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                                  lines[i] = '• ' + lines[i];
                                }
                              }

                              MystrengthsController.text = lines.join('\n');
                              MystrengthsController.selection = TextSelection.fromPosition(
                                TextPosition(offset: MystrengthsController.text.length),
                              );
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
                            hintText: "My strengths that I want to have the opportunity to use in my role",
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

                          maxLines: 5,


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
                                if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                                  lines[i] = '• ' + lines[i];
                                }
                              }

                              myOrganisationController.text = lines.join('\n');
                              myOrganisationController.selection = TextSelection.fromPosition(
                                TextPosition(offset: myOrganisationController.text.length),
                              );
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
                            hintText: "What I value about [my organisation] and workplace environment that helps me perform to my best",
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

                          maxLines: 5,

                          // cursorColor: primaryColorOfApp,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              final lines = value.split('\n');

                              for (int i = 0; i < lines.length; i++) {
                                if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                                  lines[i] = '• ' + lines[i];
                                }
                              }

                              myOrganisation2Controller.text = lines.join('\n');
                              myOrganisation2Controller.selection = TextSelection.fromPosition(
                                TextPosition(offset: myOrganisation2Controller.text.length),
                              );
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
                            hintText: "What I find challenging about [My Organisation] and the workplace environment that makes it harder for me to perform my best",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        // page.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                        _navigateToTab(0);
                        // Navigator.pop(context);
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
                            'Back',
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
                          await _navigateToTab(2);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.width * .3,
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
                            'Next',
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
                              fontSize: 20,
                              color: Colors.black)),
                      Checkbox(
                        activeColor: Colors.blue,
                        value: userAboutMEProvider.isRecommendedcCheckedForTileChallenge(i), // Use the state from the provider
                        // value: userAboutMEProvider.challengess[i].isChecked, // Use the state from the provider
                        onChanged: (value) {
                          userAboutMEProvider.isRecommendedClickedBoxChallenge(value, i, documentsss![i] );
                        },
                      ),
                    ],
                  ),
                  // Text("${challengesData['Label']}",
                  //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                  //         fontSize: 25,
                  //         color: Colors.black)),

                  SizedBox(height: 10,),

                  Text("Description :",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black)),
                  SizedBox(height: 10,),

                  Text("${challengesData['Final_description']}",
                      maxLines: 3,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black)),
                  SizedBox(height: 10,),

                  Text("Impact :",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black)),
                  SizedBox(height: 10,),
                  Text("${challengesData['Impact']}",
                      maxLines: 3,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black)),
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
                              fontSize: 20,
                              color: Colors.black)),
                      Checkbox(
                        activeColor: Colors.blue,
                        value: userAboutMEProvider.isRecommendedcCheckedForTileSoltuions(i), // Use the state from the provider
                        onChanged: (value) {
                          userAboutMEProvider.isRecommendedClickedBoxSolutions(value, i, documentsss![i] );
                        },
                      ),
                    ],
                  ),
                  // Text("${challengesData['Label']}",
                  //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                  //         fontSize: 25,
                  //         color: Colors.black)),

                  SizedBox(height: 10,),

                  Text("Description :",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black)),
                  SizedBox(height: 10,),

                  Text("${solutionsData['Final_description']}",
                      maxLines: 3,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black)),
                  SizedBox(height: 10,),

                  Text("Impact :",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black)),
                  SizedBox(height: 10,),
                  Text("${solutionsData['Impact']}",
                      maxLines: 3,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black)),
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
    var keywords = ["Mental & Emotional", "Physical", "Life"];
    // getRelatedChallenges(tags, keywords);

    print("AddChallengesPage: ${combinedResults}");

    print("RelatedChallengesdocuments: ${RelatedChallengesdocuments}");


    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("3. Challenges",
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black)),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                GestureDetector(
                  onTap:(){
                    showChallengesSelector();
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
                        'Browse',
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
                GestureDetector(
                  onTap:(){
                    showChallengesSelector();
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
              ],
            ),
            SizedBox(height: 10,),
            Consumer<UserAboutMEProvider>(
              builder: (context, userAboutMEProvider, _) {
                // print("challengesssss : ${userAboutMEProvider.challengess}");
            
            
                return (userAboutMEProvider.challengess.isEmpty) ?
                Container(
                  height: 350,
                  child: Center(child: Text("No Challenges Added Yet", style:
                  GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.displaySmall,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),),),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ) : Container(
                  height: 350,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width,
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
                              child: Text('No.',textAlign: TextAlign.center,),
                            ),

                        ),
                        DataColumn(
                          label: Container(
                            // width: 180,
                            child: Text('Label',),
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
                            DataCell(
                                Container(
                                    // width: 60,
                                    child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),))
                            ),
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
                                        showconfirmrDialogBox(challenge.id, challenge.label,challenge.description, challenge.Source, challenge.Status,challenge.tags,challenge.CreatedBy,
                                            challenge.CreatedDate,challenge.ModifiedBy,challenge.ModifiedDate,challenge.OriginalDescription,challenge.Impact,challenge.Final_description,
                                            challenge.Category,challenge.Keywords,challenge.PotentialStrengths,challenge.HiddenStrengths, index,userAboutMEProvider.challengess);                                        print("challenge.isConfirmed: ${challenge.isConfirmed}");
                                      },
                                      icon: Icon(Icons.check, color: Colors.green),
                                    ),
                                    SizedBox(width: 20,),
                                    IconButton(
                                      onPressed: () {
                                        userAboutMEProvider.removeChallenge(index,challenge);
                                        userAboutMEProvider.isRecommendedChallengeCheckedMap[index] = false;
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
            
            SizedBox(height: 10,),
            
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
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Text("Recommended Challenges (${combinedResults.length}):",
                style: GoogleFonts.montserrat(
                    textStyle: Theme.of(context).textTheme.titleLarge,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 10,),
            
            Container(
              width: MediaQuery.of(context).size.width,
              height: 210, // Add a fixed height constraint here
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: combinedResults.length,
                itemBuilder: (c, i) {
                  // relatedSolutionlength = relatedChallenges?.length;
                  // print("relatedSolutionlength: ${combinedResults.length}");
                  RelatedChallengesdocuments = combinedResults.toList();
                  print("solutionData: ${RelatedChallengesdocuments}");

                  DocumentSnapshot document = RelatedChallengesdocuments[i];

                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.all(12),
                      width: 470,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: RecommendedChallengesListTile(document, i, RelatedChallengesdocuments)
                  );
                },
              ),
            ),
            
            
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    // page.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                    _navigateToTab(1);
                    // Navigator.pop(context);
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
                        'Back',
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
                SizedBox(height: 5, width: 5,),
                InkWell(
                  onTap: () async{
                    await getRelatedSolutions(generatedsolutionstags, generatedsolutionscategory);

                    // await page.animateToPage(3, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                    _navigateToTab(3);

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width * .3,
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
                        'Next',
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
      ),
    );
  }

  Widget AddSolutionsPage(){
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("4. Solutions",
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black)),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap:(){
                showSolutionSelectors();
              },
              child:Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                // width: MediaQuery.of(context).size.width * .2,
                width: MediaQuery.of(context).size.width * .04,

                // height: 60,
                decoration: BoxDecoration(
                  color:Colors.blue ,
                  border: Border.all(
                      color:Colors.blue ,
                      width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Center(
                  child: Icon(Icons.add, size: 30,color: Colors.white,),
                  // child: Text(
                  //   'Add Solutions',
                  //   style: GoogleFonts.montserrat(
                  //     textStyle:
                  //     Theme
                  //         .of(context)
                  //         .textTheme
                  //         .titleSmall,
                  //     fontWeight: FontWeight.bold,
                  //     color:Colors.white ,
                  //   ),
                  // ),
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
        
                return (userAboutMEProvider.solutionss.isEmpty) ?
                Container(
                  height: 350,
                  child: Center(child: Text("No Solutions Added Yet", style:
                  GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.displaySmall,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),),),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ) : Container(
                  height: 350,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child:SingleChildScrollView(
                    child: DataTable(
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.black),
                      //     borderRadius: BorderRadius.circular(15)
                      // ),
                      // horizontalMargin: 10,
                      dataRowMaxHeight:60 ,
                      headingTextStyle: GoogleFonts.montserrat(
                          textStyle: Theme.of(context).textTheme.titleMedium,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      columnSpacing: 15,
                      // border: TableBorder.all(),
                      // columns: [
                      //   DataColumn(
                      //       label: Container(
                      //           width: 60,
                      //           child: Center(
                      //               child: Text('ID')
                      //           )
                      //       )
                      //   ),
                      //   DataColumn(
                      //     label: Container(
                      //       width: 180,
                      //       child: Center(
                      //           child: Text('Label',)
                      //       ),
                      //     ),
                      //   ),
                      //   DataColumn(
                      //     label: Container(
                      //         // width: 400,
                      //         child: Center(child:
                      //         Text('Description')
                      //         )
                      //     ),
                      //   ),
                      //   DataColumn(
                      //       label: Container(
                      //           // width: 140,
                      //           child: Center(child: Text('Confirm/Cancel')
                      //           )
                      //       )
                      //   ),
                      //
                      // ],
                      columns: [

                        DataColumn(
                          label: Container(
                            // color: Colors.blue,
                            // width: 60,
                            child: Text('No.',textAlign: TextAlign.center,),
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
                            DataCell(
                                Container(
                                    // width: 60,
                                    // child: Text(solution.id, style: GoogleFonts.montserrat(
                                    child: Text("${index + 1}.", style: GoogleFonts.montserrat(
                                        textStyle: Theme.of(context).textTheme.bodySmall,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),))),
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
                                        showconfirmrDialogBox(solution.id, solution.label,solution.description, solution.Source, solution.Status,solution.tags,solution.CreatedBy,
                                            solution.CreatedDate,solution.ModifiedBy,solution.ModifiedDate,solution.OriginalDescription,solution.Impact,solution.Final_description,
                                            solution.Category,solution.Keywords,"","", index,userAboutMEProvider.solutionss);
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
        
            SizedBox(height: 10,),
        
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: Text("Recommended Solutions (${combinedSolutionsResults.length}):",
                style: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.titleLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              ),
            ),
        
            SizedBox(height: 10,),
        
            Container(
              width: MediaQuery.of(context).size.width,
              height: 210, // Add a fixed height constraint here
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: combinedSolutionsResults.length,
                itemBuilder: (c, i) {
                  // relatedSolutionlength = relatedChallenges?.length;
                  // print("relatedSolutionlength: ${combinedResults.length}");
                  RelatedSolutionsdocuments = combinedSolutionsResults.toList();
                  // print("solutionData: ${RelatedChallengesdocuments}");
        
                  DocumentSnapshot document = RelatedSolutionsdocuments[i];
        
                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.all(12),
                      width: 470,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: RecommendedSolutionsListTile(document, i, RelatedSolutionsdocuments)
                  );
                },
              ),
            ),
        
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    // page.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                    _navigateToTab(2);
                    // Navigator.pop(context);
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
                        'Back',
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
                SizedBox(height: 5, width: 5,),
                InkWell(
                  onTap: () async {
                    // page.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                    _navigateToTab(4);

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width * .3,
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
        
                    Map<String, dynamic> AboutMEDatas = {
                      // 'AB_id': x,
                      'Email': selectedEmail,
                      'User_Name': nameController.text,
                      'Employee': employerController.text,
                      'Division_or_Section': divisionOrSectionController.text,
                      'Role': RoleController.text,
                      'Location': LocationController.text,
                      'Employee_Number': EmployeeNumberController.text,
                      'Line_Manager': LineManagerController.text,
                      'My_Circumstance': mycircumstancesController.text,
                      'My_Strength': MystrengthsController.text,
                      'My_Organisation': mycircumstancesController.text,
                      'Solutions': solutionsList,
                      "Created_By": widget.AdminName,
                      "Created_Date": createdAt,
                      "Modified_By": "",
                      "Modified_Date": "",
                      // Add other fields as needed
                    };
        
                    String solutionJson = json.encode(AboutMEDatas);
                    print(solutionJson);
        
                    ProgressDialog.show(context, "Creating About Me", Icons.chair);
                    await ApiRepository().createAboutMe(AboutMEDatas);
                    ProgressDialog.hide();
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
                    solutionsList.clear();
                    _userAboutMEProvider.solutionss.clear();
                    Navigator.pop(context);
                    setState(() {
        
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width * .3,
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
      ),
    );
  }

  Widget PreviewPage(){
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("5. Preview",
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black)),
            ),
            SizedBox(height: 20,),

          ],
        ),
      ),
    );
  }

  List _messages = [];
  var openAiApiKeyFromFirebase;

  var _openAI;


  Future<String> getChatgptSettingsApiKey() async {
    String apiKey = "";
    // _addKeywordProvider.querySnapshotsss = await _addKeywordProvider.productsCollection.get();
    // _addKeywordProvider.docssssss  = _addKeywordProvider.querySnapshotsss?.docs;

    await FirebaseFirestore.instance.collection('ChatGpt-Settings').doc("OpenAI").get().then((value) {

      // Access the specific field
      apiKey = value['APIKey'];
      openAiApiKeyFromFirebase = apiKey;

      // print("openAiApiKeyFromFirebase :$openAiApiKeyFromFirebase");
      // // Perform the update operation
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
    // print("apenaikey :$apiKey");
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

  }

  Set<DocumentSnapshot> combinedResults = {};
  Set<DocumentSnapshot> combinedSolutionsResults = {};

  List<DocumentSnapshot> RelatedChallengesdocuments = [];
  List<DocumentSnapshot> RelatedSolutionsdocuments = [];

  Future<List<DocumentSnapshot>> getRelatedChallenges(List<dynamic> tags, List<dynamic> keywords) async {
    // Assuming your Firestore collection is named "solutions"
    CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Challenges');

    // print("relatedd tagsss: $tags");
    // print("relatedd keywords: $keywords");
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

    // print("tagsResults: $tagsResults");
    // print("keywordsResults: ${keywordsResults}");
    // Use a set to avoid duplicate documents
    combinedResults = Set.from(tagsResults);
    combinedResults.addAll(keywordsResults);

    // print("combinedResults: $combinedResults");
    print("combinedResults.length: ${combinedResults.length}");

    return combinedResults.toList();
  }

  Future<List<DocumentSnapshot>> getRelatedSolutions(List<dynamic> tags, List<dynamic> keywords) async {
    // Assuming your Firestore collection is named "solutions"
    CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Thrivers');

    // print("relatedd tagsss: $tags");
    // print("relatedd keywords: $keywords");
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

    // print("tagsResults: $tagsResults");
    // print("keywordsResults: ${keywordsResults}");
    // Use a set to avoid duplicate documents
    combinedSolutionsResults = Set.from(tagsResults);
    combinedSolutionsResults.addAll(keywordsResults);

    // print("combinedResults: $combinedResults");
    print("combinedSolutionsResults.length: ${combinedSolutionsResults.length}");

    return combinedSolutionsResults.toList();
  }


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
                          //   _challengesProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString(),selectAllAny);
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
  }*/ /// this is tab of solution and challenges

  void showChallengesSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Challenges'),
          content: Consumer<ChallengesProvider>(
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
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
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

                    Container(
                      height: MediaQuery.of(context).size.height * .6,
                      width: MediaQuery.of(context).size.width * .6,
                      child: SingleChildScrollView(
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
                              )
                    ),



                  ],
                );
              }),
          actions: [
            Consumer<UserAboutMEProvider>(
                builder: (context, userAboutMEProvider, _) {
                  return
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            userAboutMEProvider.clearSelectedChallenges();
                            userAboutMEProvider.isCheckedMapchallenge.clear();

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
                            userAboutMEProvider.addchallenges();
                            userAboutMEProvider.clearSelectedChallenges();
                            userAboutMEProvider.isCheckedMapchallenge.clear();
                            // userAboutMEProvider.clearSelectedSolutions();

                            Navigator.pop(context);
                            print("Challenges: $Challenges");

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

                        )


                      ],
                    );
                })
          ],

        );
      },
    );
  } ///this

  void showSolutionSelectors() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                            // userAboutMEProvider.isCheckedMapchallenge.clear();

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
                            userAboutMEProvider.clearSelectedSolutions();
                            userAboutMEProvider.isCheckedMap.clear();
                            // userAboutMEProvider.isCheckedMapchallenge.clear();


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

                        )


                      ],
                    );
                })
          ],
          title: Text('Select Solutions'),
            content: Consumer<AddKeywordProvider>(
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
                                  addKeywordProvider.loadDataForPage(1);
                                  addKeywordProvider.setFirstpageNo();
                                },
                                child: Text("..clear all",style: TextStyle(color: Colors.blue))),
                          ],
                        ),
                      ) :

                      SizedBox(height: 35,),
                      Divider(
                        color: Colors.black,
                        height: 10,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * .6,
                          width: MediaQuery.of(context).size.width * .6,
                          child: SingleChildScrollView(
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
                          )
                      ),

                    ],
                  );
                })

        );
      },
    );
  } ///this


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

  Widget ChallengesListTile(DocumentSnapshot<Object?> challengesDetails, i, documents) {

    return Consumer<UserAboutMEProvider>(
        builder: (c,userAboutMEProvider, _){
      return  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(width: 10,),
        // Text(challengesDetails.id,style: Theme.of(context).textTheme.bodySmall),
        // Text("${i+1}.",style: Theme.of(context).textTheme.bodySmall),
        Text("CH0${challengesDetails['id']}",style: Theme.of(context).textTheme.bodySmall),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(challengesDetails['Label'],style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis),
              Text(challengesDetails['Description'],style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2,),
              SizedBox(height: 10),
            ],
          ),
        ),
        SizedBox(width: 30),

        Center(
          child: Checkbox(
            activeColor: Colors.blue,
            value: userAboutMEProvider.isCheckedForTileChallenge(i), // Use the state from the provider
            onChanged: (value) {
              userAboutMEProvider.isClickedBoxChallenge(value, i, challengesDetails);
            },
          ),
        )


      ],
    );
    });
  }


  void showconfirmrDialogBox(Id,label,description,source,ChallengeStatus,tags,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,OriginalDescription,
      Impact,Final_description,Category ,Keywords ,PotentialStrengths, HiddenStrengths, index, listname)  {

    DateTime dateTime = CreatedDate.toDate();


    final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");


    String formattedDate = formatter.format(dateTime);

    print("Inside showconfirmrDialogBox");
    print("Id: $Id");
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
                            onTap: (){
                              if(NotesController.text.isEmpty || userAboutMEProvider.selectedProvider == null || userAboutMEProvider.selectedInPlace == null
                                  || userAboutMEProvider.selectedPriority == null ){
                                if(NotesController.text.isEmpty){
                                  showEmptyAlert(context, "Add Notes");
                                }
                                else if(userAboutMEProvider.selectedProvider == null ){
                                  showEmptyAlert(context, "Select Provider");
                                }
                                else if(userAboutMEProvider.selectedInPlace == null ){
                                  showEmptyAlert(context, "Select In Place");
                                }
                                else if(userAboutMEProvider.selectedPriority == null){
                                  showEmptyAlert(context, "Select Priority");
                                }
                              }
                              else {
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
                              'Notes': NotesController.text,
                              'Provider': userAboutMEProvider.selectedProvider,
                              'InPlace': userAboutMEProvider.selectedInPlace,
                              'Priority': userAboutMEProvider.selectedPriority,
                              'Attachment': 'document.pdf',
                              // 'confirmed': false, // Add a 'confirmed' field
                            };

                            // String solutionJson = json.encode(solutionData);
                            // print(solutionJson);

                            print("tags: $tags");
                            print("Keywords: $Keywords");

                            generatedsolutionstags.addAll(tags);
                            generatedsolutionscategory.addAll(Keywords);

                            print(
                                "generatedsolutionstags: $generatedsolutionstags");

                            print(
                                "generatedsolutionscategory: $generatedsolutionscategory");

                            userAboutMEProvider.confirmed(
                                index, true, listname);

                            // setState(() {
                            //   isConfirmed = userAboutMEProvider.isConfirm;
                            //   solutionData['confirmed'] = isConfirmed;
                            // });

                            // print("solutionData['confirmed']: $isConfirmed");

                            solutionsList.add(solutionData);

                            print(
                                "solutionsList.length: ${solutionsList.length}");
                            print("solutionsList: ${solutionsList}");
                            NotesController.clear();
                            userAboutMEProvider.selectedPriority = null;
                            userAboutMEProvider.selectedProvider = null;
                            userAboutMEProvider.selectedInPlace = null;
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
                          child: Text("Confirm Solution",
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

                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                child: Text("Notes :",
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

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                child: Text("In Place :",
                                    style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,
                                    fontWeight: FontWeight.w600)),
                              ),
                              Row(
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
                              ),


                              SizedBox(height: 10,),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                child: Text("Priority :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,
                                    fontWeight: FontWeight.w600)),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: userAboutMEProvider.Priority.map((String value) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * .18,
                                    child: Row(
                                      children: [
                                        Radio<String>(
                                          value: value,
                                          groupValue: userAboutMEProvider.selectedPriority,
                                          activeColor: Colors.blue,
                                          onChanged: (newValue) {
                                            // setState(() {
                                            //   selectedProvider = newValue;
                                            // });
                                            userAboutMEProvider.updatePriority(newValue);
                                          },
                                        ),
                                        Flexible(
                                          child: Text(
                                            value,
                                            style: TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),



                              SizedBox(height: 10,),

                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                    child: Text("Attachment :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                                  ),
                                  SizedBox(width: 10,),

                                  InkWell(
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
                                child: Text("document.pdf", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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
