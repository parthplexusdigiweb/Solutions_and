import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/Provider/AddKeywordsProvider.dart';
import 'package:thrivers/Provider/previewProvider.dart';
import 'package:thrivers/Provider/provider_for_challenges.dart';
import 'package:thrivers/Provider/userAboutMeProvider.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';
import 'package:thrivers/model/soluton_table_model.dart';
import 'package:toastification/toastification.dart';

import '../model/challenges_table_model.dart';

class EditAboutMEScreen extends StatefulWidget {
  var aboutMeData, refreshPage, AdminName, tabindex, page,showAddAddAboutMeDialogBox;

  EditAboutMEScreen({this.aboutMeData, this.refreshPage, this.AdminName, this.tabindex, this.page, this.showAddAddAboutMeDialogBox});

  @override
  State<EditAboutMEScreen> createState() => _EditAboutMEScreenState();
}

class _EditAboutMEScreenState extends State<EditAboutMEScreen> with TickerProviderStateMixin {

  late TabController _tabController;

  late final AddKeywordProvider _addKeywordProvider;

  late final UserAboutMEProvider _userAboutMEProvider;

  late final ChallengesProvider _challengesProvider;

  late final PreviewProvider _previewProvider;


  TextEditingController searchEmailcontroller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController employerController = TextEditingController();
  TextEditingController divisionOrSectionController = TextEditingController();
  TextEditingController RoleController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  TextEditingController EmployeeNumberController = TextEditingController();
  TextEditingController LineManagerController = TextEditingController();
  TextEditingController mycircumstancesController = TextEditingController();
  TextEditingController AboutMeLabeltextController = TextEditingController();
  TextEditingController AboutMeDescriptiontextController = TextEditingController();
  TextEditingController AboutMeDatetextController = TextEditingController();
  TextEditingController AboutMeUseFulInfotextController = TextEditingController();
  TextEditingController SendNametextController = TextEditingController();
  TextEditingController CopySendNametextController = TextEditingController();
  TextEditingController SendEmailtextController = TextEditingController();
  TextEditingController CopySendEmailtextController = TextEditingController();
  TextEditingController RefineController = TextEditingController();
  TextEditingController MystrengthsController = TextEditingController();
  TextEditingController myOrganisationController = TextEditingController();
  TextEditingController myOrganisation2Controller = TextEditingController();
  TextEditingController editNotesController = TextEditingController();
  TextEditingController editsearchbyCatcontroller = TextEditingController();
  TextEditingController editsearchChallengescontroller = TextEditingController();
  TextEditingController NotesController = TextEditingController();
  TextEditingController finaltextcontroller = TextEditingController();
  TextEditingController finalSolutiontextcontroller = TextEditingController();
  TextEditingController ImpactAddChallengetextcontroller = TextEditingController();
  TextEditingController ImpactSolutiontextcontroller = TextEditingController();
  TextEditingController NotesAddChallengetextcontroller = TextEditingController();
  TextEditingController NotesSolutiontextcontroller = TextEditingController();
  TextEditingController challengesNameTextEditingController = TextEditingController();
  TextEditingController challengesDescriptionTextEditingController = TextEditingController();
  TextEditingController SolutionDescriptionTextEditingController = TextEditingController();
  TextEditingController SolutionNameTextEditingController = TextEditingController();
  TextEditingController challengesOriginalDescriptionTextEditingController = TextEditingController();
  TextEditingController SolutionsOriginalDescriptionTextEditingController = TextEditingController();


  List<SolutionModel> solutions = [];
  List<ChallengesModel> Challenges = [];

  List<dynamic> editKeywordssss = [];
  List<dynamic> edittags = [];
  List<dynamic> SolutionseditKeywordssss = [];
  List<dynamic> Solutionsedittags = [];

  var selectedEmail,AB_Status;
  String About_Me_Label = "";
  var resultString,solutionresultString;

  String messages = """
Dear LMN,

Thank you for recognising that our organisation performs better, and we achieve more together, when each of us feels safe and open to share what we need to be our best in the roles we are asked and agree to perform. This communication sets out what I think it would be helpful for you to know about me and includes what I believe helps me thrive, so that I can perform to my best, both for me and for LMN.

In relation to performing to my very best, both to help me and LMN to achieve the best we can, on the next two pages I have set out:
• information that I think it is helpful for me to share with my Team Leader and team colleagues, and
• actions and adjustments that I’ve identified can help me perform to my best in my role for LMN.

Next steps:
I will arrange to have a meeting with my [Team Leader]/[occupational health]/[relevant HR person] to discuss my requests in person. This request includes accommodations that I view as reasonable adjustments under the Equality Act 2010.

Thank you for being open to understanding me better and for considering my requests.

Signed
Date
""";


  List<String> emailList = [];

  List<Map<String, dynamic>> solutionsList = [];
  List<Map<String, dynamic>> challengesList = [];

  bool isInitialTyping = true;
  var documentId;

  List<dynamic> generatedtags = [];
  List<dynamic> generatedsolutionstags = [];
  List<dynamic> generatedcategory = [];
  List<dynamic> generatedsolutionscategory = [];
  List<DocumentSnapshot> RelatedChallengesdocuments = [];
  List<DocumentSnapshot> RelatedSolutionsdocuments = [];

  TextEditingController searchChallengescontroller = TextEditingController();
  TextEditingController searchbyCatcontroller = TextEditingController();


  Timer? _debounce;
  String query = "";
  int _debouncetime = 1000;

  List _messages = [];
  var openAiApiKeyFromFirebase;

  var _openAI;

  @override
  void initState() {
    _addKeywordProvider = Provider.of<AddKeywordProvider>(context, listen: false);
    _userAboutMEProvider = Provider.of<UserAboutMEProvider>(context, listen: false);
    _challengesProvider = Provider.of<ChallengesProvider>(context, listen: false);
    _previewProvider = Provider.of<PreviewProvider>(context, listen: false);
    _addKeywordProvider.loadDataForPage(_addKeywordProvider.currentPage);
    _challengesProvider.loadDataForPage(_challengesProvider.currentPage);
    // _loadDataForChallengesPage(_currentPage);
    super.initState();
    _addKeywordProvider.getdatasearch();
    _challengesProvider.getdatasearch();
    _tabController = TabController(length: 7, vsync: this); // Initialize the TabController
    _tabController.index = widget.tabindex;
    _addKeywordProvider.lengthOfdocument = null;
    _challengesProvider.lengthOfdocument = null;
    documentId = widget.aboutMeData.id;
    fetchEmailList();
    getQuestions();
    newSelectCategories();
    newSolSelectCategories();
    getChatgptSettingsApiKey();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Call EditChallengeList after the first frame has been rendered
      _userAboutMEProvider.EditChallengeList( widget.aboutMeData["Challenges"]);
      _userAboutMEProvider.EditChallengeListadd(challengesList);
      _userAboutMEProvider.EditChallengeListadd(_previewProvider.PreviewChallengesList);
      _userAboutMEProvider.EditSolutionList(widget.aboutMeData["Solutions"]);
      _userAboutMEProvider.EditSolutionListadd(solutionsList);
      _userAboutMEProvider.EditSolutionProvideradd(_previewProvider.PreviewSolutionMyResposibilty);
      _userAboutMEProvider.EditSolutionInPlaceadd(_previewProvider.PreviewSolutionStillNeeded,_previewProvider.PreviewSolutionNotNeededAnyMore,
          _previewProvider.PreviewSolutionNiceToHave,_previewProvider.PreviewSolutionMustHave);
      About_Me_Label = widget.aboutMeData["About_Me_Label"];
    });
  }

  void dispose() {
    _tabController!.dispose(); // Dispose the TabController
    super.dispose();
  }

  _navigateToTab(int index) {
    _tabController.animateTo(index);
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

  @override
  Widget build(BuildContext context) {
    print("widget.tabindex: ${widget.tabindex}");
    return Theme(
        data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
        child:  Consumer<UserAboutMEProvider>(
            builder: (c,userAboutMEProvider, _){
              return
                AlertDialog(
                  content: SizedBox(
                      width: double.maxFinite,
                      child:DefaultTabController(
                        length: 6, // Number of tabs
                        child: Column(
                          children: [
                            TabBar(
                              physics: NeverScrollableScrollPhysics(),
                              unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(),
                              controller: _tabController,
                              tabs: [
                                Tab(icon: Icon(Icons.add_box_outlined),text: "Employee data"),
                                Tab(icon: Icon(Icons.person_add_outlined),text: "Insights about me"),
                                Tab(icon: Icon(Icons.edit_attributes),text: "My attributes"),
                                Tab(icon: Icon(Icons.sync_problem),text: "My challenges"),
                                Tab(icon: Icon(Icons.checklist_rtl),text: "My solutions"),
                                Tab(icon: Icon(Icons.insert_drive_file),text: "Generate reports"),
                                Tab(icon: Icon(Icons.library_books),text: "My Library"),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _tabController,
                                children: [
                                  AboutmeFormpage(context,widget.aboutMeData),
                                  Detailspage(context, widget.aboutMeData),
                                  AssesmentAssistant(),
                                  AddChallengesPage(context, widget.aboutMeData),
                                  AddSolutionsPage(context, widget.aboutMeData),
                                  MyReportScreen(widget.aboutMeData),
                                  MyLibraryScreen(),
                                  // PreviewPage(widget.aboutMeData)
                                ],
                              ),
                            ),
                          ],
                        ),
                      )

                  ),
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(left: 15,top: 15),
                      //   child: Text("AB0${widget.aboutMeData['AB_id'].toString()}",style: Theme.of(context).textTheme.titleMedium),
                      // ),
                      InkWell(
                          onTap: (){
                            selectedEmail = null;
                            searchEmailcontroller.clear();
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
                            AboutMeLabeltextController.clear();
                            AboutMeUseFulInfotextController.clear();
                            AboutMeDatetextController.clear();
                            AboutMeDescriptiontextController.clear();
                            RefineController.clear();
                            solutionsList.clear();
                            _userAboutMEProvider.solutionss.clear();
                            _userAboutMEProvider.challengess.clear();
                            _userAboutMEProvider.editchallengess.clear();
                            _userAboutMEProvider.editsolutionss.clear();
                            _userAboutMEProvider.combinedSolutionsResults.clear();
                            _userAboutMEProvider.combinedResults.clear();
                            _userAboutMEProvider.isEditChallengeListAdded.clear();
                            _userAboutMEProvider.isEditSolutionListAdded.clear();
                            _previewProvider.email=null;
                            _previewProvider.name=null;
                            _previewProvider.employer=null;
                            _previewProvider.division=null;
                            _previewProvider.role=null;
                            _previewProvider.location=null;
                            _previewProvider.employeeNumber=null ;
                            _previewProvider.linemanager=null;
                            _previewProvider.title=null;
                            _previewProvider.mycircumstance=null;
                            _previewProvider.mystrength=null ;
                            _previewProvider.myorganization=null ;
                            _previewProvider.mychallenge=null ;
                            _previewProvider.PreviewChallengesList.clear();
                            _previewProvider.PreviewSolutionList.clear();
                            _previewProvider.PreviewSolutionMyResposibilty.clear();
                            _previewProvider.PreviewSolutionStillNeeded.clear();
                            _previewProvider.PreviewSolutionNotNeededAnyMore.clear();
                            _previewProvider.PreviewSolutionNiceToHave.clear();
                            _previewProvider.PreviewSolutionMustHave.clear();
                            widget.refreshPage();
                              Navigator.pop(context);
                          },
                          // child: Icon(Icons.close)
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.home, size: 24),
                              Text("Home ",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                              ),
                            ],
                          )
                      ),
                      SizedBox(width: 20),
                      // Text("${About_Me_Label}",
                      //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      // )
                    ],
                  ),
                  iconPadding: EdgeInsets.only(left: 15,top: 15),
                );
            })
    );
  }

  Widget MyReportScreen(aboutMeData){
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height ,
        child: Card(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Generate reports",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: primaryColorOfApp,
                          fontWeight: FontWeight.bold,

                        ),),

                        InkWell(
                          onTap: () async {
                            await widget.showAddAddAboutMeDialogBox();
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('Create new report',textAlign: TextAlign.center,style: GoogleFonts.montserrat(
                                  textStyle: Theme.of(context).textTheme.titleSmall,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),)),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0,bottom: 5),
                    child: Text("Here is where you can generate reports to use as a record of your findings and to communicate and collaborate with your work colleagues.",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w300
              
                    ),),
                  ),
                  Divider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0,bottom: 10),
                              child: Text("Here is your master report summarising your findings as a result of your most recent input.",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w300
              
                              ),),
                            ),
                          ),
              
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0,bottom: 10),
                              child: Text("Here is where you can Edit your master report and decide who you want to send it to.  You can create as many different versions as you wish.",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w300
              
                              ),),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height : 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').where('AB_Status', isEqualTo: 'Draft').orderBy('AB_id', descending: true).limit(1).get();
                                //
                                //
                                // print("querySnapshot :${querySnapshot}");
                                // print("querySnapshot :${querySnapshot.docs.length}");
                                //
                                // if (querySnapshot.docs.isNotEmpty) {
                                //   // Get the last document
                                //   DocumentSnapshot lastDocument = querySnapshot.docs.first;
                                //   print("lastDocument :$lastDocument");
                                  ///
                                  // showEditAboutMeDialogBox(lastDocument,4);
                                  // showReportViewPageDialogBox(lastDocument);
              
                                  About_Me_Label = aboutMeData['About_Me_Label']==null ? "" : aboutMeData['About_Me_Label'];
                                  AboutMeLabeltextController.text = aboutMeData['About_Me_Label']==null ? "" : aboutMeData['About_Me_Label'];
                                  AboutMeDescriptiontextController.text = aboutMeData['AB_Description']==null ? "" : aboutMeData['AB_Description'];
                                  AboutMeUseFulInfotextController.text = aboutMeData['AB_Useful_Info']==null ? "" : aboutMeData['AB_Useful_Info'];
                                  AboutMeDatetextController.text = aboutMeData['AB_Date']==null ? "" : aboutMeData['AB_Date'];
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
              
                                  mycircumstancesController.text = aboutMeData['My_Circumstance']==null ? "" : aboutMeData['My_Circumstance'];
                                  _previewProvider.mycircumstance = mycircumstancesController.text;
                                  MystrengthsController.text = aboutMeData['My_Strength']==null ? "" : aboutMeData['My_Strength'];
                                  _previewProvider.mystrength = MystrengthsController.text;
                                  myOrganisationController.text = aboutMeData['My_Organisation']==null ? "" : aboutMeData['My_Organisation'];
                                  _previewProvider.myorganization = myOrganisationController.text;
                                  myOrganisation2Controller.text = aboutMeData['My_Challenges_Organisation']==null ? "" : aboutMeData['My_Challenges_Organisation'];
                                  _previewProvider.mychallenge = myOrganisation2Controller.text;
              
                                  List<dynamic> challengesList = aboutMeData['Challenges'] ?? [];
                                  List<dynamic> solutionsList = aboutMeData['Solutions'] ?? [];
              
                                  Iterable<Map<String, dynamic>> challengesIterable = challengesList.map((item) => item as Map<String, dynamic>);
                                  Iterable<Map<String, dynamic>> solutionsIterable = solutionsList.map((item) => item as Map<String, dynamic>);
              
                                  List<Map<String, dynamic>> abc = [];
                                  List<Map<String, dynamic>> xyz = [];
              
                                  abc.addAll(challengesIterable);
                                  xyz.addAll(solutionsIterable);
              
              
              
                                  Uint8List pdfBytes = await makePdf(abc, xyz);
              
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return  AlertDialog(
                                            icon: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("${About_Me_Label}",
                                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                                ),
                                                IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),
                                              ],
                                            ),
                                            backgroundColor: Colors.white,
                                            content: SizedBox(
                                              width: double.maxFinite,
                                              child: PdfPreview(
                                                maxPageWidth: MediaQuery.of(context).size.width * .6,
                                                allowSharing: false,
                                                canChangeOrientation: false,
                                                canChangePageFormat: false,
                                                canDebug: false,
                                                allowPrinting: false,
                                                pdfFileName: About_Me_Label,
                                                previewPageMargin: EdgeInsets.all(10),
                                                useActions: true,
                                                pdfPreviewPageDecoration: BoxDecoration(color: Colors.white),
                                                build: (format) => pdfBytes,
                                              ),
                                            ));
                                      });
              
                                // }
                                // else{
                                //   _navigateToTab(4);
                                //   await showAddAddAboutMeDialogBox();
                                // }
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                height: 40,
              
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color:primaryColorOfApp, width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Icon(Icons.article,color: Colors.black,size: 30,),
                                      Icon(Icons.picture_as_pdf_outlined,color: Colors.black,size: 25,),
                                      SizedBox(width: 5,),
              
                                      Expanded(
                                        child: Text(
                                          // 'Solutions',
                                          'Current master report',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                              textStyle:
                                              Theme.of(context).textTheme.titleMedium,
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
                                // QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe').where('AB_Status', isEqualTo: 'Draft').orderBy('AB_id', descending: true).limit(1).get();
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
                                  showEditAboutMeDialogBox(aboutMeData,5);
                                // }
                                ///
                                // else{
                                //   _navigateToTab(5);
                                //   await showAddAddAboutMeDialogBox();
                                //
                                // }
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                height: 40,
              
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color:primaryColorOfApp, width: 1.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Icon(Icons.article,color: Colors.black,size: 30,),
                                      Icon(Icons.edit_document,color: Colors.black,size: 25,),
                                      SizedBox(width: 5,),
              
                                      Expanded(
                                        child: Text(
                                          // 'Solutions',
                                          'Edit Master report',
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                              textStyle:
                                              Theme.of(context).textTheme.titleMedium,
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
                      SizedBox(height : 10),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget MyLibraryScreen(){
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Card(
          color: Colors.white,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("My library",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: primaryColorOfApp,
                        fontWeight: FontWeight.bold,

                      ),),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              selectedEmail = null;
                              searchEmailcontroller.clear();
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
                              AboutMeLabeltextController.clear();
                              AboutMeUseFulInfotextController.clear();
                              AboutMeDatetextController.clear();
                              AboutMeDescriptiontextController.clear();
                              RefineController.clear();
                              solutionsList.clear();
                              _userAboutMEProvider.solutionss.clear();
                              _userAboutMEProvider.challengess.clear();
                              _userAboutMEProvider.editchallengess.clear();
                              _userAboutMEProvider.editsolutionss.clear();
                              _userAboutMEProvider.combinedSolutionsResults.clear();
                              _userAboutMEProvider.combinedResults.clear();
                              _userAboutMEProvider.isEditChallengeListAdded.clear();
                              _userAboutMEProvider.isEditSolutionListAdded.clear();
                              _previewProvider.email=null;
                              _previewProvider.name=null;
                              _previewProvider.employer=null;
                              _previewProvider.division=null;
                              _previewProvider.role=null;
                              _previewProvider.location=null;
                              _previewProvider.employeeNumber=null ;
                              _previewProvider.linemanager=null;
                              _previewProvider.title=null;
                              _previewProvider.mycircumstance=null;
                              _previewProvider.mystrength=null ;
                              _previewProvider.myorganization=null ;
                              _previewProvider.mychallenge=null ;
                              _previewProvider.PreviewChallengesList.clear();
                              _previewProvider.PreviewSolutionList.clear();
                              _previewProvider.PreviewSolutionMyResposibilty.clear();
                              _previewProvider.PreviewSolutionStillNeeded.clear();
                              _previewProvider.PreviewSolutionNotNeededAnyMore.clear();
                              _previewProvider.PreviewSolutionNiceToHave.clear();
                              _previewProvider.PreviewSolutionMustHave.clear();
                              widget.refreshPage();
                              Navigator.pop(context);
                              widget.page.jumpToPage(1);
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 40,

                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color:primaryColorOfApp, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Icon(Icons.article,color: Colors.black,size: 30,),
                                    Icon(Icons.insert_drive_file_outlined,color: Colors.black,size: 25,),
                                    SizedBox(width: 5,),

                                    Expanded(
                                      child: Text(
                                        // 'Solutions',
                                        'My reports',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.titleMedium,
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
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 40,

                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color:primaryColorOfApp, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Icon(Icons.article,color: Colors.black,size: 30,),
                                    Icon(Icons.medical_information_outlined,color: Colors.black,size: 25,),
                                    SizedBox(width: 5,),

                                    Expanded(
                                      child: Text(
                                        // 'Solutions',
                                        'Medical and personal document',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.titleMedium,
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
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 40,

                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color:primaryColorOfApp, width: 1.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Icon(Icons.article,color: Colors.black,size: 30,),
                                    Icon(Icons.perm_device_info_sharp,color: Colors.black,size: 25,),
                                    SizedBox(width: 5,),

                                    Expanded(
                                      child: Text(
                                        // 'Solutions',
                                        'Other useful info',
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.titleMedium,
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showEditAboutMeDialogBox(aboutMeData, int tabindex){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
              data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
          child:  Consumer<UserAboutMEProvider>(
          builder: (c,userAboutMEProvider, _){
          return AlertDialog(
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: (){
                        // userAboutMEProvider.editpreviewname = null;
                        // userAboutMEProvider.editpreviewDescription = null;
                        // userAboutMEProvider.editpreviewFinalDescription = null;
                        // userAboutMEProvider.editpreviewId = null;
                        // userAboutMEProvider.editpreviewImpact = null;
                        // userAboutMEProvider.editpreviewKeywordssss.clear();
                        // userAboutMEProvider.editpreviewtags.clear();
                        // userAboutMEProvider.editpreview = null;
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close)),
                ],
              ),
              content: SizedBox(
          width: double.maxFinite,
            child: PreviewPage(widget.aboutMeData),
          )
          );
          }));
        }
    );
  }

  Widget AboutmeFormpage(context,aboutMeData) {

    AB_Status = aboutMeData['AB_Status']==null ? "" : aboutMeData['AB_Status'];

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

    AboutMeLabeltextController.text = aboutMeData['About_Me_Label']==null ? "" : aboutMeData['About_Me_Label'];
    _previewProvider.title = AboutMeLabeltextController.text;

    // DateTime date = DateTime.now();
    // final DateFormat formatter = DateFormat('dd MMMM yyyy');
    // String formattedDate = formatter.format(date);
    // AboutMeDatetextController.text = formattedDate;
    AboutMeDatetextController.text = aboutMeData['AB_Date']==null ? "" : aboutMeData['AB_Date'];
    AboutMeUseFulInfotextController.text = aboutMeData['AB_Useful_Info']==null ? "" : aboutMeData['AB_Useful_Info'];
    AboutMeDescriptiontextController.text = aboutMeData['AB_Description']==null ? "" : aboutMeData['AB_Description'];

    // documentId = aboutMeData.id;

    print("aboutMeData['Email']: ${aboutMeData['Email']}");
    print("aboutMeData['AB_Status']: ${aboutMeData['AB_Status']}");
    print("documentId: ${documentId}");
    // print("_previewProvider.email: ${_previewProvider.email}");
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SizedBox(height: 5,),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0),
          //   child: Text("1. Personal Info",
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

                  Consumer<AddKeywordProvider>(
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
                            },
                            decoration:InputDecoration(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("2. Name:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
                    controller: nameController,

                    // cursorColor: primaryColorOfApp,
                    onChanged: (value) {
                      var createdAt = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());
                      _previewProvider.updateName(value);
                      AboutMeLabeltextController.text = value + " - draft communication to " + employerController.text;
                      About_Me_Label = value + " - draft communication to " + employerController.text;
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
                      _previewProvider.updateemployer(value);
                      AboutMeLabeltextController.text = nameController.text + " - draft communication to " + value;
                      About_Me_Label = nameController.text + " - draft communication to " + value;
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
                  // SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("5. Role:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
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
                  // SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("6. Location:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
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
                  // SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                    child: Text("8. Line manager:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                  ),
                  TextField(
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
                    // 'AB_id': ids,
                    'Email': selectedEmail,
                    'User_Name': nameController.text,
                    'Employer': employerController.text,
                    'Division_or_Section': divisionOrSectionController.text,
                    'Role': RoleController.text,
                    'Location': LocationController.text,
                    'Employee_Number': EmployeeNumberController.text,
                    'Line_Manager': LineManagerController.text,
                    'AB_Status' : (AB_Status=="Complete") ? "Complete" :"Draft",
                    'About_Me_Label': AboutMeLabeltextController.text,
                    'AB_Description' : AboutMeDescriptiontextController.text,
                    'AB_Useful_Info' : AboutMeUseFulInfotextController.text,
                    'AB_Date' : AboutMeDatetextController.text,
                    'AB_Attachment' : "",
                    // 'My_Circumstance': mycircumstancesController.text,
                    // 'My_Strength': MystrengthsController.text,
                    // 'My_Organisation': myOrganisationController.text,
                    // 'My_Challenges_Organisation': myOrganisation2Controller.text,
                    // 'Solutions': solutionsList,
                    // 'Challenges': challengesList,
                    // // "Created_By": widget.AdminName,
                    // "Created_Date": createdAt,
                    "Modified_By": widget.AdminName,
                    "Modified_Date": createdAt,
                    'Report_sent_to' : []

                    // Add other fields as needed
                  };

                  String solutionJson = json.encode(AboutMEDatas);
                  print(solutionJson);

                  ProgressDialog.show(context, "Updating", Icons.update);
                  await ApiRepository().updateAboutMe(AboutMEDatas, documentId);
                  ProgressDialog.hide();
                  if (documentId != null) {
                    _navigateToTab(1);
                    print("Document ID: ${documentId.runtimeType}");
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

  Widget Detailspage(context,aboutMeData) {

    AboutMeLabeltextController.text = aboutMeData['About_Me_Label']==null ? "" : aboutMeData['About_Me_Label'];
    _previewProvider.title = AboutMeLabeltextController.text;

    mycircumstancesController.text = aboutMeData['My_Circumstance']==null ? "" : aboutMeData['My_Circumstance'];
    _previewProvider.mycircumstance = mycircumstancesController.text;

    MystrengthsController.text = aboutMeData['My_Strength']==null ? "" : aboutMeData['My_Strength'];
    _previewProvider.mystrength = MystrengthsController.text;

    myOrganisationController.text = aboutMeData['My_Organisation']==null ? "" : aboutMeData['My_Organisation'];
    _previewProvider.myorganization =  myOrganisationController.text;

    myOrganisation2Controller.text = aboutMeData['My_Challenges_Organisation']==null ? "" : aboutMeData['My_Challenges_Organisation'];
    _previewProvider.mychallenge = myOrganisation2Controller.text;

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
                          //     hintText: "About Me Label",
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

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                            child: Row(
                              children: [
                                Text("1. About me and my circumstances: ", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                                IconButton(
                                  icon: Icon(Icons.info_outline,),
                                  onPressed: (){},
                                  tooltip: "- Anything you want to share about eg\n- Your family circumstances\n- Where you live\n- Your education and professional qualifications\n- Your life stages or life events\n- Your ethnicity, faith, identification\n- What matters most to you in life",
                                )
                              ],
                            ),
                          ),
                          TextField(
                            controller: mycircumstancesController,
                            maxLines: 6,

                            // cursorColor: primaryColorOfApp,
                            // onChanged: (value) {
                            //   if (value.isNotEmpty) {
                            //     final lines = value.split('\n');
                            //
                            //     for (int i = 0; i < lines.length; i++) {
                            //       if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                            //         lines[i] = '• ' + lines[i];
                            //       }
                            //     }
                            //
                            //     mycircumstancesController.text = lines.join('\n');
                            //     mycircumstancesController.selection = TextSelection.fromPosition(
                            //       TextPosition(offset: mycircumstancesController.text.length),
                            //     );
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
                              hintText: "- Anything you want to share about eg\n- Your family circumstances\n- Where you live\n- Your education and professional qualifications\n- Your life stages or life events\n- Your ethnicity, faith, identification\n- What matters most to you in life",
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
                            child: Row(
                              children: [
                                Text("2. My strengths that I want to have the opportunity to use in my role:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
                                IconButton(
                                  icon: Icon(Icons.info_outline,),
                                  onPressed: (){},
                                  tooltip: "What do you view as your strengths, passions and values that you hope and want to be able to deploy in your role at work - create a list",
                                )
                              ],
                            ),
                          ),
                          TextField(
                            controller: MystrengthsController,
                            maxLines: 3,
                            // cursorColor: primaryColorOfApp,
                            // onChanged: (value) {
                            //   if (value.isNotEmpty) {
                            //     final lines = value.split('\n');
                            //
                            //     for (int i = 0; i < lines.length; i++) {
                            //       if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                            //         lines[i] = '• ' + lines[i];
                            //       }
                            //     }
                            //
                            //     MystrengthsController.text = lines.join('\n');
                            //     MystrengthsController.selection = TextSelection.fromPosition(
                            //       TextPosition(offset: MystrengthsController.text.length),
                            //     );
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
                            child: Row(
                              children: [
                                Flexible(child: Text("3. What I value about [my organisation] and workplace environment that helps me perform to my best:", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,))),
                                IconButton(
                                  icon: Icon(Icons.info_outline,),
                                  onPressed: (){},
                                  tooltip: "What do you like about your organisation and the work environment that helps you be your best?\nThese could be e.g. a policy or process, something about the culture or environment - create a list.",
                                )
                              ],
                            ),
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
                                  if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                                    lines[i] = '• ' + lines[i];
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
                              hintText: "What do you like about your organisation and the work environment that helps you be your best? These could be e.g. a policy or process, something about the culture or environment - create a list.",
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    "4. What I find challenging about [My Organisation] and workplace environment that gets in the way of me performing to my best: ",
                                    style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.info_outline,),
                                  onPressed: (){},
                                  tooltip: "What is it about your organisation and the work environment that gets in the way of you being your best?\nThese could be a policy or process, something about the culture or environment - create a list.",
                                )
                              ],
                            )

                          ),
                          TextField(
                            controller: myOrganisation2Controller,
                            keyboardType: TextInputType.multiline,
                            // onSubmitted: (_) => userAboutMEProvider.handleEnter(myOrganisation2Controller),
                            maxLines: 3,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final lines = value.split('\n');

                                for (int i = 0; i < lines.length; i++) {
                                  if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                                    lines[i] = '• ' + lines[i];
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
                              hintText: "What is it about your organisation and the work environment that gets in the way of you being your best? These could be a policy or process, something about the culture or environment - create a list.",
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

  Widget AddChallengesPage(context,aboutMeData){
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
                  //   child: Text("3. Challenges",
                  //       style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                  //           fontSize: 30,
                  //           color: Colors.black)),
                  // ),
                  // SizedBox(height: 10,),

                  SizedBox(height: 10,),

                  TextField(
                    controller: RefineController,
                    maxLines: 3,
                    // onChanged: (value) {
                    //   if (value.isNotEmpty) {
                    //     final lines = value.split('\n');
                    //
                    //     for (int i = 0; i < lines.length; i++) {
                    //       if (lines[i].trim().isNotEmpty && !lines[i].startsWith('•')) {
                    //         lines[i] = '• ' + lines[i];
                    //       }
                    //     }
                    //
                    //     RefineController.text = lines.join('\n');
                    //     RefineController.selection = TextSelection.fromPosition(
                    //       TextPosition(offset: RefineController.text.length),);
                    //     userAboutMEProvider.updateisRefinetextChange(false);
                    //     print("isRefinetextChange: ${userAboutMEProvider.isRefinetextChange}");
                    //   } else {
                    //     isInitialTyping = true; // Reset when the text field becomes empty
                    //     userAboutMEProvider.updateisRefinetextChange(false);
                    //     print("isRefinetextChange: ${userAboutMEProvider.isRefinetextChange}");
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
                        final cursorPosition = RefineController.selection.baseOffset +
                            (newTextLength - value.length);

                        // Update text and cursor position
                        RefineController.value = RefineController.value.copyWith(
                          text: modifiedText,
                          selection: TextSelection.fromPosition(
                            TextPosition(offset: cursorPosition),
                          ),
                        );

                        userAboutMEProvider.updateisRefinetextChange(false);
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
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Suggested challenges (${userAboutMEProvider.combinedResults.length}):",
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
                            ) : Container(
                              height: MediaQuery.of(context).size.height * .48,
                              // width: MediaQuery.of(context).size.width * .46,
                              decoration: BoxDecoration(
                                border: (userAboutMEProvider.combinedResults.isEmpty) ?  Border.all(color: Colors.black) : Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                // width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * .388,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: userAboutMEProvider.combinedResults.length,
                                  itemBuilder: (c, i) {
                                    RelatedChallengesdocuments = userAboutMEProvider.combinedResults.toList();
                                    DocumentSnapshot document = RelatedChallengesdocuments[i];

                                    return (userAboutMEProvider.isEditChallengeListAdded[document['id']] == true) ? Container() :  Container(
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

                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text("Basket of challenges (${userAboutMEProvider.editchallengess.length}):",
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

                                // userAboutMEProvider.EditChallengeList(true,aboutMeData["Challenges"]);

                                return (userAboutMEProvider.editchallengess.isEmpty) ?
                                Container(
                                  // height: 350,
                                  height: MediaQuery.of(context).size.height * .48,
                                  // width: MediaQuery.of(context).size.width * .46,

                                  child: Center(
                                    child: Text("No Challenges Added Yet",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.displaySmall,
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
                                    scrollDirection: Axis.vertical,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        dataRowMaxHeight:60,
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
                                        rows: userAboutMEProvider.editchallengess.map((challenge) {
                                          int index = userAboutMEProvider.editchallengess.indexOf(challenge);
                                          // print(jsonString);
                                          return DataRow(
                                            cells: [

                                              DataCell(
                                                  Text(challenge.label,
                                                      overflow: TextOverflow.ellipsis,maxLines: 1,
                                                      style: GoogleFonts.montserrat(
                                                          textStyle: Theme.of(context).textTheme.bodySmall,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.black)
                                                  )),
                                              DataCell(
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * .15,
                                                      child: Text(challenge.Impact,
                                                          overflow: TextOverflow.ellipsis,maxLines: 2,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: Theme.of(context).textTheme.bodySmall,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black)
                                                      ))),
                                              DataCell(
                                                  Container(
                                                      width: MediaQuery.of(context).size.width * .15,
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
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          NewViewDialog(challenge.label,challenge.description,challenge.Impact,challenge.Final_description, challenge.Keywords,challenge.tags,challenge.id,challenge, userAboutMEProvider.isEditChallengeListAdded,userAboutMEProvider.EditRecommendedChallengeAdd);
                                                          print("challenge.isConfirmed: ${challenge.isConfirmed}");
                                                        },
                                                        icon: Icon(Icons.visibility, color: Colors.blue),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          userAboutMEProvider.removeEditConfirmChallenge(index,challenge.id,challengesList,_previewProvider.PreviewChallengesList);
                                                        },
                                                        icon: Icon(Icons.close, color: Colors.red),
                                                      ),
                                                      // SizedBox(width: 10,),
                                                      Text('Confirmed',
                                                        style: TextStyle(color: Colors.green),
                                                      ),
                                                    ],
                                                  )
                                                      :
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {
                                                          NewViewDialog(challenge.label,challenge.description,challenge.Impact,challenge.Final_description, challenge.Keywords,challenge.tags,challenge.id,challenge, userAboutMEProvider.isEditChallengeListAdded,userAboutMEProvider.EditRecommendedChallengeAdd);
                                                          print("challenge.isConfirmed: ${challenge.isConfirmed}");
                                                        },
                                                        icon: Icon(Icons.visibility, color: Colors.blue),
                                                      ),
                                                      SizedBox(width: 3,),
                                                      IconButton(
                                                        onPressed: () {
                                                          showconfirmChallengeDialogBox(challenge.id, challenge.label,challenge.description, challenge.Source, challenge.Status,challenge.tags,challenge.CreatedBy,
                                                              challenge.CreatedDate,challenge.ModifiedBy,challenge.ModifiedDate,challenge.OriginalDescription,challenge.Impact,challenge.Final_description,
                                                              challenge.Category,challenge.Keywords,challenge.PotentialStrengths,challenge.HiddenStrengths, index,userAboutMEProvider.editchallengess,challenge.notes,challenge.attachment);                                        print("challenge.isConfirmed: ${challenge.isConfirmed}");
                                                        },
                                                        icon: Icon(Icons.check, color: Colors.green),
                                                      ),
                                                      SizedBox(width: 3,),
                                                      IconButton(
                                                        onPressed: () {
                                                          userAboutMEProvider.removeEditChallenge(index,challenge);
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

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap:(){
                              showChallengesSelector();
                            },
                            child:Container(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              width: MediaQuery.of(context).size.width * .22,
                              decoration: BoxDecoration(
                                color:Colors.blue ,
                                border: Border.all(
                                    color:Colors.blue ,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Center(
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


                        ],
                      ),

                      SizedBox(height: 5, width: 5,),
                      InkWell(
                        onTap: () async{

                          await userAboutMEProvider.getRelatedSolutions(generatedsolutionstags, generatedsolutionscategory);


                          Map<String, dynamic> AboutMEDatas = {

                            'Challenges': challengesList,

                          };

                          String solutionJson = json.encode(AboutMEDatas);
                          print("solutionJson: $solutionJson");

                          ProgressDialog.show(context, "Saving", Icons.save);
                          await ApiRepository().updateAboutMe(AboutMEDatas,documentId);
                          ProgressDialog.hide();

                          challengesList.clear();
                          _userAboutMEProvider.editchallengess.clear();
                          await _navigateToTab(4);
                          widget.refreshPage();
                           // Navigator.pop(context);

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

  Widget AddSolutionsPage(context,aboutMeData){
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
                    //   child: Text("4. Solutions",
                    //       style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                    //           fontSize: 30,
                    //           color: Colors.black)),
                    // ),
                    // SizedBox(height: 10,),


                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                child: Text("Suggested solutions (${userAboutMEProvider.combinedSolutionsResults.length}):",
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

                                      return GestureDetector(
                                        onTap: (){
                                          // ViewSolutionsDialog(document.reference,document.id, document['Name'], document['Description'], document['Category']
                                          //     ,document['Keywords'],document['Created Date'],document['Created By'],document['tags'],document['Modified By']
                                          //     ,document['Modified Date'],document['id']);
                                          NewSolViewDialog(document['Label'],document['Description'],document['Impact'],document['Final_description'], document['Keywords'],document['tags'],document['id'],document,userAboutMEProvider.isEditSolutionListAdded,userAboutMEProvider.EditRecommendedSolutionAdd);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                            padding: EdgeInsets.all(12),
                                            width: 470,
                                            // height: 300,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black26),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: RecommendedSolutionsListTile(document, i, RelatedSolutionsdocuments)
                                        ),
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
                          flex: 3,
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

                                  return (userAboutMEProvider.editsolutionss.isEmpty) ?
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
                                      scrollDirection: Axis.horizontal,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: DataTable(
                                          dataRowMaxHeight:85 ,
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
                                              label: Text('Label',),
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

                                          rows: userAboutMEProvider.editsolutionss.map((solution) {
                                            int index = userAboutMEProvider.editsolutionss.indexOf(solution);


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
                                                    Text(solution.label,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: Theme.of(context).textTheme.bodySmall,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black)
                                                    )),
                                                DataCell(
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * .15,
                                                      child: Text(solution.Impact,
                                                          overflow: TextOverflow.ellipsis,maxLines: 2,
                                                          style: GoogleFonts.montserrat(
                                                              textStyle: Theme.of(context).textTheme.bodySmall,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.black)
                                                      ),
                                                    )),
                                                DataCell(
                                                    Container(
                                                        width: MediaQuery.of(context).size.width * .15,
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
                                                    // margin: EdgeInsets.all(5),
                                                    // width: 140,
                                                    child: (solution.isConfirmed==true) ?
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            IconButton(
                                                              onPressed: () {
                                                                NewSolViewDialog(solution.label, solution.description, solution.Impact, solution.Final_description, solution.Keywords, solution.tags, solution.id,solution,userAboutMEProvider.isEditSolutionListAdded,userAboutMEProvider.EditRecommendedSolutionAdd);
                                                              },
                                                              icon: Icon(Icons.visibility, color: Colors.blue),
                                                            ),
                                                            IconButton(
                                                              onPressed: () {
                                                                userAboutMEProvider.removeEditConfirmSolution(
                                                                  solution.id,solutionsList,
                                                                  _previewProvider.PreviewSolutionMyResposibilty,
                                                                  _previewProvider.PreviewSolutionStillNeeded,
                                                                  _previewProvider.PreviewSolutionNotNeededAnyMore,
                                                                  _previewProvider.PreviewSolutionNiceToHave,
                                                                  _previewProvider.PreviewSolutionMustHave,
                                                                );

                                                                // userAboutMEProvider.EditSolutionProvideradd(_previewProvider.PreviewSolutionMyResposibilty);
                                                                // userAboutMEProvider.EditSolutionInPlaceadd(_previewProvider.PreviewSolutionStillNeeded,_previewProvider.PreviewSolutionNotNeededAnyMore,
                                                                //     _previewProvider.PreviewSolutionNiceToHave,_previewProvider.PreviewSolutionMustHave);
                                                                // _previewProvider.PreviewSolutionMyResposibilty.clear();
                                                                // _previewProvider.PreviewSolutionStillNeeded.clear();
                                                                // _previewProvider.PreviewSolutionNotNeededAnyMore.clear();
                                                                // _previewProvider.PreviewSolutionNiceToHave.clear();
                                                                // _previewProvider.PreviewSolutionMustHave.clear();

                                                              },
                                                              icon: Icon(Icons.close, color: Colors.red),
                                                            ),
                                                            // SizedBox(width: 10,),
                                                            Text('Confirmed',
                                                              style: TextStyle(color: Colors.green),
                                                            ),
                                                          ],
                                                        ),
                                                        Text('${(userAboutMEProvider.newprovider[solution.id] == "Request of my employer") ? userAboutMEProvider.newInplace[solution.id] : userAboutMEProvider.newprovider[solution.id]}',
                                                          style: TextStyle(color: Colors.red,fontSize: 10),
                                                        ),
                                                      ],
                                                    )
                                                        :
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            NewSolViewDialog(solution.label, solution.description, solution.Impact, solution.Final_description, solution.Keywords, solution.tags, solution.id,solution,userAboutMEProvider.isEditSolutionListAdded,userAboutMEProvider.EditRecommendedSolutionAdd);
                                                          },
                                                          icon: Icon(Icons.visibility, color: Colors.blue),
                                                        ),
                                                        SizedBox(width: 3,),
                                                        IconButton(
                                                          onPressed: () {
                                                            showconfirmSolutionsDialogBox(solution.id, solution.label,solution.description, solution.Source, solution.Status,solution.tags,solution.CreatedBy,
                                                                solution.CreatedDate,solution.ModifiedBy,solution.ModifiedDate,solution.OriginalDescription,solution.Impact,solution.Final_description,
                                                                solution.Category,solution.Keywords,"","", index,userAboutMEProvider.editsolutionss,solution.notes,solution.attachment,solution.InPlace,solution.Provider);
                                                            print("solution.isConfirmed: ${solution.isConfirmed}");
                                                          },
                                                          icon: Icon(Icons.check, color: Colors.green),
                                                        ),
                                                        SizedBox(width: 3,),
                                                        IconButton(
                                                          onPressed: () {
                                                            userAboutMEProvider.removeEditSolution(index,solution);
                                                          },
                                                          icon: Icon(Icons.close, color: Colors.red),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),


                                              ],
                                            );
                                          }).toList(),
                                        ),
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
                        //   onTap: () async {
                        //     // page.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                        //     _navigateToTab(4);
                        //
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(horizontal: 15),
                        //     width: MediaQuery.of(context).size.width * .3,
                        //     height: 60,
                        //     decoration: BoxDecoration(
                        //       // color: Colors.white,
                        //       border: Border.all(
                        //           color: Colors.blue,
                        //           width: 2.0),
                        //       borderRadius: BorderRadius.circular(15.0),
                        //     ),
                        //     child: Center(
                        //       child: Text(
                        //         'Preview',
                        //         style: GoogleFonts.montserrat(
                        //             textStyle: Theme.of(context).textTheme.titleSmall,
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.blue
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


                          ],
                        ),

                        SizedBox(height: 5, width: 5,),
                        InkWell(
                          onTap: () async {
                            ///


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
                                'Save and next',
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
                );
              })
      ),
    );
  }

  ///
  // Widget PreviewPage(aboutMeData){
  //   // List<dynamic> challengesData = aboutMeData['Challenges'];
  //   // for (var challengeData in challengesData) {
  //   //   if (challengeData is Map<String, dynamic>) {
  //   //     _previewProvider.PreviewChallengesList.add(challengeData);
  //   //   }
  //   // }
  //   return Consumer<PreviewProvider>(
  //       builder: (c,previewProvider, _){
  //
  //         return  Container(
  //           height: MediaQuery
  //               .of(context)
  //               .size
  //               .height,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(height: 5,),
  //                 // Padding(
  //                 //   padding: const EdgeInsets.only(left: 20.0),
  //                 //   child: Row(
  //                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 //     children: [
  //                 //       Text("5. Preview",
  //                 //           style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
  //                 //               fontSize: 30,
  //                 //               color: Colors.black)),
  //                 //       InkWell(
  //                 //         onTap: (){
  //                 //           downloadAboutMePdf(challengesList,solutionsList);
  //                 //         },
  //                 //         child:Container(
  //                 //           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //                 //           width: MediaQuery.of(context).size.width * .15,
  //                 //           decoration: BoxDecoration(
  //                 //             color:Colors.blue ,
  //                 //             border: Border.all(
  //                 //                 color:Colors.blue ,
  //                 //                 width: 1.0),
  //                 //             borderRadius: BorderRadius.circular(15.0),
  //                 //           ),
  //                 //           child: Center(
  //                 //             child: Text(
  //                 //               'Download Pdf',
  //                 //               style: GoogleFonts.montserrat(
  //                 //                 textStyle:
  //                 //                 Theme
  //                 //                     .of(context)
  //                 //                     .textTheme
  //                 //                     .titleSmall,
  //                 //                 fontWeight: FontWeight.bold,
  //                 //                 color:Colors.white ,
  //                 //               ),
  //                 //             ),
  //                 //           ),
  //                 //         ),
  //                 //       )
  //                 //     ],
  //                 //   ),
  //                 // ),
  //                 // SizedBox(height: 20,),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                       vertical: 10.0, horizontal: 5),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     children: [
  //                       // Text("Title: ",
  //                       //     style: GoogleFonts.montserrat(textStyle: Theme
  //                       //         .of(context)
  //                       //         .textTheme
  //                       //         .titleMedium,)),
  //                       // Text("${previewProvider.title==null ? "" : previewProvider.title}",
  //                       //     style: GoogleFonts.montserrat(textStyle: Theme
  //                       //         .of(context)
  //                       //         .textTheme
  //                       //         .bodyLarge,fontWeight: FontWeight.w700)),
  //
  //                       Text("Report Title: ", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleMedium,)),
  //
  //                       Flexible(
  //                         child: Container(
  //                           height: 40,
  //                           width: MediaQuery.of(context).size.width * .25,
  //                           child: TextField(
  //                             controller: AboutMeLabeltextController,
  //                             onChanged: (value) {
  //                               _previewProvider.updatetitle(value);
  //                             },
  //                             style: GoogleFonts.montserrat(
  //                                 textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .bodyLarge,
  //                                 fontWeight: FontWeight.w400,
  //                                 color: Colors.black),
  //                             decoration: InputDecoration(
  //                               contentPadding: EdgeInsets.all(10),
  //                               // labelText: "Name",
  //                               hintText: "About Me Title",
  //                               errorStyle: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.bodyLarge,
  //                                   fontWeight: FontWeight.w400,
  //                                   color: Colors.redAccent),
  //                               focusedBorder: OutlineInputBorder(
  //                                   borderSide: BorderSide(color: Colors.black),
  //                                   borderRadius: BorderRadius.circular(15)),
  //                               border: OutlineInputBorder(
  //                                   borderSide: BorderSide(color: Colors.black12),
  //                                   borderRadius: BorderRadius.circular(15)),
  //                               labelStyle: GoogleFonts.montserrat(
  //                                   textStyle: Theme
  //                                       .of(context)
  //                                       .textTheme
  //                                       .bodyLarge,
  //                                   fontWeight: FontWeight.w400,
  //                                   color: Colors.black),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //
  //                       SizedBox(width: 10,),
  //
  //                       InkWell(
  //                         onTap: () async {
  //                           // sideMenu.changePage(2);
  //                           // page.jumpToPage(1);
  //                         },
  //                         child: Container(
  //                           // margin: EdgeInsets.all(10),
  //                           padding: EdgeInsets.all(5),
  //                           height: 40,
  //                           width: MediaQuery.of(context).size.width * 0.15,
  //                           decoration: BoxDecoration(
  //                             // color: Colors.white,
  //                             border: Border.all(color:primaryColorOfApp, width: 1.0),
  //                             borderRadius: BorderRadius.circular(10.0),
  //                           ),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             crossAxisAlignment: CrossAxisAlignment.center,
  //                             children: [
  //                               Icon(Icons.insert_drive_file,color: Colors.black,size: 20,),
  //                               SizedBox(width: 5,),
  //                               Expanded(
  //                                 child: Text(
  //                                   // 'Thrivers',
  //                                   'For Someone Else',
  //                                   overflow: TextOverflow.ellipsis,
  //                                   style: GoogleFonts.montserrat(
  //                                       textStyle:
  //                                       Theme.of(context).textTheme.bodySmall,
  //                                       color: Colors.black),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //
  //                       ),
  //
  //                     ],
  //                   ),
  //                 ),
  //                 Divider(color: Colors.black26,),
  //
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                       vertical: 10.0, horizontal: 5),
  //                   child: TextField(
  //                     controller: AboutMeDescriptiontextController,
  //                     onChanged: (value) {
  //                       // _previewProvider.updatetitle(value);
  //                     },
  //                     style: GoogleFonts.montserrat(
  //                         textStyle: Theme.of(context).textTheme.bodySmall,
  //                         fontWeight: FontWeight.w400,
  //                         color: Colors.black),
  //                     decoration: InputDecoration(
  //                       hintText: "Description",
  //                       focusedBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(color: Colors.black),
  //                           borderRadius: BorderRadius.circular(10)),
  //                       border: OutlineInputBorder(
  //                           borderSide: BorderSide(color: Colors.black12),
  //                           borderRadius: BorderRadius.circular(10)),
  //                     ),
  //                   ),
  //                 ),
  //
  //                 Container(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //
  //                     children: [
  //
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Text("Personal Info",
  //                             style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
  //                                 fontSize: 20,
  //                                 color: Colors.black)),
  //                       ),
  //
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text("1. Email: ",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleMedium,)),
  //                             Text("${previewProvider.email==null ? "" : previewProvider.email}",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.bodyLarge,fontWeight: FontWeight.w700)),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text("2. Name: ",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleMedium,)),
  //                             Text("${previewProvider.name==null ? "" : previewProvider.name}",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .bodyLarge,fontWeight: FontWeight.w700)),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text("3. Employer: ",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleMedium,)),
  //                             Text("${previewProvider.employer==null ? "" : previewProvider.employer}",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .bodyLarge,fontWeight: FontWeight.w700)),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text("4. Division or section: ",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleMedium,)),
  //                             Text("${previewProvider.division==null ? "" : previewProvider.division}",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .bodyLarge,fontWeight: FontWeight.w700)),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //
  //                           children: [
  //                             Text("5. Role: ",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleMedium,)),
  //                             Text("${previewProvider.role==null ? "" : previewProvider.role}",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .bodyLarge,fontWeight: FontWeight.w700)),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //
  //                           children: [
  //                             Text("6. Location: ",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleMedium,)),
  //                             Text("${previewProvider.location==null ? "" : previewProvider.location}",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .bodyLarge,fontWeight: FontWeight.w700)),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text("7. Employee number: ",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleMedium,)),
  //                             Text("${previewProvider.employeeNumber==null ? "" : previewProvider.employeeNumber}",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .bodyLarge,fontWeight: FontWeight.w700)),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text("8. Line manager:",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .titleMedium,)),
  //                             Text("${previewProvider.linemanager==null ? "" : previewProvider.linemanager}",
  //                                 style: GoogleFonts.montserrat(textStyle: Theme
  //                                     .of(context)
  //                                     .textTheme
  //                                     .bodyLarge,fontWeight: FontWeight.w700)),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 Container(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Text("Insight about me",
  //                             style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
  //                                 fontSize: 20,
  //                                 color: Colors.black)),
  //                       ),
  //                       // Padding(
  //                       //   padding: const EdgeInsets.symmetric(
  //                       //       vertical: 10.0, horizontal: 5),
  //                       //   child: Row(
  //                       //     mainAxisAlignment: MainAxisAlignment.start,
  //                       //     children: [
  //                       //       Text("Title: ",
  //                       //           style: GoogleFonts.montserrat(textStyle: Theme
  //                       //               .of(context)
  //                       //               .textTheme
  //                       //               .titleMedium,)),
  //                       //       Text("${previewProvider.title==null ? "" : previewProvider.title}",
  //                       //           style: GoogleFonts.montserrat(textStyle: Theme
  //                       //               .of(context)
  //                       //               .textTheme
  //                       //               .bodyLarge,fontWeight: FontWeight.w700)),
  //                       //     ],
  //                       //   ),
  //                       // ),
  //
  //
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Text("1. About Me and My circumstances: ",
  //                             style: GoogleFonts.montserrat(textStyle: Theme
  //                                 .of(context)
  //                                 .textTheme
  //                                 .titleMedium,)),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 5),
  //                         child: Text("${previewProvider.mycircumstance==null ? "" : previewProvider.mycircumstance}",
  //                             style: GoogleFonts.montserrat(textStyle: Theme
  //                                 .of(context)
  //                                 .textTheme
  //                                 .bodyLarge,fontWeight: FontWeight.w700)),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Text("2. My strengths that I want to have the opportunity to use in my role: ",
  //                             style: GoogleFonts.montserrat(textStyle: Theme
  //                                 .of(context)
  //                                 .textTheme
  //                                 .titleMedium,)),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 5),
  //                         child: Text("${previewProvider.mystrength==null ? "" : previewProvider.mystrength}",
  //                             style: GoogleFonts.montserrat(textStyle: Theme
  //                                 .of(context)
  //                                 .textTheme
  //                                 .bodyLarge,fontWeight: FontWeight.w700)),
  //
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Text("3. What I value about [my organisation] and workplace environment that helps me perform to my best: ",
  //                             style: GoogleFonts.montserrat(textStyle: Theme
  //                                 .of(context)
  //                                 .textTheme
  //                                 .titleMedium,)),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 5),
  //                         child: Text("${previewProvider.myorganization==null ? "" : previewProvider.myorganization}",
  //                             style: GoogleFonts.montserrat(textStyle: Theme
  //                                 .of(context)
  //                                 .textTheme
  //                                 .bodyLarge,fontWeight: FontWeight.w700)),
  //
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Text("4. What I find challenging about [My Organisation] and the workplace environment that makes it harder for me to perform my best: ",
  //                             style: GoogleFonts.montserrat(textStyle: Theme
  //                                 .of(context)
  //                                 .textTheme
  //                                 .titleMedium,)),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 5),
  //                         child: Text("${previewProvider.mychallenge==null ? "" : previewProvider.mychallenge}",
  //                             style: GoogleFonts.montserrat(textStyle: Theme
  //                                 .of(context)
  //                                 .textTheme
  //                                 .bodyLarge,fontWeight: FontWeight.w700)),
  //
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 Container(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Text("Challenges",
  //                             style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
  //                                 fontSize: 20,
  //                                 color: Colors.black)),
  //                       ),
  //                       Consumer<PreviewProvider>(
  //                         builder: (context, previewProvider, _) {
  //                           // solutions = userAboutMEProvider.getSelectedSolutions();
  //                           print("PreviewChallengesList : ${previewProvider.PreviewChallengesList}");
  //
  //
  //                           return Container(
  //                             // height: MediaQuery.of(context).size.height * .6,
  //                             width: MediaQuery.of(context).size.width ,
  //                             decoration: BoxDecoration(
  //                               border: Border.all(color: Colors.black26),
  //                               borderRadius: BorderRadius.circular(20),
  //                             ),
  //                             // width: MediaQuery.of(context).size.width,
  //                             child:SingleChildScrollView(
  //                               child: DataTable(
  //                                 dataRowMaxHeight:60 ,
  //                                 headingTextStyle: GoogleFonts.montserrat(
  //                                     textStyle: Theme.of(context).textTheme.titleMedium,
  //                                     fontWeight: FontWeight.w500,
  //                                     color: Colors.black),
  //                                 columnSpacing: 15,
  //                                 columns: [
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // color: Colors.blue,
  //                                       // width: 60,
  //                                       child: Text('Id',textAlign: TextAlign.center,),
  //                                     ),
  //
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 180,
  //                                       child: Text('Label',),
  //                                     ),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Text('Impact',),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 400,
  //                                         child: Text('Description')
  //                                     ),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 400,
  //                                         child: Text('Impact on me')
  //                                     ),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 400,
  //                                         child: Text('Attachment')
  //                                     ),
  //                                   ),
  //
  //
  //                                 ],
  //
  //                                 rows: previewProvider.PreviewChallengesList.map((solution) {
  //                                   int index = previewProvider.PreviewChallengesList.indexOf(solution);
  //
  //
  //                                   // print(jsonString);
  //
  //
  //                                   return DataRow(
  //                                     cells: [
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 60,
  //                                               child: Text("CH0${solution['id']}.", style: GoogleFonts.montserrat(
  //                                                 // child: Text("${index + 1}.", style: GoogleFonts.montserrat(
  //                                                   textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                   fontWeight: FontWeight.w600,
  //                                                   color: Colors.black),))),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 180,
  //                                               child: Text(solution['Label'],
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 400,
  //                                               child: Text(solution['Impact'],
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 400,
  //                                               child: Text(solution['Final_description'],
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 400,
  //                                               child: Text(solution['Impact_on_me'],
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 400,
  //                                               child: Text(solution['Attachment'],
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //
  //                                       // DataCell(
  //                                       //   Container(
  //                                       //     // height: 100,
  //                                       //     margin: EdgeInsets.all(5),
  //                                       //     width: 140,
  //                                       //     child: Center(
  //                                       //       child: TextField(
  //                                       //         maxLines: 4,
  //                                       //         controller: TextEditingController(text: solution.notes),
  //                                       //         onChanged: (value) {
  //                                       //         },
  //                                       //         style: GoogleFonts.montserrat(
  //                                       //             textStyle: Theme
  //                                       //                 .of(context)
  //                                       //                 .textTheme
  //                                       //                 .bodySmall,
  //                                       //             fontWeight: FontWeight.w400,
  //                                       //             color: Colors.black),
  //                                       //         decoration: InputDecoration(
  //                                       //           contentPadding: EdgeInsets.all(10),
  //                                       //           // labelText: "Name",
  //                                       //           hintText: "Notes",
  //                                       //           errorStyle: GoogleFonts.montserrat(
  //                                       //               textStyle: Theme
  //                                       //                   .of(context)
  //                                       //                   .textTheme
  //                                       //                   .bodyLarge,
  //                                       //               fontWeight: FontWeight.w400,
  //                                       //               color: Colors.redAccent),
  //                                       //           focusedBorder: OutlineInputBorder(
  //                                       //               borderSide: BorderSide(color: Colors.black),
  //                                       //               borderRadius: BorderRadius.circular(5)),
  //                                       //           border: OutlineInputBorder(
  //                                       //               borderSide: BorderSide(color: Colors.black12),
  //                                       //               borderRadius: BorderRadius.circular(5)),
  //                                       //           labelStyle: GoogleFonts.montserrat(
  //                                       //               textStyle: Theme
  //                                       //                   .of(context)
  //                                       //                   .textTheme
  //                                       //                   .bodyLarge,
  //                                       //               fontWeight: FontWeight.w400,
  //                                       //               color: Colors.black),
  //                                       //         ),
  //                                       //       ),
  //                                       //     ),
  //                                       //   ),), // Empty cell for Notes
  //
  //                                       // DataCell(
  //                                       //     Container(
  //                                       //       child: IconButton(
  //                                       //         onPressed: (){
  //                                       //
  //                                       //         },
  //                                       //         icon: Icon(Icons.add),
  //                                       //       ),
  //                                       //     )),  // Empty cell for Attachments
  //                                       // DataCell(
  //                                       //   Container(
  //                                       //     width: 120,
  //                                       //     child: DropdownButton(
  //                                       //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                                       //       // value: selectedProvider,
  //                                       //       value: selectedProviderValues[index],
  //                                       //       onChanged: (newValue) {
  //                                       //         // userAboutMEProvider.updatevalue(selectedProviderValues[index], newValue.toString());
  //                                       //         setState(() {
  //                                       //           // selectedProvider = newValue.toString();
  //                                       //           selectedProviderValues[index] = newValue.toString();
  //                                       //         });
  //                                       //       },
  //                                       //       items: provider.map((option) {
  //                                       //         return DropdownMenuItem(
  //                                       //           value: option,
  //                                       //           child: Text(option, overflow: TextOverflow.ellipsis,maxLines: 2,),
  //                                       //         );
  //                                       //       }).toList(),
  //                                       //     ),
  //                                       //   ),
  //                                       // ),  // Empty cell for Provider
  //                                       // DataCell(
  //                                       //   Container(
  //                                       //     width: 60,
  //                                       //     child: DropdownButton(
  //                                       //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                                       //       value: selectedInPlaceValues[index],
  //                                       //       // value: selectedInPlace,
  //                                       //       onChanged: (newValue) {
  //                                       //         setState(() {
  //                                       //           selectedInPlaceValues[index] = newValue.toString();
  //                                       //           // selectedInPlace = newValue.toString();
  //                                       //         });
  //                                       //       },
  //                                       //       items: InPlace.map((option) {
  //                                       //         return DropdownMenuItem(
  //                                       //           value: option,
  //                                       //           child: Text(option),
  //                                       //         );
  //                                       //       }).toList(),
  //                                       //     ),
  //                                       //   ),
  //                                       // ),  // Empty cell for In Place
  //                                       // DataCell(
  //                                       //   Container(
  //                                       //     width: 140,
  //                                       //     // child:  DropdownButton(
  //                                       //     //   style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                                       //     //   value: selectedPriorityValues[index],
  //                                       //     //   // value: selectedPriority,
  //                                       //     //   onChanged: (newValue) {
  //                                       //     //     setState(() {
  //                                       //     //       selectedPriorityValues[index] = newValue.toString();
  //                                       //     //
  //                                       //     //       print("$index: ${selectedPriorityValues[index]} ");
  //                                       //     //       // selectedPriority = newValue.toString();
  //                                       //     //     });
  //                                       //     //   },
  //                                       //     //   items: Priority.map((option) {
  //                                       //     //     return DropdownMenuItem(
  //                                       //     //       value: option,
  //                                       //     //       child: Text(option, overflow: TextOverflow.ellipsis,),
  //                                       //     //     );
  //                                       //     //   }).toList(),
  //                                       //     // ),
  //                                       //     child:  DropdownButtonFormField(
  //                                       //       style: TextStyle(fontSize: 12,overflow: TextOverflow.ellipsis),
  //                                       //       decoration: InputDecoration(
  //                                       //
  //                                       //         hintText: 'Priority',
  //                                       //       ),
  //                                       //       value: userAboutMEProvider.selectedPriorityValues[index],
  //                                       //       onChanged: (newValue) {
  //                                       //         userAboutMEProvider.updateSelectedPriorityValues(index, newValue);
  //                                       //         print('priority ${index} and ${userAboutMEProvider.selectedPriorityValues}');
  //                                       //       },
  //                                       //       icon: Icon(Icons.keyboard_arrow_down_outlined,size: 20,),
  //                                       //       items: selectedPriorityValues.map<DropdownMenuItem<String>>((String value) {
  //                                       //         // String displayedText = value;
  //                                       //         // if (displayedText.length > 5) {
  //                                       //         //   // Limit the displayed text to 10 characters and add ellipsis
  //                                       //         //   displayedText = displayedText.substring(0, 5) + '..';
  //                                       //         // }
  //                                       //         return DropdownMenuItem<String>(
  //                                       //           value: value,
  //                                       //           child: Text(value, overflow: TextOverflow.ellipsis,),
  //                                       //         );
  //                                       //       }).toList(),
  //                                       //     ),
  //                                       //   ),
  //                                       // ),  // Empty cell for Priority
  //
  //                                     ],
  //                                   );
  //                                 }).toList(),
  //                               ),
  //                             ),
  //
  //                           );
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 Container(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 5),
  //                         child: Text("Solutions",
  //                             style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
  //                                 fontSize: 20,
  //                                 color: Colors.black)),
  //                       ),
  //                       Consumer<PreviewProvider>(
  //                         builder: (context, previewProvider, _) {
  //                           print("PreviewSolutionList : ${previewProvider.PreviewSolutionList}");
  //
  //
  //                           return Container(
  //                             // height: 350,
  //                             // height: MediaQuery.of(context).size.height * .48,
  //                             width: MediaQuery.of(context).size.width,
  //
  //                             decoration: BoxDecoration(
  //                               border: Border.all(color: Colors.black26),
  //                               borderRadius: BorderRadius.circular(20),
  //                             ),
  //                             // width: MediaQuery.of(context).size.width,
  //                             child:SingleChildScrollView(
  //                               child: DataTable(
  //                                 dataRowMaxHeight:60 ,
  //                                 headingTextStyle: GoogleFonts.montserrat(
  //                                     textStyle: Theme.of(context).textTheme.titleMedium,
  //                                     fontWeight: FontWeight.w500,
  //                                     color: Colors.black),
  //                                 // border: TableBorder.all(color: Colors.black),
  //                                 columnSpacing: 15,
  //                                 columns: [
  //
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // color: Colors.blue,
  //                                       // width: 60,
  //                                       child: Text('Id',textAlign: TextAlign.center,),
  //                                     ),
  //
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 180,
  //                                       child: Text('label',),
  //                                     ),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 250,
  //                                       child: Text('Impact',),
  //                                     ),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Container(
  //                                       // width: 400,
  //                                         child: Text('Description')
  //                                     ),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Flexible(child: Text('Provider')),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Flexible(child: Text('In Place')),
  //                                   ),
  //                                   DataColumn(
  //                                     label: Flexible(child: Text('Attachment')),
  //                                   ),
  //                                 ],
  //                                 rows: previewProvider.PreviewSolutionList.map((challenge) {
  //                                   int index = previewProvider.PreviewSolutionList.indexOf(challenge);
  //                                   // print(jsonString);
  //                                   return DataRow(
  //                                     cells: [
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 60,
  //                                             //   child: Text("${index + 1}.", style: GoogleFonts.montserrat(
  //                                               child: Text("SH0${challenge['id']}.", style: GoogleFonts.montserrat(
  //                                                   textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                   fontWeight: FontWeight.w600,
  //                                                   color: Colors.black),))
  //                                       ),
  //                                       DataCell(
  //                                           Container(
  //                                             child: Text(challenge['Label'],
  //                                                 overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                 style: GoogleFonts.montserrat(
  //                                                     textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                     fontWeight: FontWeight.w600,
  //                                                     color: Colors.black)
  //                                             ),
  //                                           )),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 250,
  //                                               child: Text(challenge["Impact"],
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 400,
  //                                               child: Text(challenge['Final_description'],
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 400,
  //                                               child: Text(challenge['Provider']==null ? "" : challenge['Provider'],
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 400,
  //                                               child: Text(challenge['InPlace']==null ? "" : challenge['InPlace'],
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                       DataCell(
  //                                           Container(
  //                                             // width: 400,
  //                                               child: Text(challenge['Attachment']==null ? "" : challenge['Attachment'],
  //                                                   overflow: TextOverflow.ellipsis,maxLines: 2,
  //                                                   style: GoogleFonts.montserrat(
  //                                                       textStyle: Theme.of(context).textTheme.bodySmall,
  //                                                       fontWeight: FontWeight.w600,
  //                                                       color: Colors.black)
  //                                               ))),
  //                                     ],
  //                                   );
  //                                 }).toList(),
  //                               ),
  //                             ),
  //
  //                           );
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                       vertical: 15.0, horizontal: 5),
  //                   child: TextField(
  //                     controller: AboutMeUseFulInfotextController,
  //                     onChanged: (value) {
  //                       _previewProvider.updatetitle(value);
  //                     },
  //                     style: GoogleFonts.montserrat(
  //                         textStyle: Theme.of(context).textTheme.bodySmall,
  //                         fontWeight: FontWeight.w400,
  //                         color: Colors.black),
  //                     decoration: InputDecoration(
  //                       hintText: "Links/Document/Product Info",
  //                       focusedBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(color: Colors.black),
  //                           borderRadius: BorderRadius.circular(10)),
  //                       border: OutlineInputBorder(
  //                           borderSide: BorderSide(color: Colors.black12),
  //                           borderRadius: BorderRadius.circular(10)),
  //                     ),
  //                   ),
  //                 ),
  //
  //
  //                 Row(
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
  //                       child: Text("Attachments :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
  //                     ),
  //                     SizedBox(width: 10,),
  //
  //                     InkWell(
  //                       onTap: (){
  //                         // _userAboutMEProvider.pickFiles();
  //                       },
  //                       child: Container(
  //                         // padding: EdgeInsets.all(20),
  //                         child: Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
  //                         width: 30,
  //                         height: 30,
  //                         decoration: BoxDecoration(
  //                           color: Colors.blue,
  //                           borderRadius: BorderRadius.circular(50),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Text("${_userAboutMEProvider.aadhar==null ? "" : _userAboutMEProvider.aadhar}", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
  //                   // child: Text("document.pdf", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
  //                 ),
  //
  //                 SizedBox(height: 10,),
  //
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     InkWell(
  //                       onTap: () async {
  //                         var createdAt = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());
  //
  //                         Map<String, dynamic> AboutMEDatas = {
  //                           'About_Me_Label': AboutMeLabeltextController.text,
  //                           'AB_Status' : "Complete",
  //                           'AB_Description' : AboutMeDescriptiontextController.text,
  //                           'AB_Useful_Info' : AboutMeUseFulInfotextController.text,
  //                           'AB_Attachment' : "",
  //                         };
  //
  //
  //                         String solutionJson = json.encode(AboutMEDatas);
  //                         print(solutionJson);
  //
  //                         ProgressDialog.show(context, "Completing", Icons.save);
  //                         await ApiRepository().updateAboutMe(AboutMEDatas,documentId);
  //                         ProgressDialog.hide();
  //                         sendMailPopUp(challengesList,solutionsList);
  //                         // selectedEmail = null;
  //                         // nameController.clear();
  //                         // searchEmailcontroller.clear();
  //                         // employerController.clear();
  //                         // divisionOrSectionController.clear();
  //                         // RoleController.clear();
  //                         // LocationController.clear();
  //                         // EmployeeNumberController.clear();
  //                         // LineManagerController.clear();
  //                         // mycircumstancesController.clear();
  //                         // MystrengthsController.clear();
  //                         // mycircumstancesController.clear();
  //                         // AboutMeLabeltextController.clear();
  //                         // RefineController.clear();
  //                         // solutionsList.clear();
  //                         // _userAboutMEProvider.solutionss.clear();
  //                         // _userAboutMEProvider.editsolutionss.clear();
  //                         // _userAboutMEProvider.challengess.clear();
  //                         // _userAboutMEProvider.editchallengess.clear();
  //                         // _userAboutMEProvider.combinedSolutionsResults.clear();
  //                         // _userAboutMEProvider.combinedResults.clear();
  //                         // previewProvider.email=null;
  //                         // previewProvider.name=null;
  //                         // previewProvider.employer=null;
  //                         // previewProvider.division=null;
  //                         // previewProvider.role=null;
  //                         // previewProvider.location=null;
  //                         // previewProvider.employeeNumber=null ;
  //                         // previewProvider.linemanager=null;
  //                         // previewProvider.title=null;
  //                         // previewProvider.mycircumstance=null;
  //                         // previewProvider.mystrength=null ;
  //                         // previewProvider.myorganization=null ;
  //                         // previewProvider.mychallenge=null ;
  //                         // previewProvider.PreviewChallengesList.clear();
  //                         // previewProvider.PreviewSolutionList.clear();
  //                         // // _navigateToTab(0);
  //                         // widget.refreshPage();
  //                         // // Navigator.pop(context);
  //                         // setState(() {
  //                         //   widget.page.jumpToPage(1);
  //                         // });
  //                       },
  //                       child:Container(
  //                         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //                         width: MediaQuery.of(context).size.width * .15,
  //                         decoration: BoxDecoration(
  //                           color:Colors.blue ,
  //                           border: Border.all(
  //                               color:Colors.blue ,
  //                               width: 1.0),
  //                           borderRadius: BorderRadius.circular(15.0),
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             'Complete and send',
  //                             style: GoogleFonts.montserrat(
  //                               textStyle:
  //                               Theme
  //                                   .of(context)
  //                                   .textTheme
  //                                   .titleSmall,
  //                               fontWeight: FontWeight.bold,
  //                               color:Colors.white ,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  /// backup previwpage

  Widget PreviewPage(aboutMeData){
    return Consumer<PreviewProvider>(
        builder: (c,previewProvider, _){



          String message = """
Dear ${employerController.text},

Thank you for recognising that our organisation performs better, and we achieve more together, when each of us feels safe and open to share what we need to be our best in the roles we are asked and agree to perform. This communication sets out what I think it would be helpful for you to know about me and includes what I believe helps me thrive, so that I can perform to my best, both for me and for ${employerController.text}.

In relation to performing to my very best, both to help me and ${employerController.text} to achieve the best we can, on the next two pages I have set out:
• information that I think it is helpful for me to share with my Team Leader and team colleagues, and
• actions and adjustments that I’ve identified can help me perform to my best in my role for ${employerController.text}.

Next steps:
I will arrange to have a meeting with my ${LineManagerController.text} to discuss my requests in person. This request includes accommodations that I view as reasonable adjustments under the Equality Act 2010.

Thank you for being open to understanding me better and for considering my requests.

Signed
Date
""";

          // AboutMeDescriptiontextController.text = message;


          // AboutMeLabeltextController.text = "${nameController.text} - draft communication to ${employerController.text}";

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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        width: MediaQuery.of(context).size.width * .1,
                        child: Text("Report file name :   ", style: GoogleFonts.lato(
                            textStyle: Theme.of(context).textTheme.titleMedium,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold
                        )),
                      ),

                      Flexible(
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * .25,
                          child: TextField(
                            controller: AboutMeLabeltextController,
                            onChanged: (value) {
                              _previewProvider.updatetitle(value);
                            },
                            style: GoogleFonts.lato(
                                textStyle: Theme.of(context).textTheme.bodySmall,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            decoration: InputDecoration(
                              hintText: " - draft communication to " ,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ),

                      // SizedBox(width: 10,),
                      //
                      // InkWell(
                      //   onTap: () async {
                      //     // sideMenu.changePage(2);
                      //     // page.jumpToPage(1);
                      //   },
                      //   child: Container(
                      //     // margin: EdgeInsets.all(10),
                      //     padding: EdgeInsets.all(5),
                      //     height: 40,
                      //     width: MediaQuery.of(context).size.width * 0.15,
                      //     decoration: BoxDecoration(
                      //       // color: Colors.white,
                      //       border: Border.all(color:primaryColorOfApp, width: 1.0),
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Icon(Icons.insert_drive_file,color: Colors.black,size: 20,),
                      //         SizedBox(width: 5,),
                      //         Expanded(
                      //           child: Text(
                      //             // 'Thrivers',
                      //             'For Someone Else',
                      //             overflow: TextOverflow.ellipsis,
                      //             style: GoogleFonts.montserrat(
                      //                 textStyle:
                      //                 Theme.of(context).textTheme.bodySmall,
                      //                 color: Colors.black),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      //
                      // ),

                    ],
                  ),

                  // Divider(color: Colors.black26,),


                  SizedBox(height: 5,),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .1,
                              child: Text("Date:   ",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .19,
                                child: TextField(
                                  controller: AboutMeDatetextController,
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context).textTheme.bodyLarge,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "" ,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),

                            ),
                          ],
                        ),

                        SizedBox(height: 5,),

                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .1,
                              child: Text("To: ",style: GoogleFonts.lato(
                                textStyle:
                                Theme
                                    .of(context)
                                    .textTheme
                                    .titleMedium,
                                  fontWeight: FontWeight.w700
                              ),),
                            ),
                            Expanded(
                              child:Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .19,
                                child: TextField(
                                  controller: SendNametextController,

                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),

                            Expanded(
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .19,
                                child: TextField(
                                  controller: SendEmailtextController,
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),

                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text("Cc: ",style: GoogleFonts.lato(
                                textStyle:
                                Theme
                                    .of(context)
                                    .textTheme
                                    .titleMedium,
                                  fontWeight: FontWeight.w700
                              ),),
                            ),
                            Expanded(
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .19,
                                child: TextField(
                                  controller: CopySendNametextController,

                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),

                            Expanded(
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .19,
                                child: TextField(
                                  controller: CopySendEmailtextController,
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 5,),

                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text("Cc: ",style: GoogleFonts.lato(
                                  textStyle:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,
                                  fontWeight: FontWeight.w700
                              ),),
                            ),
                            Expanded(
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .19,
                                child: TextField(
                                  controller: CopySendNametextController,

                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),

                            Expanded(
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .19,
                                child: TextField(
                                  controller: CopySendEmailtextController,
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 5,),

                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text("Cc: ",style: GoogleFonts.lato(
                                  textStyle:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,
                                  fontWeight: FontWeight.w700
                              ),),
                            ),
                            Expanded(
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .19,
                                child: TextField(
                                  controller: CopySendNametextController,

                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),

                            Expanded(
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width * .19,
                                child: TextField(
                                  controller: CopySendEmailtextController,
                                  style: GoogleFonts.lato(
                                      textStyle: Theme.of(context).textTheme.bodySmall,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .1,
                              child: Text("Name: ",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text("${previewProvider.name==null ? "" : previewProvider.name}",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .1,
                              child: Text("Role: ",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text("${previewProvider.role==null ? "" : previewProvider.role}",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .1,
                              child: Text("Location: ",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text("${previewProvider.location==null ? "" : previewProvider.location}",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .1,
                              child: Text("Employee number: ",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text("${previewProvider.employeeNumber==null ? "" : previewProvider.employeeNumber}",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .1,
                              child: Text("Team Leader:",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,fontWeight: FontWeight.w700)),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text("${previewProvider.linemanager==null ? "" : previewProvider.linemanager}",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .bodyLarge,)),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 15,),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Performing to my best in my role ${employerController.text}: ",
                        style: GoogleFonts.lato(fontWeight: FontWeight.bold,
                            // fontSize: 20,
                            color: Colors.blue)),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: AboutMeDescriptiontextController,
                      onChanged: (value) {
                        // _previewProvider.updatetitle(value);
                      },
                      maxLines: 18,
                      style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "$message",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    // padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color:Colors.black,),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("To perform to my best in my role, I’d like to share this information about me:",
                              style: GoogleFonts.lato(fontWeight: FontWeight.bold,
                                  // fontSize: 20,
                                  color: Colors.blue)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("Me and My circumstances: ",
                              style: GoogleFonts.lato(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,
                                  decoration: TextDecoration.underline
                              )),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mycircumstance==null ? "" : previewProvider.mycircumstance}",
                              style: GoogleFonts.lato(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,fontWeight: FontWeight.w600
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("My strengths that I want to have the opportunity to use in my role: ",
                              style: GoogleFonts.lato(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,
                                  decoration: TextDecoration.underline
                              )),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mystrength==null ? "" : previewProvider.mystrength}",
                              style: GoogleFonts.lato(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,fontWeight: FontWeight.w600
                              )),

                        ),


                        Container(

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric( vertical: 10.0,horizontal: 5),
                                child: Text("Things I find challenging in life that make it harder for me to perform my best:",
                                  style: GoogleFonts.lato(textStyle: Theme
                                      .of(context)
                                      .textTheme
                                      .titleMedium,
                                      decoration: TextDecoration.underline
                                  ),
                                ),
                              ),
                              SizedBox(height: 5,),

                              Consumer<PreviewProvider>(
                                builder: (context, previewProvider, _) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: previewProvider.PreviewChallengesList.map((solution) {
                                      int index = previewProvider.PreviewChallengesList.indexOf(solution);

                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 20.0),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: RichText(
                                                maxLines: 4,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: ' •  ',
                                                        style:TextStyle(fontSize: 20)
                                                    ),
                                                    TextSpan(
                                                        text: '${solution['Label']}',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,fontWeight: FontWeight.bold,)
                                                    ),
                                                    TextSpan(
                                                        text: ' - ${solution['Final_description']}\n',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium,fontWeight: FontWeight.w400
                                                        )
                                                    ),
                                                    TextSpan(
                                                        text: '  ${solution['Impact_on_me']}',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,color: Colors.grey,)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 50,),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: (){
                                                    showEditconfirmChallengeDialogBox(solution['id'], solution['Label'] , solution['Description'],
                                                        solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
                                                        solution['Created Date'], solution['Modified By'], solution['Modified Date'],
                                                        solution['Original Description'], solution['Impact'], solution['Final_description'],
                                                        solution['Category'], solution['Keywords'], solution['Potential Strengths'],
                                                        solution['Hidden Strengths'], index, solution, solution['Impact_on_me']);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: (){
                                                    _userAboutMEProvider.removeEditConfirmChallenge(index,solution['id'],challengesList,_previewProvider.PreviewChallengesList);
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("What I value about ${employerController.text} and workplace environment that helps me perform to my best: ",
                              style: GoogleFonts.lato(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,
                                  decoration: TextDecoration.underline
                              )),
                        ),
                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.myorganization==null ? "" : previewProvider.myorganization}",
                              style: GoogleFonts.lato(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,fontWeight: FontWeight.w600
                              )),

                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("What I find challenging about ${employerController.text} and the workplace environment that makes it harder for me to perform my best: ",
                              style: GoogleFonts.lato(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,
                                  decoration: TextDecoration.underline
                              )),
                        ),
                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5),
                          child: Text("${previewProvider.mychallenge==null ? "" : previewProvider.mychallenge}",
                              style: GoogleFonts.lato(textStyle: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,fontWeight: FontWeight.w600
                              )),

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
                          child: Text("Actions and adjustments that I’ve identified can help me perform to my best in my role for ${employerController.text}:",
                              style: GoogleFonts.lato(fontWeight: FontWeight.bold,
                                  // fontSize: 20,
                                  color: Colors.blue)),
                        ),

                        _previewProvider.PreviewSolutionMyResposibilty.isNotEmpty ?
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5),
                                child: Text("Personal Responsibility",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      // fontSize: 20,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5),
                                child: Text("Things I already or will do to help myself: ",
                                    style: GoogleFonts.lato(
                                        textStyle: Theme
                                            .of(context)
                                            .textTheme
                                            .titleMedium
                                    )),
                              ),
                              Consumer<PreviewProvider>(
                                builder: (context, previewProvider, _) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: previewProvider.PreviewSolutionMyResposibilty.map((solution) {

                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 20.0),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: RichText(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: ' •  ',
                                                        style: TextStyle(fontSize: 20)
                                                    ),
                                                    TextSpan(
                                                        text: '${solution['Label']}',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,fontWeight: FontWeight.bold,)
                                                    ),
                                                    TextSpan(
                                                        text: ' - ${solution['Final_description']}\n',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium,fontWeight: FontWeight.w400
                                                        )
                                                    ),
                                                    TextSpan(
                                                        text: '  ${solution['AboutMe_Notes']}',
                                                        style: GoogleFonts.lato(
                                                          textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,color: Colors.grey,),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 50,),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: (){
                                                    showEditconfirmSolutionsDialogBox(solution['id'], solution['Label'] , solution['Description'],
                                                        solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
                                                        solution['Created Date'], solution['Modified By'], solution['Modified Date'],
                                                        solution['Original Description'], solution['Impact'], solution['Final_description'],
                                                        solution['Category'], solution['Keywords'], solution['Potential Strengths'],
                                                        solution['Hidden Strengths'], solution, solution['AboutMe_Notes'],solution['Provider'],solution['InPlace']);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: (){
                                                    _userAboutMEProvider.removeEditConfirmSolution(solution["id"],solutionsList,
                                                      _previewProvider.PreviewSolutionMyResposibilty,
                                                      _previewProvider.PreviewSolutionStillNeeded,
                                                      _previewProvider.PreviewSolutionNotNeededAnyMore,
                                                      _previewProvider.PreviewSolutionNiceToHave,
                                                      _previewProvider.PreviewSolutionMustHave,
                                                    );
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ) : Container(),

                        (_previewProvider.PreviewSolutionNotNeededAnyMore.isNotEmpty ||
                            _previewProvider.PreviewSolutionMustHave.isNotEmpty ||
                            _previewProvider.PreviewSolutionNiceToHave.isNotEmpty ||
                            _previewProvider.PreviewSolutionStillNeeded.isNotEmpty ) ?
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5),
                          child: Text("Requests of ${employerController.text}",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  // fontSize: 20,
                                  color: Colors.black)),
                        ) : Container(),

                        _previewProvider.PreviewSolutionStillNeeded.isNotEmpty ?
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5),
                                child: Text("${employerController.text} already provides the following assistance to me, which I’d like to continue to receive: ",
                                    style: GoogleFonts.lato(
                                        textStyle: Theme
                                            .of(context)
                                            .textTheme
                                            .titleMedium
                                    )),
                              ),
                              Consumer<PreviewProvider> (
                                builder: (context, previewProvider, _) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: previewProvider.PreviewSolutionStillNeeded.map((solution) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 20.0),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: RichText(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: ' •  ',
                                                        style: TextStyle(fontSize: 20)
                                                    ),
                                                    TextSpan(
                                                        text: '${solution['Label']}',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,fontWeight: FontWeight.bold,)
                                                    ),
                                                    TextSpan(
                                                        text: ' - ${solution['Final_description']}\n',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium,fontWeight: FontWeight.w400
                                                        )
                                                    ),
                                                    TextSpan(
                                                        text: '  ${solution['AboutMe_Notes']}',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,color: Colors.grey,)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 50,),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: (){
                                                    showEditconfirmSolutionsDialogBox(solution['id'], solution['Label'] , solution['Description'],
                                                        solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
                                                        solution['Created Date'], solution['Modified By'], solution['Modified Date'],
                                                        solution['Original Description'], solution['Impact'], solution['Final_description'],
                                                        solution['Category'], solution['Keywords'], solution['Potential Strengths'],
                                                        solution['Hidden Strengths'], solution, solution['AboutMe_Notes'],solution['Provider'],solution['InPlace']);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: (){
                                                    _userAboutMEProvider.removeEditConfirmSolution(solution["id"],solutionsList,
                                                      _previewProvider.PreviewSolutionMyResposibilty,
                                                      _previewProvider.PreviewSolutionStillNeeded,
                                                      _previewProvider.PreviewSolutionNotNeededAnyMore,
                                                      _previewProvider.PreviewSolutionNiceToHave,
                                                      _previewProvider.PreviewSolutionMustHave,
                                                    );
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ) : Container(),

                        _previewProvider.PreviewSolutionMustHave.isNotEmpty ?
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5),
                                child: Text("I’m asking ${employerController.text} to start providing for me:",
                                    style: GoogleFonts.lato(
                                        textStyle: Theme
                                            .of(context)
                                            .textTheme
                                            .titleMedium
                                    )),
                              ),
                              Consumer<PreviewProvider>(
                                builder: (context, previewProvider, _) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: previewProvider.PreviewSolutionMustHave.map((solution) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 20.0),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: RichText(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: ' •  ',
                                                        style: TextStyle(fontSize: 20)
                                                    ),
                                                    TextSpan(
                                                        text: '${solution['Label']}',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,fontWeight: FontWeight.bold,)
                                                    ),
                                                    TextSpan(
                                                        text: ' - ${solution['Final_description']}\n',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium,fontWeight: FontWeight.w400
                                                        )
                                                    ),
                                                    TextSpan(
                                                        text: '  ${solution['AboutMe_Notes']}',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,color: Colors.grey,)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 50,),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: (){
                                                    showEditconfirmSolutionsDialogBox(solution['id'], solution['Label'] , solution['Description'],
                                                        solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
                                                        solution['Created Date'], solution['Modified By'], solution['Modified Date'],
                                                        solution['Original Description'], solution['Impact'], solution['Final_description'],
                                                        solution['Category'], solution['Keywords'], solution['Potential Strengths'],
                                                        solution['Hidden Strengths'],solution, solution['AboutMe_Notes'],solution['Provider'],solution['InPlace']);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: (){
                                                    _userAboutMEProvider.removeEditConfirmSolution(solution["id"],solutionsList,
                                                      _previewProvider.PreviewSolutionMyResposibilty,
                                                      _previewProvider.PreviewSolutionStillNeeded,
                                                      _previewProvider.PreviewSolutionNotNeededAnyMore,
                                                      _previewProvider.PreviewSolutionNiceToHave,
                                                      _previewProvider.PreviewSolutionMustHave,
                                                    );
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ) : Container(),

                        _previewProvider.PreviewSolutionNiceToHave.isNotEmpty ?
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5),
                                child: Text("I’m asking  ${employerController.text} to start providing for me but they are not essential: ",
                                    style: GoogleFonts.lato(
                                        textStyle: Theme
                                            .of(context)
                                            .textTheme
                                            .titleMedium
                                    )),
                              ),
                              Consumer<PreviewProvider>(
                                builder: (context, previewProvider, _) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: previewProvider.PreviewSolutionNiceToHave.map((solution) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 20.0),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: RichText(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: ' •  ',
                                                        style: TextStyle(fontSize: 20)
                                                    ),
                                                    TextSpan(
                                                        text: '${solution['Label']}',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,fontWeight: FontWeight.bold,)
                                                    ),
                                                    TextSpan(
                                                        text: ' - ${solution['Final_description']}\n',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium,fontWeight: FontWeight.w400
                                                        )
                                                    ),
                                                    TextSpan(
                                                        text: '  ${solution['AboutMe_Notes']}',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,color: Colors.grey,)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 50,),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: (){
                                                    showEditconfirmSolutionsDialogBox(solution['id'], solution['Label'] , solution['Description'],
                                                        solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
                                                        solution['Created Date'], solution['Modified By'], solution['Modified Date'],
                                                        solution['Original Description'], solution['Impact'], solution['Final_description'],
                                                        solution['Category'], solution['Keywords'], solution['Potential Strengths'],
                                                        solution['Hidden Strengths'], solution, solution['AboutMe_Notes'],solution['Provider'],solution['InPlace']);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: (){
                                                    _userAboutMEProvider.removeEditConfirmSolution(solution["id"],solutionsList,
                                                      _previewProvider.PreviewSolutionMyResposibilty,
                                                      _previewProvider.PreviewSolutionStillNeeded,
                                                      _previewProvider.PreviewSolutionNotNeededAnyMore,
                                                      _previewProvider.PreviewSolutionNiceToHave,
                                                      _previewProvider.PreviewSolutionMustHave,
                                                    );
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ) : Container(),

                        _previewProvider.PreviewSolutionNotNeededAnyMore .isNotEmpty ?
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5),
                                child: Text("${employerController.text} already provides for me but are not needed anymore: ",
                                    style: GoogleFonts.lato(
                                        textStyle: Theme
                                            .of(context)
                                            .textTheme
                                            .titleMedium
                                    )),
                              ),
                              Consumer<PreviewProvider>(
                                builder: (context, previewProvider, _) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: previewProvider.PreviewSolutionNotNeededAnyMore.map((solution) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 20.0),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: RichText(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: ' •  ',
                                                        style: TextStyle(fontSize: 20)
                                                    ),
                                                    TextSpan(
                                                        text: '${solution['Label']}',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,fontWeight: FontWeight.bold,)
                                                    ),
                                                    TextSpan(
                                                        text: ' - ${solution['Final_description']}\n',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium,fontWeight: FontWeight.w400
                                                        )
                                                    ),
                                                    TextSpan(
                                                        text: '  ${solution['AboutMe_Notes']}',
                                                        style: GoogleFonts.lato(textStyle: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium,color: Colors.grey,)
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 50,),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: (){
                                                    showEditconfirmSolutionsDialogBox(solution['id'], solution['Label'] , solution['Description'],
                                                        solution['Source'], solution['Challenge Status'], solution['tags'], solution['Created By'],
                                                        solution['Created Date'], solution['Modified By'], solution['Modified Date'],
                                                        solution['Original Description'], solution['Impact'], solution['Final_description'],
                                                        solution['Category'], solution['Keywords'], solution['Potential Strengths'],
                                                        solution['Hidden Strengths'], solution, solution['AboutMe_Notes'],solution['Provider'],solution['InPlace']);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete),
                                                  onPressed: (){
                                                    _userAboutMEProvider.removeEditConfirmSolution(solution["id"],solutionsList,
                                                      _previewProvider.PreviewSolutionMyResposibilty,
                                                      _previewProvider.PreviewSolutionStillNeeded,
                                                      _previewProvider.PreviewSolutionNotNeededAnyMore,
                                                      _previewProvider.PreviewSolutionNiceToHave,
                                                      _previewProvider.PreviewSolutionMustHave,
                                                    );
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ) : Container(),

                        SizedBox(height: 5,),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 5),
                    child: TextField(
                      controller: AboutMeUseFulInfotextController,
                      onChanged: (value) {
                        _previewProvider.updatetitle(value);
                      },
                      style: GoogleFonts.lato(
                          textStyle: Theme.of(context).textTheme.bodySmall,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Links/Document/Product Info",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                        child: Text("Attachments :", style: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.titleSmall,)),
                      ),
                      SizedBox(width: 10,),

                      // InkWell(
                      //   onTap: (){
                      //     // _userAboutMEProvider.pickFiles();
                      //   },
                      //   child: Container(
                      //     // padding: EdgeInsets.all(20),
                      //     child: Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
                      //     width: 30,
                      //     height: 30,
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue,
                      //       borderRadius: BorderRadius.circular(50),
                      //     ),
                      //   ),
                      // ),
                      IconButton(onPressed: (){},
                        icon: Container(
                          // padding: EdgeInsets.all(20),
                          child: Center(child: Icon(Icons.add, size: 30, color: Colors.white,)),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        tooltip: "Medical and Personal",
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${_userAboutMEProvider.aadhar==null ? "" : _userAboutMEProvider.aadhar}", style: GoogleFonts.lato(textStyle: Theme.of(context).textTheme.titleSmall,)),
                    // child: Text("document.pdf", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
                  ),
                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        InkWell(
                          onTap: () async {

                            var createdAt = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());

                            Map<String, dynamic> AboutMEDatas = {
                              'About_Me_Label': AboutMeLabeltextController.text,
                              'AB_Description' : AboutMeDescriptiontextController.text,
                              'AB_Date' : AboutMeDatetextController.text,
                              'AB_Useful_Info' : AboutMeUseFulInfotextController.text,
                              'AB_Attachment' : "",
                              'Solutions': solutionsList,
                              'Challenges': challengesList,
                            };

                            String solutionJson = json.encode(AboutMEDatas);
                            print("About_Me_Label: ${AboutMEDatas['About_Me_Label']}");

                            ProgressDialog.show(context, "Completing", Icons.save);
                            await ApiRepository().updateAboutMe(AboutMEDatas,documentId);

                            // downloadAboutMePdf(challengesList,solutionsList);

                            ProgressDialog.hide();

                            // sendMailPopUp(challengesList,solutionsList);

                            // selectedEmail = null;
                            // nameController.clear();
                            // searchEmailcontroller.clear();
                            // employerController.clear();
                            // divisionOrSectionController.clear();
                            // RoleController.clear();
                            // LocationController.clear();
                            // EmployeeNumberController.clear();
                            // LineManagerController.clear();
                            // mycircumstancesController.clear();
                            // MystrengthsController.clear();
                            // mycircumstancesController.clear();
                            // AboutMeLabeltextController.clear();
                            // RefineController.clear();
                            // solutionsList.clear();
                            // _userAboutMEProvider.solutionss.clear();
                            // _userAboutMEProvider.challengess.clear();
                            // _userAboutMEProvider.combinedSolutionsResults.clear();
                            // _userAboutMEProvider.combinedResults.clear();
                            // previewProvider.email=null;
                            // previewProvider.name=null;
                            // previewProvider.employer=null;
                            // previewProvider.division=null;
                            // previewProvider.role=null;
                            // previewProvider.location=null;
                            // previewProvider.employeeNumber=null ;
                            // previewProvider.linemanager=null;
                            // previewProvider.title=null;
                            // previewProvider.mycircumstance=null;
                            // previewProvider.mystrength=null ;
                            // previewProvider.myorganization=null ;
                            // previewProvider.mychallenge=null ;
                            // previewProvider.PreviewChallengesList.clear();
                            // previewProvider.PreviewSolutionList.clear();
                            // // _navigateToTab(0);
                            // // Navigator.pop(context);
                            // setState(() {
                            //   page.jumpToPage(1);
                            // });

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
                              child:Text(
                                'Save',
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
                        SizedBox(width: 10,),

                        InkWell(
                          onTap: () async {

                            var createdAt = DateFormat('yyyy-MM-dd, hh:mm').format(DateTime.now());

                            Map<String, dynamic> AboutMEDatas = {
                              'About_Me_Label': AboutMeLabeltextController.text,
                              'AB_Status' : "Complete",
                              'AB_Description' : AboutMeDescriptiontextController.text,
                              'AB_Useful_Info' : AboutMeUseFulInfotextController.text,
                              'AB_Date' : AboutMeDatetextController.text,
                              'AB_Attachment' : "",
                              'Solutions': solutionsList,
                              'Challenges': challengesList,
                            };

                            String solutionJson = json.encode(AboutMEDatas);
                            print(solutionJson);

                            ProgressDialog.show(context, "Completing", Icons.save);
                            await ApiRepository().updateAboutMe(AboutMEDatas,documentId);

                            ProgressDialog.hide();

                            sendMailPopUp(challengesList,solutionsList);
                            //
                            // downloadAboutMePdf(challengesList,solutionsList);

                            // selectedEmail = null;
                            // nameController.clear();
                            // searchEmailcontroller.clear();
                            // employerController.clear();
                            // divisionOrSectionController.clear();
                            // RoleController.clear();
                            // LocationController.clear();
                            // EmployeeNumberController.clear();
                            // LineManagerController.clear();
                            // mycircumstancesController.clear();
                            // MystrengthsController.clear();
                            // mycircumstancesController.clear();
                            // AboutMeLabeltextController.clear();
                            // RefineController.clear();
                            // solutionsList.clear();
                            // _userAboutMEProvider.solutionss.clear();
                            // _userAboutMEProvider.challengess.clear();
                            // _userAboutMEProvider.combinedSolutionsResults.clear();
                            // _userAboutMEProvider.combinedResults.clear();
                            // previewProvider.email=null;
                            // previewProvider.name=null;
                            // previewProvider.employer=null;
                            // previewProvider.division=null;
                            // previewProvider.role=null;
                            // previewProvider.location=null;
                            // previewProvider.employeeNumber=null ;
                            // previewProvider.linemanager=null;
                            // previewProvider.title=null;
                            // previewProvider.mycircumstance=null;
                            // previewProvider.mystrength=null ;
                            // previewProvider.myorganization=null ;
                            // previewProvider.mychallenge=null ;
                            // previewProvider.PreviewChallengesList.clear();
                            // previewProvider.PreviewSolutionList.clear();
                            // // _navigateToTab(0);
                            // // Navigator.pop(context);
                            // setState(() {
                            //   page.jumpToPage(1);
                            // });
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
                              child:Text(
                                'Complete and Send',
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
                  )

                ],
              ),
            ),
          );
        });
  }

  sendMailPopUp(dataList,dataList2){

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
                title: Text(
                  'Send Mail to:',
                  style: GoogleFonts.montserrat(
                    textStyle:
                    Theme
                        .of(context)
                        .textTheme
                        .titleMedium,
                    fontWeight: FontWeight.bold,
                    //color: primaryColorOfApp
                  ),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                            child: Text("To: ",style: GoogleFonts.montserrat(
                              textStyle:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,
                            ),),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5),
                              child: TextField(
                                controller: SendNametextController,

                                style: GoogleFonts.montserrat(
                                    textStyle: Theme.of(context).textTheme.bodySmall,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5),
                              child: TextField(
                                controller: SendEmailtextController,
                                style: GoogleFonts.montserrat(
                                    textStyle: Theme.of(context).textTheme.bodySmall,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.05,
                            child: Text("Copy: ",style: GoogleFonts.montserrat(
                              textStyle:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,
                            ),),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5),
                              child: TextField(
                                controller: CopySendNametextController,

                                style: GoogleFonts.montserrat(
                                    textStyle: Theme.of(context).textTheme.bodySmall,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5),
                              child: TextField(
                                controller: CopySendEmailtextController,
                                style: GoogleFonts.montserrat(
                                    textStyle: Theme.of(context).textTheme.bodySmall,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("File: "),
                            Text("$About_Me_Label"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          SendEmailtextController.clear();
                          CopySendEmailtextController.clear();
                          SendNametextController.clear();
                          CopySendNametextController.clear();
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
                      SizedBox(width: 5, height: 5,),
                      InkWell(
                        onTap: () async {

                          DateTime date = DateTime.now();
                          final DateFormat formatter = DateFormat('dd MMMM yyyy');
                          String formattedDate = formatter.format(date);
                          // AboutMeDatetextController.text = formattedDate;

                          Map<String, dynamic> sentTojson1 ={
                            "Sent_to" : SendNametextController.text,
                            "email": SendEmailtextController.text,
                            "Date_sent" : formattedDate,
                          };
                          Map<String, dynamic> sentTojson2 ={
                            "Sent_to" : CopySendNametextController.text.isEmpty ? "" : CopySendNametextController.text,
                            "email": CopySendEmailtextController.text.isEmpty ? "" : CopySendEmailtextController.text,
                            "Date_sent" : CopySendEmailtextController.text.isEmpty ? "" : formattedDate,
                          };

                          Map<String, dynamic> AboutMEDatas = {
                            // 'About_Me_Label': AboutMeLabeltextController.text,
                            'AB_Status' : "Complete and Sent",
                            'Report_sent_to' : [sentTojson1,sentTojson2]
                          };

                          String solutionJson = json.encode(AboutMEDatas);
                          print(solutionJson);

                          ProgressDialog.show(context, "Sending", Icons.save);
                          await ApiRepository().updateAboutMe(AboutMEDatas,documentId);


                          final Uint8List pdfBytes = await makePdf(dataList,dataList2);
                          String base64EncodedData = base64.encode(pdfBytes);
                          String filename = "${About_Me_Label}.pdf";
                          print("sendMailPopUp chunks: ${base64EncodedData}");
                          print("sendMailPopUp filename: ${ filename}");
                        await ApiRepository().sendEmailWithAttachment(
                              context,
                              SendEmailtextController.text,
                              SendNametextController.text,
                              CopySendEmailtextController.text,
                              CopySendNametextController.text,
                              base64EncodedData,
                              filename
                          );

                        await downloadAboutMePdf(dataList,dataList2);



                          print(SendEmailtextController.text);
                          print(CopySendEmailtextController.text);
                          print(SendNametextController.text);
                          print(CopySendNametextController.text);


                          ProgressDialog.hide();
                          // selectedEmail = null;
                          // SendEmailtextController.clear();
                          // SendNametextController.clear();
                          // nameController.clear();
                          // searchEmailcontroller.clear();
                          // employerController.clear();
                          // divisionOrSectionController.clear();
                          // RoleController.clear();
                          // LocationController.clear();
                          // EmployeeNumberController.clear();
                          // LineManagerController.clear();
                          // mycircumstancesController.clear();
                          // MystrengthsController.clear();
                          // mycircumstancesController.clear();
                          // AboutMeLabeltextController.clear();
                          // RefineController.clear();
                          // solutionsList.clear();
                          // _userAboutMEProvider.solutionss.clear();
                          // _userAboutMEProvider.challengess.clear();
                          // _userAboutMEProvider.combinedSolutionsResults.clear();
                          // _userAboutMEProvider.combinedResults.clear();
                          // _previewProvider.email=null;
                          // _previewProvider.name=null;
                          // _previewProvider.employer=null;
                          // _previewProvider.division=null;
                          // _previewProvider.role=null;
                          // _previewProvider.location=null;
                          // _previewProvider.employeeNumber=null ;
                          // _previewProvider.linemanager=null;
                          // _previewProvider.title=null;
                          // _previewProvider.mycircumstance=null;
                          // _previewProvider.mystrength=null ;
                          // _previewProvider.myorganization=null ;
                          // _previewProvider.mychallenge=null ;
                          // _previewProvider.PreviewChallengesList.clear();
                          // _previewProvider.PreviewSolutionList.clear();
                          // _navigateToTab(0);
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          width: MediaQuery.of(context).size.width * .3,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                                color: Colors.blue ,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                            child: Text(
                              'Send',
                              style: GoogleFonts.montserrat(
                                  textStyle:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .titleSmall,
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
              )
          );
        }
    );
  }


  Future<Uint8List> makePdf(List<Map<String, dynamic>> dataList, List<Map<String, dynamic>> dataList2) async {
    final pdf = pw.Document();
    final Reportfont = await PdfGoogleFonts.latoBoldItalic();
    final Reportansfont = await PdfGoogleFonts.latoItalic();

    final headingfont1 = await PdfGoogleFonts.latoBold();
    final bodyfont1 = await PdfGoogleFonts.latoRegular();

    pdf.addPage(
        pw.MultiPage(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(20),
          build: (context) {
            // List<pw.Widget> ChallengetableRows = generateChallengeWidgets(dataList,headingfont1,bodyfont1);
            List<pw.TableRow> SolutiontableRows = generateSolutionTableRows(dataList2);
            return [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 10.0,),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text("Report file name: ", style: pw.TextStyle(font: Reportfont)),

                    pw.Text("${AboutMeLabeltextController.text}",style: pw.TextStyle(font: Reportansfont,color: PdfColors.black)),

                  ],
                ),
              ),

              pw.SizedBox(height: 5,),


              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 120,
                    child: pw.Text(
                      "Date: ",
                      style: pw.TextStyle(
                        font: headingfont1,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    "${AboutMeDatetextController.text}",
                    style: pw.TextStyle(font: bodyfont1),
                  ),
                ],
              ),

              pw.SizedBox(height: 10,),


              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 120,
                    child: pw.Text(
                      "Name: ",
                      style: pw.TextStyle(
                        font: headingfont1,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    "${nameController.text}",
                    style: pw.TextStyle(font: bodyfont1),
                  ),
                ],
              ),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 120,
                    child: pw.Text(
                      "Role: ",
                      style: pw.TextStyle(
                        font: headingfont1,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    "${RoleController.text}",
                    style: pw.TextStyle(font: bodyfont1),
                  ),
                ],
              ),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 120,
                    child: pw.Text(
                      "Location: ",
                      style: pw.TextStyle(
                        font: headingfont1,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    "${LocationController.text}",
                    style: pw.TextStyle(font: bodyfont1),
                  ),
                ],
              ),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 120,
                    child: pw.Text(
                      "Employee number: ",
                      style: pw.TextStyle(
                        font: headingfont1,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    "${EmployeeNumberController.text}",
                    style: pw.TextStyle(font: bodyfont1),
                  ),
                ],
              ),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 120,
                    child: pw.Text(
                      "Team Leader: ",
                      style: pw.TextStyle(
                        font: headingfont1,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    "${LineManagerController.text}",
                    style: pw.TextStyle(font: bodyfont1),
                  ),
                ],
              ),

              pw.SizedBox(height: 10,),

              pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0,),
                  child: pw.Text("Performing to my best in my role ${employerController.text}: ",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font:headingfont1))
              ),

              pw.SizedBox(height: 5,),


              pw.Text(
                "${AboutMeDescriptiontextController.text}",
                style: pw.TextStyle(font: bodyfont1),
              ),


              pw.SizedBox(height: 20,),


            ];
          },));

    pdf.addPage(
        pw.MultiPage(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(20),
          build: (context) {
            List<pw.Widget> ChallengetableRows = generateChallengeWidgets(dataList,headingfont1,bodyfont1);
            List<pw.Widget> SolutiontableRows1 =  generateSolutionsMyResponsibiltyWidgets(dataList2,headingfont1,bodyfont1);
            List<pw.Widget> SolutiontableRows2 =  generateSolutionsStillNeededWidgets(dataList2,headingfont1,bodyfont1);
            List<pw.Widget> SolutiontableRows3 =  generateSolutionsNotNeededAnymoreWidgets(dataList2,headingfont1,bodyfont1);
            List<pw.Widget> SolutiontableRows4 =  generateSolutionsNoNicetohaveWidgets(dataList2,headingfont1,bodyfont1);
            List<pw.Widget> SolutiontableRows5 =  generateSolutionsMustHaveWidgets(dataList2,headingfont1,bodyfont1);
            return [

              pw.Container(
                  width: 1000,
                  padding: pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color:PdfColors.black,),
                    // borderRadius: pw.BorderRadius.circular(10),
                  ),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,

                      children: [
                        pw.Text("To perform to my best in my role, I’d like to share this information about me: ",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font:headingfont1)),

                        pw.SizedBox(height: 10,),

                        pw.Text(
                          "Me and My circumstances: ",
                          style: pw.TextStyle(font: bodyfont1, decoration: pw.TextDecoration.underline),
                        ),

                        pw.SizedBox(height: 10,),

                        pw.Text(
                          "${mycircumstancesController.text}",
                          style: pw.TextStyle(font: bodyfont1),
                        ),


                        pw.SizedBox(height: 10,),

                        pw.Text(
                          "My strengths that I want to have the opportunity to use in my role: ",
                          style: pw.TextStyle(font: bodyfont1, decoration: pw.TextDecoration.underline),
                        ),

                        pw.SizedBox(height: 10,),

                        pw.Text(
                          "${MystrengthsController.text}",
                          style: pw.TextStyle(font: bodyfont1),
                        ),

                        pw.SizedBox(height: 10,),

                        pw.Text(
                          "Things I find challenging in life that make it harder for me to perform my best: ",
                          style: pw.TextStyle(font: bodyfont1, decoration: pw.TextDecoration.underline),
                        ),

                        pw.SizedBox(height: 10,),

                        ...ChallengetableRows,


                        pw.SizedBox(height: 10,),

                        pw.Text(
                          "What I value about ${employerController.text} and workplace environment that helps me perform to my best: ",
                          style: pw.TextStyle(font: bodyfont1, decoration: pw.TextDecoration.underline),
                        ),

                        pw.SizedBox(height: 10,),

                        pw.Text(
                          "${myOrganisationController.text}",
                          style: pw.TextStyle(font: bodyfont1),
                        ),


                        pw.SizedBox(height: 10,),

                        pw.Text(
                          "What I find challenging about ${employerController.text} and the workplace environment that makes it harder for me to perform my best: ",
                          style: pw.TextStyle(font: bodyfont1, decoration: pw.TextDecoration.underline),
                        ),

                        pw.SizedBox(height: 10,),

                        pw.Text(
                          "${myOrganisation2Controller.text}",
                          style: pw.TextStyle(font: bodyfont1),
                        ),

                        pw.SizedBox(height: 10,),



                      ])),

              pw.SizedBox(height: 10,),

              pw.Text("Actions and adjustments that I’ve identified can help me perform to my best in my role for ${employerController.text}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font:headingfont1)),

              pw.SizedBox(height: 10,),

              (SolutiontableRows1.isNotEmpty) ?  pw.Text(
                "Personal Responsibility ",
                style: pw.TextStyle(font: headingfont1, decoration: pw.TextDecoration.underline),
              ) :

              pw.SizedBox(),

              (SolutiontableRows1.isNotEmpty) ? pw.SizedBox(height: 10,) : pw.SizedBox(),


              (SolutiontableRows1.isNotEmpty) ? pw.Text("Things I already or will do to help myself:",
                  style: pw.TextStyle( font:bodyfont1)) :

              pw.SizedBox(),

              (SolutiontableRows1.isNotEmpty) ? pw.SizedBox(height: 10,) : pw.SizedBox(),

              ...SolutiontableRows1,

              (SolutiontableRows1.isNotEmpty) ? pw.SizedBox(height: 10,) : pw.SizedBox(),

              (SolutiontableRows2.isNotEmpty || SolutiontableRows3.isNotEmpty || SolutiontableRows4.isNotEmpty || SolutiontableRows5.isNotEmpty ) ? pw.Text(
                "Requests of ${employerController.text}",
                style: pw.TextStyle(font: headingfont1, decoration: pw.TextDecoration.underline),
              ) : pw.SizedBox(),

              (SolutiontableRows2.isNotEmpty) ? pw.SizedBox(height: 10,) : pw.SizedBox(),

              (SolutiontableRows2.isNotEmpty) ?  pw.Text("${employerController.text} already provides the following assistance to me, which I’d like to continue to receive:",
                  style: pw.TextStyle( font:bodyfont1)) : pw.SizedBox(),

              (SolutiontableRows2.isNotEmpty) ? pw.SizedBox(height: 10,) : pw.SizedBox(),


              ...SolutiontableRows2,


              (SolutiontableRows2.isNotEmpty) ? pw.SizedBox(height: 10,) : pw.SizedBox(),

              (SolutiontableRows3.isNotEmpty) ? pw.Text("I’m asking ${employerController.text} to start providing for me:",
                  style: pw.TextStyle( font:bodyfont1)) : pw.SizedBox(),

              (SolutiontableRows3.isNotEmpty) ? pw.SizedBox(height: 10,) : pw.SizedBox(),

              ...SolutiontableRows3,


              (SolutiontableRows3.isNotEmpty) ? pw.SizedBox(height: 10,) : pw.SizedBox(),

              (SolutiontableRows4.isNotEmpty) ? pw.Text("I’m asking ${employerController.text} to start providing for me but they are not essential:",
                  style: pw.TextStyle( font:bodyfont1)) : pw.SizedBox(),

              (SolutiontableRows4.isNotEmpty) ? pw.SizedBox(height: 10,) : pw.SizedBox(),

              ...SolutiontableRows4,


              (SolutiontableRows5.isNotEmpty) ? pw.SizedBox(height: 10,) : pw.SizedBox(),

              (SolutiontableRows5.isNotEmpty) ? pw.Text("${employerController.text} already provides for me but are not needed anymore:",
                  style: pw.TextStyle( font:bodyfont1)) : pw.SizedBox(),

              (SolutiontableRows5.isNotEmpty) ? pw.SizedBox(height: 10,) : pw.SizedBox(),

              ...SolutiontableRows5,


              // pw.Padding(
              //   padding: const pw.EdgeInsets.symmetric(
              //       vertical: 10.0, horizontal: 8),
              //   child: pw.Row(
              //     mainAxisAlignment: pw.MainAxisAlignment.start,
              //     children: [
              //
              //       pw.Text("Useful Info: ",),
              //       pw.Text("${AboutMeUseFulInfotextController.text}",),
              //
              //     ],
              //   ),
              // ),
              //
              // pw.Padding(
              //   padding: const pw.EdgeInsets.symmetric(
              //       vertical: 10.0, horizontal: 8),
              //   child: pw.Row(
              //     mainAxisAlignment: pw.MainAxisAlignment.start,
              //     children: [
              //
              //       pw.Text("Attachment: ",),
              //       pw.Text("Attachment",),
              //
              //     ],
              //   ),
              // ),

            ];
          },));





    return pdf.save();
  }

  Future<void> downloadAboutMePdf(dataList,dataList2) async {
    // final Uint8List pdfBytes = await generateAboutMePdf();
    final Uint8List pdfBytes = await makePdf(dataList,dataList2);
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "$About_Me_Label")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  List<pw.Widget> generateChallengeWidgets(List<Map<String, dynamic>> dataList,headingfont1,bodyfont1) {
    List<pw.Widget> widgets = [];

    for (var solution in dataList) {


      pw.Widget widget = pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Padding(
            padding: pw.EdgeInsets.only(bottom: 20.0, right: 20,),
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.RichText(
                    maxLines: 4,
                    overflow: pw.TextOverflow.span,
                    text: pw.TextSpan(
                      children: [
                        pw.TextSpan(
                          text: ' • ',
                          style: pw.TextStyle(
                            font: bodyfont1,
                          ),
                        ),
                        pw.TextSpan(
                          text: '${solution['Label']}',
                          style: pw.TextStyle(
                            font: headingfont1,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.TextSpan(
                          text: ' - ${solution['Final_description']}\n',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            font: bodyfont1,
                          ),
                        ),
                        pw.TextSpan(
                          text: ' ${solution['Impact_on_me']}',
                          style: pw.TextStyle(
                              color: PdfColors.grey, font: bodyfont1),
                        ),
                      ],
                    ),
                  ),),
              ],
            ),
          ),
        ],
      );
      widgets.add(widget);
    }

    return widgets;
  }

  List<pw.Widget> generateSolutionsMyResponsibiltyWidgets(List<Map<String, dynamic>> dataList2,headingfont1,bodyfont1) {
    List<pw.Widget> widgets = [];

    for (var solution in dataList2) {

      if(solution["Provider"] == "My Responsibilty") {
        pw.Widget widget = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.only(bottom: 20.0, right: 20,),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.RichText(
                      maxLines: 4,
                      overflow: pw.TextOverflow.span,
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text: ' • ',
                            style: pw.TextStyle(
                              font: bodyfont1,
                            ),
                          ),
                          pw.TextSpan(
                            text: '${solution['Label']}',
                            style: pw.TextStyle(
                              font: headingfont1,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.TextSpan(
                            text: ' - ${solution['Final_description']}\n',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              font: bodyfont1,
                            ),
                          ),
                          pw.TextSpan(
                            text: ' ${solution['AboutMe_Notes']}',
                            style: pw.TextStyle(
                                color: PdfColors.grey, font: bodyfont1),
                          ),
                        ],
                      ),
                    ),),
                ],
              ),
            ),
          ],
        );
        widgets.add(widget);
      }
    }

    return widgets;
  }

  List<pw.Widget> generateSolutionsStillNeededWidgets(List<Map<String, dynamic>> dataList2,headingfont1,bodyfont1) {
    List<pw.Widget> widgets = [];

    for (var solution in dataList2) {

      if(solution["InPlace"] == "Yes (Still Needed)") {
        pw.Widget widget = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.only(bottom: 20.0, right: 20),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.RichText(
                      maxLines: 4,
                      overflow: pw.TextOverflow.span,
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text: ' • ',
                            style: pw.TextStyle(
                              font: bodyfont1,
                            ),
                          ),
                          pw.TextSpan(
                            text: '${solution['Label']}',
                            style: pw.TextStyle(
                              font: headingfont1,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.TextSpan(
                            text: ' - ${solution['Final_description']}\n',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              font: bodyfont1,
                            ),
                          ),
                          pw.TextSpan(
                            text: ' ${solution['AboutMe_Notes']}',
                            style: pw.TextStyle(
                                color: PdfColors.grey, font: bodyfont1),
                          ),
                        ],
                      ),
                    ),),
                ],
              ),
            ),
          ],
        );
        widgets.add(widget);
      }
    }

    return widgets;
  }

  List<pw.Widget> generateSolutionsNotNeededAnymoreWidgets(List<Map<String, dynamic>> dataList2,headingfont1,bodyfont1) {
    List<pw.Widget> widgets = [];

    for (var solution in dataList2) {

      if(solution["InPlace"] == "Yes (Not Needed Anymore)") {
        pw.Widget widget = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.only(bottom: 20.0, right: 20),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.RichText(
                      maxLines: 4,
                      overflow: pw.TextOverflow.span,
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text: ' • ',
                            style: pw.TextStyle(
                              font: bodyfont1,
                            ),
                          ),
                          pw.TextSpan(
                            text: '${solution['Label']}',
                            style: pw.TextStyle(
                              font: headingfont1,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.TextSpan(
                            text: ' - ${solution['Final_description']}\n',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              font: bodyfont1,
                            ),
                          ),
                          pw.TextSpan(
                            text: ' ${solution['AboutMe_Notes']}',
                            style: pw.TextStyle(
                                color: PdfColors.grey, font: bodyfont1),
                          ),
                        ],
                      ),
                    ),),
                ],
              ),
            ),
          ],
        );
        widgets.add(widget);
      }
    }

    return widgets;
  }

  List<pw.Widget> generateSolutionsNoNicetohaveWidgets(List<Map<String, dynamic>> dataList2,headingfont1,bodyfont1) {
    List<pw.Widget> widgets = [];

    for (var solution in dataList2) {

      if(solution["InPlace"] == "No (Nice to have)") {
        pw.Widget widget = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.only(bottom: 20.0, right: 20),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.RichText(
                      maxLines: 4,
                      overflow: pw.TextOverflow.span,
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text: ' • ',
                            style: pw.TextStyle(
                              font: bodyfont1,
                            ),
                          ),
                          pw.TextSpan(
                            text: '${solution['Label']}',
                            style: pw.TextStyle(
                              font: headingfont1,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.TextSpan(
                            text: ' - ${solution['Final_description']}\n',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              font: bodyfont1,
                            ),
                          ),
                          pw.TextSpan(
                            text: ' ${solution['AboutMe_Notes']}',
                            style: pw.TextStyle(
                                color: PdfColors.grey, font: bodyfont1),
                          ),
                        ],
                      ),
                    ),),
                ],
              ),
            ),
          ],
        );
        widgets.add(widget);
      }
    }

    return widgets;
  }

  List<pw.Widget> generateSolutionsMustHaveWidgets(List<Map<String, dynamic>> dataList2,headingfont1,bodyfont1) {
    List<pw.Widget> widgets = [];

    for (var solution in dataList2) {

      if(solution["InPlace"] == "No (Must Have)") {
        pw.Widget widget = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.only(bottom: 20.0, right: 20),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.RichText(
                      maxLines: 2,
                      overflow: pw.TextOverflow.span,
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text: ' • ',
                            style: pw.TextStyle(
                              font: bodyfont1,
                            ),
                          ),
                          pw.TextSpan(
                            text: '${solution['Label']}',
                            style: pw.TextStyle(
                              font: headingfont1,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.TextSpan(
                            text: ' - ${solution['Final_description']}\n',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              font: bodyfont1,
                            ),
                          ),
                          pw.TextSpan(
                            text: ' ${solution['AboutMe_Notes']}',
                            style: pw.TextStyle(
                                color: PdfColors.grey, font: bodyfont1),
                          ),
                        ],
                      ),
                    ),),
                ],
              ),
            ),
          ],
        );
        widgets.add(widget);
      }
    }

    return widgets;
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
                                NewViewDialog(challengesData['Label'],challengesData['Description'],challengesData['Impact'],challengesData['Final_description'], challengesData['Keywords'],challengesData['tags'],challengesData['id'],challengesData,userAboutMEProvider.isEditChallengeListAdded,userAboutMEProvider.EditRecommendedChallengeAdd);
                              },
                              icon: Icon(Icons.visibility, color: Colors.blue,)
                          ),
                          SizedBox(width: 8),
                          (userAboutMEProvider.isEditChallengeListAdded[challengesData['id']] == true) ? Text(
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
                              userAboutMEProvider.EditRecommendedChallengeAdd(true, documentsss![i]);
                              toastification.show(context: context,
                                  title: Text('${challengesData['Label']} added to basket'),
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
                      Text("Impact: ",
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
                      Text("${solutionsData['Label']}",
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

                      Row(
                        children: [
                          IconButton(
                              onPressed: (){
                                NewSolViewDialog(solutionsData['Label'],solutionsData['Description'],solutionsData['Impact'],solutionsData['Final_description'], solutionsData['Keywords'],solutionsData['tags'],solutionsData['id'],solutionsData,userAboutMEProvider.isEditSolutionListAdded,userAboutMEProvider.EditRecommendedSolutionAdd);
                              },
                              icon: Icon(Icons.visibility, color: Colors.blue,)
                          ),
                          SizedBox(width: 8),

                          (userAboutMEProvider.isEditSolutionListAdded[solutionsData['id']] == true) ? Text(
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
                              userAboutMEProvider.EditRecommendedSolutionAdd(true, documentsss![i]);
                              toastification.show(context: context,
                                  title: Text('${solutionsData['Label']} added to basket'),
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
                      Text("Impact: ",
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
            
                      (challengesProvider.isLoadingMore) ?
                      Center(child: CircularProgressIndicator()) :
                      Flexible(
                        child: ListView.separated(
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          actions: [
            InkWell(
              onTap:(){
                showAddChallengesDialogBox();
              },
              child:Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                // width: MediaQuery.of(context).size.width * .2,
                width: MediaQuery.of(context).size.width * .2,

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
                    'can’t find? .. add new challenge',
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
          ],
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

  void showSolutionSelectors() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

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
            ),
          actions: [
            InkWell(
            onTap:(){
              showAddThriverDialogBox();
            },
            child:Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              // width: MediaQuery.of(context).size.width * .2,
              width: MediaQuery.of(context).size.width * .2,

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
                  'can’t find? .. add new solution',
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
          ],

        );
      },
    );
  } ///this

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

                              ProgressDialog.show(context, "Creating a Challenge", Icons.chair);

                              var defaulttext ;
                              defaulttext = q1;
                              defaulttext = defaulttext +""+ "where xxx = ${challengesOriginalDescriptionTextEditingController.text.toString()}";
                              print(defaulttext);
                              await getChatGptResponse(defaulttext);


                              var defaulttext2 ="";
                              defaulttext2 =  q2;
                              defaulttext2 =  defaulttext2 + " where yyy is "+finaltextcontroller.text.toString();

                              var defaulttextq3 ="";
                              defaulttextq3 =  q3;
                              defaulttextq3 =  defaulttextq3 + " where yyy is "+finaltextcontroller.text.toString();

                              var defaulttextq4 ="";
                              defaulttextq4 =  q4;
                              defaulttextq4 =  defaulttextq4 + " where yyy is "+finaltextcontroller.text.toString();
                              defaulttextq4 =  defaulttextq4 + " and select tags from "+"${resultString}";


                              var defaulttextq5 ="";
                              defaulttextq5 =  q5;
                              defaulttextq5 =  defaulttextq5 + " where yyy is "+finaltextcontroller.text.toString();


                              await getChatResponsenew(defaulttext2,defaulttextq3,defaulttextq4,defaulttextq5);

                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('Challenges')
                                  .orderBy('Created Date', descending: true)
                                  .limit(1)
                                  .get();
                              final abc =   querySnapshot.docs.first;
                              print("abccccc; ${abc['id']}");
                              print("abccccc; ${abc['id'].runtimeType}");
                              var ids = abc['id'] + 1;


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
                                'Description': challengesDescriptionTextEditingController.text,
                                'Source': selectedEmail,
                                'Challenge Status': "New",
                                // 'tags': challengeProvider.ProviderTags,
                                'tags': challengeProvider.ProviderTags,
                                'Created By': widget.AdminName,
                                // 'Created Date': formattedDate,
                                'Created Date': Timestamp.now(),
                                'Modified By': '',
                                'Modified Date': '',
                                // 'Original Description': originaltextEditingController.text,
                                'Original Description': challengesOriginalDescriptionTextEditingController.text,
                                'Impact': ImpactAddChallengetextcontroller.text,
                                'Final_description': finaltextcontroller.text,
                                'Category': 	"Challenge Category",
                                // 'Keywords': challengeProvider.keywordsssss,
                                'Keywords': challengeProvider.keywordsssss,
                                'Potential Strengths': "",
                                'Hidden Strengths': '',
                                'Notes': '',
                              };

                              print("ChallengesData['id']: ${ChallengesData['id']}");
                              print("ChallengesData['Label']: ${ChallengesData['Label']}");
                              print("ChallengesData Created Date: ${ChallengesData['Created Date']}");
                              print("ChallengesData Keywords: ${ChallengesData['Keywords']}");
                              print("ChallengesData tags: ${ChallengesData['tags']}");

                              _userAboutMEProvider.EditmanuallyAddChallenge(ChallengesData);

                              ProgressDialog.hide();
                              // _challengesProvider.loadDataForPage(1);
                              // _challengesProvider.setFirstpageNo();

                              toastification.show(context: context,
                                  title: Text('${ChallengesData['Label']} added to basket'),
                                  autoCloseDuration: Duration(milliseconds: 2500),
                                  alignment: Alignment.center,
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icon(Icons.check_circle, color: Colors.white,),
                                  animationDuration: Duration(milliseconds: 1000),
                                  showProgressBar: false
                              );
                              Navigator.pop(context);
                              challengesNameTextEditingController.clear();
                              // challengeProvider.keywordsssssclear();
                              // challengeProvider.ProviderTagsclear();
                              challengeProvider.selectsourceItems = null;
                              challengeProvider.selectThriversStatusItems = null;
                              finaltextcontroller.clear();
                              ImpactAddChallengetextcontroller.clear();
                              NotesAddChallengetextcontroller.clear();

                              print("ChallengesData Keywordsdfdsfs: ${ChallengesData['Keywords']}");
                              print("ChallengesData tagdfdfs: ${ChallengesData['tags']}");
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
                            child: Text("Describe challenge",
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
                                child: TextField(
                                  controller: challengesOriginalDescriptionTextEditingController,
                                  // cursorColor: primaryColorOfApp,
                                  maxLines: 3,
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
                                    contentPadding: EdgeInsets.all(20),
                                    labelText: "Describe challenge",
                                    hintText: "Describe challenge",

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
                              ProgressDialog.show(context, "Creating a Solution", Icons.chair);

                              var defaulttext ;
                              defaulttext = q1;
                              defaulttext = defaulttext +""+ "where xxx = ${SolutionsOriginalDescriptionTextEditingController.text.toString()}";
                              print(defaulttext);
                              await getChatSolGptResponse(defaulttext);


                              var defaulttext2 ="";
                              defaulttext2 =  q2;
                              defaulttext2 =  defaulttext2 + " where yyy is "+finalSolutiontextcontroller.text.toString();

                              var defaulttextq3 ="";
                              defaulttextq3 =  q3;
                              defaulttextq3 =  defaulttextq3 + " where yyy is "+finalSolutiontextcontroller.text.toString();

                              var defaulttextq4 ="";
                              defaulttextq4 =  q4;
                              defaulttextq4 =  defaulttextq4 + " where yyy is "+finalSolutiontextcontroller.text.toString();
                              defaulttextq4 =  defaulttextq4 + " and select tags from "+"${solutionresultString}";


                              var defaulttextq5 ="";
                              defaulttextq5 =  q5;
                              defaulttextq5 =  defaulttextq5 + " where yyy is "+finalSolutiontextcontroller.text.toString();


                              await getChatSolResponsenew(defaulttext2,defaulttextq3,defaulttextq4,defaulttextq5);

                              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection('Thrivers')
                                  .orderBy('Created Date', descending: true)
                                  .limit(1)
                                  .get();
                              final abc =   querySnapshot.docs.first;
                              print("abccccc; ${abc['id']}");
                              print("abccccc; ${abc['id'].runtimeType}");
                              var ids = abc['id'] + 1;
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
                                'Label': SolutionNameTextEditingController.text,
                                // 'Description': _controllerSolution.document.toPlainText(),
                                'Description':  SolutionDescriptionTextEditingController.text,
                                'Source': selectedEmail,
                                'Thirver Status': "New",
                                'tags': addKeywordProvider.ProviderTags,
                                // 'tags': [],
                                'Created By': widget.AdminName,
                                // 'Created Date': formattedDate,
                                'Created Date': Timestamp.now(),
                                'Modified By': '',
                                'Modified Date': '',
                                'Original Description': SolutionsOriginalDescriptionTextEditingController.text,
                                // 'Original Description': 'Original Description',
                                'Impact': ImpactSolutiontextcontroller.text,
                                'Final_description': finalSolutiontextcontroller.text,
                                'Category': 	"Solution Category",
                                'Keywords': addKeywordProvider.keywordsssss,
                                // 'Keywords': [],
                                'Notes': NotesSolutiontextcontroller.text,
                              };

                              print("SolutionData: ${SolutionData['Label']}");
                              print("SolutionData Created Date: ${SolutionData['Created Date']}");

                              _userAboutMEProvider.EditmanuallyAddSolution(SolutionData);

                              ProgressDialog.hide();

                              toastification.show(context: context,
                                  title: Text('${SolutionData['Label']} added to basket'),
                                  autoCloseDuration: Duration(milliseconds: 2500),
                                  alignment: Alignment.center,
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icon(Icons.check_circle, color: Colors.white,),
                                  animationDuration: Duration(milliseconds: 1000),
                                  showProgressBar: false
                              );
                              Navigator.pop(context);
                              SolutionNameTextEditingController.clear();
                              finalSolutiontextcontroller.clear();
                              ImpactSolutiontextcontroller.clear();
                              NotesSolutiontextcontroller.clear();
                              // addKeywordProvider.selectedValue.clear();
                              // addKeywordProvider.keywordsssssclear();
                              // addKeywordProvider.ProviderTagsclear();
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
                            child: Text("Describe solution",
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
                                child: TextField(
                                  controller: SolutionsOriginalDescriptionTextEditingController,
                                  // cursorColor: primaryColorOfApp,
                                  maxLines: 3,
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
                                    labelText: "Describe solution",
                                    hintText: "Describe solution",


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

                              //
                              // Padding(
                              //   /// Name
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: TextField(
                              //     controller: SolutionNameTextEditingController,
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
                              //       labelText: "Label",
                              //       hintText: "Label",
                              //
                              //       /*prefixIcon: Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Icon(Icons.question_mark_outlined,
                              //    // color: primaryColorOfApp
                              //     ),
                              // ),*/
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
                              //
                              //
                              //   /// Final Description
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: TextField(
                              //     // maxLines: null,
                              //     // maxLines: 2,
                              //     controller: finalSolutiontextcontroller,
                              //     // cursorColor: primaryColorOfApp,
                              //     inputFormatters: [
                              //       FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                              //     ],
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
                              //       labelText: "Description",
                              //       hintText: "Description",
                              //
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
                              //
                              // Padding(
                              //   /// Impact
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: TextField(
                              //     controller: ImpactSolutiontextcontroller,
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
                              //       labelText: "Impact",
                              //       hintText: "Impact",
                              //
                              //       /*prefixIcon: Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Icon(Icons.question_mark_outlined,
                              //    // color: primaryColorOfApp
                              //     ),
                              // ),*/
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
                              //
                              // Padding(
                              //   /// Notes
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: TextField(
                              //     controller: NotesSolutiontextcontroller,
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
                              //       labelText: "Notes",
                              //       hintText: "Notes",
                              //
                              //       /*prefixIcon: Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Icon(Icons.question_mark_outlined,
                              //    // color: primaryColorOfApp
                              //     ),
                              // ),*/
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
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Text("* Note: Please confirm the Solution in order to save it.",
                              //     style: TextStyle(
                              //         color: Colors.red,
                              //         fontWeight: FontWeight.w300
                              //     ),
                              //   ),
                              // ),


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

  Future<void> getChatResponsenew(q2text,q3text,q4text,q5text,) async {
    setState(() {
      _messages.insert(0, q2text);
      // _typingUsers.add(_gptChatUser);
    });
    // ProgressDialog.show(context, "Expand", Icons.search);

    List<Messages> _messagesHistory2 = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: q2text);
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
          String responseContent = gptResponse.replaceAll('"', '');

          // thriverNameTextEditingController.text = element.message!.content;
          challengesNameTextEditingController.text = responseContent;
        });
        print("response: ${element.message!.content}");
      }
    }


    List<Messages> _messagesHistory3 = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: q3text);
    }).toList();
    final request3 = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory3,
      maxToken: 200,
    );
    final response3 = await _openAI.onChatCompletion(request: request3);
    for (var element in response3!.choices) {
      if (element.message != null) {
        setState(() {
          challengesDescriptionTextEditingController.text = element.message!.content;

          // _controller = element.message!.content;
          // _controller = QuillController(
          //   document: Document()..insert(0, element.message!.content),
          //   selection: TextSelection.collapsed(offset: element.message!.content.length),
          // );

        });
        print("response: ${element.message!.content}");
      }
    }



    List<Messages> _messagesHistory4 = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: q4text);
    }).toList();
    final request4 = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory4,
      maxToken: 200,
    );
    final response4 = await _openAI.onChatCompletion(request: request4);
    for (var element in response4!.choices) {
      if (element.message != null) {
        setState(() {
          // ValueItem<String> valueItem = new ValueItem<String>(value: element.message!.content, label: '${element.message!.content}');

          // controller.options.add(valueItem);

          String gptResponse = element.message!.content;
          String responseContent = gptResponse.replaceAll(', ', ',');

          // List<String> responseList = [gptResponse];
          // print("responseListttt: ${responseList}");
          // print("responseInList: ${[element.message!.content]}");


          _challengesProvider.keywordsssss = responseContent.split(',');

          // _addKeywordProvider.keywordsssss = [gptResponse];


        });
        print("_challengesProvider.ProviderTags: ${_challengesProvider.keywordsssss}");
        print("responsesssss: ${element.message!.content}");
      }
    }


    List<Messages> _messagesHistory5 = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: q5text);
    }).toList();
    final request5 = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory5,
      maxToken: 200,
    );
    final response5 = await _openAI.onChatCompletion(request: request5);
    for (var element in response5!.choices) {
      if (element.message != null) {
        setState(() {
          // ValueItem<String> valueItem = new ValueItem<String>(value: element.message!.content, label: '${element.message!.content}');
          //
          // controller.options.add( valueItem) ;
          String gptResponse = element.message!.content;
          String responseContent = gptResponse.replaceAll(', ', ',');

          _challengesProvider.ProviderTags = responseContent.split(',');
        });
        print("_challengesProvider.ProviderTags: ${_challengesProvider.ProviderTags}");
        print("response: ${element.message!.content}");
      }
    }


    ProgressDialog.hide();

  }

  Future<void> getChatGptResponse(defaulttext) async {
    setState(() {
      _messages.insert(0, defaulttext);
      // _typingUsers.add(_gptChatUser);
    });
    // ProgressDialog.show(context, "Expand", Icons.search);

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
          String responseContent = gptResponse.replaceAll('"', '');

          // thriverNameTextEditingController.text = element.message!.content;
          finaltextcontroller.text = responseContent;
        });
        print("response: ${element.message!.content}");
      }
    }

    // ProgressDialog.hide();

  }

  Future<void> getChatSolResponsenew(q2text,q3text,q4text,q5text,) async {
    setState(() {
      _messages.insert(0, q2text);
      // _typingUsers.add(_gptChatUser);
    });
    // ProgressDialog.show(context, "Expand", Icons.search);

    List<Messages> _messagesHistory2 = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: q2text);
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
          String responseContent = gptResponse.replaceAll('"', '');

          // thriverNameTextEditingController.text = element.message!.content;
          SolutionNameTextEditingController.text = responseContent;
        });
        print("response: ${element.message!.content}");
      }
    }


    List<Messages> _messagesHistory3 = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: q3text);
    }).toList();
    final request3 = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory3,
      maxToken: 200,
    );
    final response3 = await _openAI.onChatCompletion(request: request3);
    for (var element in response3!.choices) {
      if (element.message != null) {
        setState(() {
          SolutionDescriptionTextEditingController.text = element.message!.content;

          // _controller = element.message!.content;
          // _controller = QuillController(
          //   document: Document()..insert(0, element.message!.content),
          //   selection: TextSelection.collapsed(offset: element.message!.content.length),
          // );

        });
        print("response: ${element.message!.content}");
      }
    }



    List<Messages> _messagesHistory4 = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: q4text);
    }).toList();
    final request4 = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory4,
      maxToken: 200,
    );
    final response4 = await _openAI.onChatCompletion(request: request4);
    for (var element in response4!.choices) {
      if (element.message != null) {
        setState(() {
          // ValueItem<String> valueItem = new ValueItem<String>(value: element.message!.content, label: '${element.message!.content}');

          // controller.options.add(valueItem);

          String gptResponse = element.message!.content;
          String responseContent = gptResponse.replaceAll(', ', ',');

          // List<String> responseList = [gptResponse];
          // print("responseListttt: ${responseList}");
          // print("responseInList: ${[element.message!.content]}");


          _addKeywordProvider.keywordsssss = responseContent.split(',');

          // _addKeywordProvider.keywordsssss = [gptResponse];


        });
        print("_addKeywordProvider.ProviderTags: ${_challengesProvider.keywordsssss}");
        print("responsesssss: ${element.message!.content}");
      }
    }


    List<Messages> _messagesHistory5 = _messages.reversed.map((m) {
      return Messages(role: Role.user, content: q5text);
    }).toList();
    final request5 = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory5,
      maxToken: 200,
    );
    final response5 = await _openAI.onChatCompletion(request: request5);
    for (var element in response5!.choices) {
      if (element.message != null) {
        setState(() {
          // ValueItem<String> valueItem = new ValueItem<String>(value: element.message!.content, label: '${element.message!.content}');
          //
          // controller.options.add( valueItem) ;
          String gptResponse = element.message!.content;
          String responseContent = gptResponse.replaceAll(', ', ',');

          _addKeywordProvider.ProviderTags = responseContent.split(',');
        });
        print("_addKeywordProvider.ProviderTags: ${_addKeywordProvider.ProviderTags}");
        print("response: ${element.message!.content}");
      }
    }
    ProgressDialog.hide();
  }

  Future<void> getChatSolGptResponse(defaulttext) async {
    setState(() {
      _messages.insert(0, defaulttext);
      // _typingUsers.add(_gptChatUser);
    });
    // ProgressDialog.show(context, "Expand", Icons.search);

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
          String responseContent = gptResponse.replaceAll('"', '');

          // thriverNameTextEditingController.text = element.message!.content;
          finalSolutiontextcontroller.text = responseContent;
        });
        print("response: ${element.message!.content}");
      }
    }

    // ProgressDialog.hide();

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
                          NewViewDialog(documents![i]['Label'],documents![i]['Description'],documents![i]['Impact'],documents![i]['Final_description'], documents![i]['Keywords'],documents![i]['tags'],documents![i]['id'],documents![i], userAboutMEProvider.isEditChallengeListAdded,userAboutMEProvider.EditRecommendedChallengeAdd);
                        },
                        icon: Icon(Icons.visibility, color: Colors.blue,)
                    ),
                    SizedBox(width: 8),
                    (userAboutMEProvider.isEditChallengeListAdded[documents![i]['id']] == true) ? Text(
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
                        userAboutMEProvider.EditRecommendedChallengeAdd(true, documents![i]);
                        toastification.show(context: context,
                            title: Text('${documents![i]['Label']} added to basket'),
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
                      Text(documentsss![i]['Label'],style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis),
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
                          NewSolViewDialog(documentsss![i]['Label'],documentsss![i]['Description'],documentsss![i]['Impact'],documentsss![i]['Final_description'], documentsss![i]['Keywords'],documentsss![i]['tags'],documentsss![i]['id'],documentsss![i], userAboutMEProvider.isEditSolutionListAdded,userAboutMEProvider.EditRecommendedSolutionAdd);
                        },
                        icon: Icon(Icons.visibility, color: Colors.blue,)
                    ),
                    SizedBox(width: 8),
                    (userAboutMEProvider.isEditSolutionListAdded[documentsss![i]['id']] == true) ? Text(
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
                        userAboutMEProvider.EditRecommendedSolutionAdd(true,documentsss![i]);
                        toastification.show(context: context,
                            title: Text('${documentsss![i]['Label']} added to basket'),
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


  String formatTimestamp(Timestamp timestamp) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd, HH:mm:ss');
    DateTime dateTime = timestamp.toDate();
    return formatter.format(dateTime);
  }

  void showconfirmChallengeDialogBox(Id,label,description,source,ChallengeStatus,tags,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,OriginalDescription,
      Impact,Final_description,Category ,Keywords ,PotentialStrengths, HiddenStrengths, index, listname, Notes,Attachment){

    print("CreatedDate: $CreatedDate");

    // DateTime dateTime = CreatedDate.toDate();


    // final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");

    // final DateFormat formatter = DateFormat('yyyy-MM-dd, HH:mm:ss');
    //
    //
    //
    // var formattedDate = formatter.format(CreatedDate);

    String createdDate = "";

    if (CreatedDate is Timestamp) {
      createdDate = formatTimestamp(CreatedDate);
    } else if (CreatedDate != null) {
      createdDate = CreatedDate.toString();
    }

    NotesController.text = Notes.toString()== "" || Notes.toString().isEmpty ? Impact.toString() : Notes;

    print("Inside showconfirmrDialogBox");
    print("Id: CH0$Id");
    print("label: $label");
    print("description: $description");
    print("source: $source");
    print("Status: $ChallengeStatus");
    print("tags: ${tags}");
    print("CreatedBy: $CreatedBy");
    print("CreatedDate: $createdDate");
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
    print("Attachment: $Attachment");
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
                                  'Created Date': createdDate,
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
                                  'Attachment_link': userAboutMEProvider.downloadURL==null ? Attachment != null ? Attachment : "" : userAboutMEProvider.downloadURL,
                                  'Attachment': userAboutMEProvider.aadhar== null ? Attachment != null ? Attachment : "" : userAboutMEProvider.aadhar
                                };

                                print("solutionData['Attachment']: ${solutionData['Attachment']}");
                                print("solutionData['Attachment_link']: ${solutionData['Attachment_link']}");

                                Map<String, dynamic> challengeData = {
                                  'id': Id,
                                  'Label': label,
                                  'Description': description,
                                  'Source': source,
                                  'Challenge Status': ChallengeStatus,
                                  'tags': tags,
                                  'Created By': CreatedBy,
                                  'Created Date': createdDate,
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
                                    'Created Date': createdDate,
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


                                print("index: $index");


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
                                // userAboutMEProvider.selectedPriority = null;
                                // userAboutMEProvider.selectedProvider = null;
                                // userAboutMEProvider.selectedInPlace = null;
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
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                child: Text("Impact on me:",
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

                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                    child: Text("Relevant attachments :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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
                                child: Text("${userAboutMEProvider.aadhar== null ? Attachment != null ? Attachment : "" : userAboutMEProvider.aadhar}", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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

  void showEditconfirmChallengeDialogBox(Id,label,description,source,ChallengeStatus,tags,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,OriginalDescription,
      Impact,Final_description,Category ,Keywords ,PotentialStrengths, HiddenStrengths, index, listname, Notes) {

    print("CreatedDate: $CreatedDate");


    NotesController.text = Notes;

    print("Inside showconfirmrDialogBox");
    print("Id: CH0$Id");
    print("label: $label");
    print("description: $description");
    print("source: $source");
    print("Status: $ChallengeStatus");
    print("tags: ${tags}");
    print("CreatedBy: $CreatedBy");
    print("CreatedDate: $CreatedDate");
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


                                int indexToUpdate = challengesList.indexWhere((element) => element['id'] == Id);

                                if (indexToUpdate != -1) {
                                  // Create a new solutionData to update the existing one
                                  Map<String, dynamic> updatedSolutionData = {
                                    'id': Id,
                                    'Label': label,
                                    'Description': description,
                                    'Source': source,
                                    'Challenge Status': ChallengeStatus,
                                    'tags': tags,
                                    'Created By': CreatedBy,
                                    'Created Date': CreatedDate,
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
                                    'Attachment_link': userAboutMEProvider.downloadURL == null ? null : userAboutMEProvider.downloadURL,
                                    'Attachment': userAboutMEProvider.aadhar == null ? "" : userAboutMEProvider.aadhar
                                  };

                                  // challengesList[indexToUpdate] = updatedSolutionData;
                                  userAboutMEProvider.updateconfirmList(challengesList,indexToUpdate,updatedSolutionData);
                                  userAboutMEProvider.updateconfirmList(_previewProvider.PreviewChallengesList,indexToUpdate,updatedSolutionData);
                                } else {
                                  print("Id not found in challengesList.");
                                }



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
                                child: Text("Impact on me: ",
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
                                    child: Text("Relevant attachments :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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
      Impact,Final_description,Category ,Keywords ,PotentialStrengths, HiddenStrengths, index, listname,Notes,Attachment, InPlace, Provider){

    // DateTime dateTime = CreatedDate.toDate();
    //
    //
    // final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");
    //
    //
    // String formattedDate = formatter.format(dateTime);

    String createdDate = "";

    if (CreatedDate is Timestamp) {
      createdDate = formatTimestamp(CreatedDate);
    } else if (CreatedDate != null) {
      createdDate = CreatedDate.toString();
    }

    NotesController.text = Notes.toString()== "" || Notes.toString().isEmpty ? Impact.toString() : Notes;
    _userAboutMEProvider.selectedProvider = Provider;
    _userAboutMEProvider.selectedInPlace = InPlace;

    print("Inside showconfirmrDialogBox");
    print("Id: $Id");
    print("label: $label");
    print("description: $description");
    print("source: $source");
    print("Status: $ChallengeStatus");
    print("tags: ${tags}");
    print("CreatedBy: $CreatedBy");
    print("CreatedDate: $createdDate");
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
    print("Attachment: $Attachment");
    print("InPlace: $InPlace");
    print("Provider: $Provider");
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
                                  'Created Date': createdDate,
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
                                  'Attachment_link': userAboutMEProvider.downloadURL==null ? Attachment != null ? Attachment : "" : userAboutMEProvider.downloadURL,
                                  'Attachment': userAboutMEProvider.aadhar== null ? Attachment != null ? Attachment : "" : userAboutMEProvider.aadhar
                                  // 'confirmed': false, // Add a 'confirmed' field
                                };


                                Map<String, dynamic> solutionDataSaved = {
                                  'id': Id,
                                  'Label': label,
                                  'Description': description,
                                  'Source': source,
                                  'Thirver Status': ChallengeStatus,
                                  'tags': tags,
                                  'Created By': CreatedBy,
                                  'Created Date': createdDate,
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
                                    'Label': label,
                                    'Description': description,
                                    'Source': source,
                                    'Challenge Status': ChallengeStatus,
                                    'tags': tags,
                                    'Created By': CreatedBy,
                                    'Created Date': createdDate,
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
                                // _previewProvider.PreviewSolutionList.add(solutionData);
                                userAboutMEProvider.updatenewprovider(solutionData["Provider"],solutionData["id"]);
                                userAboutMEProvider.updatenewInplace(solutionData["InPlace"],solutionData["id"]);

                                if(_userAboutMEProvider.selectedProvider == "My Responsibilty"){
                                  _previewProvider.PreviewSolutionMyResposibilty.add(solutionData);
                                }
                                if(_userAboutMEProvider.selectedInPlace == "Yes (Still Needed)"){
                                  _previewProvider.PreviewSolutionStillNeeded.add(solutionData);}
                                if(_userAboutMEProvider.selectedInPlace == "Yes (Not Needed Anymore)"){
                                  _previewProvider.PreviewSolutionNotNeededAnyMore.add(solutionData);}
                                if(_userAboutMEProvider.selectedInPlace == "No (Nice to have)"){
                                  _previewProvider.PreviewSolutionNiceToHave.add(solutionData);}
                                if(_userAboutMEProvider.selectedInPlace == "No (Must Have)"){
                                  _previewProvider.PreviewSolutionMustHave.add(solutionData);}

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

                              (userAboutMEProvider.selectedProvider=="Request of my employer") ?   Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                child: Text("In Place :",
                                    style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,
                                        fontWeight: FontWeight.w600)),
                              ) : Container(),

                              (userAboutMEProvider.selectedProvider=="Request of my employer") ?   Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: userAboutMEProvider.InPlace.map((String value) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width * .3,
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


                              SizedBox(height: 10,),

                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                                    child: Text("Relevant attachments :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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
                                child: Text("${userAboutMEProvider.aadhar== null ? Attachment != null ? Attachment : "" : userAboutMEProvider.aadhar}", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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

  void showEditconfirmSolutionsDialogBox(Id,label,description,source,ChallengeStatus,tags,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,OriginalDescription,
      Impact,Final_description,Category ,Keywords ,PotentialStrengths, HiddenStrengths, listname,Notes,Provider,InPlace)  {


    NotesController.text = Notes;
    _userAboutMEProvider.selectedProvider = Provider;
    _userAboutMEProvider.selectedInPlace = InPlace;

    print("Inside showconfirmrDialogBox");
    print("pop up Id: $Id");
    print("label: $label");
    print("Provider: $Provider");
    print("InPlace: $InPlace");

    // print("description: $description");
    // print("source: $source");
    // print("Status: $ChallengeStatus");
    // print("tags: ${tags}");
    // print("CreatedBy: $CreatedBy");
    // print("CreatedDate: $CreatedDate");
    // print("ModifiedBy: $ModifiedBy");
    // print("ModifiedDate: $ModifiedDate");
    // print("OriginalDescription: $OriginalDescription");
    // print("Impact: $Impact");
    // print("Final_description: $Final_description");
    // print("Category: $Category");
    // print("Keywords: $Keywords");
    // print("PotentialStrengths: $PotentialStrengths");
    // print("HiddenStrengths: $HiddenStrengths");
    // print("Notes: $Notes");
    // // print("index: $index");
    // print("listname: $listname");

    // print("solutionsList before edit: $solutionsList");
    // print("solutionsList before edit: ${solutionsList.length}");

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

                              {
                                ProgressDialog.show(context, "Confirming", Icons.check_circle_outline);

                                if(userAboutMEProvider.aadhar != null) {
                                  await userAboutMEProvider.uploadFile(
                                      userAboutMEProvider.fileBytes,
                                      userAboutMEProvider.aadhar);
                                }



                                int indexToUpdate = solutionsList.indexWhere((element) => element['id'] == Id);

                                if (indexToUpdate != -1) {
                                  Map<String, dynamic> solutionData = {
                                    'id': Id,
                                    'Label': label,
                                    'Description': description,
                                    'Source': source,
                                    'Challenge Status': ChallengeStatus,
                                    'tags': tags,
                                    'Created By': CreatedBy,
                                    'Created Date': CreatedDate,
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
                                    'InPlace': userAboutMEProvider.selectedProvider == 'My Responsibilty' ? null : userAboutMEProvider.selectedInPlace,
                                    'Attachment_link': userAboutMEProvider.downloadURL == null ? null : userAboutMEProvider.downloadURL,
                                    'Attachment': userAboutMEProvider.aadhar == null ? "-" : userAboutMEProvider.aadhar
                                  };

                                  if(userAboutMEProvider.selectedProvider == 'My Responsibilty'){

                                    // e

                                    userAboutMEProvider.updateEditConfirmSolution18(Id,_previewProvider.PreviewSolutionMyResposibilty);
                                    userAboutMEProvider.updateEditConfirmSolution28(Id,_previewProvider.PreviewSolutionStillNeeded);
                                    userAboutMEProvider.updateEditConfirmSolution38(Id,_previewProvider.PreviewSolutionNotNeededAnyMore);
                                    userAboutMEProvider.updateEditConfirmSolution48(Id,_previewProvider.PreviewSolutionNiceToHave);
                                    userAboutMEProvider.updateEditConfirmSolution58(Id,_previewProvider.PreviewSolutionMustHave);

                                    userAboutMEProvider.updateInplaceValue(userAboutMEProvider.selectedInPlace);

                                    // if(solutionData['id']==Id){
                                    //   _previewProvider.PreviewSolutionMyResposibilty.
                                    // }

                              int index = _previewProvider.PreviewSolutionMyResposibilty.indexWhere((solution) => solution['id'] == Id);

                              if (index != -1) {
                                print("inside replace My Resposibilty");
                                print("index: $index");
                                // _previewProvider.PreviewSolutionMyResposibilty[index] = solutionData;
                                _previewProvider.PreviewSolutionMyResposibilty.removeAt(index); // Remove the old solution
                                _previewProvider.PreviewSolutionMyResposibilty.add(solutionData);
                              }

                              else
                                  _previewProvider.PreviewSolutionMyResposibilty.add(solutionData);
                                  print("Add in My Resposibilty");
                                  print(_previewProvider.PreviewSolutionMyResposibilty.length);
                                  userAboutMEProvider.updateconfirmList(solutionsList, indexToUpdate, solutionData);
                                  print("Update solutionsList My Resposibilty");

                              }

                                 else if(userAboutMEProvider.selectedInPlace == "No (Must Have)"){

                                    userAboutMEProvider.updateEditConfirmSolution18(Id,_previewProvider.PreviewSolutionMyResposibilty);
                                    userAboutMEProvider.updateEditConfirmSolution28(Id,_previewProvider.PreviewSolutionStillNeeded);
                                    userAboutMEProvider.updateEditConfirmSolution38(Id,_previewProvider.PreviewSolutionNotNeededAnyMore);
                                    userAboutMEProvider.updateEditConfirmSolution48(Id,_previewProvider.PreviewSolutionNiceToHave);
                                    userAboutMEProvider.updateEditConfirmSolution58(Id,_previewProvider.PreviewSolutionMustHave);


                                    int index = _previewProvider.PreviewSolutionMustHave.indexWhere((solution) => solution['id'] == Id);
                                    if (index != -1) {
                                      print("inside replace No (Must Have)");
                                      // _previewProvider.PreviewSolutionMustHave[index] = solutionData;
                                      _previewProvider.PreviewSolutionMustHave.removeAt(index);
                                      _previewProvider.PreviewSolutionMustHave.add(solutionData);
                                    }
                                    else
                                  _previewProvider.PreviewSolutionMustHave.add(solutionData);
                                  print("Add in No (Must Have)");
                                  userAboutMEProvider.updateconfirmList(solutionsList, indexToUpdate, solutionData);
                                  print("Update solutionsList No (Must Have)");
                              }

                                 else if(userAboutMEProvider.selectedInPlace == "Yes (Still Needed)"){
                                    userAboutMEProvider.updateEditConfirmSolution18(Id,_previewProvider.PreviewSolutionMyResposibilty);
                                    userAboutMEProvider.updateEditConfirmSolution28(Id,_previewProvider.PreviewSolutionStillNeeded);
                                    userAboutMEProvider.updateEditConfirmSolution38(Id,_previewProvider.PreviewSolutionNotNeededAnyMore);
                                    userAboutMEProvider.updateEditConfirmSolution48(Id,_previewProvider.PreviewSolutionNiceToHave);
                                    userAboutMEProvider.updateEditConfirmSolution58(Id,_previewProvider.PreviewSolutionMustHave);

                                    int index = _previewProvider.PreviewSolutionStillNeeded.indexWhere((solution) => solution['id'] == Id);
                                    if (index != -1) {
                                      print("inside replace Yes (Still Needed)");
                                      // _previewProvider.PreviewSolutionStillNeeded[index] = solutionData;
                                      _previewProvider.PreviewSolutionStillNeeded.removeAt(index); // Remove the old solution
                                      _previewProvider.PreviewSolutionStillNeeded.add(solutionData);
                                    }
                                    else
                                  _previewProvider.PreviewSolutionStillNeeded.add(solutionData);
                                  print("Add in Yes (Still Needed)");
                                  userAboutMEProvider.updateconfirmList(solutionsList, indexToUpdate, solutionData);
                                  print("Update solutionsList Yes (Still Needed)");
                              }

                                 else if(userAboutMEProvider.selectedInPlace == "Yes (Not Needed Anymore)"){
                                    userAboutMEProvider.updateEditConfirmSolution18(Id,_previewProvider.PreviewSolutionMyResposibilty);
                                    userAboutMEProvider.updateEditConfirmSolution28(Id,_previewProvider.PreviewSolutionStillNeeded);
                                    userAboutMEProvider.updateEditConfirmSolution38(Id,_previewProvider.PreviewSolutionNotNeededAnyMore);
                                    userAboutMEProvider.updateEditConfirmSolution48(Id,_previewProvider.PreviewSolutionNiceToHave);
                                    userAboutMEProvider.updateEditConfirmSolution58(Id,_previewProvider.PreviewSolutionMustHave);

                                    int index = _previewProvider.PreviewSolutionNotNeededAnyMore.indexWhere((solution) => solution['id'] == Id);
                                    if (index != -1) {
                                      print("inside replace Yes (Not Needed Anymore)");
                                      // _previewProvider.PreviewSolutionNotNeededAnyMore[index] = solutionData;
                                      _previewProvider.PreviewSolutionNotNeededAnyMore.removeAt(index); // Remove the old solution
                                      _previewProvider.PreviewSolutionNotNeededAnyMore.add(solutionData);
                                    }
                                    else
                                  _previewProvider.PreviewSolutionNotNeededAnyMore.add(solutionData);
                                  print("Add in Yes (Not Needed Anymore)");
                                  userAboutMEProvider.updateconfirmList(solutionsList, indexToUpdate, solutionData);
                                  print("Update solutionsList Yes (Not Needed Anymore)");
                              }

                                 else if(userAboutMEProvider.selectedInPlace == "No (Nice to have)"){
                                    userAboutMEProvider.updateEditConfirmSolution18(Id,_previewProvider.PreviewSolutionMyResposibilty);
                                    userAboutMEProvider.updateEditConfirmSolution28(Id,_previewProvider.PreviewSolutionStillNeeded);
                                    userAboutMEProvider.updateEditConfirmSolution38(Id,_previewProvider.PreviewSolutionNotNeededAnyMore);
                                    userAboutMEProvider.updateEditConfirmSolution48(Id,_previewProvider.PreviewSolutionNiceToHave);
                                    userAboutMEProvider.updateEditConfirmSolution58(Id,_previewProvider.PreviewSolutionMustHave);

                                    int index = _previewProvider.PreviewSolutionNiceToHave.indexWhere((solution) => solution['id'] == Id);
                                    if (index != -1) {
                                      print("inside replace No (Nice to have)");
                                      // _previewProvider.PreviewSolutionNiceToHave[index] = solutionData;
                                      _previewProvider.PreviewSolutionNiceToHave.removeAt(index); // Remove the old solution
                                      _previewProvider.PreviewSolutionNiceToHave.add(solutionData);
                                      // userAboutMEProvider.updateconfirmList(_previewProvider.PreviewSolutionNiceToHave, index, solutionData);

                                    }
                                    else
                                  _previewProvider.PreviewSolutionNiceToHave.add(solutionData);
                                  print("Add in No (Nice to have)");
                                  userAboutMEProvider.updateconfirmList(solutionsList, indexToUpdate, solutionData);
                                  print("Update solutionsList No (Nice to have)");
                              }


                                  // print("solutionsList after edit: $solutionsList");
                                  // print("solutionsList length after edit: ${solutionsList.length}");
                                  // userAboutMEProvider.updateconfirmList(solutionsList, indexToUpdate, solutionData);
                                  userAboutMEProvider.updatenewprovider(solutionData["Provider"], solutionData["id"]);
                                  userAboutMEProvider.updatenewInplace(solutionData["InPlace"], solutionData["id"]);
                                }

                                else {
                                  print("Id not found in solutionData.");
                                }




                                ProgressDialog.hide();



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
                                    width: MediaQuery.of(context).size.width * .24,
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
                                    width: MediaQuery.of(context).size.width * .3,
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
                                    child: Text("Relevant attachments :", style: GoogleFonts.montserrat(textStyle: Theme.of(context).textTheme.titleSmall,)),
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


  void NewViewDialog(Label, Description, Impact, FinalDescription, keywords, tags, insideId,document,isTrueOrFalse,AddButton,){


    final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");

    // String formattedDate = formatter.format(dateTime);

    // _challengesProvider.addkeywordsList(keywords);
    // _challengesProvider.addProviderEditTagsList(tags);

    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
            child:   Consumer<UserAboutMEProvider>(
                builder: (c,userAboutMEProvider, _){
                  if(userAboutMEProvider.editpreviewname != null || userAboutMEProvider.editpreviewDescription != null ||userAboutMEProvider.editpreviewFinalDescription != null ||
                      userAboutMEProvider.editpreviewId != null ||userAboutMEProvider.editpreviewImpact != null ||userAboutMEProvider.editpreviewKeywordssss.isNotEmpty ||
                      userAboutMEProvider.editpreviewtags.isNotEmpty || userAboutMEProvider.editpreview !=null ){
                    Label = userAboutMEProvider.editpreviewname;
                    Description = userAboutMEProvider.editpreviewDescription;
                    FinalDescription = userAboutMEProvider.editpreviewFinalDescription;
                    insideId = userAboutMEProvider.editpreviewId;
                    Impact = userAboutMEProvider.editpreviewImpact;
                    keywords = userAboutMEProvider.editpreviewKeywordssss;
                    tags = userAboutMEProvider.editpreviewtags;
                    document = userAboutMEProvider.editpreview;
                  }
                  _challengesProvider.addkeywordsList(keywords);
                  _challengesProvider.addProviderEditTagsList(tags);

                  return AlertDialog(
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
                                userAboutMEProvider.editpreviewname = null;
                                userAboutMEProvider.editpreviewDescription = null;
                                userAboutMEProvider.editpreviewFinalDescription = null;
                                userAboutMEProvider.editpreviewId = null;
                                userAboutMEProvider.editpreviewImpact = null;
                                userAboutMEProvider.editpreviewKeywordssss.clear();
                                userAboutMEProvider.editpreviewtags.clear();
                                userAboutMEProvider.editpreview = null;
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
                                flex: 2,
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
                                          (Label==""|| Label==null) ? Container() : Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Text("Label: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                              Text(Label,
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
                                                                if(_tabController.index == 3){
                                                                  searchChallengescontroller.text = item;
                                                                  _challengesProvider.loadDataForPageSearchFilter(item);
                                                                  // Navigator.pop(context);
                                                                  showChallengesSelector();
                                                                }
                                                                if(_tabController.index == 4){
                                                                  searchbyCatcontroller.text = item;
                                                                  _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString());
                                                                  // Navigator.pop(context);
                                                                  showSolutionSelectors();
                                                                }
                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                // width: 200,
                                                                margin: EdgeInsets.only(bottom: 10),
                                                                padding: EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    // color: Color(0xFF00ACC1)
                                                                    color: Colors.grey
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(item, style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: 10,
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
                                                                if(_tabController.index == 3){
                                                                  searchChallengescontroller.text = item;
                                                                  _challengesProvider.loadDataForPageSearchFilter(item);
                                                                  // Navigator.pop(context);
                                                                  showChallengesSelector();
                                                                }
                                                                if(_tabController.index == 4){
                                                                  searchbyCatcontroller.text = item;
                                                                  _addKeywordProvider.loadDataForPageSearchFilter(searchbyCatcontroller.text.toString());
                                                                  // Navigator.pop(context);
                                                                  showSolutionSelectors();
                                                                }

                                                              },
                                                              child: Container(
                                                                height: 30,
                                                                // width: 200,
                                                                padding: EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    // color: Colors.teal
                                                                    color: Colors.grey
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(item, style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: 10,
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
                                                        child: Text("Related challenges (${relatedChallenges?.length}):",
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
                                                                border: Border.all(color: Colors.orange),
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

                                                                        Row(
                                                                          children: [
                                                                            IconButton(
                                                                                onPressed: (){
                                                                                  userAboutMEProvider.updateEditChallengePreview(
                                                                                      challengesData['Label'],
                                                                                      challengesData['Description'],
                                                                                      challengesData['Final_Description'],
                                                                                      challengesData['Impact'],
                                                                                      challengesData['Keywords'],
                                                                                      challengesData['tags'],
                                                                                      challengesData['id'],
                                                                                      isTrueOrFalse,
                                                                                      challengesData
                                                                                  );
                                                                                },
                                                                                icon: Icon(Icons.visibility, color: Colors.blue,)
                                                                            ),
                                                                            SizedBox(width: 5,),
                                                                            (userAboutMEProvider.isEditChallengeListAdded[challengesData['id']] == true) ? Text(
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
                                                                                userAboutMEProvider.EditRecommendedChallengeAdd(true, relatedChallenges![i]);
                                                                                toastification.show(context: context,
                                                                                    title: Text('${challengesData['Label']} added to basket'),
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
                                                                            ),
                                                                          ],
                                                                        ),

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
                                          width: MediaQuery.of(context).size.width,
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
                                                      child: Text("Suggested solutions (${relatedSolutions?.length}):",
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
                                                              border: Border.all(color: Colors.green),
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
                                                                        child: Text("${solutionData['Label']}",
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
                                                                      Row(
                                                                        children: [
                                                                          IconButton(
                                                                              onPressed: (){
                                                                                userAboutMEProvider.updateEditSolutionPreview(
                                                                                    solutionData['Label'],
                                                                                    solutionData['Description'],
                                                                                    solutionData['Final_Description'],
                                                                                    solutionData['Impact'],
                                                                                    solutionData['Keywords'],
                                                                                    solutionData['tags'],
                                                                                    solutionData['id'],
                                                                                    isTrueOrFalse,
                                                                                    solutionData
                                                                                );
                                                                              },

                                                                              icon: Icon(Icons.visibility, color: Colors.blue,)
                                                                          ),
                                                                          SizedBox(width: 5,),

                                                                          (userAboutMEProvider.isEditSolutionListAdded[solutionData['id']] == true) ? Text(
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
                                                                              userAboutMEProvider.EditRecommendedSolutionAdd(true, relatedSolutions![i]);
                                                                              toastification.show(context: context,
                                                                                  title: Text('${solutionData['Label']} added to basket'),
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
                                                                          ),
                                                                        ],
                                                                      )
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
                                        // SizedBox(height: 20,),
                                        // Container(
                                        //   height: 170 ,
                                        //   child: FutureBuilder(
                                        //     future: getRelatedChallenges(tags, keywords),
                                        //     builder: (context, snapshot) {
                                        //       if (snapshot.connectionState == ConnectionState.waiting) {
                                        //         return Container(
                                        //             width: 330,
                                        //             child: Container(
                                        //                 height: 20, // Adjust the height as needed
                                        //                 width: 20,
                                        //                 child: Center(
                                        //                     child: CircularProgressIndicator()
                                        //                 )
                                        //             )
                                        //         ); // Display a loading indicator while fetching data
                                        //       } else if (snapshot.hasError) {
                                        //         return Text('Error: ${snapshot.error}');
                                        //       } else {
                                        //         // List<DocumentSnapshot<Object?>>? relatedSolutions = snapshot.data;
                                        //         List<DocumentSnapshot<Map<String, dynamic>>>? relatedChallenges = snapshot.data?.cast<DocumentSnapshot<Map<String, dynamic>>>();
                                        //
                                        //         // print("relatedSolutions: $relatedSolutions");
                                        //
                                        //         return Column(
                                        //           mainAxisAlignment: MainAxisAlignment.start,
                                        //           crossAxisAlignment: CrossAxisAlignment.start,
                                        //           children: [
                                        //             Padding(
                                        //               padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                        //               child: Text("Related Challenges (${relatedChallenges?.length})",
                                        //                   style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                        //                       fontSize: 20,
                                        //                       color: Colors.black)
                                        //               ),
                                        //             ),
                                        //             Expanded(
                                        //               child: ListView.builder(
                                        //                 scrollDirection: Axis.horizontal,
                                        //                 shrinkWrap: true,
                                        //                 itemCount: relatedChallenges?.length,
                                        //                 itemBuilder: (c, i) {
                                        //                   // relatedSolutionlength = relatedChallenges?.length;
                                        //                   // print("relatedSolutionlength: $relatedSolutionlength");
                                        //                   var challengesData = relatedChallenges?[i].data() as Map<String, dynamic>;
                                        //                   print("solutionData: ${challengesData}");
                                        //                   return Container(
                                        //                     margin: EdgeInsets.symmetric(horizontal: 15),
                                        //                     padding: EdgeInsets.all(12),
                                        //                     width: 330,
                                        //                     decoration: BoxDecoration(
                                        //                       border: Border.all(color: Colors.orange),
                                        //                       borderRadius: BorderRadius.circular(20),
                                        //                     ),
                                        //                     child: SingleChildScrollView(
                                        //                       child: Column(
                                        //                         mainAxisAlignment: MainAxisAlignment.start,
                                        //                         crossAxisAlignment: CrossAxisAlignment.start,
                                        //                         children: [
                                        //                           Row(
                                        //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                             crossAxisAlignment: CrossAxisAlignment.start,
                                        //                             children: [
                                        //                               Flexible(
                                        //                                 child: Text("${challengesData['Label']}",
                                        //                                     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                        //                                         fontSize: 18,
                                        //                                         color: Colors.black)),
                                        //                               ),
                                        //                               // InkWell(
                                        //                               //   onTap: (){
                                        //                               //     _userAboutMEProvider.isRecommendedAddedChallenge(true,  relatedChallenges![i]);
                                        //                               //   },
                                        //                               //   child: Container(
                                        //                               //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                        //                               //     width: MediaQuery.of(context).size.width * .05,
                                        //                               //     // width: MediaQuery.of(context).size.width * .15,
                                        //                               //
                                        //                               //     // height: 60,
                                        //                               //     decoration: BoxDecoration(
                                        //                               //       color:Colors.blue ,
                                        //                               //       border: Border.all(
                                        //                               //           color:Colors.blue ,
                                        //                               //           width: 1.0),
                                        //                               //       borderRadius: BorderRadius.circular(8.0),
                                        //                               //     ),
                                        //                               //     child: Center(
                                        //                               //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                        //                               //       child: Text(
                                        //                               //         'Add',
                                        //                               //         style: GoogleFonts.montserrat(
                                        //                               //           textStyle:
                                        //                               //           Theme
                                        //                               //               .of(context)
                                        //                               //               .textTheme
                                        //                               //               .titleSmall,
                                        //                               //           fontWeight: FontWeight.bold,
                                        //                               //           color:Colors.white ,
                                        //                               //         ),
                                        //                               //       ),
                                        //                               //     ),
                                        //                               //   ),
                                        //                               // ),
                                        //
                                        //                               Row(
                                        //                                 children: [
                                        //                                   IconButton(
                                        //                                       onPressed: (){
                                        //                                         userAboutMEProvider.updateEditChallengePreview(
                                        //                                             challengesData['Label'],
                                        //                                             challengesData['Description'],
                                        //                                             challengesData['Final_Description'],
                                        //                                             challengesData['Impact'],
                                        //                                             challengesData['Keywords'],
                                        //                                             challengesData['tags'],
                                        //                                             challengesData['id'],
                                        //                                             isTrueOrFalse,
                                        //                                             challengesData
                                        //                                         );
                                        //                                       },
                                        //                                       icon: Icon(Icons.visibility, color: Colors.orange,)
                                        //                                   ),
                                        //                                   SizedBox(width: 5,),
                                        //                                   (userAboutMEProvider.isEditChallengeListAdded[challengesData['id']] == true) ? Text(
                                        //                                             'Added',
                                        //                                             style: GoogleFonts.montserrat(
                                        //                                               textStyle:
                                        //                                               Theme
                                        //                                                   .of(context)
                                        //                                                   .textTheme
                                        //                                                   .titleSmall,
                                        //                                               fontStyle: FontStyle.italic,
                                        //                                               color:Colors.orange ,
                                        //                                             ),
                                        //                                           ) : InkWell(
                                        //                                             onTap: (){
                                        //                                               // userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                        //                                               userAboutMEProvider.EditRecommendedChallengeAdd(true, relatedChallenges![i]);
                                        //                                               toastification.show(context: context,
                                        //                                                   title: Text('${challengesData['Label']} added to basket'),
                                        //                                                   autoCloseDuration: Duration(milliseconds: 2500),
                                        //                                                   alignment: Alignment.center,
                                        //                                                   backgroundColor: Colors.orange,
                                        //                                                   foregroundColor: Colors.white,
                                        //                                                   icon: Icon(Icons.check_circle, color: Colors.white,),
                                        //                                                   animationDuration: Duration(milliseconds: 1000),
                                        //                                                   showProgressBar: false
                                        //                                               );
                                        //
                                        //                                             },
                                        //                                             child: Container(
                                        //                                               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                        //                                               width: MediaQuery.of(context).size.width * .05,
                                        //                                               // width: MediaQuery.of(context).size.width * .15,
                                        //
                                        //                                               // height: 60,
                                        //                                               decoration: BoxDecoration(
                                        //                                                 color:Colors.orange ,
                                        //                                                 border: Border.all(
                                        //                                                     color:Colors.orange ,
                                        //                                                     width: 1.0),
                                        //                                                 borderRadius: BorderRadius.circular(8.0),
                                        //                                               ),
                                        //                                               child: Center(
                                        //                                                 // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                        //                                                 child: Text(
                                        //                                                   'Add',
                                        //                                                   style: GoogleFonts.montserrat(
                                        //                                                     textStyle:
                                        //                                                     Theme
                                        //                                                         .of(context)
                                        //                                                         .textTheme
                                        //                                                         .titleSmall,
                                        //                                                     fontWeight: FontWeight.bold,
                                        //                                                     color:Colors.white ,
                                        //                                                   ),
                                        //                                                 ),
                                        //                                               ),
                                        //                                             ),
                                        //                                           ),
                                        //                                 ],
                                        //                               ),
                                        //
                                        //                             ],
                                        //                           ),
                                        //                           SizedBox(height: 5,),
                                        //                           // Text("${challengesData['Label']}",
                                        //                           //     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                        //                           //         fontSize: 18,
                                        //                           //         color: Colors.black)),
                                        //                           Text("${challengesData['Final_description']}",
                                        //                               maxLines: 3,
                                        //                               style: GoogleFonts.montserrat(
                                        //                                   fontSize: 15,
                                        //                                   color: Colors.black)),
                                        //                         ],
                                        //                       ),
                                        //                     ),
                                        //                   );
                                        //                 },
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         );
                                        //       }
                                        //     },
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  );
        })
          );
          // });
        }
    );
  }

  void NewSolViewDialog(Label, Description, Impact, FinalDescription, keywords, tags, insideId,document,isTrueOrFalse,AddButton,){


    final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");

    // String formattedDate = formatter.format(dateTime);

    // _challengesProvider.addkeywordsList(keywords);
    // _challengesProvider.addProviderEditTagsList(tags);

    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
            child:   Consumer<UserAboutMEProvider>(
                builder: (c,userAboutMEProvider, _){
                  if(userAboutMEProvider.editpreviewname != null || userAboutMEProvider.editpreviewDescription != null ||userAboutMEProvider.editpreviewFinalDescription != null ||
                      userAboutMEProvider.editpreviewId != null ||userAboutMEProvider.editpreviewImpact != null ||userAboutMEProvider.editpreviewKeywordssss.isNotEmpty ||
                      userAboutMEProvider.editpreviewtags.isNotEmpty || userAboutMEProvider.editpreview !=null ){
                    Label = userAboutMEProvider.editpreviewname;
                    Description = userAboutMEProvider.editpreviewDescription;
                    FinalDescription = userAboutMEProvider.editpreviewFinalDescription;
                    insideId = userAboutMEProvider.editpreviewId;
                    Impact = userAboutMEProvider.editpreviewImpact;
                    keywords = userAboutMEProvider.editpreviewKeywordssss;
                    tags = userAboutMEProvider.editpreviewtags;
                    document = userAboutMEProvider.editpreview;
                  }
                  _challengesProvider.addkeywordsList(keywords);
                  _challengesProvider.addProviderEditTagsList(tags);

                  return AlertDialog(
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
                                userAboutMEProvider.editpreviewname = null;
                                userAboutMEProvider.editpreviewDescription = null;
                                userAboutMEProvider.editpreviewFinalDescription = null;
                                userAboutMEProvider.editpreviewId = null;
                                userAboutMEProvider.editpreviewImpact = null;
                                userAboutMEProvider.editpreviewKeywordssss.clear();
                                userAboutMEProvider.editpreviewtags.clear();
                                userAboutMEProvider.editpreview = null;
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
                                flex: 2,
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
                                          (Label==""|| Label==null) ? Container() : Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Text("Label: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                              Text(Label,
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
                                                                height: 30,
                                                                // width: 200,
                                                                margin: EdgeInsets.only(bottom: 10),
                                                                padding: EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    // color: Color(0xFF00ACC1)
                                                                    color: Colors.grey
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(item, style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: 10,
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
                                                                height: 30,
                                                                // width: 200,
                                                                padding: EdgeInsets.all(8),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    // color: Colors.teal
                                                                    color: Colors.grey
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(item, style: TextStyle(
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: 10,
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
                                                        child: Text("Related solutions (${relatedSolutions?.length}):",
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
                                                                border: Border.all(color: Colors.green),
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
                                                                          child: Text("${solutionData['Label']}",
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
                                                                        Row(
                                                                          children: [
                                                                            IconButton(
                                                                                onPressed: (){
                                                                                  userAboutMEProvider.updateEditSolutionPreview(
                                                                                      solutionData['Label'],
                                                                                      solutionData['Description'],
                                                                                      solutionData['Final_Description'],
                                                                                      solutionData['Impact'],
                                                                                      solutionData['Keywords'],
                                                                                      solutionData['tags'],
                                                                                      solutionData['id'],
                                                                                      isTrueOrFalse,
                                                                                      solutionData
                                                                                  );
                                                                                },

                                                                                icon: Icon(Icons.visibility, color: Colors.blue,)
                                                                            ),
                                                                            SizedBox(width: 5,),

                                                                            (userAboutMEProvider.isEditSolutionListAdded[solutionData['id']] == true) ? Text(
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
                                                                                userAboutMEProvider.EditRecommendedSolutionAdd(true, relatedSolutions![i]);
                                                                                toastification.show(context: context,
                                                                                    title: Text('${solutionData['Label']} added to basket'),
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
                                                                            ),
                                                                          ],
                                                                        )
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
                                        // Container(
                                        //   height: 170 ,
                                        //   child: FutureBuilder(
                                        //     future: getRelatedSolutions(tags, keywords),
                                        //     builder: (context, snapshot) {
                                        //       if (snapshot.connectionState == ConnectionState.waiting) {
                                        //         return Container(
                                        //             width: 330,
                                        //             child: Container(
                                        //                 height: 20, // Adjust the height as needed
                                        //                 width: 20,
                                        //                 child: Center(
                                        //                     child: CircularProgressIndicator()
                                        //                 )
                                        //             )
                                        //         ); // Display a loading indicator while fetching data
                                        //       } else if (snapshot.hasError) {
                                        //         return Text('Error: ${snapshot.error}');
                                        //       } else {
                                        //         // List<DocumentSnapshot<Object?>>? relatedSolutions = snapshot.data;
                                        //         List<DocumentSnapshot<Map<String, dynamic>>>? relatedSolutions = snapshot.data?.cast<DocumentSnapshot<Map<String, dynamic>>>();
                                        //
                                        //         // print("relatedSolutions: $relatedSolutions");
                                        //
                                        //         return Column(
                                        //           mainAxisAlignment: MainAxisAlignment.start,
                                        //           crossAxisAlignment: CrossAxisAlignment.start,
                                        //           children: [
                                        //             Padding(
                                        //               padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                                        //               child: Text("Suggested Solutions (${relatedSolutions?.length})",
                                        //                   style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                        //                       fontSize: 20,
                                        //                       color: Colors.black)
                                        //               ),
                                        //             ),
                                        //             Expanded(
                                        //               child: ListView.builder(
                                        //                 scrollDirection: Axis.horizontal,
                                        //                 shrinkWrap: true,
                                        //                 itemCount: relatedSolutions?.length,
                                        //                 itemBuilder: (c, i) {
                                        //                   // relatedSolutionlength = relatedSolutions?.length;
                                        //                   // print("relatedSolutionlength: $relatedSolutionlength");
                                        //                   var solutionData = relatedSolutions?[i].data() as Map<String, dynamic>;
                                        //                   print("solutionData: ${solutionData}");
                                        //                   return Container(
                                        //                     margin: EdgeInsets.symmetric(horizontal: 15),
                                        //                     padding: EdgeInsets.all(12),
                                        //                     width: 330,
                                        //                     decoration: BoxDecoration(
                                        //                       border: Border.all(color: Colors.green),
                                        //                       borderRadius: BorderRadius.circular(20),
                                        //                     ),
                                        //                     child: SingleChildScrollView(
                                        //                       child: Column(
                                        //                         mainAxisAlignment: MainAxisAlignment.start,
                                        //                         crossAxisAlignment: CrossAxisAlignment.start,
                                        //                         children: [
                                        //                           Row(
                                        //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                             crossAxisAlignment: CrossAxisAlignment.start,
                                        //                             children: [
                                        //                               Flexible(
                                        //                                 child: Text("${solutionData['Name']}",
                                        //                                     maxLines: null,
                                        //                                     style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                        //                                         fontSize: 18,
                                        //                                         color: Colors.black)),
                                        //                               ),
                                        //                               SizedBox(width: 5,),
                                        //                               // InkWell(
                                        //                               //   onTap: (){
                                        //                               //     _userAboutMEProvider.isRecommendedAddedSolutions(true, relatedSolutions![i]);
                                        //                               //   },
                                        //                               //   child: Container(
                                        //                               //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                        //                               //     width: MediaQuery.of(context).size.width * .05,
                                        //                               //     // width: MediaQuery.of(context).size.width * .15,
                                        //                               //
                                        //                               //     // height: 60,
                                        //                               //     decoration: BoxDecoration(
                                        //                               //       color:Colors.blue ,
                                        //                               //       border: Border.all(
                                        //                               //           color:Colors.blue ,
                                        //                               //           width: 1.0),
                                        //                               //       borderRadius: BorderRadius.circular(8.0),
                                        //                               //     ),
                                        //                               //     child: Center(
                                        //                               //       // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                        //                               //       child: Text(
                                        //                               //         'Add',
                                        //                               //         style: GoogleFonts.montserrat(
                                        //                               //           textStyle:
                                        //                               //           Theme
                                        //                               //               .of(context)
                                        //                               //               .textTheme
                                        //                               //               .titleSmall,
                                        //                               //           fontWeight: FontWeight.bold,
                                        //                               //           color:Colors.white ,
                                        //                               //         ),
                                        //                               //       ),
                                        //                               //     ),
                                        //                               //   ),
                                        //                               // ),
                                        //                               Row(
                                        //                                 children: [
                                        //                                   IconButton(
                                        //                                       onPressed: (){
                                        //                                         userAboutMEProvider.updateEditSolutionPreview(
                                        //                                             solutionData['Name'],
                                        //                                             solutionData['Description'],
                                        //                                             solutionData['Final_Description'],
                                        //                                             solutionData['Impact'],
                                        //                                             solutionData['Keywords'],
                                        //                                             solutionData['tags'],
                                        //                                             solutionData['id'],
                                        //                                             isTrueOrFalse,
                                        //                                             solutionData
                                        //                                         );
                                        //                                       },
                                        //
                                        //                                       icon: Icon(Icons.visibility, color: Colors.green,)
                                        //                                   ),
                                        //                                   SizedBox(width: 5,),
                                        //
                                        //                                   (userAboutMEProvider.isEditSolutionListAdded[solutionData['id']] == true) ? Text(
                                        //                                     'Added',
                                        //                                     style: GoogleFonts.montserrat(
                                        //                                       textStyle:
                                        //                                       Theme
                                        //                                           .of(context)
                                        //                                           .textTheme
                                        //                                           .titleSmall,
                                        //                                       fontStyle: FontStyle.italic,
                                        //                                       color:Colors.green ,
                                        //                                     ),
                                        //                                   ) : InkWell(
                                        //                                     onTap: (){
                                        //                                       // userAboutMEProvider.isRecommendedAddedChallenge(true, documents);
                                        //                                       userAboutMEProvider.EditRecommendedSolutionAdd(true, relatedSolutions![i]);
                                        //                                       toastification.show(context: context,
                                        //                                           title: Text('${solutionData['Name']} added to basket'),
                                        //                                           autoCloseDuration: Duration(milliseconds: 2500),
                                        //                                           alignment: Alignment.center,
                                        //                                           backgroundColor: Colors.green,
                                        //                                           foregroundColor: Colors.white,
                                        //                                           icon: Icon(Icons.check_circle, color: Colors.white,),
                                        //                                           animationDuration: Duration(milliseconds: 1000),
                                        //                                           showProgressBar: false
                                        //                                       );
                                        //                                     },
                                        //                                     child: Container(
                                        //                                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                        //                                       width: MediaQuery.of(context).size.width * .05,
                                        //                                       // width: MediaQuery.of(context).size.width * .15,
                                        //
                                        //                                       // height: 60,
                                        //                                       decoration: BoxDecoration(
                                        //                                         color:Colors.green ,
                                        //                                         border: Border.all(
                                        //                                             color:Colors.green ,
                                        //                                             width: 1.0),
                                        //                                         borderRadius: BorderRadius.circular(8.0),
                                        //                                       ),
                                        //                                       child: Center(
                                        //                                         // child: Icon(Icons.add, size: 30,color: Colors.white,),
                                        //                                         child: Text(
                                        //                                           'Add',
                                        //                                           style: GoogleFonts.montserrat(
                                        //                                             textStyle:
                                        //                                             Theme
                                        //                                                 .of(context)
                                        //                                                 .textTheme
                                        //                                                 .titleSmall,
                                        //                                             fontWeight: FontWeight.bold,
                                        //                                             color:Colors.white ,
                                        //                                           ),
                                        //                                         ),
                                        //                                       ),
                                        //                                     ),
                                        //                                   ),
                                        //                                 ],
                                        //                               )
                                        //                             ],
                                        //                           ),
                                        //                           SizedBox(height: 5,),
                                        //                           // Icon(Icons.add, color: Colors.blue, size: 24,),
                                        //                           Text("${solutionData['Final_description']}",
                                        //                               maxLines: 3,
                                        //                               style: GoogleFonts.montserrat(
                                        //                                   fontSize: 15,
                                        //                                   color: Colors.black)),
                                        //                         ],
                                        //                       ),
                                        //                     ),
                                        //                   );
                                        //                 },
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         );
                                        //       }
                                        //     },
                                        //   ),
                                        // ),
                                        // SizedBox(height: 20,),
                                        Container(
                                          height: 170 ,
                                          width: MediaQuery.of(context).size.width,
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
                                                      child: Text("Suggestes challenges (${relatedChallenges?.length}):",
                                                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                              fontSize: 20,
                                                              color: Colors.black)
                                                      ),
                                                    ),
                                                    Flexible(
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
                                                              border: Border.all(color: Colors.orange),
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

                                                                      Row(
                                                                        children: [
                                                                          IconButton(
                                                                              onPressed: (){
                                                                                userAboutMEProvider.updateEditChallengePreview(
                                                                                    challengesData['Label'],
                                                                                    challengesData['Description'],
                                                                                    challengesData['Final_Description'],
                                                                                    challengesData['Impact'],
                                                                                    challengesData['Keywords'],
                                                                                    challengesData['tags'],
                                                                                    challengesData['id'],
                                                                                    isTrueOrFalse,
                                                                                    challengesData
                                                                                );
                                                                              },
                                                                              icon: Icon(Icons.visibility, color: Colors.blue,)
                                                                          ),
                                                                          SizedBox(width: 5,),
                                                                          (userAboutMEProvider.isEditChallengeListAdded[challengesData['id']] == true) ? Text(
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
                                                                                      userAboutMEProvider.EditRecommendedChallengeAdd(true, relatedChallenges![i]);
                                                                                      toastification.show(context: context,
                                                                                          title: Text('${challengesData['Label']} added to basket'),
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
                                                                                  ),
                                                                        ],
                                                                      ),

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
                  );
        })
          );
          // });
        }
    );
  }

  void ViewChallengesDialog(documentReference,Id, Label, Description, newvalues, keywords, createdat,createdby,tags, modifiedBy,modifiedDate,insideId,documents,i) {


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
                                                                        (userAboutMEProvider.isEditChallengeListAdded[insideId] == true) ? Text(
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
                                                                            userAboutMEProvider.EditRecommendedChallengeAdd(true, documents);
                                                                            toastification.show(context: context,
                                                                                title: Text('${name} added to basket'),
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
                                                                                          child: Text("${solutionData['Label']}",
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
                                                                                                (userAboutMEProvider.isEditSolutionListAdded[solutionData['id']] == true) ? Text(
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
                                                                                                    userAboutMEProvider.EditRecommendedSolutionAdd(true, relatedSolutions![i]);
                                                                                                    toastification.show(context: context,
                                                                                                        title: Text('${solutionData['Label']} added to basket'),
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
                                                                              //       challengesData['tags'],
                                                                              //     challengesData['id'],
                                                                              //     isTrueOrFalse);
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

                                                                                          (userAboutMEProvider.isEditChallengeListAdded[challengesData['id']] == true)
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
                                                                                              userAboutMEProvider.EditRecommendedChallengeAdd(true, relatedChallenges![i]);
                                                                                              toastification.show(
                                                                                                  context: context,
                                                                                                  title: Text('${challengesData['Label']} added to basket'),
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

  void ViewSolutionsDialog(documentReference,Id, Label, Description, newvalues, keywords, createdat, createdby,tags, modifiedBy,modifiedDate,insideId,documentsss){


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

                                  var name = doc?.get("Label");
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
                                                                (userAboutMEProvider.isEditSolutionListAdded[insideId] == true) ? Text(
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
                                                                    userAboutMEProvider.EditRecommendedSolutionAdd(true,documentsss);
                                                                    toastification.show(context: context,
                                                                        title: Text('${name} added to basket'),
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
                                                                                  child: Text("${solutionData['Label']}",
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
                                                                                        (userAboutMEProvider.isEditSolutionListAdded[solutionData['id']] == true) ? Text(
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
                                                                                            userAboutMEProvider.EditRecommendedSolutionAdd(true, relatedSolutions![i]);
                                                                                            toastification.show(context: context,
                                                                                                title: Text('${solutionData['Label']} added to basket'),
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
                                                                                        (userAboutMEProvider.isEditChallengeListAdded[challengesData['id']] == true) ? Text(
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
                                                                                            userAboutMEProvider.EditRecommendedChallengeAdd(true, relatedChallenges![i]);
                                                                                            toastification.show(context: context,
                                                                                                title: Text('${challengesData['Label']} added to basket'),
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

  Future<DocumentSnapshot> fetchDetails(DocumentReference docRef) async {
    return await docRef.get();
  }

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

  Future<String> newSolSelectCategories() async {
    List<String> matches = [];
    String documentId = "aqTybsZWFxMuHPQt7u1T";
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('Keywords').doc("aqTybsZWFxMuHPQt7u1T").get();

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
    solutionresultString = matches.join(', ');
    print("solutionresultString $solutionresultString");
    return solutionresultString;
  }

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

}
