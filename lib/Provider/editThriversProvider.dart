import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditThriverProvider with ChangeNotifier {

  List<dynamic> keywords = [];

  void addkeywordsList(List<dynamic>tags){
    keywords = tags;
    notifyListeners();
  }

  void addkeywordschip(tags) {
    if (tags.isNotEmpty && !keywords.contains(tags)) {
      keywords.add(tags);
    }
    notifyListeners();
  }

  void removekeywords(key) {
    keywords.remove(key);
    notifyListeners();
  }

}