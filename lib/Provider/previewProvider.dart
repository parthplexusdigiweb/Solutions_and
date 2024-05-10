import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool isDuplicate = false;

  void isDuplicatefalse(falsee) {
    isDuplicate = falsee;
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