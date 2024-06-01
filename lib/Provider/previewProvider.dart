import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

import 'package:thrivers/main.dart';

class PreviewProvider with ChangeNotifier{
  var name, email, employer, division, role, location, employeeNumber, linemanager, title, mycircumstance, mystrength, myorganization, mychallenge;

  List<Map<String, dynamic>> PreviewChallengesList = [];
  List<Map<String, dynamic>> PreviewSolutionList = [];
  List<Map<String, dynamic>> PreviewSolutionMyResposibilty = [];
  List<Map<String, dynamic>> PreviewSolutionStillNeeded = [];
  List<Map<String, dynamic>> PreviewSolutionNotNeededAnyMore = [];
  List<Map<String, dynamic>> PreviewSolutionNiceToHave = [];
  List<Map<String, dynamic>> PreviewSolutionMustHave = [];

  List<String> ccEmails = [];
  List<String> ccNames = [];

  void addCCRecipient(email,name) {
      ccEmails.add(email);
      ccNames.add(name);
      notifyListeners();
  }

  void clearCCRecipient() {
      ccEmails.clear();
      ccNames.clear();
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
  TextEditingController SendNametextController = TextEditingController();


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


  void removeCCRecipient(int index) {
      ccEmails.removeAt(index);
      ccNames.removeAt(index);
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

}