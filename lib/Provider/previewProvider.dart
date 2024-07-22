import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;


import 'package:thrivers/main.dart';
import 'package:thrivers/model/challenges_table_model.dart';
import 'package:thrivers/model/soluton_table_model.dart';

class PreviewProvider with ChangeNotifier{
  var name, email, employer,editemployer, division, role, location, employeeNumber, linemanager, title, mycircumstance, mystrength, myorganization, mychallenge,ABDescription, Osdate;

  List<Map<String, dynamic>> PreviewChallengesList = [];
  List<Map<String, dynamic>> PreviewSolutionList = [];
  List<Map<String, dynamic>> PreviewSolutionMyResposibilty = [];
  List<Map<String, dynamic>> PreviewSolutionStillNeeded = [];
  List<Map<String, dynamic>> PreviewSolutionNotNeededAnyMore = [];
  List<Map<String, dynamic>> PreviewSolutionNiceToHave = [];
  List<Map<String, dynamic>> PreviewSolutionMustHave = [];

  List<Map<String, dynamic>> ccEmails = [];
  List<String> ccNames = [];


  int tabindex = 0;

   pagechange(index) {
      tabindex = index;
      notifyListeners();
  }

  void addCCRecipient(email,name) {
      ccEmails.add({'name': name, 'email': email, "datetime":  DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now())});
      // ccNames.add(name);
      notifyListeners();
  }


  void clearCCRecipient() {
      ccEmails.clear();
      // ccNames.clear();
      notifyListeners();
  }

  void removeCCRecipient(int index) {
    ccEmails.removeAt(index);
    // ccNames.removeAt(index);
    notifyListeners();
  }

  void purpose(purpose) {
    isOfficial = purpose;
      notifyListeners();
  }

  Future<void> userlogout(BuildContext context) async {
    // Clear any session data if needed
    clearSessionData();

    // Remove the loginToken query parameter from the URL
    final url = html.window.location.href;
    print("html.window.location.href: ${html.window.location.href}");
    final uri = Uri.parse(url);
    final newUri = uri.replace(queryParameters: {},path: '/userlogin');
    print("    html.window.history : ${    html.window.history.state}");
    print("    newUri : ${newUri}");

    html.window.history.replaceState(null, '', newUri.toString());

    context.go('/userlogin');
    // widget.isClientLogeddin = false;
    final prefs = await SharedPreferences.getInstance();
    isloggedIn = await prefs.setBool('isLoggedIn', false);
    print("setBoolisloggedIn: $isloggedIn");

    // Optionally, redirect to the login page or another page
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (context) => UserLoginPage()),
    // );
  }

  void clearSessionData() {
    // Clear session storage or cookies if needed
    print("html.window.localStorage: ${html.window.localStorage}");
    html.window.localStorage.clear();
    print("html.window.localStorage: ${html.window.localStorage}");
    // Add any other cleanup logic here
  }


  bool isDuplicate = false;
  var isOfficial;

  void isDuplicatefalse(falsee) {
    isDuplicate = falsee;
      notifyListeners();
  }

  TextEditingController PurposeOfReporttextController = TextEditingController();
  TextEditingController mycircumstancesController = TextEditingController();
  TextEditingController MystrengthsController = TextEditingController();
  TextEditingController myOrganisationController = TextEditingController();
  TextEditingController myOrganisation2Controller = TextEditingController();
  TextEditingController SendNametextController = TextEditingController();
  TextEditingController SendEmailtextController = TextEditingController();

  List<SolutionModel> OSeditsolutions = [];
  List<ChallengesModel> OSeditchallengess = [];

  getDataForOs(assigndata){
    print("assigndata ${assigndata}");
    print("assigndata ${assigndata["User_Name"]}");
   PurposeOfReporttextController.text = assigndata["Purpose_of_report"];
   name = assigndata["User_Name"];
   editemployer = assigndata["Employer"];
   division = assigndata["Division_or_Section"];
   role = assigndata["Role"];
   location = assigndata["Location"];
   employeeNumber = assigndata["Employee_Number"];
   linemanager = assigndata["Line_Manager"];
   title = assigndata["About_Me_Label"];
   mycircumstance = assigndata["My_Circumstance"];
   mystrength = assigndata["My_Strength"];
   myorganization = assigndata["My_Organisation"];
   mychallenge = assigndata["My_Challenges_Organisation"];
    ABDescription = assigndata["AB_Description"];
    print("assigndata : ${assigndata["Created_Date"]}");
    print("assigndata : ${assigndata["Created_Date"].runtimeType}");

    DateTime parsedDate = DateTime.parse(assigndata["Created_Date"]!.split(', ')[0]);
    print("date : $parsedDate");
    Osdate = DateFormat('dd MMMM yyyy').format(parsedDate);
   // if (assigndata.exists) {
     print("assigndata.exist");

     List<dynamic> recipients = assigndata['Report_sent_to_cc'];
     List<dynamic> TO = assigndata['Report_sent_to'];
     ccEmails = recipients.map((recipient) {
       return {
         'name': recipient['name'],
         'email': recipient['email'],
       };
     }).toList();
     for(var i in TO){
       SendNametextController.text = i['name'];
       SendEmailtextController.text = i['email'];

       print(" name ${SendNametextController.text}");
       print(" email ${email}");

     }
   // }

   notifyListeners();
  }

  getDataForPPS( name, editemployer, division, role, location, employeeNumber,
      linemanager, title, mycircumstance, mystrength, myorganization, mychallenge, ABDescription,Email,Email2,assigndata,){
    print("assigndata ${assigndata}");
    print("assigndata ${assigndata["User_Name"]}");
   // PurposeOfReport = assigndata["Purpose_of_report"];
   name = assigndata["User_Name"];
   editemployer = assigndata["Employer"];
   division = assigndata["Division_or_Section"];
   role = assigndata["Role"];
   location = assigndata["Location"];
   employeeNumber = assigndata["Employee_Number"];
   linemanager = assigndata["Line_Manager"];
   title = assigndata["About_Me_Label"];
   mycircumstance = assigndata["My_Circumstance"];
   mystrength = assigndata["My_Strength"];
   myorganization = assigndata["My_Organisation"];
   mychallenge = assigndata["My_Challenges_Organisation"];
    ABDescription = assigndata["AB_Description"];
    Email = assigndata["Email"];
    Email2 = assigndata["Email"];
     print("assigndata.exist");


   notifyListeners();
  }


  void OSEditChallengeList(challengesList) {

    List<dynamic> allTags = [];

    for(var ChallengesDetails in challengesList) {
      OSeditchallengess.add(ChallengesModel(
        id: ChallengesDetails['id'],
        label: ChallengesDetails['Label'],
        description: ChallengesDetails['Description'],
        notes: ChallengesDetails['Impact_on_me'],
        Source: ChallengesDetails['Source'],
        Status: ChallengesDetails['Challenge Status'],
        tags: ChallengesDetails['tags'],
        RelatedChallengesTag: ChallengesDetails['Related_challenges_tags'],
        SuggestedChallengesTag: ChallengesDetails['Suggested_solutions_tags'],
        CreatedBy: ChallengesDetails['Created By'],
        CreatedDate: ChallengesDetails['Created Date'],
        ModifiedBy: ChallengesDetails['Modified By'],
        ModifiedDate: ChallengesDetails['Modified Date'],
        OriginalDescription: ChallengesDetails['Original Description'],
        Impact: ChallengesDetails['Impact'],
        ImpactToCoworker: ChallengesDetails['Impacts_to_Coworkers'],
        ImpactToEmployee: ChallengesDetails['Impacts_to_employee'],
        NegativeImpactToOrganisation: ChallengesDetails['Negative_impacts_to_organisation'],
        Final_description: ChallengesDetails['Final_description'],
        Category: ChallengesDetails['Category'],
        Keywords: ChallengesDetails['Keywords'],
        PotentialStrengths: ChallengesDetails['Potential Strengths'],
        HiddenStrengths: ChallengesDetails['Hidden Strengths'],
        attachment: ChallengesDetails['Attachment'],
      ));
      // isEditChallengeListAdded[ChallengesDetails['id']] = true;

      print("editchallengessAdded: $OSeditchallengess");

      // print("isEditChallengeListAddedADDING: $isEditChallengeListAdded");
      // notifyListeners();
      allTags.addAll(ChallengesDetails['tags']);

    }
    print("All tags combined: $allTags");
    print("All tags combined length: ${allTags.length}");

    // getSuggestedSolutions(allTags);

  }

  void OSEditChallengeListadd(mainList){
    for (var challenge in OSeditchallengess) {
      challenge.isConfirmed = true;
      Map<String, dynamic> solutionData = {
        'id':challenge.id,
        'Label':challenge.label,
        'Description':challenge.description,
        'Source':challenge.Source,
        'Challenge Status':challenge.Source,
        'tags':challenge.tags,
        'Related_challenges_tags':challenge.RelatedChallengesTag,
        'Suggested_solutions_tags':challenge.SuggestedChallengesTag,
        'Created By':challenge.CreatedBy,
        'Created Date':challenge.CreatedDate,
        'Modified By':challenge.ModifiedBy,
        'Modified Date':challenge.ModifiedDate,
        'Original Description':challenge.OriginalDescription,
        'Impact':challenge.Impact,
        'Impacts_to_Coworkers':challenge.ImpactToCoworker,
        'Impacts_to_employee':challenge.ImpactToEmployee,
        'Negative_impacts_to_organisation':challenge.NegativeImpactToOrganisation,
        'Final_description':challenge.Final_description,
        'Category':challenge.Category,
        'Keywords':challenge.Keywords,
        'Potential Strengths':challenge.PotentialStrengths,
        'Hidden Strengths':challenge.HiddenStrengths,
        'Impact_on_me':challenge.notes,
        'Attachment_link':challenge.attachment_link,
        'Attachment':challenge.attachment,
      };
      mainList.add(solutionData);
      print("EditChallengeListadd challenge: ${mainList.length}");
      print("EditChallengeListadd challenge: ${mainList}");
      print("EditChallengeListadd");
      // notifyListeners();
    }
  }

  void OSEditSolutionList(solutionList) {

    for(var SolutionDetails in solutionList) {

      OSeditsolutions.add(SolutionModel(
        id: SolutionDetails['id'],
        label: SolutionDetails['Label'],
        description: SolutionDetails['Description'],
        notes: SolutionDetails['AboutMe_Notes'],
        Source: SolutionDetails['Source'],
        Status: SolutionDetails['Challenge Status'],
        tags: SolutionDetails['tags'],
        CreatedBy: SolutionDetails['Created By'],
        CreatedDate: SolutionDetails['Created Date'],
        ModifiedBy: SolutionDetails['Modified By'],
        ModifiedDate: SolutionDetails['Modified Date'],
        OriginalDescription: SolutionDetails['Original Description'],
        Impact: SolutionDetails['Impact'],
        Final_description: SolutionDetails['Final_description'],
        Category: SolutionDetails['Category'],
        Keywords: SolutionDetails['Keywords'],
        attachment: SolutionDetails['Attachment'],
        InPlace: SolutionDetails['InPlace'],
        Provider: SolutionDetails['Provider'],
        Help: SolutionDetails['Helps'],
        PositiveImpactstoEmployee: SolutionDetails['Positive_impacts_to_employee'],
        PositiveImpactstoOrganisation: SolutionDetails['Positive_impacts_to_organisation'],
        RelatedSolutionsTags: SolutionDetails['Related_solution_tags'],
        SuggestedChallengesTags: SolutionDetails['Suggested_challenges_tags'],
      ));
      // isEditSolutionListAdded[SolutionDetails['id']] = true;


      print("isEditSolutionListAdded: $OSeditsolutions");

      // print("isEditSolutionListAddedADDING: $isEditSolutionListAdded");
      // notifyListeners();

    }

  }

  void OSEditSolutionListadd(mainList){
    for (var solution in OSeditsolutions) {
      solution.isConfirmed = true;
      Map<String, dynamic> solutionData = {
        'id':solution.id,
        'Label':solution.label,
        'Description':solution.description,
        'Source':solution.Source,
        'Challenge Status':solution.Source,
        'tags':solution.tags,
        'Created By':solution.CreatedBy,
        'Created Date':solution.CreatedDate,
        'Modified By':solution.ModifiedBy,
        'Modified Date':solution.ModifiedDate,
        'Original Description':solution.OriginalDescription,
        'Impact':solution.Impact,
        'Final_description':solution.Final_description,
        'Category':solution.Category,
        'Keywords':solution.Keywords,
        'Potential Strengths':"",
        'Hidden Strengths':"",
        'AboutMe_Notes':solution.notes,
        'Provider':solution.Provider,
        'InPlace':solution.InPlace,
        'Attachment_link' : solution.attachment_link,
        'Attachment': solution.attachment,
        "Help": solution.Help,
        "Positive_impacts_to_employee": solution.PositiveImpactstoEmployee,
        "Positive_impacts_to_organisation": solution.PositiveImpactstoOrganisation,
        "Related_solution_tags": solution.RelatedSolutionsTags,
        "Suggested_challenges_tags": solution.SuggestedChallengesTags,
        // 'confirmed': false, // Add a 'confirmed' field
      };

      // print("Provider object:${solutionData["Provider"]}");
      // print("InPlace object:${solutionData["InPlace"]}");

      mainList.add(solutionData);
      // updatenewprovider(solutionData["Provider"], solutionData["id"]);
      // updatenewInplace(solutionData["InPlace"], solutionData["id"]);
      print("mainList.length: ${mainList.length}");
      print("mainList: ${mainList}");
      // notifyListeners();

    }
  }

  void OSEditSolutionProvideradd(mainList){
    for (var solution in OSeditsolutions) {
      solution.isConfirmed = true;
      Map<String, dynamic> solutionData = {
        'id':solution.id,
        'Label':solution.label,
        'Description':solution.description,
        'Source':solution.Source,
        'Challenge Status':solution.Status,
        'tags':solution.tags,
        'Created By':solution.CreatedBy,
        'Created Date':solution.CreatedDate,
        'Modified By':solution.ModifiedBy,
        'Modified Date':solution.ModifiedDate,
        'Original Description':solution.OriginalDescription,
        'Impact':solution.Impact,
        'Final_description':solution.Final_description,
        'Category':solution.Category,
        'Keywords':solution.Keywords,
        'Potential Strengths':"",
        'Hidden Strengths':"",
        'AboutMe_Notes':solution.notes,
        'Provider':solution.Provider,
        'InPlace':solution.InPlace,
        'Attachment_link' : solution.attachment_link,
        'Attachment': solution.attachment,
        "Help": solution.Help,
        "Positive_impacts_to_employee": solution.PositiveImpactstoEmployee,
        "Positive_impacts_to_organisation": solution.PositiveImpactstoOrganisation,
        "Related_solution_tags": solution.RelatedSolutionsTags,
        "Suggested_challenges_tags": solution.SuggestedChallengesTags,
        // 'confirmed': false, // Add a 'confirmed' field
      };
      if(solutionData["Provider"]=="My Responsibilty"){
        mainList.add(solutionData);
        // notifyListeners();

      }
      // print("mainList.length solution: ${mainList.length}");
      // print("mainList solution: ${mainList}");
    }
  }

  void OSEditSolutionInPlaceadd(mainList,mainList1,mainList2,mainList3){
    for (var solution in OSeditsolutions) {
      solution.isConfirmed = true;
      Map<String, dynamic> solutionData = {
        'id':solution.id,
        'Label':solution.label,
        'Description':solution.description,
        'Source':solution.Source,
        'Challenge Status':solution.Source,
        'tags':solution.tags,
        'Created By':solution.CreatedBy,
        'Created Date':solution.CreatedDate,
        'Modified By':solution.ModifiedBy,
        'Modified Date':solution.ModifiedDate,
        'Original Description':solution.OriginalDescription,
        'Impact':solution.Impact,
        'Final_description':solution.Final_description,
        'Category':solution.Category,
        'Keywords':solution.Keywords,
        'Potential Strengths':"",
        'Hidden Strengths':"",
        'AboutMe_Notes':solution.notes,
        'Provider':solution.Provider,
        'InPlace':solution.InPlace,
        'Attachment_link' : solution.attachment_link,
        'Attachment': solution.attachment,
        "Help": solution.Help,
        "Positive_impacts_to_employee": solution.PositiveImpactstoEmployee,
        "Positive_impacts_to_organisation": solution.PositiveImpactstoOrganisation,
        "Related_solution_tags": solution.RelatedSolutionsTags,
        "Suggested_challenges_tags": solution.SuggestedChallengesTags,
        // 'confirmed': false, // Add a 'confirmed' field
      };
      if(solutionData["InPlace"]=='Yes (Still Needed)'){
        mainList.add(solutionData);
      }
      else if(solutionData["InPlace"]=='Yes (Not Needed Anymore)'){
        mainList1.add(solutionData);
      }
      else  if(solutionData["InPlace"]=='No (Nice to have)'){
        mainList2.add(solutionData);
      }
      else if(solutionData["InPlace"]=='No (Must Have)'){
        mainList3.add(solutionData);
      }
      // notifyListeners();
    }
  }

  void removeOSConfirmChallenge(int index, id,ConfirmChallenge,providerlist) {
    List<dynamic> challengesList = ConfirmChallenge ?? [];
    List<dynamic> providerchallengesList = providerlist ?? [];
    Iterable<Map<String, dynamic>> challengesIterable = challengesList.map((item) => item as Map<String, dynamic>);
    Iterable<Map<String, dynamic>> providerIterable = providerchallengesList.map((item) => item as Map<String, dynamic>);

    for (var solutionData in challengesIterable) {
      print("solutionData iddddd: ${solutionData["id"]}");
      if (solutionData["id"] == id) {
        print("solutionData: ${solutionData["id"]}");
        ConfirmChallenge.remove(solutionData);
        print("challengesListREMOVEED: ${solutionData['Label']}");
        print("challengesList.length: ${ConfirmChallenge.length}");
        print("challengesList: ${ConfirmChallenge}");
        break;
      }
      notifyListeners();
    }

    for (var providerData in providerIterable) {
      print("providerData iddddd: ${providerData["id"]}");
      if (providerData["id"] == id) {
        print("providerData: ${providerData["id"]}");
        providerlist.remove(providerData);
        print("providerlistREMOVEED: ${providerData['Label']}");
        print("providerlist.length: ${providerlist.length}");
        print("providerlist: ${providerlist}");
        break;
      }
      notifyListeners();
    }

    if (OSeditchallengess.length > index) {
      ChallengesModel removedSolution = OSeditchallengess.removeAt(index);

      notifyListeners();
    }

  }

  void removeOSConfirmSolution(id,ConfirmSolution, providerlist1,providerlist2,providerlist3,providerlist4,providerlist5) {
    List<dynamic> solutionsList = ConfirmSolution ?? [];

    List<dynamic> providersolutionsList1 = providerlist1 ?? [];
    List<dynamic> providersolutionsList2 = providerlist2 ?? [];
    List<dynamic> providersolutionsList3 = providerlist3 ?? [];
    List<dynamic> providersolutionsList4 = providerlist4 ?? [];
    List<dynamic> providersolutionsList5 = providerlist5 ?? [];

    Iterable<Map<String, dynamic>> solutionIterable = solutionsList.map((item) => item as Map<String, dynamic>);

    Iterable<Map<String, dynamic>> providerIterable1 = providersolutionsList1.map((item) => item as Map<String, dynamic>);
    Iterable<Map<String, dynamic>> providerIterable2 = providersolutionsList2.map((item) => item as Map<String, dynamic>);
    Iterable<Map<String, dynamic>> providerIterable3 = providersolutionsList3.map((item) => item as Map<String, dynamic>);
    Iterable<Map<String, dynamic>> providerIterable4 = providersolutionsList4.map((item) => item as Map<String, dynamic>);
    Iterable<Map<String, dynamic>> providerIterable5 = providersolutionsList5.map((item) => item as Map<String, dynamic>);

    for (var solutionData in solutionIterable) {
      print("solutionData iddddd: ${solutionData["id"]}");

      if (solutionData["id"] == id) {
        print("solutionData: ${solutionData["id"]}");

        ConfirmSolution.remove(solutionData);

        print("solutionsListREMOVEED: ${solutionData['Label']}");
        print("ConfirmSolution.length: ${ConfirmSolution.length}");
        print("ConfirmSolution: ${ConfirmSolution}");
        break;
      }
      notifyListeners();
    }

    for (var solutionData in providerIterable1) {
      if (solutionData["id"] == id) {
        print("solutionData: ${solutionData["id"]}");
        if (solutionData["Provider"] == "My Responsibilty") {
          providerlist1.remove(solutionData);
          print("providerlist: My Responsibilty");
          print("providerlist1: $providerlist1");
          notifyListeners();
        }

        print("providerlist1REMOVEED: ${solutionData['Label']}");
        print("providerlist1.length: ${providerlist1.length}");
        print("providerlist1: ${providerlist1}");
        break;
      }
    }

    for (var solutionData in providerIterable2) {

      if (solutionData["id"] == id) {
        print("solutionData: ${solutionData["id"]}");

        if (solutionData["InPlace"] == "Yes (Still Needed)") {
          providerlist2.remove(solutionData);
          print("providerlist: Yes (Still Needed)");
          print("providerlist2: $providerlist2");
        }

        print("providerlist2REMOVEED: ${solutionData['Label']}");
        print("providerlist2.length: ${providerlist2.length}");
        print("providerlist2: ${providerlist2}");
        break;
      }
      notifyListeners();
    }

    for (var solutionData in providerIterable3) {
      print("solutionData iddddd: ${solutionData["id"]}");

      if (solutionData["id"] == id) {
        print("solutionData: ${solutionData["id"]}");

        if (solutionData["InPlace"] == "Yes (Not Needed Anymore)") {
          providerlist3.remove(solutionData);
          print("providerlist: Yes (Not Needed Anymore)");
          print("providerlist3: $providerlist3");
        }

        print("providerIterable3 REMOVEED: ${solutionData['Label']}");
        print("providerIterable3.length: ${providerIterable3.length}");
        print("providerIterable3: ${providerIterable3}");
        break;
      }
      notifyListeners();
    }

    for (var solutionData in providerIterable4) {
      print("solutionData iddddd: ${solutionData["id"]}");

      if (solutionData["id"] == id) {
        print("solutionData: ${solutionData["id"]}");

        if (solutionData["InPlace"] == "No (Nice to have)") {
          providerlist4.remove(solutionData);
          print("providerlist: No (Nice to have)");
          print("providerlist4: $providerlist4");
        }

        print("providerlist4 REMOVEED: ${solutionData['Label']}");
        print("providerlist4.length: ${providerlist4.length}");
        print("providerlist4: ${providerlist4}");
        break;
      }
      notifyListeners();
    }

    for (var solutionData in providerIterable5) {
      print("solutionData iddddd: ${solutionData["id"]}");

      if (solutionData["id"] == id) {
        print("solutionData: ${solutionData["id"]}");

        if (solutionData["InPlace"] == "No (Must Have)") {
          providerlist5.remove(solutionData);
          print("providerlist: No (Must Have)");
          print("providerlist5: $providerlist5");
        }


        print("providerlist5 REMOVEED: ${solutionData['Label']}");
        print("providerlist5.length: ${providerlist5.length}");
        print("providerlist5: ${providerlist5}");
        break;
      }
      notifyListeners();
    }

    OSeditsolutions.removeWhere((solution) => solution.id == id);

    notifyListeners();


  }



  void updatePurposeofReport(linemanager) {
    PurposeOfReporttextController.text = "Official request to $linemanager";
    SendNametextController.text = "$linemanager";
    print("PurposeofReport : ${PurposeOfReporttextController.text}");
      notifyListeners();
  }

  void updateOtherCommuniation(name,linemanager) {
    // if(PurposeOfReporttextController.text.isNotEmpty){
    //   PurposeOfReporttextController.clear();
    //   SendNametextController.clear();
    //   print("PurposeofReport : ${PurposeOfReporttextController.text}");
    // }
    // else
      PurposeOfReporttextController.text = "$name for discussion with [colleague name]";
    SendNametextController.text = "[colleague name]";

    notifyListeners();

  }





  logout(String adminusername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("Logout prefs before: ${prefs.getString(adminusername)}");
    await prefs.remove(adminusername);
    print("Logout prefs: ${prefs.getString(adminusername)}");// Navigate back to login screen
    notifyListeners();
  }




  updateEmail(value){
    email = value;
    notifyListeners();
  }

    updatetitle(value){
      title = value;
    notifyListeners();
  }

    updatemycircumstance(value){
      mycircumstance = value;
    notifyListeners();
  }

    updatemystrength(value){
      mystrength = value;
    notifyListeners();
  }

    updatemyorganization(value){
      myorganization = value;
    notifyListeners();
  }

    updatemychallenge(value){
      mychallenge = value;
    notifyListeners();
  }

  updateName(value){
    name = value;
    notifyListeners();
  }

  updateemployer(value){
    employer = value;
    notifyListeners();
  }

  updatedivision(value){
    division = value;
    notifyListeners();
  }

  updaterole(value){
    role = value;
    notifyListeners();
  }

  updatelocation(value){
    location = value;
    notifyListeners();
  }

  updateemployeeNumber(value){
    employeeNumber = value;
    notifyListeners();
  }

  updatelinemanager(value){
    linemanager = value;
    notifyListeners();
  }



  Future<Uint8List> OSPdf(List<Map<String, dynamic>> dataList, List<Map<String, dynamic>> dataList2) async {
    print("inside OSPdf");
    final pdf = pw.Document();
    final Reportfont = await PdfGoogleFonts.latoBoldItalic();
    final Reportansfont = await PdfGoogleFonts.latoItalic();

    final headingfont1 = await PdfGoogleFonts.latoBold();
    final bodyfont1 = await PdfGoogleFonts.latoRegular();

    final imageByteData = await rootBundle.load('assets/images/header.png');

    final imageUint8List = imageByteData.buffer
        .asUint8List(imageByteData.offsetInBytes, imageByteData.lengthInBytes);

    final image = pw.MemoryImage(imageUint8List);

    // final circumstance = await loadImage('assets/images/circumstance.png');
    // final challenges = await loadImage('assets/images/challenges.png');
    // final myrole = await loadImage('assets/images/myrole.png');
    // final liked = await loadImage('assets/images/liked.png');
    // final disliked = await loadImage('assets/images/disliked.png');
    // final myresponsibility = await loadImage('assets/images/myresponsibility.png');
    // final request1 = await loadImage('assets/images/request1.png');
    // final request2 = await loadImage('assets/images/request2.png');

    final customBgColor = PdfColor.fromInt(0xFFD9E2F3);
    final customFontColor = PdfColor.fromInt(0xFF4478D4);

    List<pw.Widget> SolutiontableRows1 =  generateSolutionsMyResponsibiltyWidgets(dataList2,headingfont1,bodyfont1);
    List<pw.Widget> SolutiontableRows2 =  generateSolutionsStillNeededWidgets(dataList2,headingfont1,bodyfont1);
    List<pw.Widget> SolutiontableRows3 =  generateSolutionsNotNeededAnymoreWidgets(dataList2,headingfont1,bodyfont1);
    List<pw.Widget> SolutiontableRows4 =  generateSolutionsNoNicetohaveWidgets(dataList2,headingfont1,bodyfont1);
    List<pw.Widget> SolutiontableRows5 =  generateSolutionsMustHaveWidgets(dataList2,headingfont1,bodyfont1);
    List<pw.Widget> CCEmailWidgets =  generateCCEmailWidgets(ccEmails,headingfont1,bodyfont1);

    // List<String> output = processRoutes(mycircumstancesController.text);
    // print(output);
    // print("mycircumstancesController.text : ${output}");

    pdf.addPage(
        pw.MultiPage(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(0),
          header: (context) {
            return pw.Image(image);
          },
          footer: (context) {
            return pw.Column(
                children: [
                  pw.Image(image),
                  pw.SizedBox(height: 5,),

                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 30),
                    child:  pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text("${name}: for discussion with ${linemanager}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                          pw.SizedBox(width: 70,),

                          pw.Text("${DateFormat('dd MMMM yyyy').format(DateTime.now())}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                          pw.SizedBox(width: 120,),

                          pw.Text("Page ${context.pageNumber} of ${context.pagesCount}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                        ]
                    ),
                  ),



                  pw.SizedBox(height: 15,),

                ]
            );
          },
          build: (context) {
            // List<pw.Widget> ChallengetableRows = generateChallengeWidgets(dataList,headingfont1,bodyfont1);
            // List<pw.TableRow> SolutiontableRows = generateSolutionTableRows(dataList2);
            return [

              pw.SizedBox(height: 10,),

              pw.Container(
                padding: pw.EdgeInsets.all(5),
                margin: pw.EdgeInsets.symmetric(horizontal: 30),
                width: double.maxFinite,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black),
                  color: PdfColor.fromInt(0xffd9e2f3),
                ),
                child: pw.Text("Performing to my best in my role for ${editemployer} ",
                    style: pw.TextStyle(font: headingfont1,fontSize: 18, color: PdfColor.fromInt(0xFF4472c4),fontWeight: pw.FontWeight.bold)
                ),
              ),

              pw.SizedBox(height: 10,),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 30),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    // pw.Text("Report file name: ", style: pw.TextStyle(font: Reportfont)),

                    pw.Text("${name}: for discussion with ${linemanager}",style: pw.TextStyle(font: Reportfont,color: PdfColor.fromInt(0xFF4472c4),fontSize: 16)),

                  ],
                ),
              ),

              // pw.SizedBox(height: 5,),


              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 180,
                    margin: pw.EdgeInsets.symmetric(horizontal: 30),
                    child: pw.Text(
                      "Date:",
                      style: pw.TextStyle(
                        font: headingfont1,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    // "${AboutMeDatetextController.text}",
                    // "01 July 2024",
                    // "${Osdate}",
                    "${DateFormat('dd MMMM yyyy').format(DateTime.now())}",
                    style: pw.TextStyle(font: bodyfont1),
                  ),
                ],
              ),

              pw.SizedBox(height: 10,),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 180,
                    margin: pw.EdgeInsets.symmetric(horizontal: 30),
                    child: pw.Text(
                      "To:",
                      style: pw.TextStyle(
                        font: headingfont1,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.UrlLink(
                    destination: 'mailto:${SendEmailtextController.text}',
                    child: pw.Text(
                      SendEmailtextController.text,
                      style: pw.TextStyle(
                        font: bodyfont1,
                        color: PdfColors.blue,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10,),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 180,
                    margin: pw.EdgeInsets.symmetric(horizontal: 30),
                    child: pw.Text(
                      "Cc:",
                      style: pw.TextStyle(
                        font: headingfont1,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [...CCEmailWidgets]
                  )
                ],
              ),
              pw.SizedBox(height: 30,),

              pw.Container(
                  width: double.maxFinite,
                  margin: pw.EdgeInsets.symmetric(horizontal: 30),
                  // height: 280,
                  // decoration: pw.BoxDecoration(
                  //     gradient: pw.LinearGradient(colors: [PdfColor.fromInt(0xffd9e2f3),PdfColor.fromInt(0xFF8faadc)],begin: pw.Alignment.topLeft, end:pw.Alignment.bottomRight )
                  // ),
                  child: pw.Text("$ABDescription", style: pw.TextStyle(
                    font: bodyfont1,
                    fontWeight: pw.FontWeight.bold,
                  ),)
              ),


              pw.Container(
                  padding: pw.EdgeInsets.all(5),
                  margin: pw.EdgeInsets.symmetric(horizontal: 30),
                  width: double.maxFinite,
                  child: pw.Column(
                      children: [
                        pw.SizedBox(height: 15,),

                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 130,
                              child: pw.Text(
                                "Name: ",
                                style: pw.TextStyle(
                                  font: headingfont1,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${name}",
                              style: pw.TextStyle(font: bodyfont1),
                            ),
                          ],
                        ),

                        pw.SizedBox(height: 15,),

                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 130,
                              child: pw.Text(
                                "Role: ",
                                style: pw.TextStyle(
                                  font: headingfont1,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${role}",
                              style: pw.TextStyle(font: bodyfont1),
                            ),
                          ],
                        ),

                        pw.SizedBox(height: 15,),

                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 130,
                              child: pw.Text(
                                "Location: ",
                                style: pw.TextStyle(
                                  font: headingfont1,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${location}",
                              style: pw.TextStyle(font: bodyfont1),
                            ),
                          ],
                        ),

                        pw.SizedBox(height: 15,),

                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 130,
                              child: pw.Text(
                                "Employee number: ",
                                style: pw.TextStyle(
                                  font: headingfont1,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${employeeNumber}",
                              style: pw.TextStyle(font: bodyfont1),
                            ),
                          ],
                        ),

                        pw.SizedBox(height: 15,),

                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 130,
                              child: pw.Text(
                                "Team Leader: ",
                                style: pw.TextStyle(
                                  font: headingfont1,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              "${linemanager}",
                              style: pw.TextStyle(font: bodyfont1),
                            ),
                          ],
                        ),
                      ]
                  ),
              ),

              // pw.SizedBox(height: 15,),
              //
              //
              //
              // pw.SizedBox(height: 10,),
              //
              // pw.Padding(
              //     padding: const pw.EdgeInsets.symmetric(
              //       vertical: 10.0,),
              //     child: pw.Text("Performing to my best in my role ${employerController.text}: ",
              //         style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font:headingfont1))
              // ),
              //
              // pw.SizedBox(height: 5,),
              //
              //
              // pw.Text(
              //   "${AboutMeDescriptiontextController.text}",
              //   style: pw.TextStyle(font: bodyfont1),
              // ),
              //
              //
              // pw.SizedBox(height: 20,),


            ];
          },));

    pdf.addPage(

        pw.MultiPage(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(0),
          header: (context) {
            return pw.Image(image);
          },
          footer: (context) {
            return pw.Column(
                children: [
                  pw.Image(image),
                  pw.SizedBox(height: 5,),

                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 30),
                    child:  pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text("${name}: for discussion with ${linemanager}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                          pw.SizedBox(width: 70,),

                          pw.Text("${DateFormat('dd MMMM yyyy').format(DateTime.now())}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                          pw.SizedBox(width: 120,),

                          pw.Text("Page ${context.pageNumber} of ${context.pagesCount}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                        ]
                    ),
                  ),



                  pw.SizedBox(height: 15,),

                ]
            );
          },
          build: (context) {
            List<pw.Widget> ChallengetableRows = generateChallengeWidgets(dataList,headingfont1,bodyfont1);
            return [

              pw.Container(
                padding: pw.EdgeInsets.all(5),
                margin: pw.EdgeInsets.symmetric(horizontal: 30),
                width: double.maxFinite,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black),
                  color: PdfColor.fromInt(0xffd9e2f3),
                ),
                child: pw.Text("My Basic data:",
                    style: pw.TextStyle(font: headingfont1,fontSize: 18, color: PdfColor.fromInt(0xFF4472c4),fontWeight: pw.FontWeight.bold)
                ),
              ),

             pw.Container(
                  padding: pw.EdgeInsets.all(5),
              margin: pw.EdgeInsets.symmetric(horizontal: 30),
              width: double.maxFinite,
              child: pw.Column(
                children: [
                  pw.SizedBox(height: 15,),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 130,
                        child: pw.Text(
                          "Name: ",
                          style: pw.TextStyle(
                            font: headingfont1,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Text(
                        "${name}",
                        style: pw.TextStyle(font: bodyfont1),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 15,),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 130,
                        child: pw.Text(
                          "Role: ",
                          style: pw.TextStyle(
                            font: headingfont1,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Text(
                        "${role}",
                        style: pw.TextStyle(font: bodyfont1),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 15,),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 130,
                        child: pw.Text(
                          "Location: ",
                          style: pw.TextStyle(
                            font: headingfont1,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Text(
                        "${location}",
                        style: pw.TextStyle(font: bodyfont1),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 15,),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 130,
                        child: pw.Text(
                          "Employee number: ",
                          style: pw.TextStyle(
                            font: headingfont1,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Text(
                        "${employeeNumber}",
                        style: pw.TextStyle(font: bodyfont1),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 15,),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 130,
                        child: pw.Text(
                          "Team Leader: ",
                          style: pw.TextStyle(
                            font: headingfont1,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.Text(
                        "${linemanager}",
                        style: pw.TextStyle(font: bodyfont1),
                      ),
                    ],
                  ),
                ]
              )
             )
            ];
          },));

    pdf.addPage(

        pw.MultiPage(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(0),
          header: (context) {
            return pw.Image(image);
          },
          footer: (context) {
            return pw.Column(
                children: [
                  pw.Image(image),
                  pw.SizedBox(height: 5,),

                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 30),
                    child:  pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text("${name}: for discussion with ${linemanager}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                          pw.SizedBox(width: 70,),

                          pw.Text("${DateFormat('dd MMMM yyyy').format(DateTime.now())}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                          pw.SizedBox(width: 120,),

                          pw.Text("Page ${context.pageNumber} of ${context.pagesCount}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                        ]
                    ),
                  ),



                  pw.SizedBox(height: 15,),

                ]
            );
          },
          build: (context) {
            List<pw.Widget> ChallengetableRows = generateChallengeWidgets(dataList,headingfont1,bodyfont1);
            return [

              pw.Container(
                padding: pw.EdgeInsets.all(5),
                margin: pw.EdgeInsets.symmetric(horizontal: 30),
                width: double.maxFinite,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black),
                  color: PdfColor.fromInt(0xffd9e2f3),
                ),
                child: pw.Text("About Me",
                    style: pw.TextStyle(font: headingfont1,fontSize: 18, color: PdfColor.fromInt(0xFF4472c4),fontWeight: pw.FontWeight.bold)
                ),
              ),



              pw.SizedBox(height: 10,),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child:pw.Text("Me and my circumstances:",
                  style: pw.TextStyle(
                    font: headingfont1,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14, color: PdfColor.fromInt(0xFF4472c4),
                  ),
                ),
              ),
              pw.SizedBox(height: 10,),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child:pw.Text("${mycircumstance}",
                  style: pw.TextStyle(font: bodyfont1,fontSize: 12,
                      decorationStyle: pw.TextDecorationStyle.double),
                ),
              ),

              pw.SizedBox(height: 20,),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child:pw.Text("My strengths that I want to have the opportunity to use in my role:",
                  style: pw.TextStyle(
                    font: headingfont1,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14, color: PdfColor.fromInt(0xFF4472c4),
                  ),
                ),
              ),

              pw.SizedBox(height: 10,),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child:pw.Text("${mystrength}",
                  style: pw.TextStyle(font: bodyfont1,fontSize: 12,
                      decorationStyle: pw.TextDecorationStyle.double),
                ),
              ),

              pw.SizedBox(height: 20,),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child:pw.Text("Things I find challenging in life that make it harder for me to perform my best:",
                  style: pw.TextStyle(
                    font: headingfont1,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14, color: PdfColor.fromInt(0xFF4472c4),
                  ),
                ),
              ),

              pw.SizedBox(height: 10,),
              pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 30),
              child: pw.Column(
                children: [...ChallengetableRows]
              )
              ),
              pw.SizedBox(height: 20,),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child:pw.Text("What I value about $editemployer and the workplace environment that helps me perform my best: ",
                  style: pw.TextStyle(
                    font: headingfont1,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14, color: PdfColor.fromInt(0xFF4472c4),
                  ),
                ),
              ),

              pw.SizedBox(height: 10,),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child:pw.Text("${myorganization}",
                  style: pw.TextStyle(font: bodyfont1,fontSize: 12,
                      decorationStyle: pw.TextDecorationStyle.double),
                ),
              ),

              pw.SizedBox(height: 20,),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child:pw.Text("What I find challenging about $editemployer and the workplace environment that make it harder for me to perform my best:",
                  style: pw.TextStyle(
                    font: headingfont1,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14, color: PdfColor.fromInt(0xFF4472c4),
                  ),
                ),
              ),

              pw.SizedBox(height: 10,),

              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child:pw.Text("${mychallenge}",
                  style: pw.TextStyle(font: bodyfont1,fontSize: 12,
                      decorationStyle: pw.TextDecorationStyle.double),
                ),
              ),

            ];
          },));


    (SolutiontableRows1.isNotEmpty) ? pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(0),
        header: (context) {
          return pw.Image(image);
        },
        footer: (context) {
          return pw.Column(
              children: [
                pw.Image(image),
                pw.SizedBox(height: 5,),

                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 30),
                  child:  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text("${name}: for discussion with ${linemanager}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                        pw.SizedBox(width: 70,),

                        pw.Text("${DateFormat('dd MMMM yyyy').format(DateTime.now())}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                        pw.SizedBox(width: 120,),

                        pw.Text("Page ${context.pageNumber} of ${context.pagesCount}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                      ]
                  ),
                ),



                pw.SizedBox(height: 15,),

              ]
          );
        },
        build: (context) {
          return [
            pw.Container(
              padding: pw.EdgeInsets.all(5),
              margin: pw.EdgeInsets.symmetric(horizontal: 30),
              width: double.maxFinite,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black),
                color: PdfColor.fromInt(0xffd9e2f3),
              ),
              child: pw.Text("Actions and adjustments that I’ve identified can help me perform to my best in my role for ${editemployer}",
                  style: pw.TextStyle(font: headingfont1,fontSize: 18, color: PdfColor.fromInt(0xFF4472c4),fontWeight: pw.FontWeight.bold)
              ),
            ),

            pw.SizedBox(height: 20,),
            //pw.Padding(padding: pw.EdgeInsets.all(20)),


            (SolutiontableRows1.isNotEmpty) ? pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child: pw.Text("Personal Responsibility",
                    style: pw.TextStyle(font: headingfont1,fontSize: 16, color: PdfColor.fromInt(0xFF4472c4),fontWeight: pw.FontWeight.bold)
                )) : pw.SizedBox(),

            (SolutiontableRows1.isNotEmpty) ? pw.SizedBox(height: 25,) : pw.SizedBox(),

            (SolutiontableRows1.isNotEmpty) ?  pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 30),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Things I already or will do to help myself:",
                    style: pw.TextStyle(
                      font: headingfont1,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14, color: PdfColor.fromInt(0xFF4472c4),
                    ),
                  ),
                  pw.SizedBox(height: 10,),

                  ...SolutiontableRows1
                ]
              )

            ) : pw.SizedBox(),

            (SolutiontableRows1.isNotEmpty) ? pw.SizedBox(height: 25,) : pw.SizedBox(),



          ];
        },
      ),
    ) : pw.SizedBox();

    (SolutiontableRows2.isNotEmpty||SolutiontableRows3.isNotEmpty) ?  pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(0),
        build: (context) {
          return [


            (SolutiontableRows2.isNotEmpty) ? pw.SizedBox(height: 25,) : pw.SizedBox(),

            (SolutiontableRows2.isNotEmpty) ? pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child: pw.Text("My request of ${editemployer}",
                    style: pw.TextStyle(font: headingfont1,fontSize: 16, color: PdfColor.fromInt(0xFF4472c4),fontWeight: pw.FontWeight.bold)
                )) : pw.SizedBox(),

            (SolutiontableRows2.isNotEmpty) ? pw.SizedBox(height: 15,) : pw.SizedBox(),

            (SolutiontableRows2.isNotEmpty) ?  pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 30),
              child: pw.Column(
                  children: [
                    pw.Text("$editemployer already provides the following assistance to me, which I’d like if possible to continue to receive:",
                      style: pw.TextStyle(
                        font: headingfont1,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14, color: PdfColor.fromInt(0xFF4472c4),
                      ),
                    ),
                    pw.SizedBox(height: 10,),
                    ...SolutiontableRows2
                  ]
              )
            ) : pw.SizedBox(),

            (SolutiontableRows2.isNotEmpty) ? pw.SizedBox(height: 25,) : pw.SizedBox(),


            (SolutiontableRows3.isNotEmpty) ?  pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 30),
              child:pw.Column(
                  children: [
                    pw.Text("Here is what I’m asking $editemployer whether it’s possible to start providing for me: ",
                      style: pw.TextStyle(
                        font: headingfont1,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14, color: PdfColor.fromInt(0xFF4472c4),
                      ),
                    ),
                    pw.SizedBox(height: 10,),

                    ...SolutiontableRows3
                  ]
              )
            ) : pw.SizedBox(),

            (SolutiontableRows3.isNotEmpty) ? pw.SizedBox(height: 25,) : pw.SizedBox(),

            (SolutiontableRows4.isNotEmpty) ?  pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child:pw.Column(
                    children: [
                      pw.Text("Here is what I’m asking $editemployer whether it’s possible to start providing for me: ",
                        style: pw.TextStyle(
                          font: headingfont1,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14, color: PdfColor.fromInt(0xFF4472c4),
                        ),
                      ),
                      pw.SizedBox(height: 10,),

                      ...SolutiontableRows4
                    ]
                )
            ) : pw.SizedBox(),

            (SolutiontableRows5.isNotEmpty) ? pw.SizedBox(height: 25,) : pw.SizedBox(),

            (SolutiontableRows5.isNotEmpty) ?  pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 30),
                child:pw.Column(
                    children: [
                      pw.Text("Here is what I’m asking $editemployer whether it’s possible to start providing for me: ",
                        style: pw.TextStyle(
                          font: headingfont1,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14, color: PdfColor.fromInt(0xFF4472c4),
                        ),
                      ),
                      pw.SizedBox(height: 10,),
                      ...SolutiontableRows5
                    ]
                )
            ) : pw.SizedBox(),

            (SolutiontableRows5.isNotEmpty) ? pw.SizedBox(height: 25,) : pw.SizedBox(),
          ];
        },
        header: (context) {
          return pw.Image(image);
        },
        footer: (context) {
          return pw.Column(
              children: [
                pw.Image(image),
                pw.SizedBox(height: 5,),

                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 30),
                  child:  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text("${name}: for discussion with ${linemanager}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                        pw.SizedBox(width: 70,),

                        pw.Text("${DateFormat('dd MMMM yyyy').format(DateTime.now())}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                        pw.SizedBox(width: 120,),

                        pw.Text("Page ${context.pageNumber} of ${context.pagesCount}",style: pw.TextStyle(font: Reportansfont,fontSize: 10)),

                      ]
                  ),
                ),



                pw.SizedBox(height: 15,),

              ]
          );
        },
      ),
    ) : pw.SizedBox();

    return pdf.save();
  }

  List<pw.Widget> generateCCEmailWidgets(List<Map<String, dynamic>> ccList, pw.Font headingFont, pw.Font bodyFont) {
    List<pw.Widget> widgets = [];

    for (var recipient in ccList) {
      pw.Widget widget = pw.Padding(
        padding: pw.EdgeInsets.only( right: 20),
        child: pw.Container(
          padding: const pw.EdgeInsets.all(2),
          child:  pw.UrlLink(
            destination: 'mailto:${recipient['email']}',
            child: pw.Text(
              recipient['email']!,
              style: pw.TextStyle(
                font: bodyFont,
                color: PdfColors.blue,
                decoration: pw.TextDecoration.underline,
              ),
            ),
          ),
        ),
      );

      widgets.add(widget);
    }

    return widgets;
  }

  List<pw.Widget> generateChallengeWidgets(List<Map<String, dynamic>> dataList,headingfont1,bodyfont1) {
    List<pw.Widget> widgets = [];

    for (var solution in dataList) {


      pw.Widget widget = pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // pw.Padding(
          //   padding: pw.EdgeInsets.only(bottom: 20.0, right: 20,),
          //   child: pw.Row(
          //     children: [
          //       pw.Expanded(
          //         child: pw.RichText(
          //           maxLines: 4,
          //           overflow: pw.TextOverflow.span,
          //           text: pw.TextSpan(
          //             children: [
          //               pw.TextSpan(
          //                 text: ' • ',
          //                 style: pw.TextStyle(
          //                   font: bodyfont1,
          //                 ),
          //               ),
          //               pw.TextSpan(
          //                 text: '${solution['Label']}',
          //                 style: pw.TextStyle(
          //                   font: headingfont1,
          //                   fontWeight: pw.FontWeight.bold,
          //                 ),
          //               ),
          //               pw.TextSpan(
          //                 text: ' - ${solution['Final_description']}\n',
          //                 style: pw.TextStyle(
          //                   fontWeight: pw.FontWeight.normal,
          //                   font: bodyfont1,
          //                 ),
          //               ),
          //               pw.TextSpan(
          //                 text: ' ${solution['Impact_on_me']}',
          //                 style: pw.TextStyle(
          //                     color: PdfColors.grey, font: bodyfont1),
          //               ),
          //             ],
          //           ),
          //         ),),
          //     ],
          //   ),
          // ),


          pw.Padding(
              padding: pw.EdgeInsets.only(bottom: 10.0, right: 20,),
              child: pw.Container(
                // padding: const pw.EdgeInsets.all(8),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('• ',
                      style: pw.TextStyle(
                        font: bodyfont1,
                      ),),
                    // pw.SizedBox(width: 8),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.RichText(
                                  maxLines: 4,
                                  overflow: pw.TextOverflow.span,
                                  text: pw.TextSpan(
                                    children: [
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
                                        text: '${solution['Impact_on_me']}',
                                        style: pw.TextStyle(
                                            color: PdfColors.grey, font: bodyfont1),
                                      ),
                                    ],
                                  ),
                                ),),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              )
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
            // pw.Padding(
            //   padding: pw.EdgeInsets.only(bottom: 10.0, right: 20,),
            //   child: pw.Row(
            //     children: [
            //       pw.Expanded(
            //         child: pw.RichText(
            //           maxLines: 4,
            //           overflow: pw.TextOverflow.span,
            //           text: pw.TextSpan(
            //             children: [
            //               pw.TextSpan(
            //                 text: ' • ',
            //                 style: pw.TextStyle(
            //                   font: bodyfont1,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: '${solution['Label']}',
            //                 style: pw.TextStyle(
            //                   font: headingfont1,
            //                   fontWeight: pw.FontWeight.bold,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: ' - ${solution['Final_description']}\n',
            //                 style: pw.TextStyle(
            //                   fontWeight: pw.FontWeight.normal,
            //                   font: bodyfont1,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: ' ${solution['AboutMe_Notes']}',
            //                 style: pw.TextStyle(
            //                     color: PdfColors.grey, font: bodyfont1),
            //               ),
            //             ],
            //           ),
            //         ),),
            //     ],
            //   ),
            // ),

            pw.Padding(
                padding: pw.EdgeInsets.only(bottom: 10.0, right: 20,),
                child: pw.Container(
                  // padding: const pw.EdgeInsets.all(8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('• ',
                        style: pw.TextStyle(
                          font: bodyfont1,
                        ),),
                      // pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.RichText(
                                    maxLines: 4,
                                    overflow: pw.TextOverflow.span,
                                    text: pw.TextSpan(
                                      children: [
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
                                          text: '${solution['AboutMe_Notes']}',
                                          style: pw.TextStyle(
                                              color: PdfColors.grey, font: bodyfont1),
                                        ),
                                      ],
                                    ),
                                  ),),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                )
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
            // pw.Padding(
            //   padding: pw.EdgeInsets.only(bottom: 10.0, right: 20),
            //   child: pw.Row(
            //     children: [
            //       pw.Expanded(
            //         child: pw.RichText(
            //           maxLines: 4,
            //           overflow: pw.TextOverflow.span,
            //           text: pw.TextSpan(
            //             children: [
            //               pw.TextSpan(
            //                 text: ' • ',
            //                 style: pw.TextStyle(
            //                   font: bodyfont1,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: '${solution['Label']}',
            //                 style: pw.TextStyle(
            //                   font: headingfont1,
            //                   fontWeight: pw.FontWeight.bold,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: ' - ${solution['Final_description']}\n',
            //                 style: pw.TextStyle(
            //                   fontWeight: pw.FontWeight.normal,
            //                   font: bodyfont1,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: ' ${solution['AboutMe_Notes']}',
            //                 style: pw.TextStyle(
            //                     color: PdfColors.grey, font: bodyfont1),
            //               ),
            //             ],
            //           ),
            //         ),),
            //     ],
            //   ),
            // ),

            pw.Padding(
                padding: pw.EdgeInsets.only(bottom: 10.0, right: 20,),
                child: pw.Container(
                  // padding: const pw.EdgeInsets.all(8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('• ',
                        style: pw.TextStyle(
                          font: bodyfont1,
                        ),),
                      // pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.RichText(
                                    maxLines: 4,
                                    overflow: pw.TextOverflow.span,
                                    text: pw.TextSpan(
                                      children: [
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
                                          text: '${solution['AboutMe_Notes']}',
                                          style: pw.TextStyle(
                                              color: PdfColors.grey, font: bodyfont1),
                                        ),
                                      ],
                                    ),
                                  ),),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                )
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
            // pw.Padding(
            //   padding: pw.EdgeInsets.only(bottom: 10.0, right: 20),
            //   child: pw.Row(
            //     children: [
            //       pw.Expanded(
            //         child: pw.RichText(
            //           maxLines: 4,
            //           overflow: pw.TextOverflow.span,
            //           text: pw.TextSpan(
            //             children: [
            //               pw.TextSpan(
            //                 text: ' • ',
            //                 style: pw.TextStyle(
            //                   font: bodyfont1,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: '${solution['Label']}',
            //                 style: pw.TextStyle(
            //                   font: headingfont1,
            //                   fontWeight: pw.FontWeight.bold,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: ' - ${solution['Final_description']}\n',
            //                 style: pw.TextStyle(
            //                   fontWeight: pw.FontWeight.normal,
            //                   font: bodyfont1,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: ' ${solution['AboutMe_Notes']}',
            //                 style: pw.TextStyle(
            //                     color: PdfColors.grey, font: bodyfont1),
            //               ),
            //             ],
            //           ),
            //         ),),
            //     ],
            //   ),
            // ),

            pw.Padding(
                padding: pw.EdgeInsets.only(bottom: 10.0, right: 20,),
                child: pw.Container(
                  // padding: const pw.EdgeInsets.all(8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('• ',
                        style: pw.TextStyle(
                          font: bodyfont1,
                        ),),
                      // pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.RichText(
                                    maxLines: 4,
                                    overflow: pw.TextOverflow.span,
                                    text: pw.TextSpan(
                                      children: [
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
                                          text: '${solution['AboutMe_Notes']}',
                                          style: pw.TextStyle(
                                              color: PdfColors.grey, font: bodyfont1),
                                        ),
                                      ],
                                    ),
                                  ),),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                )
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
            // pw.Padding(
            //   padding: pw.EdgeInsets.only(bottom: 10.0, right: 20),
            //   child: pw.Row(
            //     children: [
            //       pw.Expanded(
            //         child: pw.RichText(
            //           maxLines: 4,
            //           overflow: pw.TextOverflow.span,
            //           text: pw.TextSpan(
            //             children: [
            //               pw.TextSpan(
            //                 text: ' • ',
            //                 style: pw.TextStyle(
            //                   font: bodyfont1,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: '${solution['Label']}',
            //                 style: pw.TextStyle(
            //                   font: headingfont1,
            //                   fontWeight: pw.FontWeight.bold,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: ' - ${solution['Final_description']}\n',
            //                 style: pw.TextStyle(
            //                   fontWeight: pw.FontWeight.normal,
            //                   font: bodyfont1,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: ' ${solution['AboutMe_Notes']}',
            //                 style: pw.TextStyle(
            //                     color: PdfColors.grey, font: bodyfont1),
            //               ),
            //             ],
            //           ),
            //         ),),
            //     ],
            //   ),
            // ),

            pw.Padding(
                padding: pw.EdgeInsets.only(bottom: 10.0, right: 20,),
                child: pw.Container(
                  // padding: const pw.EdgeInsets.all(8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('• ',
                        style: pw.TextStyle(
                          font: bodyfont1,
                        ),),
                      // pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.RichText(
                                    maxLines: 4,
                                    overflow: pw.TextOverflow.span,
                                    text: pw.TextSpan(
                                      children: [
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
                                          text: '${solution['AboutMe_Notes']}',
                                          style: pw.TextStyle(
                                              color: PdfColors.grey, font: bodyfont1),
                                        ),
                                      ],
                                    ),
                                  ),),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                )
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
            // pw.Padding(
            //   padding: pw.EdgeInsets.only(bottom: 10.0, right: 20),
            //   child: pw.Row(
            //     children: [
            //       pw.Expanded(
            //         child: pw.RichText(
            //           maxLines: 2,
            //           overflow: pw.TextOverflow.span,
            //           text: pw.TextSpan(
            //             children: [
            //               pw.TextSpan(
            //                 text: ' • ',
            //                 style: pw.TextStyle(
            //                   font: bodyfont1,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: '${solution['Label']}',
            //                 style: pw.TextStyle(
            //                   font: headingfont1,
            //                   fontWeight: pw.FontWeight.bold,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: ' - ${solution['Final_description']}\n',
            //                 style: pw.TextStyle(
            //                   fontWeight: pw.FontWeight.normal,
            //                   font: bodyfont1,
            //                 ),
            //               ),
            //               pw.TextSpan(
            //                 text: ' ${solution['AboutMe_Notes']}',
            //                 style: pw.TextStyle(
            //                     color: PdfColors.grey, font: bodyfont1),
            //               ),
            //             ],
            //           ),
            //         ),),
            //     ],
            //   ),
            // ),

            pw.Padding(
                padding: pw.EdgeInsets.only(bottom: 10.0, right: 20,),
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('• ',
                        style: pw.TextStyle(
                          font: bodyfont1,
                        ),),
                      // pw.SizedBox(width: 8),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.RichText(
                                    maxLines: 4,
                                    overflow: pw.TextOverflow.span,
                                    text: pw.TextSpan(
                                      children: [
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
                                          text: '${solution['AboutMe_Notes']}',
                                          style: pw.TextStyle(
                                              color: PdfColors.grey, font: bodyfont1),
                                        ),
                                      ],
                                    ),
                                  ),),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                )
            ),
          ],
        );
        widgets.add(widget);
      }
    }

    return widgets;
  }
}