

import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:thrivers/screens/addthriverscreen.dart';

class AddKeywordProvider with ChangeNotifier{


  var  key, category;
  var suggestion;
  List<dynamic> chips = [];
  List<dynamic> editkeywords = [];
  List<dynamic> keywords = [];
  List<dynamic> ProviderTags = [];
  List<dynamic> ProviderEditTags = [];
  List<dynamic> keywordsssss = [];
  List<dynamic> searchbycategory = [];
  List<dynamic> searchbytag = [];




  void addkeywordsList(tags){
    keywords = tags;
    // notifyListeners();
  }
  void newaddkeywordsList(tags){
    keywords = tags;
    notifyListeners();
  }

  List<QueryDocumentSnapshot<Object?>>? docssssss;
  final CollectionReference productsCollection = FirebaseFirestore.instance.collection('Thrivers');
  List<DocumentSnapshot> documents = [];
  QuerySnapshot? querySnapshotsss;
 var lengthOfdocument;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  int _perPage = 10;
  int currentPage = 1; // Current page number
  int totalPages = 31; // Total number of pages

  void loadNextPage() {
    if (currentPage < totalPages) {
        currentPage++;
        _isLoadingMore = true;
      loadDataForPage(currentPage);
      notifyListeners();
    }
  }

  void loadPreviousPage() {
    if (currentPage > 1) {
        currentPage--;
        _isLoadingMore = true;
      loadDataForPage(currentPage);
      notifyListeners();
    }
  }


  getdatasearch() async {
    querySnapshotsss = await productsCollection.get();
    docssssss  = querySnapshotsss?.docs;
    // print("docssssss: $docssssss");
  }

  void loadDataForPage(int page) {
    int startIndex = (page - 1) * _perPage;

    _isLoadingMore = true;

    FirebaseFirestore.instance
        .collection('Thrivers')
        .orderBy('id')
        .startAfter([startIndex]) // Start after the specified document index
        .limit(_perPage)
        .get()
        .then((QuerySnapshot querySnapshot) {
        documents.clear();
        documents.addAll(querySnapshot.docs);
        _isLoadingMore = false;
        // currentPage = 1;
        notifyListeners();
    }).catchError((error) {
      print('Error loading data for page $page: $error');
      _isLoadingMore = false;
      notifyListeners();
    });
  }

  void setFirstpageNo(){
    currentPage = 1;
    notifyListeners();
  }

  var searchAllAny = ["All","Any"];

  var selectAllAny = "All";

  updateselectAllAny(value,search){
    selectAllAny = value;
    loadDataForPageSearchFilter(search);
    notifyListeners();
  }


  Future<void> loadDataForPageSearchFilter(search) async   {
    try {
      _isLoadingMore = true;

      print("_addKeywordProvider.searchbycategory ${search}");
      List<String> keywordsList = [];
      if (selectAllAny == "Any") {
        keywordsList = search.split(" ");
      } else {
        keywordsList.add(search);
      }
      print("keywordsList ${keywordsList}");

      if (search.isEmpty) {
        loadDataForPage(1);
      } else {
        documents.clear();

        docssssss?.map((e) => print("docsssssseeeee $e"));
        final dc = docssssss?.where((element) {
          var name = element.get("Label").toLowerCase();
          var description = element.get("Description").toLowerCase();
          var tags = element.get('tags').toString().toLowerCase();
          var category = element.get('Keywords').toString().toLowerCase();

          // Check if selectAllAny is "All"
          if (selectAllAny == "All") {
            return name.contains(search.toLowerCase()) ||
                description.contains(search.toLowerCase()) ||
                tags.contains(search.toLowerCase()) ||
                category.contains(search.toLowerCase());
          } else {
            // Otherwise, search for individual words
            return keywordsList.any((keyword) =>
            name.contains(keyword.toLowerCase()) ||
                description.contains(keyword.toLowerCase()) ||
                tags.contains(keyword.toLowerCase()) ||
                category.contains(keyword.toLowerCase()));
          }
        }).toList();
        documents.addAll(dc!);

        // Notify listeners after a delay to ensure the UI is updated
        Future.delayed(Duration(seconds: 1), () {
          _isLoadingMore = false;
          lengthOfdocument = documents.length;
          print("length of lengthOfdocument: ${lengthOfdocument}");
          notifyListeners();
        });
        notifyListeners();

      }
    } catch (error) {
      print('Error loading data: $error');
    } finally {
      // Notify listeners after a delay to ensure the UI is updated
      Future.delayed(Duration(seconds: 1), () {
        _isLoadingMore = false;
        lengthOfdocument = documents.length;
        print("length of lengthOfdocument: ${lengthOfdocument}");
        notifyListeners(); // This will trigger UI update if necessary
      });
      notifyListeners();
    }
  }


  Future<void> loadDataForPageSearchFilterold(search, isAll) async {
    try {

      _isLoadingMore = true;

      print("_addKeywordProvider.searchbycategory ${search}");
      List<String> keywordsList = [];
      if (isAll == "Any") {
        keywordsList = search.split(" ");
      } else {
        keywordsList.add(search);
      }
      print("keywordsList ${keywordsList}");

      if (search == "" || search == null) {
        loadDataForPage(1);
      } else {
        documents.clear();

        docssssss?.map((e) => print("$e"));
        final dc = docssssss?.where((element) {
          var name = element.get("Label").toLowerCase();
          var description = element.get("Description").toLowerCase();
          var tags = element.get('tags').toString().toLowerCase();
          var category = element.get('Keywords').toString().toLowerCase();
          if (name.contains(search.toLowerCase())) {
            print("inisde provider element name ${name}");
            return true;
          }
          if (description.contains(search.toLowerCase())) {
            print("inisde provider element description $description ");
            return true;
          }
          if (tags.contains(search.toLowerCase())) {
            print("inisde provider element tags $tags ");
            return true;
          }
          if (category.contains(search.toLowerCase())) {
            print("inisde provider element category $category ");
            return true;
          }
          return false;
        }).toList();
        documents.addAll(dc!);

        Future.delayed(Duration(seconds: 1), () {
          _isLoadingMore = false;
          lengthOfdocument = documents.length;
          print("length of lengthOfdocument: ${lengthOfdocument}");

          notifyListeners();
        });
        notifyListeners();
      }
    } catch (error) {
      print('Error loading data: $error');
    } finally {
      Future.delayed(Duration(seconds: 1), () {
        _isLoadingMore = false;
        lengthOfdocument = documents.length;
        print("length of lengthOfdocument: ${lengthOfdocument}");
        notifyListeners(); // This will trigger UI update if necessary
      });
      notifyListeners();
    }
  }



  void loadDataForPageFilter(int page,mainkey, keywordArray) {

    _isLoadingMore = true;

    int startIndex = (page - 1) * _perPage;

    print("_addKeywordProvider.searchbycategory ${keywordArray}");
    print("mainkey ${mainkey}");


    if(keywordArray.length == 0){
      loadDataForPage(1);
    }else {
      FirebaseFirestore.instance
          .collection('Thrivers')
          .orderBy('id')
          .where(mainkey, arrayContainsAny: keywordArray)
          // .where(mainkey, arrayContains: keywordArray)
      // .startAfter([1])
      // .limit(_perPage)
          .get()
          .then((QuerySnapshot querySnapshot) {
          // print("querySnapshot.docs ${querySnapshot.docs}");
          documents.clear();
          documents.addAll(querySnapshot.docs);
          lengthOfdocument = documents.length;
          print("length of documents: ${lengthOfdocument}");
          Future.delayed(Duration(seconds: 1), () {
            _isLoadingMore = false;
            notifyListeners();
          });
          notifyListeners();
      }).catchError((error) {
        print('Error loading data for page $page: $error');
        Future.delayed(Duration(seconds: 1), () {
          _isLoadingMore = false;
          notifyListeners(); // This will trigger UI update if necessary
        });
        notifyListeners();
      });
    }
  }


  void addProviderEditTagsList(tags){
    ProviderEditTags = tags;
    // notifyListeners();
  }
  void newaddProviderEditTagsList(tags){
    ProviderEditTags = tags;
    notifyListeners();
  }

  void keywordsssssclear(){
    keywordsssss.removeRange(0, keywordsssss.length);
    notifyListeners();
  }
  void ProviderTagsclear(){
    ProviderTags.removeRange(0, ProviderTags.length);
    notifyListeners();
  }

  void addtags(text,tags) {

    if (text.isNotEmpty && !tags.contains(text)) {
      // print("Before add: tags");

      tags.add(text);

      // print("After add : $tags");

      // text.clear();
    }
    notifyListeners();
  }


  void addChip(tags) {
    if (tags.isNotEmpty && !chips.contains(tags)) {
        chips.add(tags);
    }
    notifyListeners();
  }

  void addkeywordschip(tags,keys) {
    if (tags.isNotEmpty && !keys.contains(tags)) {
      // print("Before add: $keys");
      keys.add(tags);
      // print("After add : $keys");
    }
    notifyListeners();
  }

  void editaddKeywords(keywords) {
    if (keywords.isNotEmpty && !editkeywords.contains(keywords)) {
      editkeywords.add(keywords);
    }
    notifyListeners();
  }

  void updateSuggetion(sss) {
    if(sss != null){
      suggestion = sss;
      notifyListeners();
    }
  }

  void updatesearch(search) {
    searchbycategory = search;
    notifyListeners();
  }

  void remove(key) {
    chips.remove(key);
    notifyListeners();
  }

  void removekeywords(item) {
    // print("Before removal: $keywords");
    keywords.remove(item);
    // newKeywordsList.remove(item);

    // print("After removal: $keywords");
    notifyListeners();
  }

  void removetags(item) {
    // print("Before removal: $ProviderTags");
    ProviderTags.remove(item);
    // print("After removal: $ProviderTags");
    notifyListeners();
  }
  void removesearchtags(item) {
    // print("Before removal: $searchbytag");
    searchbytag.remove(item);
    // print("After removal: $searchbytag");
    notifyListeners();
  }
  void removesearchcat(item) {
    // print("Before removal: $searchbycategory");
    searchbycategory.remove(item);
    // print("After removal: $searchbycategory");
    notifyListeners();
  }

  void removeedittags(item) {
    // print("Before removal: $ProviderEditTags");
    ProviderEditTags.remove(item);
    // print("After removal: $ProviderEditTags");
    notifyListeners();
  }

  void editremovekeywords(key) {
    editkeywords.remove(key);
    notifyListeners();
  }

  List<String> dropdownItems = [];
  List<String> sourceItems = [];
  List<String> ThriversStatusItems = [];

  List<String> keywordsList = [];
  // List<String> editKeywordsList = [];

  var newKeywordsList = [];

  // var editNewKyewordsList = [];

  var selectedValue, selectedValueeeee;

  var newvalue, selectsourceItems, selectThriversStatusItems;

  var newselectedValue;


  // void loadExistingData(String documentId) async {
  //   try {
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Keywords').doc(documentId).get();
  //
  //     if (snapshot.exists) {
  //       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //
  //       print("fenil data: $data");
  //       category = data['Key'];
  //       keywords = List.from(data['Values']);
  //       print("fenil keywords: $keywords");
  //       print("fenil key: $key");
  //
  //     }
  //   } catch (e) {
  //     print('Error loading existing data: $e');
  //   }
  //   notifyListeners();
  // }

  void getcategoryAndKeywords () async{
    try{
      QuerySnapshot querySnapshot  = await FirebaseFirestore.instance.collection('Keywords').get();

      dropdownItems = querySnapshot.docs.map((doc) => doc['Key'].toString()).toList();

      notifyListeners();
    }
    catch (e){
      print('Error loading data: $e');
    }
  }


  void getSource() async{
    String value = "Source";
    // try {
    //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Keywords').get();
    //
    //   print("querySnapshot ${querySnapshot}");
    //
    //   for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
    //     dynamic data = snapshot.data();
    //
    //
    //     if (data != null && data.containsKey('Key')) {
    //       String key = data['Key'].toString().toLowerCase();
    //
    //       if (key.contains(selectedValue.toLowerCase())) {
    //         // If the key matches, retrieve and add its values
    //         List<String> values = data.containsKey('Values') ? data['Values'].cast<String>() : [];
    //         print("matches $matches");
    //         print(" values $values");
    //
    //         if (key == selectedValue?.toLowerCase()) {
    //           // Add only the values for the selected key
    //           matches.addAll(values);
    //           print("matches ${matches}");
    //
    //         }
    //       }
    //     }
    //   }
    // } catch (e) {
    //   print("Error getting suggestions: $e");
    // }
    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('Keywords');

      QuerySnapshot querySnapshot = await collectionReference.limit(10).get();

      Set<String> sourceItemsSet = {};

      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        dynamic data = snapshot.data();

        if (data != null && data.containsKey('Key')) {
          String key = data['Key'].toString().toLowerCase();

          if (key.contains(value.toLowerCase())) {

            List<String> values = data.containsKey('Values') ? data['Values'].cast<String>() : [];

            sourceItemsSet.addAll(values);

          }
        }
      }

      // Convert the set to a list if needed
      sourceItems = sourceItemsSet.toList();

      notifyListeners();
    } catch (error) {
      print("Error fetching data: $error");
    }

  }

  void newgetSource() async {
    String value = "Source";

    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('Keywords');

      DocumentSnapshot documentSnapshot = await collectionReference.doc("TPhgk0obP8mRlptK92IG").get();

      if (documentSnapshot.exists) {
        // Document exists, you can now access the data
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('Values')) {
          List<String> sourceItemsSet = data['Values'].cast<String>();

          sourceItems = sourceItemsSet.toList();
          // Now you have the source items based on the document ID
          print("Source Items: $sourceItems");
        }
      } else {
        // Document doesn't exist
        print("Document with ID 'your_document_id' doesn't exist.");
      }

      notifyListeners();
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  void getThriversStatus() async{
    String value = "Thriver Status";
    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('Keywords');

      QuerySnapshot querySnapshot = await collectionReference.get();

      // Use a Set to store unique values
      Set<String> sourceItemsSet = {};

      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        dynamic data = snapshot.data();

        if (data != null && data.containsKey('Key')) {
          String key = data['Key'].toString().toLowerCase();

          if (key.contains(value.toLowerCase())) {
            // If the key matches, retrieve and add its values
            List<String> values = data.containsKey('Values') ? data['Values'].cast<String>() : [];

            // Add all values to sourceItemsSet
            sourceItemsSet.addAll(values);


          }
        }
      }
      // print("sourceItems matches $sourceItemsSet");

      // Convert the set to a list if needed
      ThriversStatusItems = sourceItemsSet.toList();

      notifyListeners();
    } catch (error) {
      print("Error fetching data: $error");
    }

  }

  void newgetThriversStatus() async{
    String value = "Thriver Status";
    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('Keywords');

      DocumentSnapshot documentSnapshot = await collectionReference.doc("Nje6IpKZ4c3Gh0gNavUo").get();

      if (documentSnapshot.exists) {
        // Document exists, you can now access the data
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('Values')) {
          List<String> sourceItemsSet = data['Values'].cast<String>();

          ThriversStatusItems = sourceItemsSet.toList();
          // Now you have the source items based on the document ID
          print("status Items: $ThriversStatusItems");
        }
      } else {
        // Document doesn't exist
        print("Document with ID 'Nje6IpKZ4c3Gh0gNavUo' doesn't exist.");
      }

      notifyListeners();
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  List<String> newKeyValues = [];












   Future<void> addKeyword(context ,String key, List<dynamic> values) async {
    try {
      await FirebaseFirestore.instance.collection('Keywords').add({
        'Key': key,
        'Values': values,
      });
      showSuccessAlert(context, "Keyword added\nsuccessfully!");
      print('Keyword added successfully!');
    } catch (e) {
      showErrorAlert(context,"Error adding keywords!!");
      print('Error adding keyword: $e');
    }
  }

   Future<void> updateKeyword(context,String documentId, String newKey, List<dynamic> newValues) async {
    try {
      await FirebaseFirestore.instance.collection('Keywords').doc(documentId).update({
        'Key': newKey,
        'Values': newValues,
      });

      showSnackBar(context, 'Keyword updated successfully!', Colors.green);
      print('Keyword updated successfully!');
    } catch (e) {
      print('Error updating keyword: $e');
      showSnackBar(context, 'Error updating keyword', Colors.red);
    }
  }

   Future<void> deleteKeyword(context, String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('Keywords').doc(documentId).delete();
      showSnackBar(context, 'Keyword deleted successfully!', Colors.green);

      print('Keyword deleted successfully!');
    } catch (e) {
      print('Error deleting keyword: $e');
      showSnackBar(context, 'Error deleted keyword', Colors.red);

    }
  }

  //  Future<void> getKeyword(String documentId) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('Keywords').doc(documentId).get();
  //
  //
  //     print('Keyword getted successfully!');
  //   } catch (e) {
  //     print('Error deleting keyword: $e');
  //   }
  // }

  void showSuccessAlert(context,message) {
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
                        Icon(Icons.check_circle_rounded ,color: Colors.green,size: 60,),
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

  void showErrorAlert(context,message) {
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

  void showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 3), // Adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}

