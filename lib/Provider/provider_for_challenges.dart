import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thrivers/model/challenges_table_model.dart';

class ChallengesProvider with ChangeNotifier{


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


  List<QueryDocumentSnapshot<Object?>>? docssssss;
  final CollectionReference productsCollection = FirebaseFirestore.instance.collection('Challenges');
  List<DocumentSnapshot> challengesdocuments = [];
  QuerySnapshot? querySnapshotsss;


  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  bool showTreeView = false;
  bool showTagView = false;
  bool get getshowTreeView => showTreeView;
  bool get getshowTagView => showTagView;

  int _perPage = 30;
  int currentPage = 1; // Current page number
  int totalPages = 1; // Total number of pages
  var lengthOfdocument;


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

  void loadFirstPage() {
    currentPage = 1;
    _isLoadingMore = true;
    loadDataForPage(currentPage);
    notifyListeners();
  }

  void loadLastPage() {
    currentPage = totalPages;
    _isLoadingMore = true;
    loadDataForPage(currentPage);
    notifyListeners();
  }

  getdatasearch() async {
    print("inside getdatasearch");
    querySnapshotsss = await productsCollection.get();
    docssssss?.clear();
    print("docssssss.clear(): $docssssss");
    docssssss  = await querySnapshotsss?.docs;
    print("docssssss: $docssssss");

  }

  List<QueryDocumentSnapshot<Object?>> allChallenges = [];
  List<String> tagValues = [];
  List<String> categoryValues = [];

   fetchAllChallenges() async {
    try {
      _isLoadingMore = true;

      allChallenges.clear();
      tagValues.clear();
      categoryValues.clear();
      // Fetch all data once when the screen appears
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Challenges').orderBy('id').get();
      allChallenges = querySnapshot.docs;
      print('Fetched ${allChallenges.length} challenges');

      DocumentSnapshot specificDocument = await FirebaseFirestore.instance.collection('Keywords').doc('j8jejx508jAec8WOc2nQ').get();
      DocumentSnapshot specificDocuments = await FirebaseFirestore.instance.collection('Keywords').doc('CUTs7fvcYX2dN9TnDj4c').get();

      if (specificDocument.exists) {
        tagValues = List<String>.from(specificDocument['Values']);
      }
      if (specificDocuments.exists) {
        categoryValues = List<String>.from(specificDocuments['Values']);
      }

     await loadDataForPage(currentPage);
      _isLoadingMore = false;

      // Notify listeners if needed
      // notifyListeners();
    } catch (error) {
      print('Error fetching all challenges: $error');
    }
  }

   loadDataForPage(int page) {
    int startIndex = (page - 1) * _perPage;

    _isLoadingMore = true;

    int totalCount = allChallenges.length;
    print('Total challenges: $totalCount');

    totalPages = (totalCount / _perPage).ceil();
    print('Total totalPages: $totalPages');

    // Handle the case where totalCount is 0
    if (totalCount == 0) {
      challengesdocuments.clear();
      _isLoadingMore = false;
      notifyListeners();
      return;
    }

    // Ensure currentPage does not exceed totalPages
    if (currentPage > totalPages) {
      currentPage = totalPages;
    }

    // Adjust the startIndex to ensure it doesn't exceed totalCount
    if (startIndex >= totalCount) {
      startIndex = (totalCount - 1).clamp(0, totalCount - 1);
    }

    // Load data for the page from the locally stored data
    challengesdocuments.clear();
    challengesdocuments.addAll(allChallenges.sublist(startIndex, (startIndex + _perPage).clamp(0, totalCount)));

    _isLoadingMore = false;
    notifyListeners();
  } /// new this

  void loadDataForPagee(int page) {
    int startIndex = (page - 1) * _perPage;

    _isLoadingMore = true;


    FirebaseFirestore.instance.collection('Challenges')
        .get()
        .then((QuerySnapshot querySnapshot) {
      int totalCount = querySnapshot.docs.length;
      totalPages = (totalCount / _perPage).ceil();

      // Ensure currentPage does not exceed totalPages
      if (currentPage > totalPages) {
        currentPage = totalPages;
      }

      // Adjust the startIndex to ensure it doesn't exceed totalCount
      if (startIndex >= totalCount) {
        startIndex = (totalCount - 1).clamp(0, totalCount - 1);
      }

    FirebaseFirestore.instance
        .collection('Challenges')
        .orderBy('id')
        .startAfter([startIndex]) // Start after the specified document index
        .limit(_perPage)
        .get()
        .then((QuerySnapshot querySnapshot) {
      challengesdocuments.clear();
      challengesdocuments.addAll(querySnapshot.docs);
      _isLoadingMore = false;
      // currentPage = 1;
      notifyListeners();
    }).catchError((error) {
      print('Error loading data for page $page: $error');
      _isLoadingMore = false;
      notifyListeners();
    });
    }).catchError((error) {
      print('Error retrieving document count: $error');
    });
  } /// old this

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

  List<ChallengesModel> selectedChallenges = [];



  Future<void> loadDataForPageSearchFilter(search) async   {
    try {
      // loadDataForPage(1);
      // getdatasearch();
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
        challengesdocuments.clear();
        List<QueryDocumentSnapshot<Object?>>? docssssss = [];
        docssssss?.clear();
        querySnapshotsss = await productsCollection.get();
        print("docssssss.clear(): $docssssss");
        docssssss  = await querySnapshotsss?.docs;
        docssssss?.map((e) => print("eeeee : $e"));
        print("inside loadDataForPageSearchFilter allChallenges : ${allChallenges.length}");
        // final dc = docssssss?.where((element) {
        final dc = allChallenges?.where((element) {
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
        challengesdocuments.addAll(dc!);

        // Notify listeners after a delay to ensure the UI is updated
        Future.delayed(Duration(seconds: 1), () {
          _isLoadingMore = false;
          lengthOfdocument = challengesdocuments.length;
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
        lengthOfdocument = challengesdocuments.length;
        print("length of lengthOfdocument: ${lengthOfdocument}");
        notifyListeners(); // This will trigger UI update if necessary
      });
      notifyListeners();
    }
  }  ///this

  // Future<void> loadDataForPageSearchFilter(search,isall) async {
  //
  //
  //   print("_addKeywordProvider.searchbycategory ${search}");
  //   List<String> keywordsList = [];
  //   if (isall == "Any") {
  //     keywordsList = search.split(" ");
  //   } else {
  //     keywordsList.add(search);
  //   }
  //   print("keywordsList ${keywordsList}");
  //
  //   if (search == "" || search == null) {
  //     loadDataForPage(1);
  //   } else {
  //     _isLoadingMore = true;
  //     documents.clear();
  //
  //     docssssss?.map((e) => print("$e"));
  //     final dc = docssssss?.where((element) {
  //       print("inside provider docssssss ${element.data()}");
  //       var name = element.get("Name").toLowerCase();
  //       var description = element.get("Description").toLowerCase();
  //       if (name.contains(search.toLowerCase())) {
  //         print("inisde provider element name $name and element is $element");
  //         return true;
  //       }
  //       if (description.contains(search.toLowerCase())) {
  //         print("inisde provider element name $description and element is $element");
  //         return true;
  //       }
  //       return false;
  //     }).toList();
  //     documents.addAll(dc!);
  //     _isLoadingMore = false;
  //     notifyListeners();
  //   }
  // }
  Future<void> loadDataForPageSearchFilterold(search, isall) async {
    try {
      // Set isLoading to true when data loading starts
      _isLoadingMore = true;

      print("_challengesProvider.search ${search}");
      List<String> keywordsList = [];
      if (isall == "Any") {
        keywordsList = search.split(" ");
      } else {
        keywordsList.add(search);
      }
      print("keywordsList ${keywordsList}");

      if (search == "" || search == null) {
        loadDataForPage(1);
      } else {
        challengesdocuments.clear();

        docssssss?.map((e) => print("$e"));
        final dc = docssssss?.where((element) {
          // print("inside provider docssssss ${element.data()}");
          var name = element.get("Label").toLowerCase();
          var description = element.get("Description").toLowerCase();
          var originalDescription = element.get("Original Description").toLowerCase();
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

          if (originalDescription.contains(search.toLowerCase())) {
            print("inisde provider element originalDescription $originalDescription ");
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
        challengesdocuments.addAll(dc!);
        Future.delayed(Duration(seconds: 1), () {
          _isLoadingMore = false;
          lengthOfdocument = challengesdocuments.length;
          print("length of documents: ${lengthOfdocument}");

          notifyListeners();
        });
        notifyListeners();
      }
    } catch (error) {
      print('Error loading data: $error');
    } finally {
      // Set isLoading to false when data loading finishes or an error occurs
      Future.delayed(Duration(seconds: 1), () {
        _isLoadingMore = false;
        notifyListeners();
        lengthOfdocument = challengesdocuments.length;
        print("length of documents: ${lengthOfdocument}");
      });
      notifyListeners();
      // _isLoadingMore = false;
      // notifyListeners();
    }
  }

  void loadDataForPageFilter(int page, String mainkey,  keywordArray) {
    _isLoadingMore = true;

    if (keywordArray.isEmpty) {
      loadDataForPage(1);
    } else {
      final filteredDocuments = allChallenges.where((element) {
        var fieldValue = element.get(mainkey).toString().toLowerCase();
        return keywordArray.any((keyword) => fieldValue.contains(keyword.toLowerCase()));
      }).toList();

      challengesdocuments.clear();
      challengesdocuments.addAll(filteredDocuments);

      Future.delayed(Duration(seconds: 1), () {
        _isLoadingMore = false;
        lengthOfdocument = challengesdocuments.length;
        print("length of documents: ${lengthOfdocument}");
        notifyListeners();
      });
    }
  } /// new this

  void loadDataForPageFilterr(int page,mainkey, keywordArray) {

    _isLoadingMore = true;

    int startIndex = (page - 1) * _perPage;

    print("_addKeywordProvider.searchbycategory ${keywordArray}");
    print("mainkey ${mainkey}");


    if(keywordArray.length == 0){
      loadDataForPage(1);
    }else {
      FirebaseFirestore.instance.collection('Challenges').orderBy('id').where(mainkey, arrayContainsAny: keywordArray)
      // .where(mainkey, arrayContains: keywordArray)
      // .startAfter([1])
      // .limit(_perPage)
          .get().then((QuerySnapshot querySnapshot) {
        // print("querySnapshot.docs ${querySnapshot.docs}");
        challengesdocuments.clear();
        challengesdocuments.addAll(querySnapshot.docs);
        Future.delayed(Duration(seconds: 1), () {
          _isLoadingMore = false;
          lengthOfdocument = challengesdocuments.length;
          print("length of documents: ${lengthOfdocument}");
          notifyListeners(); // This will trigger UI update if necessary
        });
        notifyListeners();
      }).catchError((error) {
        print('Error loading data for page $page: $error');
        Future.delayed(Duration(seconds: 1), () {
          _isLoadingMore = false;
          lengthOfdocument = challengesdocuments.length;
          print("length of documents: ${lengthOfdocument}");
          notifyListeners(); // This will trigger UI update if necessary
        });
        notifyListeners();
      });
    }
  }  /// old this

  List<Widget> tagsnodes = [];
  List<Widget> categorynodes = [];

  void filterChallengesByTags(ViewChallengesDialog,showEditChallengesDialogBox) {

    tagsnodes.clear();

    for (var tag in tagValues) {
      List<Widget> thriverNodes = [];

      for (var document in allChallenges) {
        if (document['tags'].contains(tag)) {
          String thriverName = document['Label'];
          thriverNodes.add(
            ListTile(
              title: Text(thriverName, style: TextStyle(color: Colors.black)),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      ViewChallengesDialog(
                        document.reference,
                        document.id,
                        document['Label'],
                        document['Description'],
                        document['Category'],
                        document['Keywords'],
                        document['Created Date'],
                        document['Created By'],
                        document['tags'],
                        document['Modified By'],
                        document['Modified Date'],
                        document['id'],
                      );
                    },
                    child: Icon(Icons.visibility),
                  ),
                  SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      showEditChallengesDialogBox(
                        document.reference,
                        document.id,
                        document['Label'],
                        document['Description'],
                        document['Category'],
                        document['Keywords'],
                        document['Created Date'],
                        document['Created By'],
                        document['tags'],
                        document['Modified By'],
                        document['Modified Date'],
                        document['id'],
                        document['Linked_solutions'],
                      );
                    },
                    child: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          );
        }
      }

      if (thriverNodes.isNotEmpty) {
        tagsnodes.add(
          ExpansionTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text("$tag (${thriverNodes.length})", style: TextStyle(color: Colors.black)),
            children: thriverNodes,
          ),
        );
      }
    }

    notifyListeners();
  }

  void filterChallengesByCategory(ViewChallengesDialog,showEditChallengesDialogBox) {


    categorynodes.clear();

    for (var tag in categoryValues) {
      List<Widget> thriverNodes = [];

      for (var document in allChallenges) {
        if (document['Keywords'].contains(tag)) {
          String thriverName = document['Label'];
          thriverNodes.add(
            ListTile(
              title: Text(thriverName, style: TextStyle(color: Colors.black)),
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      ViewChallengesDialog(
                        document.reference,
                        document.id,
                        document['Label'],
                        document['Description'],
                        document['Category'],
                        document['Keywords'],
                        document['Created Date'],
                        document['Created By'],
                        document['tags'],
                        document['Modified By'],
                        document['Modified Date'],
                        document['id'],
                      );
                    },
                    child: Icon(Icons.visibility),
                  ),
                  SizedBox(width: 15),
                  InkWell(
                    onTap: () {
                      showEditChallengesDialogBox(
                        document.reference,
                        document.id,
                        document['Label'],
                        document['Description'],
                        document['Category'],
                        document['Keywords'],
                        document['Created Date'],
                        document['Created By'],
                        document['tags'],
                        document['Modified By'],
                        document['Modified Date'],
                        document['id'],
                        document['Linked_solutions'],
                      );
                    },
                    child: Icon(Icons.edit),
                  ),
                ],
              ),
            ),
          );
        }
      }

      if (thriverNodes.isNotEmpty) {
        categorynodes.add(
          ExpansionTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text("$tag (${thriverNodes.length})", style: TextStyle(color: Colors.black)),
            children: thriverNodes,
          ),
        );
      }
    }

    notifyListeners();
  }

  int currentToggleIndex = 0;

  indexValue (index) {
  currentToggleIndex = index;
  notifyListeners();
  }

  listView(){
  showTreeView = false;
  showTagView = false;
  currentToggleIndex = 0;
  notifyListeners();
  }

  TagView(){
    showTagView = true;
    showTreeView = false;
  currentToggleIndex = 1;
  notifyListeners();
  }

  CategoryView(){
    showTreeView = true;
    showTagView = false;
  currentToggleIndex = 2;
  notifyListeners();
  }

  void addkeywordsList(tags){
    keywords = tags;
    // notifyListeners();
  }
  void newaddkeywordsList(tags){
    keywords = tags;
    notifyListeners();
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



  void removeList(ind){

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
  List<String> ChallengesSourceItems = [];
  List<String> ChallengesStatusItems = [];

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

    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('Keywords');

      DocumentSnapshot documentSnapshot = await collectionReference.doc("9lN1IMh0ljdVv5qftyTw").get();

      if (documentSnapshot.exists) {
        // Document exists, you can now access the data
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('Values')) {
          List<String> sourceItemsSet = data['Values'].cast<String>();

          ChallengesSourceItems = sourceItemsSet.toList();
          // Now you have the source items based on the document ID
          print("Source Items: $ChallengesSourceItems");
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

  void getChallengesStatus() async{
    String value = "Thriver Status";
    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('Keywords');

      DocumentSnapshot documentSnapshot = await collectionReference.doc("rnAPiVUuPbOuGl1EbaXb").get();

      if (documentSnapshot.exists) {
        // Document exists, you can now access the data
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('Values')) {
          List<String> sourceItemsSet = data['Values'].cast<String>();

          ChallengesStatusItems = sourceItemsSet.toList();
          // Now you have the source items based on the document ID
          print("status Items: $ChallengesStatusItems");
        }
      } else {
        // Document doesn't exist
        print("Document with ID 'rnAPiVUuPbOuGl1EbaXb' doesn't exist.");
      }

      notifyListeners();
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  List<String> newKeyValues = [];

  // Future<void> updateKeyValues(String selectedKey,value) async {
  //   // Call your method to get suggestions for the selected key
  //   List<String> selectedKeyValues = await KeywordServices.getSuggestions(selectedKey, (newselectedValue == null) ? value : newselectedValue);
  //
  //   newKeyValues = selectedKeyValues;
  //
  //   // Notify listeners about the change
  //   notifyListeners();
  // }

  void setSelectedValue(String value) async {
    selectedValue = value;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Keywords').where('Key', isEqualTo: value).get();
      if (querySnapshot.docs.isNotEmpty) {
        List<String> values = querySnapshot.docs.first['Values'].cast<String>();

        // print("values: $values");

        setMultiSelectItems(values);

      } else {
        setMultiSelectItems([]);
      }
    } catch (e) {
      print('Error loading data: $e');
    }

    notifyListeners();
  }

  void setSelectedValueeee(String value) async {
    value = value;


    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Keywords').where('Key', isEqualTo: value).get();
      if (querySnapshot.docs.isNotEmpty) {
        List<String> values = querySnapshot.docs.first['Values'].cast<String>();
        // print("values: $values");
        setMultiSelectItems(values);

      } else {
        setMultiSelectItems([]);
      }
    } catch (e) {
      print('Error loading data: $e');
    }

    notifyListeners();
  }


  void setMultiSelectItems(items) {
    keywordsList = items;
    notifyListeners();
  }


  void setnewMultiSelectItems(items) {
    newKeywordsList = items;

  }



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