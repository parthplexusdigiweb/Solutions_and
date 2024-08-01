import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AboutMeProvider with ChangeNotifier {
  DocumentSnapshot? _aboutMeDocument;
  String _errorMessage = '';
  bool _isLoading = true;

  DocumentSnapshot? get aboutMeDocument => _aboutMeDocument;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchAboutMeDocument(String adminName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('AboutMe')
          .where('AB_Status', isEqualTo: "main")
          .where("Email", isEqualTo: adminName)
          .orderBy('AB_id', descending: true)
          .limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        _aboutMeDocument = querySnapshot.docs.first;
      } else {
        _errorMessage = "No docs found, logout and relogin to this portal";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
