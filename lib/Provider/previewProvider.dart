import 'package:flutter/material.dart';

class PreviewProvider with ChangeNotifier{
  var name, email, employer, division, role, location, employeeNumber, linemanager, title, mycircumstance, mystrength, myorganization, mychallenge;

  List<Map<String, dynamic>> PreviewChallengesList = [];
  List<Map<String, dynamic>> PreviewSolutionList = [];


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