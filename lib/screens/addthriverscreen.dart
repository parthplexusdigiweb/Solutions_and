import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_tree/flutter_tree.dart';


import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import 'package:thrivers/Provider/AddKeywordsProvider.dart';
import 'package:thrivers/screens/addthriverscreen.dart';
import '../Network/FirebaseApi.dart';
import '../core/apphelper.dart';
import '../core/constants.dart';
import '../core/progress_dialog.dart';
import 'addthriverscreen.dart';

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}

class AddThriversScreen extends StatefulWidget {
  var AdminName;

  AddThriversScreen({this.AdminName});

  @override
  State<AddThriversScreen> createState() => _AddThriversScreenState();
}

class _AddThriversScreenState extends State<AddThriversScreen> {

  CollectionReference thriversCollection = FirebaseFirestore.instance.collection('Thrivers');

  // MultiSelectControllerller<String> controller = MultiSelectController();
  // MultiSelectController<String> newcontroller = MultiSelectController();

  var selectedValue; // Variable to store the selected value

  List<Map> dataItems = [];
  List<DocumentSnapshot> documentss = [];

  List<String> listOfUserToAdd = [];
  TextEditingController thriverNameTextEditingController = TextEditingController();
  TextEditingController editthriverNameTextEditingController = TextEditingController();
  TextEditingController editthriverDescTextEditingController = TextEditingController();
  TextEditingController thriverDescTextEditingController = TextEditingController();
  TextEditingController catergoryTextEditingController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController originaltextEditingController = TextEditingController();
  TextEditingController editoriginaltextEditingController = TextEditingController();
  TextEditingController finaltextcontroller = TextEditingController();
  TextEditingController editfinaltextcontroller = TextEditingController();
  TextEditingController Impacttextcontroller = TextEditingController();
  TextEditingController editImpacttextcontroller = TextEditingController();
  TextEditingController Notestextcontroller = TextEditingController();
  TextEditingController editNotestextcontroller = TextEditingController();
  TextEditingController subcategoryTextEditingController = TextEditingController();
  TextEditingController challangesTextEditingController = TextEditingController();
  TextEditingController solutionsTextEditingController = TextEditingController();
  TextEditingController countryTextEditingController = TextEditingController();
  TextEditingController industryTextEditingController = TextEditingController();
  List<Widget> nodes = [];

  List<String> categories = [];

  String? userAccountSearchErrorText;
  var newselectedValue, editsourceValue, editstatusvalue;
  List<dynamic> editKeywordssss = [];
  List<dynamic> edittags = [];
  List<dynamic> Keywordssss = [];
  List<dynamic> tags = [];
  List<dynamic> searchbycat = [];




  String searchText = '';
  TextEditingController searchTextEditingController = TextEditingController();
  TextEditingController searchTextbyCKEditingController = TextEditingController();


  List<String> suggestions = [];



  List<String> mySelectedUsers = [];

  List<DocumentReference> challengesDocRefs = [];
  List<DocumentReference> solutionsDocRefs = [];

  bool showTreeView = false;

  static List<Animal> _animals = [];
  final _items = _animals
      .map((animal) => MultiSelectItem<Animal>(animal, animal.name))
      .toList();
  //List<Animal> _selectedAnimals = [];
  List<Animal> _selectedAnimals2 = [];
  List<Animal> _selectedAnimals3 = [];
  //List<Animal> _selectedAnimals4 = [];
  List<Animal> _selectedAnimals5 = [];

  List<Map<String, dynamic>> treeListData = [];


  List<Map<String, dynamic>> initialTreeData = [];

  List<String> challanges = [];
  List<String> solutions = [];
  List<DocumentReference> challangeDocRefs = [];


  List<String> fieldNames = [];
  List<String> selectedFieldNames = [];
  List<String> categoriesStringList = [];
  List<String> subcategories = [];

  QuillController _controller = QuillController.basic();
  QuillController _editcontroller = QuillController.basic();

  TextEditingController addDetailsController = TextEditingController();


  TextEditingController tagscontroller = TextEditingController();
  TextEditingController edittagscontroller = TextEditingController();
  TextEditingController editcategorycontroller = TextEditingController();
  TextEditingController keywordscontroller = TextEditingController();
  TextEditingController searchbyCatcontroller = TextEditingController();
  TextEditingController searchbyTagcontroller = TextEditingController();
  late final AddKeywordProvider _addKeywordProvider;

  DocumentSnapshot? _lastDocument;
  var _lastindex =0;

  bool _isLoadingMore = false;
  int _perPage = 10;



  var openAiApiKeyFromFirebase;

  var _openAI;

  var relatedSolutionlength;




  // Function to load data for a specific page
  // void _loadDataForPage(int page) {
  //   int startIndex = (page - 1) * _perPage;
  //
  //   _isLoadingMore = true;
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
  //       _isLoadingMore = false;
  //     });
  //   }).catchError((error) {
  //     print('Error loading data for page $page: $error');
  //     setState(() {
  //       _isLoadingMore = false;
  //     });
  //   });
  // }
///
//   void _loadDataForPageFilter(int page,mainkey, keywordArray) {
//     int startIndex = (page - 1) * _perPage;
//
//     print("_addKeywordProvider.searchbycategory ${keywordArray}");
//     print("mainkey ${mainkey}");
//
//
//     if(keywordArray.length == 0){
//       _loadDataForPage(1);
//     }else {
//       FirebaseFirestore.instance
//           .collection('Thrivers')
//           .orderBy('id')
//           .where(mainkey, arrayContainsAny: keywordArray)
//       // .startAfter([1])
//       // .limit(_perPage)
//           .get()
//           .then((QuerySnapshot querySnapshot) {
//         setState(() {
//           // print("querySnapshot.docs ${querySnapshot.docs}");
//           documents.clear();
//           documents.addAll(querySnapshot.docs);
//           _isLoadingMore = false;
//         });
//       }).catchError((error) {
//         print('Error loading data for page $page: $error');
//         setState(() {
//           _isLoadingMore = false;
//         });
//       });
//     }
//   }
///
  // void _loadDataForPageSearchFilter(search,isall) {
  //   // int startIndex = (page - 1) * _perPage;
  //
  //   print("_addKeywordProvider.searchbycategory ${search}");
  //   List<String> keywordsList =[];
  //   if(isall == "Any"){
  //    keywordsList = search.split(" ");
  //   }else{
  //     keywordsList.add(search);
  //   }
  //   print("keywordsList ${keywordsList}");
  //
  //
  //   if(search == "" || search == null ){
  //     _loadDataForPage(1);
  //   }else {
  //     FirebaseFirestore.instance
  //         .collection('Thrivers')
  //         // .where('Keywords', arrayContainsAny: keywordsList)
  //
  //     // .where('Label', arrayContainsAny: keywordsList)
  //     // .where('Description', arrayContainsAny: keywordsList)
  //     // .where('Category', arrayContainsAny: keywordsList)
  //     // .where('tags', arrayContainsAny: keywordsList)
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       print("querySnapshot.docs keywords ${querySnapshot.docs}");
  //       // documents.clear();
  //       // documents.addAll(querySnapshot.docs);
  //       // _isLoadingMore = false;
  //       print("inside keywords");
  //
  //       // Process the query results
  //       // Here you can access the documents returned by the query
  //     })
  //         .catchError((error) {
  //       // Handle errors
  //       print('Error: $error');
  //     });
  //
  //     FirebaseFirestore.instance
  //         .collection('Thrivers')
  //     // .where('Keywords', arrayContainsAny: keywordsList)
  //         .where('Label', isGreaterThanOrEqualTo: search)
  //         .where('Label', isLessThan: search + 'z')
  //     // .where('Description', arrayContainsAny: keywordsList)
  //     // .where('Category', arrayContainsAny: keywordsList)
  //     // .where('tags', arrayContainsAny: keywordsList)
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       print("querySnapshot.docs name ${querySnapshot.docs}");
  //       documents.addAll(querySnapshot.docs);
  //       print("inside Label");
  //
  //       // Process the query results
  //       // Here you can access the documents returned by the query
  //     })
  //         .catchError((error) {
  //       // Handle errors
  //       print('Error: $error');
  //     });
  //
  //     FirebaseFirestore.instance
  //         .collection('Thrivers')
  //     // .where('Keywords', arrayContainsAny: keywordsList)
  //     // .where('Label', arrayContainsAny: keywordsList)
  //     // .where('Description', arrayContainsAny: keywordsList)
  //         .where('Description', isGreaterThanOrEqualTo: search)
  //         .where('Description', isLessThan: search + 'z')
  //     // .where('Category', arrayContainsAny: keywordsList)
  //     // .where('tags', arrayContainsAny: keywordsList)
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       print("querySnapshot.docs Description ${querySnapshot.docs}");
  //       documents.addAll(querySnapshot.docs);
  //       print("inside Description");
  //
  //       // Process the query results
  //       // Here you can access the documents returned by the query
  //     })
  //         .catchError((error) {
  //       // Handle errors
  //       print('Error: $error');
  //     });
  //
  //     FirebaseFirestore.instance
  //         .collection('Thrivers')
  //     // .where('Keywords', arrayContainsAny: keywordsList)
  //     // .where('Label', arrayContainsAny: keywordsList)
  //     // .where('Description', arrayContainsAny: keywordsList)
  //         .where('Original Description', isGreaterThanOrEqualTo: search)
  //         .where('Original Description', isLessThanOrEqualTo: search + '\uf8ff')
  //     // .where('tags', arrayContainsAny: keywordsList)
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       print("querySnapshot.docs Original Description ${querySnapshot.docs}");
  //       documents.addAll(querySnapshot.docs);
  //       print("inside Original Description");
  //
  //       // Process the query results
  //       // Here you can access the documents returned by the query
  //     })
  //         .catchError((error) {
  //       // Handle errors
  //       print('Error: $error');
  //     });
  //
  //     FirebaseFirestore.instance
  //         .collection('Thrivers')
  //     // .where('Keywords', arrayContainsAny: keywordsList)
  //     // .where('Label', arrayContainsAny: keywordsList)
  //     // .where('Description', arrayContainsAny: keywordsList)
  //     // .where('Category', arrayContainsAny: keywordsList)
  //         .where('tags', arrayContainsAny: keywordsList)
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       // documents.addAll(querySnapshot.docs);
  //       // Process the query results
  //       print("querySnapshot.docs ${querySnapshot.docs}");
  //       print("inside tags");
  //
  //       setState(() {
  //         documents.addAll(querySnapshot.docs);
  //         _isLoadingMore = false;
  //       });
  //       // Here you can access the documents returned by the query
  //     })
  //         .catchError((error) {
  //       // Handle errors
  //       print('Error: $error');
  //     });
  //   }
  //
  // }
  final CollectionReference productsCollection =
  FirebaseFirestore.instance.collection('Thrivers');

  Future<List<DocumentSnapshot>> searchProductsByDescription(String description) async {
    // QuerySnapshot querySnapshot = await productsCollection
    //     .where('Label', isEqualTo: description)
    //     .get();

    String startValue = description;
    String endValue = description + '\uf8ff';

    // Use 'startAt' and 'endAt' to perform a partial match
    QuerySnapshot querySnapshot = await productsCollection// Replace with your collection name

        .get();

    //
    // QuerySnapshot querySnapshot = await productsCollection
    //     .where('Label', isGreaterThanOrEqualTo: description)
    //     .where('Label', isLessThanOrEqualTo: description + '\uf8ff')
    //     .get();
    print("isnide searchProductsByDescription ${querySnapshot.size}");
    return querySnapshot.docs;
  }

  // Future<void> _loadDataForPageSearchFilter(search,isall) async {
  //   print("_addKeywordProvider.searchbycategory ${search}");
  //   List<String> keywordsList =[];
  //   if(isall == "Any"){
  //    keywordsList = search.split(" ");
  //   }else{
  //     keywordsList.add(search);
  //   }
  //   print("keywordsList ${keywordsList}");
  //
  //
  //   if(search == "" || search == null ){
  //     _loadDataForPage(1);
  //   }else {
  //     documents.clear();
  //   // var xyz =  productsCollection.doc();
  //   QuerySnapshot querySnapshot = await productsCollection.get();
  //
  //   final docssssss  = querySnapshot.docs;
  //
  //   docssssss.map((e) => print("$e"));
  //  final dc =  docssssss.where((element) {
  //     print("inside docssssss ${element.data()}");
  //     var name  = element.get("Label").toLowerCase();
  //     var description  = element.get("Description").toLowerCase();
  //     if(name.contains(search.toLowerCase())){
  //       print("inisde element name $name and element is $element");
  //
  //       return true;
  //     }
  //     if(description.contains(search.toLowerCase())){
  //       print("inisde element name $name and element is $element");
  //
  //       return true;
  //     }
  //
  //     return false;
  //   }).toList();
  //   documents.addAll(dc);
  //
  //
  //   }
  //
  // }
/// this is main one ----->>>>>
//   Future<void> _loadDataForPageSearchFilter(search,isall) async {
//     print("_addKeywordProvider.searchbycategory ${search}");
//     List<String> keywordsList =[];
//     if(isall == "Any"){
//      keywordsList = search.split(" ");
//     }else{
//       keywordsList.add(search);
//     }
//     print("keywordsList ${keywordsList}");
//
//
//     if(search == "" || search == null ){
//       // _loadDataForPage(1);
//     }else {
//       documents.clear();
//     // var xyz =  productsCollection.doc();
//
//       // List<QueryDocumentSnapshot<Object?>>? docssssss  = querySnapshotsss?.docs;
//
//     docssssss?.map((e) => print("$e"));
//    final dc =  docssssss?.where((element) {
//       print("inside docssssss ${element.data()}");
//       var name  = element.get("Label").toLowerCase();
//       // var description  = element.get("Description").toLowerCase();
//       if(name.contains(search.toLowerCase())){
//         print("inisde element name $name and element is $element");
//
//         return true;
//       }
//       // if(description.contains(search.toLowerCase())){
//       //   print("inisde element name $description and element is $element");
//       //
//       //   return true;
//       // }
//
//       return false;
//     }).toList();
//     documents.addAll(dc!);
//
// setState(() {
//
// });
//     }
//
//   }
///
   Timer? _debounce;
  String query = "";
  int _debouncetime = 1000;





     // void main() {
  //   // Replace this with your actual Timestamp
  //   Timestamp timestamp = Timestamp(seconds: 1679725311, nanoseconds: 0);
  //
  //   // Convert Timestamp to DateTime
  //   DateTime dateTime = timestamp.toDate();
  //
  //   // Define the desired format
  //   final DateFormat formatter = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z");
  //
  //   // Format the DateTime using the formatter
  //   String formattedDate = formatter.format(dateTime);
  //
  //   print(formattedDate);
  // }
  QuerySnapshot? querySnapshotssss;
  @override
  void initState() {
    super.initState();
    // _fetchFieldNameFromFirebase();
    // loadData();
    getQuestions();
    // Create a QuillController and set initial text
    // KeywordServices();
    newSelectCategories();
    _addKeywordProvider = Provider.of<AddKeywordProvider>(context, listen: false);
    // _addKeywordProvider.getcategoryAndKeywords();
    _addKeywordProvider.newgetSource();
    _addKeywordProvider.newgetThriversStatus();
   getChatgptSettingsApiKey();
    _addKeywordProvider.getdatasearch();
    _addKeywordProvider.lengthOfdocument = null;


    // FirebaseFirestore.instance
    //     .collection('Thrivers')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   setState(() {
    //     _totalPages = (querySnapshot.docs.length / _perPage).ceil();
    //   });
    // });
    _addKeywordProvider.loadDataForPage(_addKeywordProvider.currentPage);
    // main();
// _updateIDS();

  }



  _updateIDS() {
    // Get a reference to the collection
    CollectionReference thriversCollectionRef = FirebaseFirestore.instance.collection('Thrivers');

    // Create a new WriteBatch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Fetch all documents in the collection
    thriversCollectionRef.get().then((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs);
      querySnapshot.docs.forEach((doc) {
        // Extract the ID from the document
        String id = doc['id'];

        print("id: $id");
        // Remove the "TH" prefix from the ID and convert to integer
        int newId = int.parse(id.replaceFirst('TH0', ''));

        // Update the document in the batch
        batch.update(doc.reference, {'id': newId});
      });

      // Commit the batch
      batch.commit().then((_) {
        print('Batch update completed successfully.');
      }).catchError((error) {
        print('Error performing batch update: $error');
      });
    }).catchError((error) {
      print('Error fetching documents: $error');
    });
  }
  List<QueryDocumentSnapshot<Object?>>? docssssss;
  Future<String> getChatgptSettingsApiKey() async {
    String apiKey = "";
    // _addKeywordProvider.querySnapshotsss = await _addKeywordProvider.productsCollection.get();
    // _addKeywordProvider.docssssss  = _addKeywordProvider.querySnapshotsss?.docs;
    querySnapshotssss = await productsCollection.get();
   docssssss  = querySnapshotssss?.docs;

    await FirebaseFirestore.instance.collection('ChatGpt-Settings').doc("OpenAI").get().then((value) {

      // Access the specific field
      apiKey = value['APIKey'];
      openAiApiKeyFromFirebase = apiKey;

      // print("openAiApiKeyFromFirebase :$openAiApiKeyFromFirebase");
      // // Perform the update operation
      _openAI = OpenAI.instance.build(
        // token: OPENAI_API_KEY,
        token: openAiApiKeyFromFirebase,
        baseOption: HttpSetup(
          receiveTimeout: const Duration(
            seconds: 20,
          ),
        ),
        enableLog: true,
      );

    });
    print("openAiApiKeyFromFirebase :$openAiApiKeyFromFirebase");
    return apiKey;

  }

  // _loadMoreData() {
  //   thriversCollection
  //
  //       .orderBy('id') // Sort by ID
  //       .startAfterDocument(
  //       _lastDocument!) // Start after the last document retrieved
  //       .limit(_perPage) // Limit the number of documents retrieved per page
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     // Check if there are more documents available
  //     if (querySnapshot.docs.isNotEmpty) {
  //       // Update the last document retrieved
  //       // Add the new documents to the existing list
  //       setState(() {
  //         _lastDocument = querySnapshot.docs.last;
  //         print("inside load more set last document $_lastDocument");
  //         documents.addAll(querySnapshot.docs);
  //
  //         _isLoadingMore = false;
  //       });
  //     } else {
  //       // No more documents available
  //       print('No more documents to load.');
  //       setState(() {
  //         _isLoadingMore = false;
  //       });
  //     }
  //   })
  //       .catchError((error) {
  //     print('Error loading more data: $error');
  //     setState(() {
  //       _isLoadingMore = false;
  //     });
  //   });
  // }

  // _loadMoreData(page) {
  //   int startIndex = (page - 1) * _perPage;
  //   thriversCollection
  //       .orderBy('id') // Sort by ID
  //       // .startAfterDocument(_lastDocument!) // Start after the last document retrieved
  //       .startAfter([_lastindex]) // Start after the last document retrieved
  //       .limit(_perPage) // Limit the number of documents retrieved per page
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     // Check if there are more documents available
  //     if (querySnapshot.docs.isNotEmpty) {
  //       // Update the last document retrieved
  //       _lastDocument = querySnapshot.docs.last['id'];
  //       print("inside load more set last document $_lastDocument");
  //
  //       // Update the documents list with the newly fetched documents
  //       setState(() {
  //         documents.addAll(querySnapshot.docs);
  //         _isLoadingMore = false;
  //       });
  //     } else {
  //       // No more documents available
  //       print('No more documents to load.');
  //       setState(() {
  //         _isLoadingMore = false;
  //       });
  //     }
  //   })
  //       .catchError((error) {
  //     print('Error loading more data: $error');
  //     setState(() {
  //       _isLoadingMore = false;
  //     });
  //   });
  // }

  void _fetchFieldNameFromFirebase() async {
    print("Fields Fetching");
    // Assuming you have a Firestore collection named 'challenge'
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Thrivers').limit(10).get();

    // print("Fields Fetching");
    Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;

    List<String> fieldNamesList = data.keys.toList();
    // print("Field Names: $fieldNamesList");
    // print("data: $data");

    fieldNamesList.forEach((element) {
      fieldNames.add(element);
    });
    // setState(() {});
    print("Fields Fetched");
  }

  loadData() async {
   /// var response = await rootBundle.loadString('assets/data.json');
    setState(() {
      initialTreeData.forEach((item) {
        treeListData.add(item);
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.2),
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Wrap(
            children: [

              HeaderWidget(),

              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Consumer<AddKeywordProvider>(
                                builder: (c,addKeywordProvider, _){
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TypeAheadField(
                                      noItemsFoundBuilder: (ctx){
                                        print("ccccc: $ctx");
                                        return Container(
                                            child: Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Text("No Keywords Found",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
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
                                      suggestionsCallback: (value) async {
                                        return await KeywordServicessss.getSuggestions(value);

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
                                        print('onSuggestionSelected suggestion $suggestion before  ${addKeywordProvider.searchbycategory}');

                                          addKeywordProvider.addkeywordschip(suggestion,addKeywordProvider.searchbycategory);
                                        searchbyCatcontroller.clear();
                                        _addKeywordProvider.loadDataForPageFilter(1,'Keywords',_addKeywordProvider.searchbycategory);
                                        _addKeywordProvider.setFirstpageNo();

                                        print('onSuggestionSelected after  ${_addKeywordProvider.searchbycategory}');
                                      },
                                      textFieldConfiguration: TextFieldConfiguration(
                                        controller: searchbyCatcontroller,
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context).textTheme.bodyLarge,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                                        ),
                                        decoration: InputDecoration(
                                          //errorText: userAccountSearchErrorText,
                                          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                                          labelText: "Search By Category",
                                          hintText: "Search By Category",
                                          errorStyle: GoogleFonts.montserrat(
                                              textStyle: Theme.of(context).textTheme.bodyLarge,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.redAccent),

                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                              borderRadius: BorderRadius.circular(100)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black12),
                                              borderRadius: BorderRadius.circular(100)),
                                          //hintText: "e.g Abouzied",
                                          labelStyle: GoogleFonts.montserrat(
                                              textStyle: Theme.of(context).textTheme.bodyLarge,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  );}
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Consumer<AddKeywordProvider>(
                                builder: (c,addKeywordProvider, _){
                                  // print("searchbycattttt: $searchbycat");
                                  return (addKeywordProvider.searchbycategory.isNotEmpty) ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                                        controller: ScrollController(keepScrollOffset: true),
                                        child: Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          crossAxisAlignment: WrapCrossAlignment.start,
                                          alignment: WrapAlignment.start,
                                          runAlignment: WrapAlignment.start,
                                          children: addKeywordProvider.searchbycategory.map((item){
                                            // print("item: $item");
                                            // print("searchbycat_addKeywordProvider: ${_addKeywordProvider.searchbycategory}");
                                            return Container(
                                              height: 40,
                                              // width: 200,
                                              // margin: EdgeInsets.only(bottom: 10),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  border: Border.all(
                                                      color: Colors.blue
                                                  )
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(item, style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.blue

                                                  ),),

                                                  IconButton(
                                                      onPressed: ()async{
                                                        // _addKeywordProvider.removekeywords(item);
                                                        setState(() {

                                                          addKeywordProvider.removesearchcat(item);
                                                          _addKeywordProvider.loadDataForPageFilter(1,'Keywords',_addKeywordProvider.searchbycategory);
                                                          _addKeywordProvider.setFirstpageNo();
                                                          _addKeywordProvider.lengthOfdocument = null;


                                                        });
                                                      },
                                                      icon: Icon(Icons.dangerous_sharp,size: 15, color: Colors.black38,)
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ) : Container(height: 40,);
                                }),
                          )
                        ],
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TypeAheadField(
                                noItemsFoundBuilder: (c){
                                  print("tagcccccc: $c");
                                  return Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text("Search Tags ${searchbyTagcontroller.text}",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                                        ),
                                      )
                                  );
                                },
                                // direction: AxisDirection.up,
                                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                    scrollbarTrackAlwaysVisible: true,
                                    scrollbarThumbAlwaysVisible: true,
                                    hasScrollbar: true,
                                    borderRadius: BorderRadius.circular(5),
                                    // color: Colors.white,
                                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, )
                                ),
                                suggestionsCallback: (value) async {
                                  print("taggggg value: $value");
                                  return await TagServices.getSuggestions(searchbyTagcontroller.text.toLowerCase());
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
                                onSuggestionSelected: (String suggestion) {
                                  print("Im selectedf $suggestion" );
                                  print("Im selectedf ${searchbyTagcontroller.text}" );
                                  // setState(() {
                                  // tagscontroller.text = suggestion;
                                  setState(() {
                                    _addKeywordProvider.addtags(suggestion,_addKeywordProvider.searchbytag);
                                    _addKeywordProvider.loadDataForPageFilter(1,'tags',_addKeywordProvider.searchbytag);
                                    _addKeywordProvider.setFirstpageNo();

                                  });
                                  print("fenil tags added: ${_addKeywordProvider.searchbytag}");
                                  searchbyTagcontroller.clear();

                                  // });
                                },
                                textFieldConfiguration: TextFieldConfiguration(
                                  controller: searchbyTagcontroller,
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context).textTheme.bodyLarge,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                                  ),
                                  onSubmitted: (suggestion){
                                    setState(() {
                                      _addKeywordProvider.addtags(suggestion,_addKeywordProvider.searchbytag);
                                      _addKeywordProvider.loadDataForPageFilter(1,'tags',_addKeywordProvider.searchbytag);
                                      _addKeywordProvider.setFirstpageNo();

                                    });
                                    print("fenil tags added: ${_addKeywordProvider.searchbytag}");
                                    searchbyTagcontroller.clear();
                                  },
                                  decoration: InputDecoration(
                                    //errorText: userAccountSearchErrorText,
                                    contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                                    labelText: "Search by Tags",
                                    hintText: "Search by Tags",
                                    errorStyle: GoogleFonts.montserrat(
                                        textStyle: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyLarge,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.redAccent),

                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(100)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(100)),
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
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Consumer<AddKeywordProvider>(
                                builder: (c,addKeywordProvider, _){
                                  return (addKeywordProvider.searchbytag.isNotEmpty) ? Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          spacing: 10,
                                          runSpacing: 10,
                                          crossAxisAlignment: WrapCrossAlignment.start,
                                          alignment: WrapAlignment.start,
                                          runAlignment: WrapAlignment.start,
                                          children: addKeywordProvider.searchbytag.map((item){
                                            return Container(
                                              height: 40,
                                              // margin: EdgeInsets.only(bottom: 10),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  border: Border.all(
                                                      color: Colors.green
                                                  )
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(item, style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                    color: Colors.green
                                                  ),),
                                                  IconButton(
                                                      onPressed: (){
                                                        // setState(() {
                                                        setState(() {
                                                          addKeywordProvider.removesearchtags(item);
                                                          _addKeywordProvider.loadDataForPageFilter(1,'tags',_addKeywordProvider.searchbytag);
                                                          _addKeywordProvider.setFirstpageNo();
                                                          _addKeywordProvider.lengthOfdocument = null;
                                                        });
                                                        // _addKeywordProvider.searchbytag.remove(item);
                                                        // });
                                                      },
                                                      icon: Icon(Icons.dangerous_sharp,size: 15, color: Colors.black38,)
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ) : Container(height: 40,);

                                }),
                          ),
                        ],
                      ),

                      Consumer<AddKeywordProvider>(
                          builder: (c,addKeywordProvider, _){
                            // print("addKeywordProvider.lengthOfdocument :${addKeywordProvider.lengthOfdocument}");
                            return
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [

                                      Container(
                                        margin:EdgeInsets.only(left: 20),
                                        width: MediaQuery.of(context).size.width*0.3,
                                        child: TextField(
                                          controller: searchTextbyCKEditingController,
                                          onChanged: (val){
                                            print("valuse ${val}");
                                            if (_debounce?.isActive ?? false) _debounce?.cancel();
                                            _debounce = Timer(Duration(milliseconds: _debouncetime), () {
                                              if (searchTextbyCKEditingController.text != "") {
                                                ///here you perform your search
                                                // _loadDataForPageFilter(1,'tags',_addKeywordProvider.searchbytag); //(searchTextbyCKEditingController.text.toString());
                                                // _loadDataForPageSearchFilter(searchTextbyCKEditingController.text.toString(),selectAllAny);
                                                addKeywordProvider.loadDataForPageSearchFilter(searchTextbyCKEditingController.text.toString());
                                                print("documentssssssss: ${_addKeywordProvider.documents}");

                                              }
                                              else {
                                                addKeywordProvider.loadDataForPage(1);
                                                addKeywordProvider.setFirstpageNo();

                                              }
                                            });
                                          },

                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                                            hintText: (addKeywordProvider.selectAllAny == "All") ? 'Search All Solutions By (Label, Description, Category, Tags)' : "Search Thrivers By Any",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0),
                                            ),
                                            suffixIcon:
                                            // (searchTextbyCKEditingController.text.isNotEmpty) ?
                                            GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    searchTextbyCKEditingController.clear();
                                                    _addKeywordProvider.loadDataForPage(1);
                                                    _addKeywordProvider.setFirstpageNo();
                                                    _addKeywordProvider.lengthOfdocument = null;
                                                  });
                                                },
                                                child: Icon(Icons.close,)
                                            ),
                                            // ) : null,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0),
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(100.0),
                                              borderSide: BorderSide(color: Colors.black, width: 2.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // height: MediaQuery.of(context).size.width*0.03,
                                        width: MediaQuery.of(context).size.width*0.06,
                                        margin: EdgeInsets.symmetric(horizontal: 20),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DropdownButtonFormField<String>(
                                            value: addKeywordProvider.selectAllAny,
                                            // value: 'Thrivers Category',
                                            // value: ,
                                            onChanged: (value) async {
                                                addKeywordProvider.updateselectAllAny(value!,searchTextbyCKEditingController.text );
                                            },
                                            // onChanged: null,
                                            items: addKeywordProvider.searchAllAny.map((item) {
                                              return DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            // onTap: null,
                                            decoration: InputDecoration(
                                              // iconColor: Colors.black,
                                              // contentPadding: EdgeInsets.only(
                                              //     top: 20, bottom: 20, left: 32, right: 22),
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                              labelText: 'Search By',
                                              hintText: 'Search By',
                                              labelStyle: TextStyle(color: Colors.black),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.black),
                                                  borderRadius: BorderRadius.circular(15)
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
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
                                            addKeywordProvider.searchbytag.clear();
                                            addKeywordProvider.searchbycategory.clear();
                                            searchTextbyCKEditingController.clear();
                                            addKeywordProvider.loadDataForPage(1);
                                            addKeywordProvider.setFirstpageNo();
                                          },
                                            child: Text("..clear all",style: TextStyle(color: Colors.blue))),
                                      ],
                                    ),
                                  ) :

                                  SizedBox(height: 35,)
                                ],
                              );
                          }),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(width: MediaQuery.of(context).size.width*0.01,),
                            InkWell(
                                onTap: (){
                                  showTreeView = !showTreeView;
                                  setState(() {});
                                },
                                // child: (!showTreeView)?FaIcon(FontAwesomeIcons.folderTree):FaIcon(FontAwesomeIcons.list))),
                                child: (showTreeView)?FaIcon(FontAwesomeIcons.list):FaIcon(FontAwesomeIcons.folderTree)),
                            InkWell(
                                onTap: (){
                                  showAddThriverDialogBox();
                                },
                                child: FaIcon(FontAwesomeIcons.add)),
                            Container(width: MediaQuery.of(context).size.width*0.01,),
                          ],
                        ),
                      ),


                    ],
                  )
              ),

              Container(
                height: MediaQuery.of(context).size.height * .65,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:
            //  backgroundColor: Colors.grey.withOpacity(0.2),


              showTreeView?FutureBuilder(
                future: fetchDatasss(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  // Reset the list of nodes
                  // nodes.clear();

                  print("Hola");
                  print(nodes.length);

                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: nodes.length,
                      itemBuilder: (context, index) {
                        return nodes[index];
                      },
                    ),
                  );
                },
              ) :
              Consumer<AddKeywordProvider>(
                  builder: (c,addKeywordProvider, _){
                    // addKeywordProvider.getcategoryAndKeywords();
                    // addKeywordProvider.newgetSource();
                    // addKeywordProvider.getThriversStatus();
                    return
                      Column(
                        children: [
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.2,
                                  child:Row(
                                    children: [
                                      SizedBox(width: 10,),
                                      // Text(thriversDetails.id,style: Theme.of(context).textTheme.bodySmall),
                                      Text("NO.",style: Theme.of(context).textTheme.titleMedium),
                                      // Text("${thriversDetails['id']}",style: Theme.of(context).textTheme.bodySmall),
                                      SizedBox(width: 20,),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Text("Label & Description",style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis),

                                            // SizedBox(height: 10),


                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 50),


                                Container(
                                  width: MediaQuery.of(context).size.width*0.15,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Source ",style: Theme.of(context).textTheme.titleMedium),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.165,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Status",style: Theme.of(context).textTheme.titleMedium),
                                    ],
                                  ),
                                ),

                                Column(
                                    children:[
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.33,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Padding(
                                            //   padding: const EdgeInsets.symmetric(vertical: 2.0),
                                            //   child: Icon(Icons.tag,size: 16,),
                                            // ),
                                            // SizedBox(width: 5,),
                                            // Expanded(child: Text(keys.toString(),style: Theme.of(context).textTheme.bodySmall, )),
                                            Expanded(
                                              child: Text('Category & Tags',style: Theme.of(context).textTheme.titleMedium,),
                                            ),
                                            // Expanded(child: Text("No Country",style: Theme.of(context).textTheme.bodySmall,overflow: TextOverflow.ellipsis,)),
                                            // SizedBox(width: 10,),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 10,),

                                    ]
                                ),


                              ],
                            ),
                          ),
                          Divider(color: Colors.black,),

                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  // (documents.isEmpty) ?
                                  // Center(child: Text("No Solutions Added Yet", style: Theme.of(context).textTheme.displaySmall,)):
                                   (addKeywordProvider.isLoadingMore) ?
                                    Center(child: CircularProgressIndicator()) :
                                    ListView.separated(
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    physics: NeverScrollableScrollPhysics(), // Disable scrolling
                                    shrinkWrap: true,
                                    itemCount: addKeywordProvider.documents.length,
                                    separatorBuilder: (BuildContext context, int index) {
                                      return Divider();
                                    },
                                    itemBuilder: (BuildContext context, int index) {
                                      // print("after search documentssssssss: ${addKeywordProvider.documents}");

                                      return Column(
                                        children: [
                                          ThriversListTile(addKeywordProvider.documents[index], index, addKeywordProvider.documents),
                                        ],
                                      );
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ),
                          (addKeywordProvider.documents.isEmpty) ?

                          Container() :

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: addKeywordProvider.loadPreviousPage,
                                child: Text('Previous'),
                              ),
                              SizedBox(width: 10),
                              Text('Page ${addKeywordProvider.currentPage} of ${addKeywordProvider.totalPages}'),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: addKeywordProvider.loadNextPage,
                                child: Text('Next'),
                              ),
                            ],
                          ),
                        ],
                      );
                  })

              ),


                // StreamBuilder<QuerySnapshot>(
                //   stream: thriversCollection
                //
                //       .orderBy('id') // Sort by ID
                //       // .startAfterDocument(_lastDocument!) // Start after the last document retrieved
                //       .limit(_perPage) // Limit the number of documents retrieved per page
                //       .snapshots(),
                //       builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //       return Center(child: CircularProgressIndicator());
                //       }
                //
                //       // Check for errors
                //       if (snapshot.hasError) {
                //       return Center(child: Text('Error: ${snapshot.error}'));
                //       }
                //
                //       // Extract the documents from the snapshot
                //       List<DocumentSnapshot> newDocuments = snapshot.data!.docs;
                //
                //       // Update the last document retrieved
                //       if (newDocuments.isNotEmpty) {
                //       // _lastDocument = newDocuments[newDocuments.length - 1];
                //         _lastindex =snapshot.data!.docs.last["id"];
                //       print("inside set last document $_lastDocument");
                //       }
                //     //
                //     // WriteBatch batch = FirebaseFirestore.instance.batch();
                //     //
                //     //               snapshot.data!.docs.forEach((element) {
                //     //               var id = element['id'];
                //     //               // snapshot.data!.
                //     //               // Remove the "TH" prefix from the ID
                //     //               // String newId = id.replaceFirst('TH0', '');
                //     //               if(id != "" || id != null) {
                //     //                 print("id.runtimeType  ${id.runtimeType}");
                //     //                 if(id.runtimeType == String) {
                //     //                   String newIdString = id.replaceFirst(
                //     //                       'TH0', ''); // Remove prefix and convert to string
                //     //                   int newId = int.tryParse(newIdString) ?? 0;
                //     //                   // print("newId ${newId}");
                //     //                   batch.update(element.reference, {'id': newId});
                //     //                 }
                //     //               }
                //     //               // snapshot.data!.docs.up
                //     //               });
                //     //               batch.commit().then((_) {
                //     //               print('Batch update completed successfully.');
                //     //               }).catchError((error) {
                //     //               print('Error performing batch update: $error');
                //     //               });
                //
                //     documents.addAll(snapshot.data!.docs);
                //
                //
                //     _isLoadingMore = false;
                //
                //     return ListView.separated(
                //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //       physics: BouncingScrollPhysics(),
                //       itemCount: documents.length,
                //       separatorBuilder: (BuildContext context, int index) {
                //         return Divider();
                //       },
                //       itemBuilder: (BuildContext context, int index) {
                //         return Column(
                //           children: [
                //             ThriversListTile(documents[index], index, documents),
                //           ],
                //         );
                //       },
                //     );
                //   },
                // )


              // ),

            ],
          ),
        ),
      ),
    );
  }

  // Define an async function to fetch data from Firestore
  Future<void> fetchData() async {

    //Fetch Categories Fetch Subcategories and then make a tree



    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Categories').limit(10).get();

    // Return the list of documents
    List<DocumentSnapshot> categories = querySnapshot.docs;



    for (DocumentSnapshot categoryDocument in categories) {
      String categoryName = categoryDocument['Label'];
      print("Category Label"+categoryName);

      // Fetch data from "Thrivers" where category matches
      var thriversSnapshot = await FirebaseFirestore.instance
          .collection('Thrivers')
          .where('Category', isEqualTo: categoryName)
          .get();

      List<Widget> thriverNodes = [];

      for (QueryDocumentSnapshot thriverDocument in thriversSnapshot.docs) {
        String thriverName = thriverDocument['Label'];
        print("category name"+thriverName);
        thriverNodes.add(ListTile(title: Text(thriverName,style: TextStyle(color: Colors.black),)));
      }



      // Create a parent node with child nodes
      Widget categoryNode = ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(categoryName,style: TextStyle(color: Colors.black),),
        children: thriverNodes,
      );


      if(!categoriesStringList.contains(categoryName)){
        categoriesStringList.add(categoryName);
        // Add the parent node to the list
        nodes.add(categoryNode);
      }


    }

    // Trigger a rebuild by calling setState
    /*if (mounted) {
      setState(() {});
    }*/
  }

  Future<void> fetchDatas() async {

    //Fetch Categories Fetch Subcategories and then make a tree
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Keywords').limit(10).get();

    // Return the list of documents
    List<DocumentSnapshot> categories = querySnapshot.docs;

    for (DocumentSnapshot categoryDocument in categories) {
      String categoryName = categoryDocument['Key'];
      List<dynamic> values = categoryDocument['Values'];

      // var categoryName = categoryDocument['Values'];
      print("Category Label"+categoryName);
      print("Values: $values");

      // Fetch data from "Thrivers" where category matches
      var thriversSnapshot = await FirebaseFirestore.instance.collection('Thrivers').where('Keywords', isEqualTo: values).limit(10).get();

      List<Widget> thriverNodes = [];

      for (QueryDocumentSnapshot thriverDocument in thriversSnapshot.docs) {
        String thriverName = thriverDocument['Label'];
        print("category name"+thriverName);
        thriverNodes.add(ListTile(title: Text(thriverName,style: TextStyle(color: Colors.black),)));
      }



      // Create a parent node with child nodes
      Widget categoryNode = ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(categoryName,style: TextStyle(color: Colors.black),),
        children: thriverNodes,
      );


      if(!categoriesStringList.contains(categoryName)){
        categoriesStringList.add(categoryName);
        // Add the parent node to the list
        nodes.add(categoryNode);
      }


    }

    // Trigger a rebuild by calling setState
    /*if (mounted) {
      setState(() {});
    }*/
  }

  Future<void> fetchDatasss() async {
    // Fetch specific document by ID
    DocumentSnapshot specificDocument = await FirebaseFirestore.instance
        .collection('Keywords').doc('aqTybsZWFxMuHPQt7u1T')
        .get();

    if (specificDocument.exists) {
      List<dynamic> values = specificDocument['Values'];
      // print("avluesssss: $values");

      for (var value in values) {
        // Fetch data from "Thrivers" where category matches
        var thriversSnapshot = await FirebaseFirestore.instance.collection('Thrivers').where('Keywords', arrayContains: value).limit(10).get();

        // print("thriversSnapshot  $thriversSnapshot" );

        List<Widget> thriverNodes = [];

        for (QueryDocumentSnapshot thriverDocument in thriversSnapshot.docs) {
          String thriverName = thriverDocument['Label'];
          // print("category nameee $thriverName");
          thriverNodes.add(
            ListTile(
              title: InkWell(
                onTap: (){
                  // thriversDetails.reference,thriversDetails.id, thriversDetails['Label'], thriversDetails['Description'], thriversDetails['Category']
                  // ,thriversDetails['Keywords'],thriversDetails['Created Date'],thriversDetails['Created By'],thriversDetails['tags'],thriversDetails['Modified By']
                  // ,thriversDetails['Modified Date'],thriversDetails['id']
                  ViewSolutionDialog(thriverDocument.reference, thriverDocument.id,
                      thriverDocument['Label'], thriverDocument['Description'], thriverDocument['Category'],
                      thriverDocument['Keywords'], thriverDocument['Created Date'], thriverDocument['Created By'],
                      thriverDocument['tags'], thriverDocument['Modified By'], thriverDocument['Modified Date'], thriverDocument['id']);
                },
                  child: Text(thriverName, style: TextStyle(color: Colors.black))),
            ),
          );
        }

        // Create a parent node with child nodes
        Widget categoryNode = ExpansionTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text("$value (${thriverNodes.length})", style: TextStyle(color: Colors.black)),
          children: thriverNodes,
        );

        if (!categoriesStringList.contains(value)) {
          categoriesStringList.add(value);
          // Add the parent node to the list
          nodes.add(categoryNode);
        }
      }
    }
  }


  List<DocumentSnapshot<Object?>> filteredDocuments = [];

  Widget buildKeywordContainer(String keyword) {
    return GestureDetector(
      onTap: () {
        // Handle the click event for the keyword
        print('Clicked on keyword: $keyword');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.blue[100], // Set your desired background color for the container
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          keyword,
          style: TextStyle(
            color: Colors.blue, // Set your desired color for the text
          ),
        ),
      ),
    );
  }

  Widget ThriversListTile(DocumentSnapshot<Object?> thriversDetails, i, documentsss) {

    // print("thriversDetails");
    // print(thriversDetails.data());
    // print(thriversDetails.id);


    var keys = thriversDetails["Keywords"].join(",");
    // var keys = thriversDetails["Keywords"].map((e) => e.toString()).join(', ');
    // print("keyssssss :$keys");

    var tags = thriversDetails["tags"].join(",");
    // print("keyssssss :$tags");

    List<TextSpan> getClickableKeywords(keywordsString) {
      var keywords = thriversDetails["Keywords"];

      List<TextSpan> spans = [];
      int index = 0;



      for (var keyword in keywords) {

        spans.add(
          TextSpan(
            text: keyword,
            style: TextStyle(
              // color: Colors.blue, // Set your desired color for clickable text
              // decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  // searchTextbyCKEditingController.text = keyword;
                  _addKeywordProvider.addkeywordschip(keyword,_addKeywordProvider.searchbycategory);
                  _addKeywordProvider.loadDataForPageFilter(1,'Keywords',_addKeywordProvider.searchbycategory);
                  _addKeywordProvider.setFirstpageNo();

                });
                // print('Clicked on keyword: $keyword');
              },
          ),
        );

        if (index < keywords.length - 1) {
          spans.add(
            TextSpan(
              text: ', ',
            ),
          );
        }

        index++;
      }

      return spans;
    }

    List<TextSpan> getClickableTags(keywordsString) {
      var Tags = thriversDetails["tags"];

      List<TextSpan> spans = [];
      int index = 0;



      for (var tag in Tags) {

        spans.add(
          TextSpan(
            text: tag,
            style: TextStyle(
              // color: Colors.blue, // Set your desired color for clickable text
              // decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle the click event for the keyword
                setState(() {
                  // if (keyword.isNotEmpty && !searchbycat.contains(keyword)) {
                  //   print("Before add: tags");
                  //   searchbycat.add(keyword);
                  //   print("After add : $searchbycat");
                  //   // text.clear();
                  // }
                  // searchTextbyCKEditingController.text = tag;
                  _addKeywordProvider.addtags(tag,_addKeywordProvider.searchbytag);
                  _addKeywordProvider.loadDataForPageFilter(1,'tags',_addKeywordProvider.searchbytag);
                  _addKeywordProvider.setFirstpageNo();

                  // search(keyword);
                });

                // _addKeywordProvider.addtags(keyword, searchbycat);
                print('Clicked on keyword: $tag');
              },
          ),
        );

        if (index < tag.length - 1) {
          spans.add(
            TextSpan(
              text: ', ',
            ),
          );
        }

        index++;
      }

      return spans;
    }



    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.2,
          child:Row(
            children: [
              SizedBox(width: 10,),
              // Text(thriversDetails.id,style: Theme.of(context).textTheme.bodySmall),
              // Text("${i+1}.",style: Theme.of(context).textTheme.bodySmall),
              Text("SH0${thriversDetails['id']}",style: Theme.of(context).textTheme.bodySmall),
              SizedBox(width: 20,),
              Expanded(
                child: InkWell(
                  onTap: (){
                    ViewSolutionDialog(thriversDetails.reference,thriversDetails.id, thriversDetails['Label'], thriversDetails['Description'], thriversDetails['Category']
                        ,thriversDetails['Keywords'],thriversDetails['Created Date'],thriversDetails['Created By'],thriversDetails['tags'],thriversDetails['Modified By']
                        ,thriversDetails['Modified Date'],thriversDetails['id']);

                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      !selectedFieldNames.contains("Label")?Text(thriversDetails['Label'],style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis):Container(),
                      !selectedFieldNames.contains("Description")?Text(thriversDetails['Description'],style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey,overflow: TextOverflow.ellipsis),maxLines: 2,):Container(),
                      SizedBox(height: 10),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 30),


        Container(
          width: MediaQuery.of(context).size.width*0.115,

          child: Column(
            children: [
              (thriversDetails['Source']==null||thriversDetails['Source']=="") ? Text('-') :  Text("${thriversDetails['Source']}",),
            ],
          ),
        ),
        SizedBox(width: 100,),

         Container(
          width: MediaQuery.of(context).size.width*0.115,

          child: Column(
            children: [
              (thriversDetails['Thirver Status']==null||thriversDetails['Thirver Status']=="") ? Text('-') : Text("${thriversDetails['Thirver Status']}",),
            ],
          ),
        ),
        SizedBox(width: 30,),
        Column(
            children:[
              !selectedFieldNames.contains("Keywords")?Container(
                width: MediaQuery.of(context).size.width*0.33,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Icon(Icons.tag,size: 16,),
                    ),
                    SizedBox(width: 5,),
                    // Expanded(child: Text(keys.toString(),style: Theme.of(context).textTheme.bodySmall, )),
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleSmall,
                          children: getClickableKeywords(keys),
                        ),
                      ),
                    )
                    // Expanded(child: Text("No Country",style: Theme.of(context).textTheme.bodySmall,overflow: TextOverflow.ellipsis,)),
                    // SizedBox(width: 10,),
                  ],
                ),
              ):Container(),

              SizedBox(height: 10,),

              !selectedFieldNames.contains("Keywords")?Container(
                width: MediaQuery.of(context).size.width*0.33,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      // child: Icon(Icons.arr,size: 10, color: Colors.black38,),
                    ),
                    SizedBox(width: 5,),
                    // Expanded(child: Text(keys.toString(),style: Theme.of(context).textTheme.bodySmall, )),
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.labelMedium,
                          children: getClickableTags(tags),
                        ),
                      ),
                    ),
                    // Expanded(child: Text("No Country",style: Theme.of(context).textTheme.bodySmall,overflow: TextOverflow.ellipsis,)),
                    // SizedBox(width: 10,),
                  ],
                ),
              ):Container(),

            ]
        ),



        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /*Row(
                children: [

                  */
              /*Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.credit_card_outlined),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("credits",style: TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 1.5,),
                          ),
                        ],
                      ),
                      Text("Credits",style: TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 0.8,),

                    ],
                  ),
                  */
              /*

                ],
              ),*/
              IconButton(
                  iconSize: 25,
                  color: primaryColorOfApp,
                  onPressed: () async {
                    // print("object: ${thriversDetails.id} , ${thriversDetails['Label']}, ${thriversDetails['Description']}, ${thriversDetails['Category']}, ${thriversDetails['Keywords']} ,${thriversDetails['Created Date']},${thriversDetails['Created By']},${thriversDetails['Modified By']},${thriversDetails['Modified Date']}}");
                    showEditThriverDialogBox
                      (thriversDetails.reference,thriversDetails.id, thriversDetails['Label'], thriversDetails['Description'], thriversDetails['Category']
                        ,thriversDetails['Keywords'],thriversDetails['Created Date'],thriversDetails['Created By'],thriversDetails['tags'],thriversDetails['Modified By']
                        ,thriversDetails['Modified Date'],thriversDetails['id']);
                    // showEditThriverDialogBox(thriversDetails.id, thriversDetails['Label'], thriversDetails['Description'], thriversDetails['Category'] );
                  },
                  icon: Icon(Icons.edit,)),

              // SizedBox(width: 20,),
              /*Row(
                children: [

                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.note_alt_sharp),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(thriversDetails['ListOfBoughtTests'].length.toString(),style: TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 1.5,),
                          ),
                        ],
                      ),
                      Text("Tests Bought",style: TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 0.8,),

                    ],
                  ),

                ],
              ),*/

              IconButton(
                  iconSize: 25,
                  color: primaryColorOfApp,
                  onPressed: () async {
                    ProgressDialog.show(context, "Deleting Users",Icons.person);
                    await ApiRepository().DeleteSectionPreset(thriversDetails.reference);
                    _addKeywordProvider.loadDataForPage(1);
                    _addKeywordProvider.setFirstpageNo();
                    ProgressDialog.hide();
                  },
                  icon: Icon(Icons.delete,)),
              // SizedBox(width: 20,),
            ],
          ),
        ),
      ],
    );
  }

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: []);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        listOfUserToAdd = results;
      });
    }
  }


  Future<DocumentSnapshot> fetchEventDetails(DocumentReference docRef) async {
    //Fetch List of All the tickets
    return await docRef.get();
  }

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



  var createdAt = DateFormat('yyyy-MM-dd, HH:mm:ss').format(DateTime.now());

  var ModifiedAt = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC'Z").format(DateTime.now());

  void addTagListToDocument( List<dynamic> tagList) {
    FirebaseFirestore.instance.collection('Keywords').doc("GEdua4iCBaakTpNB1NY5").update({
      'Values': FieldValue.arrayUnion(tagList),
    });
  }

  void showAddThriverDialogBox() {

    _controller.document.insert(0, "Expanded Description");

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
                    .width * 0.08),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          thriverNameTextEditingController.clear();
                          originaltextEditingController.clear();
                          finaltextcontroller.clear();
                          _controller.clear();
                          Impacttextcontroller.clear();
                          Notestextcontroller.clear();
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
                          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                              .collection('Thrivers')
                              .orderBy('Created Date', descending: true)
                              .limit(1)
                              .get();
                        final abc =   querySnapshot.docs.first;
                          print("abccccc; ${abc['id']}");
                          print("abccccc; ${abc['id'].runtimeType}");
                          var ids = abc['id'] + 1;
                          ProgressDialog.show(context, "Creating a Thriver", Icons.chair);
                          await ApiRepository().createThriversss({
                            "id": ids,
                            "Source" : addKeywordProvider.selectsourceItems,
                            "Thirver Status" : addKeywordProvider.selectThriversStatusItems,
                            "tags": addKeywordProvider.ProviderTags,
                            "Created By": widget.AdminName,
                            "Created Date": DateTime.now(),
                            "Modified By": "",
                            "Modified Date": "",
                            'Label': thriverNameTextEditingController.text,
                            // 'Description': thriverDescTextEditingController.text,
                            'Description': _controller.document.toPlainText(),
                            'Original Description': originaltextEditingController.text,
                            'Final_description': finaltextcontroller.text,
                            'Impact': Impacttextcontroller.text,
                            // 'Details': _controller.document.insert(0, addDetailsController.text.toString()),
                            // 'Category': addKeywordProvider.selectedValue.toString(),
                            'Category': "Thrivers Category",
                            'Keywords': addKeywordProvider.keywordsssss,
                            "Notes" :  Notestextcontroller.text
                            // 'Associated Thrivers': "",
                            // 'Associated Challenges': ""
                          }
                          );
                          addTagListToDocument(addKeywordProvider.ProviderTags);
                          _addKeywordProvider.loadDataForPage(1);
                          _addKeywordProvider.setFirstpageNo();
                          ProgressDialog.hide();
                          Navigator.pop(context);
                          thriverNameTextEditingController.clear();
                          originaltextEditingController.clear();
                          finaltextcontroller.clear();
                          Impacttextcontroller.clear();
                          Notestextcontroller.clear();
                          _controller.clear();
                          // addKeywordProvider.selectedValue.clear();
                          addKeywordProvider.keywordsssssclear();
                          addKeywordProvider.ProviderTagsclear();
                          addKeywordProvider.selectsourceItems = null;
                          addKeywordProvider.selectThriversStatusItems = null;
                          // controller.clearAllSelection();
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
                        child: Text("Add A Solution",
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

                          // Row(
                          //   // mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     Flexible(
                          //       child: Container(
                          //         padding: EdgeInsets.only(left: 10),
                          //         child: SizedBox(
                          //           child: Row(
                          //             children: [
                          //               Expanded(
                          //                 flex: 4,
                          //                 child: TextField(
                          //                   maxLines: 2,
                          //                   controller: originaltextEditingController,
                          //                   cursorColor: primaryColorOfApp,
                          //
                          //                   onSubmitted: (v)async{
                          //
                          //                     print(q1);
                          //                     print(originaltextEditingController.text.toString());
                          //
                          //
                          //                     var defaulttext;
                          //                     defaulttext = q1;
                          //                     defaulttext = defaulttext +""+ "where xxx = ${originaltextEditingController.text.toString()}";
                          //                     print(defaulttext);
                          //                     await getChatResponse(defaulttext);
                          //
                          //                   },
                          //                   // readOnly: readonly,
                          //                   // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          //                   style: GoogleFonts.montserrat(
                          //                       textStyle: Theme
                          //                           .of(context)
                          //                           .textTheme
                          //                           .bodyLarge,
                          //                       fontWeight: FontWeight.w400,
                          //                       color: Colors.black),
                          //                   decoration: InputDecoration(
                          //                     //errorText: userAccountSearchErrorText,
                          //                     contentPadding: EdgeInsets.all(25),
                          //                     labelText: "Original Description",
                          //                     hintText: "Original Description",
                          //
                          //                     /*prefixIcon: Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Icon(Icons.question_mark_outlined,
                          //          // color: primaryColorOfApp
                          //           ),
                          //       ),*/
                          //
                          //                     errorStyle: GoogleFonts.montserrat(
                          //                         textStyle: Theme
                          //                             .of(context)
                          //                             .textTheme
                          //                             .bodyLarge,
                          //                         fontWeight: FontWeight.w400,
                          //                         color: Colors.redAccent),
                          //
                          //                     focusedBorder: OutlineInputBorder(
                          //                         borderSide: BorderSide(color: Colors.black),
                          //                         borderRadius: BorderRadius.circular(15)),
                          //                     border: OutlineInputBorder(
                          //                         borderSide: BorderSide(color: Colors.black12),
                          //                         borderRadius: BorderRadius.circular(15)),
                          //                     //hintText: "e.g Abouzied",
                          //                     labelStyle: GoogleFonts.montserrat(
                          //                         textStyle: Theme
                          //                             .of(context)
                          //                             .textTheme
                          //                             .bodyLarge,
                          //                         fontWeight: FontWeight.w400,
                          //                         color: Colors.black),
                          //                   ),
                          //                 ),
                          //               ),
                          //
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     Flexible(
                          //       child: Container(
                          //         padding: EdgeInsets.only(left: 10),
                          //         child: SizedBox(
                          //           child: Row(
                          //             children: [
                          //               Expanded(
                          //                 flex: 4,
                          //                 child: TextField(
                          //                   maxLines: 2,
                          //                   controller: originaltextEditingController,
                          //                   cursorColor: primaryColorOfApp,
                          //
                          //                   onSubmitted: (v)async{
                          //
                          //                     print(q1);
                          //                     print(originaltextEditingController.text.toString());
                          //
                          //
                          //                     var defaulttext;
                          //                     defaulttext = q1;
                          //                     defaulttext = defaulttext +""+ "where xxx = ${originaltextEditingController.text.toString()}";
                          //                     print(defaulttext);
                          //                     await getChatResponse(defaulttext);
                          //
                          //                   },
                          //                   // readOnly: readonly,
                          //                   // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          //                   style: GoogleFonts.montserrat(
                          //                       textStyle: Theme
                          //                           .of(context)
                          //                           .textTheme
                          //                           .bodyLarge,
                          //                       fontWeight: FontWeight.w400,
                          //                       color: Colors.black),
                          //                   decoration: InputDecoration(
                          //                     //errorText: userAccountSearchErrorText,
                          //                     contentPadding: EdgeInsets.all(25),
                          //                     labelText: "Original Description",
                          //                     hintText: "Original Description",
                          //
                          //                     /*prefixIcon: Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Icon(Icons.question_mark_outlined,
                          //          // color: primaryColorOfApp
                          //           ),
                          //       ),*/
                          //
                          //                     errorStyle: GoogleFonts.montserrat(
                          //                         textStyle: Theme
                          //                             .of(context)
                          //                             .textTheme
                          //                             .bodyLarge,
                          //                         fontWeight: FontWeight.w400,
                          //                         color: Colors.redAccent),
                          //
                          //                     focusedBorder: OutlineInputBorder(
                          //                         borderSide: BorderSide(color: Colors.black),
                          //                         borderRadius: BorderRadius.circular(15)),
                          //                     border: OutlineInputBorder(
                          //                         borderSide: BorderSide(color: Colors.black12),
                          //                         borderRadius: BorderRadius.circular(15)),
                          //                     //hintText: "e.g Abouzied",
                          //                     labelStyle: GoogleFonts.montserrat(
                          //                         textStyle: Theme
                          //                             .of(context)
                          //                             .textTheme
                          //                             .bodyLarge,
                          //                         fontWeight: FontWeight.w400,
                          //                         color: Colors.black),
                          //                   ),
                          //                 ),
                          //               ),
                          //
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          ///
                          Row(
                            children: [

                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField<String>(
                                    value: null,
                                    // value: 'Thrivers Category',
                                    // value: ,
                                    onChanged: (value) async {
                                      addKeywordProvider.selectsourceItems = value;
                                    },
                                    // onChanged: null,
                                    items: addKeywordProvider.sourceItems.map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onTap: null,
                                    decoration: InputDecoration(
                                      // iconColor: Colors.black,
                                      contentPadding: EdgeInsets.only(
                                          top: 25, bottom: 25, left: 32, right: 22),
                                      labelText: 'Select Source',
                                      hintText: 'Select Source',
                                      labelStyle: TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField<String>(
                                    value: null,
                                    // value: 'Thrivers Category',
                                    // value: ,
                                    onChanged: (value) async {
                                      addKeywordProvider.selectThriversStatusItems = value;
                                    },
                                    // onChanged: null,
                                    items: addKeywordProvider.ThriversStatusItems.map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onTap: null,
                                    decoration: InputDecoration(
                                      // iconColor: Colors.black,
                                      contentPadding: EdgeInsets.only(
                                          top: 25, bottom: 25, left: 32, right: 22),
                                      labelText: 'Solution Status',
                                      hintText: 'Solution Status',
                                      labelStyle: TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),

                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      maxLines: 2,
                                      controller: originaltextEditingController,
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
                                        labelText: "Original Description",
                                        hintText: "Original Description",

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
                                  ),

                                ],
                              ),
                            ),
                          ),


                          InkWell(
                            onTap: ()async{

                              // print(q1);
                              // print(originaltextEditingController.text.toString());


                              var defaulttext ;
                              defaulttext = q1;
                              defaulttext = defaulttext +""+ "where xxx = ${originaltextEditingController.text.toString()}";
                              print(defaulttext);
                              await getChatResponse(defaulttext);

                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 20,left: 10,right: 10, bottom: 10),
                              width: 200,
                              height: 60,
                              decoration: BoxDecoration(
                                color:Colors.blue,
                                border: Border.all(
                                    color:Colors.blue,
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Clean',
                                  style: GoogleFonts.montserrat(
                                      textStyle:
                                      Theme.of(context).textTheme.titleSmall,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),

                          ),


                          Padding(


                            /// Final Description
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              // maxLines: null,
                              maxLines: 2,
                              controller: finaltextcontroller,
                              // cursorColor: primaryColorOfApp,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                              ],
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
                                labelText: "Description",
                                hintText: "Description",


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
                          ),
                          InkWell(
                            onTap: () async {
                              var defaulttext ="";
                              // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                              defaulttext =  q2;
                              defaulttext =  defaulttext + " where yyy is "+finaltextcontroller.text.toString();
                              var defaulttextq3 ="";
                              // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                              defaulttextq3 =  q3;
                              defaulttextq3 =  defaulttextq3 + " where yyy is "+finaltextcontroller.text.toString();

                              var defaulttextq4 ="";
                              // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                              defaulttextq4 =  q4;
                              defaulttextq4 =  defaulttextq4 + " where yyy is "+finaltextcontroller.text.toString();
                              defaulttextq4 =  defaulttextq4 + " and select tags from "+"${resultString}";


                              var defaulttextq5 ="";
                              defaulttextq5 =  q5;
                              defaulttextq5 =  defaulttextq5 + " where yyy is "+finaltextcontroller.text.toString();

                              // defaulttext =defaulttext +" 3."+ "  $q3 "+originaltextEditingController.text.toString();
                              // defaulttext =defaulttext +" 4."+ "  $q4 "+originaltextEditingController.text.toString();
                              // defaulttext =defaulttext +" 5."+ "  $q5 "+originaltextEditingController.text.toString();
                              await getChatResponsenew(defaulttext,defaulttextq3,defaulttextq4,defaulttextq5);

                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              width: 200,
                              height: 60,
                              decoration: BoxDecoration(
                                color:Colors.blue,
                                border: Border.all(
                                    color:Colors.blue,
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Expand',
                                  style: GoogleFonts.montserrat(
                                      textStyle:
                                      Theme.of(context).textTheme.titleSmall,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            /// Label
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: thriverNameTextEditingController,

                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                              ],
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
                                //errorText: userAccountSearchErrorText,
                                contentPadding: EdgeInsets.all(25),
                                labelText: "Label",
                                hintText: "Label",

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
                          ),



                          Container(
                            /// Details
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black, width: 1)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: QuillEditor.basic(
                                    configurations: QuillEditorConfigurations(
                                      // placeholder: "Expanded Description",
                                      maxContentWidth: null,
                                      // maxHeight: 200,
                                      padding: EdgeInsets.only(left: 10, top: 10),
                                      controller: _controller,
                                      readOnly: false,
                                      minHeight: 100,
                                      sharedConfigurations: const QuillSharedConfigurations(
                                        locale: Locale('en'),
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Center(
                                    child: QuillToolbar.simple(
                                      configurations: QuillSimpleToolbarConfigurations(
                                        controller: _controller,
                                        sharedConfigurations: const QuillSharedConfigurations(
                                          locale: Locale('en'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Padding(
                            /// Impact
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: Impacttextcontroller,

                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                              ],
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
                                //errorText: userAccountSearchErrorText,
                                contentPadding: EdgeInsets.all(25),
                                labelText: "Impact",
                                hintText: "Impact",

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
                          ),



                          Consumer<AddKeywordProvider>(
                              builder: (c,addKeywordProvider, _){
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TypeAheadField(
                                    noItemsFoundBuilder: (c){
                                      print("ccccc: $c");
                                      return Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text("No Keywords Found",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
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
                                    suggestionsCallback: (value) async {
                                      // return await KeywordServices.getSuggestions(value, (addKeywordProvider.newselectedValue == null) ? addKeywordProvider.selectedValue : addKeywordProvider.newselectedValue);
                                      // return await KeywordServices.getSuggestions(value, 'Thrivers Category');
                                      return await KeywordServicessss.getSuggestions(value);
                                    },
                                    itemBuilder: (context, String suggestion) {
                                      // print('selected multiple items before newselectedValue ${suggestion}');
                                      // print('selected multiple items after newselectedValue ${addKeywordProvider.newKeyValues} ');
                                      return Container(
                                        // color: Colors.black,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(suggestion,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                                        ),
                                      );
                                    },
                                    direction: AxisDirection.up,
                                    onSuggestionSelected: (String suggestion) {
                                      // print('onSuggestionSelected before  ${addKeywordProvider.keywordsssss}');
                                      // addKeywordProvider.addkeywordschip(suggestion,editKeywordssss);
                                      addKeywordProvider.addkeywordschip(suggestion,addKeywordProvider.keywordsssss);
                                      // print('onSuggestionSelected after  ${addKeywordProvider.keywordsssss}');


                                      keywordscontroller.clear();
                                    },
                                    textFieldConfiguration: TextFieldConfiguration(
                                      controller: keywordscontroller,
                                      // onSubmitted: (text) {
                                      //   addKeywordProvider.addkeywordschip(tagscontroller.text.toString(),editKeywordssss);
                                      //   // addKeywordProvider.addkeywordschip(addKeywordProvider.newselectedValue);
                                      // },
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context).textTheme.bodyLarge,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                                      ),
                                      decoration: InputDecoration(
                                        //errorText: userAccountSearchErrorText,
                                        contentPadding: EdgeInsets.all(25),
                                        labelText: "Select Category",
                                        hintText: "Select Category",
                                        /*prefixIcon: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Icon(Icons.question_mark_outlined,
                                                                          //color: primaryColorOfApp
                                                                          ),
                                                                      ),*/
                                        errorStyle: GoogleFonts.montserrat(
                                            textStyle: Theme.of(context).textTheme.bodyLarge,
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
                                            textStyle: Theme.of(context).textTheme.bodyLarge,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                );}
                          ),

                          // SizedBox(height: 16),

                          Consumer<AddKeywordProvider>(
                              builder: (c,addKeywordProvider, _){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      alignment: WrapAlignment.start,
                                      runAlignment: WrapAlignment.start,
                                      children: addKeywordProvider.keywordsssss.map((item){
                                      // children: editKeywordssss.map((item){
                                      //   print("item: $item");
                                      //   print("addKeywordProvider.keywordsssss: ${addKeywordProvider.keywordsssss}");
                                        return Container(
                                          height: 50,
                                          // width: 200,
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.blue
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(item, style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                ),
                                                  overflow: TextOverflow.ellipsis,
                                                  // softWrap: true,
                                                  // maxLines: 1,
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: ()async{
                                                    // addKeywordProvider.newKeywordsList.remove(item);
                                                    // _addKeywordProvider.removekeywords(item);
                                                    _addKeywordProvider.keywordsssss.remove(item);
                                                  },
                                                  icon: Icon(Icons.close,size: 20, color: Colors.white,)
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              }),



                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TypeAheadField(
                              noItemsFoundBuilder: (c){
                                return Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text("Add Tag: '${tagscontroller.text}'",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                                      ),
                                    )
                                );
                              },
                              direction: AxisDirection.up,
                              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                  scrollbarTrackAlwaysVisible: true,
                                  scrollbarThumbAlwaysVisible: true,
                                  hasScrollbar: true,
                                  borderRadius: BorderRadius.circular(5),
                                  // color: Colors.white,
                                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, )
                              ),
                              suggestionsCallback: (value) async {
                                return await TagServices.getSuggestions(value);
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
                              onSuggestionSelected: (String suggestion) {
                                print("Im selectedf $suggestion" );
                                print("Im selectedf ${tagscontroller.text}" );
                                // setState(() {
                                tagscontroller.text = suggestion;
                                _addKeywordProvider.addtags(tagscontroller.text.toString(),_addKeywordProvider.ProviderTags);
                                tagscontroller.clear();
                                //

                                // });
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: tagscontroller,
                                onSubmitted: (text) {
                                  _addKeywordProvider.addtags(text,_addKeywordProvider.ProviderTags);
                                  tagscontroller.clear();
                                  // print("tags: $tags");
                                },
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                                ),
                                decoration: InputDecoration(
                                  //errorText: userAccountSearchErrorText,
                                  contentPadding: EdgeInsets.all(25),
                                  labelText: "Tags",
                                  hintText: "Tags",
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.tag,color: primaryColorOfApp,),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.add, size: 20, color: primaryColorOfApp,),
                                    onPressed: () {
                                      _addKeywordProvider.addtags(tagscontroller.text.toString(),_addKeywordProvider.ProviderTags);
                                    },
                                  ),
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
                          ),



                          Consumer<AddKeywordProvider>(
                              builder: (c,addKeywordProvider, _){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      alignment: WrapAlignment.start,
                                      runAlignment: WrapAlignment.start,
                                      children: addKeywordProvider.ProviderTags.map((item){
                                        return Container(
                                          height: 50,
                                          // width: 200,
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.blue
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(item, style: TextStyle(
                                                  fontWeight: FontWeight.w700
                                              ),),
                                              IconButton(
                                                  onPressed: (){
                                                    // setState(() {
                                                    addKeywordProvider.removetags(item);
                                                    // });
                                                  },
                                                  icon: Icon(Icons.close,size: 20, color: Colors.white,)
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );

                              }),

                          Padding(
                            /// Notes
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: Notestextcontroller,

                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                              ],
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
                                //errorText: userAccountSearchErrorText,
                                contentPadding: EdgeInsets.all(25),
                                labelText: "Notes",
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

  List _messages = [];

  Future<void> getChatResponse( defaulttext) async {
    setState(() {
      _messages.insert(0, defaulttext);
      // _typingUsers.add(_gptChatUser);
    });
    ProgressDialog.show(context, "Clean", Icons.search);

    print("openAiApiKeyFromFirebase :$openAiApiKeyFromFirebase");

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


          // finaltextcontroller.text = element.message!.content;
          finaltextcontroller.text = responseContent;
        });
        print("response: ${element.message!.content}");
      }
    }
    ProgressDialog.hide();

  }

  Future<void> getChatResponsenew( defaulttext,q3text,q4text,q5text,) async {
    setState(() {
      _messages.insert(0, defaulttext);
      // _typingUsers.add(_gptChatUser);
    });
    ProgressDialog.show(context, "Expand", Icons.search);

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
          thriverNameTextEditingController.text = responseContent;
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
          // thriverDescTextEditingController.text = element.message!.content;
          // _controller = element.message!.content;
          _controller = QuillController(
            document: Document()..insert(0, element.message!.content),
            selection: TextSelection.collapsed(offset: element.message!.content.length),
          );
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
          //
          // controller.options.add( valueItem) ;

          String gptResponse = element.message!.content;
          String responseContent = gptResponse.replaceAll(', ', ',');

          // List<String> responseList = [gptResponse];
          // print("responseListttt: ${responseList}");
          // print("responseInList: ${[element.message!.content]}");


          _addKeywordProvider.keywordsssss = responseContent.split(',');

          // _addKeywordProvider.keywordsssss = [gptResponse];


        });
        print("_addKeywordProvider.ProviderTags: ${_addKeywordProvider.keywordsssss}");
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

  Future<void> editThrivergetChatResponse( defaulttext) async {
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
          String responseContent = gptResponse.replaceAll('"', '');


          // finaltextcontroller.text = element.message!.content;
          editfinaltextcontroller.text = responseContent;
        });
        print("response: ${element.message!.content}");
      }
    }
    ProgressDialog.hide();

  }


  Future<void> editThrivergetChatResponsenew( defaulttext,q3text,q4text,q5text,) async {
    setState(() {
      _messages.insert(0, defaulttext);
      // _typingUsers.add(_gptChatUser);
    });
    ProgressDialog.show(context, "Expand", Icons.search);

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
          editthriverNameTextEditingController.text = responseContent;
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

        print('Type of data1: ${element.message!.content.runtimeType}');
        print('Type of document1: ${_editcontroller.document.runtimeType}');


        // print("Before update: ${_editcontroller.document.toPlainText()}");
        setState(() {

          // print('Type of data2: ${element.message!.content.runtimeType}');
          // print('Type of document.toPlainText()2: ${_editcontroller.document.toPlainText().runtimeType}');

          // editthriverDescTextEditingController.text = element.message!.content;
          // _editcontroller = QuillController(
          //   document: Document()..insert(0, element.message!.content),
          //   selection: TextSelection.collapsed(offset: element.message!.content.length),
          //
          // );

          print('Type of data: ${element.message!.content.runtimeType}');
          print('Type of document: ${_editcontroller.document.runtimeType}');

          _editcontroller.document = Document()..insert(0, element.message!.content);



        });
        // print("After update: ${_editcontroller.document.toPlainText()}");
        print("_editcontrollerresponse: ${element.message!.content}");
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
          //
          // controller.options.add( valueItem) ;

          // _addKeywordProvider.keywords = element.message!.content.split(',');

          String gptResponse = element.message!.content;
          String responseContent = gptResponse.replaceAll(', ', ',');

          editKeywordssss = responseContent.split(',');

          _addKeywordProvider.newaddkeywordsList(editKeywordssss);


          // _addKeywordProvider.keywords.replaceRange(0, _addKeywordProvider.keywords.length, element.message!.content.split(','));

        });
        print("_addKeywordProvider.keywords: ${_addKeywordProvider.keywords}");
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

          // _addKeywordProvider.ProviderEditTags = element.message!.content.split(',');

          String gptResponse = element.message!.content;
          String responseContent = gptResponse.replaceAll(', ', ',');

          edittags = responseContent.split(',');

          _addKeywordProvider.newaddProviderEditTagsList(edittags);

          // _addKeywordProvider.ProviderEditTags.replaceRange(0, _addKeywordProvider.ProviderEditTags.length, element.message!.content.split(','));
        });
        print("_addKeywordProvider.ProviderEditTags: ${_addKeywordProvider.ProviderEditTags}");
        print("response: ${element.message!.content}");
      }
    }


    ProgressDialog.hide();

  }


  HeaderWidget() {
    return Container(
      padding: EdgeInsets.all(10.0),
      //color: Colors.deepPurple, // Change the color to your desired background color
      child: Text(
        'Solutions',
        style: TextStyle(
          color: Colors.black, // Change the text color to your desired color
          fontSize: 24.0, // Adjust the font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  var newvalue, resultString;
  var removekeyword =[];

  List<String> matches = [];

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

  void showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 3), // Adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Future<List<String>> Selectcategories() async {


  Future<String> oldSelectcategories() async {
    List<String> matches = [];    //
    String selectedValue = "Solution Category";
    // print("Getting Suggestions For " + selectedValue);

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Keywords').get();

      // print("querySnapshot ${querySnapshot}");

      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        dynamic data = snapshot.data();


        if (data != null && data.containsKey('Key')) {
          String key = data['Key'].toString().toLowerCase();

          if (key.contains(selectedValue.toLowerCase())) {
            // If the key matches, retrieve and add its values
            List<String> values = data.containsKey('Values') ? data['Values'].cast<String>() : [];
            // print("matches $matches");
            // print(" values $values");

            if (key == selectedValue?.toLowerCase()) {
              // Add only the values for the selected key
              matches.addAll(values);
              // print("matches ${matches}");

            }
          }
        }
      }
    } catch (e) {
      print("Error getting suggestions: $e");
    }
     resultString = matches.join(', ');

    print("resultString ${resultString}");

    return resultString;
    // return matches;
  }

  Future<String> newSelectCategories() async {
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
    resultString = matches.join(', ');
    print("resultString $resultString");
    return resultString;
  }



  // void showEditThriverDialogBox(thriversDetails,Id, Label, Description, newvalues, keywords) {
  // // void showEditThriverDialogBox(Id, Label, Description, newvalues) {
  //
  //
  //   List<TextEditingController> textControllers = [];
  //   for(int i=0;i<6;i++){
  //     textControllers.add(TextEditingController());
  //   }
  //   showDialog(
  //
  //       context: context,
  //       builder: (BuildContext context) {
  //     return  StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return Consumer<AddKeywordProvider>(
  //               builder: (c,addKeywordProvider, _){
  //                 editthriverNameTextEditingController.text = Label ;
  //                 editthriverDescTextEditingController.text = Description;
  //
  //                 print("new Values $keywords");
  //               // var thriversDetailssss =  documents.indexOf(thriversDetails);
  //               //   documents[thriversDetailssss].reference.update({"keyword":});
  //                 addKeywordProvider.newvalue = newvalues;
  //
  //                 // addKeywordProvider.EditsetSelectedValue(newvalues!);
  //
  //                 if (keywords != null) {
  //
  //                   var keynames = keywords.whereType<String>().toList();
  //                   print("keynames: $keynames");
  //
  //
  //                   keynames.removeWhere((element) => removekeyword.contains(element));
  //
  //                   print("keynames keynames: $keynames");
  //
  //                   // print("keynamessss: ${addKeywordProvider.newKeywordsList = keynames}");
  //                   addKeywordProvider.newKeywordsList = keynames;
  //                   _addKeywordProvider.addkeywordsList(keynames);
  //                   print("Tag newKeywordsList: ${addKeywordProvider.newKeywordsList}");
  //
  //                 }
  //                 //
  //                 // var keynames = keywords.whereType<String>().toList();
  //                 //
  //                 // addKeywordProvider.keywords = keynames;
  //
  //                 // addKeywordProvider.addkeywordsList(keynames);
  //
  //                 //
  //                 // print("stringKeywords: ${stringKeywords}");
  //                 //
  //                 // // Now, you can use 'stringKeywords' to set the value of newmultiSelectItems
  //                 // addKeywordProvider.editsetnewMultiSelectItems(keywords);// = stringKeywords.cast<String>();
  //                 //
  //                 // print("addKeywordProvider.editnewmultiSelectItems: ${addKeywordProvider.editnewmultiSelectItems}");
  //
  //                 // addKeywordProvider.getcategoryAndKeywords();
  //                 return
  //                   Theme(
  //                     data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
  //                     child: AlertDialog(
  //                       actions: <Widget>[
  //                         InkWell(
  //                           onTap: () async {
  //                             Navigator.pop(context);
  //                           },
  //                           child: Container(
  //                             width: 200,
  //                             height: 60,
  //                             decoration: BoxDecoration(
  //                               //color: Colors.white,
  //                               border: Border.all(
  //                                 //color:primaryColorOfApp ,
  //                                   width: 1.0),
  //                               borderRadius: BorderRadius.circular(15.0),
  //                             ),
  //                             child: Center(
  //                               child: Text(
  //                                 'Cancel',
  //                                 style: GoogleFonts.montserrat(
  //                                   textStyle:
  //                                   Theme
  //                                       .of(context)
  //                                       .textTheme
  //                                       .titleSmall,
  //                                   fontWeight: FontWeight.bold,
  //                                   //color: primaryColorOfApp
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //
  //                         ),
  //                         InkWell(
  //                           onTap: () async {
  //                             print("Label ${editthriverNameTextEditingController.text}");
  //                             print("Description ${editthriverDescTextEditingController.text}");
  //                             print("Category ${(addKeywordProvider.newselectedValue == null) ? addKeywordProvider.newvalue.toString() : addKeywordProvider.newselectedValue.toString()}");
  //                             print("Keywords ${addKeywordProvider.keywords}");
  //                             // print("Keywords ${addKeywordProvider.keywords}");
  //                             //ApiRepository().updateSecurityPINFor(userAccountId,newPinTextEditingController.text);
  //
  //                             ProgressDialog.show(
  //                                 context, "Update a Thriver", Icons.chair);
  //                             await ApiRepository().updateThriver({
  //                               'Label': editthriverNameTextEditingController.text,
  //                               'Description': editthriverDescTextEditingController.text,
  //                               'Category': (addKeywordProvider.newselectedValue == null) ? addKeywordProvider.newvalue.toString() : addKeywordProvider.newselectedValue.toString(),
  //                               // 'Keywords': addKeywordProvider.newKeywordsList,
  //                               'Keywords': addKeywordProvider.keywords,
  //                               'Associated Thrivers': "",
  //                               'Associated Challenges': ""
  //
  //                               /// Add more fields as needed
  //                             },
  //                                 Id
  //                             );
  //                             ProgressDialog.hide();
  //                             Navigator.pop(context);
  //                           },
  //                           child: Container(
  //                             width: 200,
  //                             height: 60,
  //                             decoration: BoxDecoration(
  //                               color: Colors.blue,
  //                               border: Border.all(
  //                                   color: Colors.blue,
  //                                   width: 2.0),
  //                               borderRadius: BorderRadius.circular(15.0),
  //                             ),
  //                             child: Center(
  //                               child: Text(
  //                                 'Update',
  //                                 style: GoogleFonts.montserrat(
  //                                     textStyle:
  //                                     Theme
  //                                         .of(context)
  //                                         .textTheme
  //                                         .titleSmall,
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.white),
  //                               ),
  //                             ),
  //                           ),
  //
  //                         ),
  //                       ],
  //                       title: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 20.0),
  //                             child: Text("Edit A Thriver",
  //                                 style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
  //                                     color: Colors.black)),
  //                           ),
  //                           Text("$Id", style: GoogleFonts.montserrat(textStyle:
  //                           Theme
  //                               .of(context)
  //                               .textTheme
  //                               .titleSmall,)),
  //                         ],
  //                       ),
  //                       content: SizedBox(
  //                         width: double.maxFinite,
  //                         //height: MediaQuery.of(context).size.height*0.5,
  //                         child: SingleChildScrollView(
  //                           child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               mainAxisSize: MainAxisSize.min,
  //                               children: <Widget>[
  //
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: TextField(
  //                                     controller: editthriverNameTextEditingController,
  //                                     // cursorColor: primaryColorOfApp,
  //                                     onChanged: (value) {
  //
  //                                     },
  //                                     style: GoogleFonts.montserrat(
  //                                         textStyle: Theme
  //                                             .of(context)
  //                                             .textTheme
  //                                             .bodyLarge,
  //                                         fontWeight: FontWeight.w400,
  //                                         color: Colors.black),
  //                                     decoration: InputDecoration(
  //                                       //errorText: userAccountSearchErrorText,
  //                                       contentPadding: EdgeInsets.all(25),
  //                                       labelText: "Thriver Label",
  //                                       hintText: "Thriver Label",
  //                                       /*prefixIcon: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Icon(Icons.question_mark_outlined,
  //                                  // color: primaryColorOfApp
  //                                   ),
  //                               ),*/
  //                                       errorStyle: GoogleFonts.montserrat(
  //                                           textStyle: Theme
  //                                               .of(context)
  //                                               .textTheme
  //                                               .bodyLarge,
  //                                           fontWeight: FontWeight.w400,
  //                                           color: Colors.redAccent),
  //
  //                                       focusedBorder: OutlineInputBorder(
  //                                           borderSide: BorderSide(color: Colors.black),
  //                                           borderRadius: BorderRadius.circular(15)),
  //                                       border: OutlineInputBorder(
  //                                           borderSide: BorderSide(color: Colors.black12),
  //                                           borderRadius: BorderRadius.circular(15)),
  //                                       //hintText: "e.g Abouzied",
  //                                       labelStyle: GoogleFonts.montserrat(
  //                                           textStyle: Theme
  //                                               .of(context)
  //                                               .textTheme
  //                                               .bodyLarge,
  //                                           fontWeight: FontWeight.w400,
  //                                           color: Colors.black),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: TextField(
  //                                     maxLines: null,
  //                                     controller: editthriverDescTextEditingController,
  //                                     //cursorColor: primaryColorOfApp,
  //                                     onChanged: (value) {
  //
  //                                     },
  //                                     style: GoogleFonts.montserrat(
  //                                         textStyle: Theme
  //                                             .of(context)
  //                                             .textTheme
  //                                             .bodyLarge,
  //                                         fontWeight: FontWeight.w400,
  //                                         color: Colors.black),
  //                                     decoration: InputDecoration(
  //                                       //errorText: userAccountSearchErrorText,
  //                                       contentPadding: EdgeInsets.all(25),
  //                                       labelText: "Thriver Description",
  //                                       hintText: "Thriver Description",
  //                                       /*prefixIcon: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Icon(Icons.question_mark_outlined,
  //                                   //color: primaryColorOfApp
  //                                   ),
  //                               ),*/
  //                                       errorStyle: GoogleFonts.montserrat(
  //                                           textStyle: Theme
  //                                               .of(context)
  //                                               .textTheme
  //                                               .bodyLarge,
  //                                           fontWeight: FontWeight.w400,
  //                                           color: Colors.redAccent),
  //
  //                                       focusedBorder: OutlineInputBorder(
  //                                           borderSide: BorderSide(color: Colors.black),
  //                                           borderRadius: BorderRadius.circular(15)),
  //                                       border: OutlineInputBorder(
  //                                           borderSide: BorderSide(color: Colors.black12),
  //                                           borderRadius: BorderRadius.circular(15)),
  //                                       //hintText: "e.g Abouzied",
  //                                       labelStyle: GoogleFonts.montserrat(
  //                                           textStyle: Theme
  //                                               .of(context)
  //                                               .textTheme
  //                                               .bodyLarge,
  //                                           fontWeight: FontWeight.w400,
  //                                           color: Colors.black),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //
  //
  //                                 Padding (
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: DropdownButtonFormField<String>(
  //                                     value: (addKeywordProvider.newselectedValue == null) ? addKeywordProvider.newvalue : addKeywordProvider.newselectedValue,
  //                                     onChanged: (value) async {
  //                                       addKeywordProvider.newselectedValue = value;
  //                                       await addKeywordProvider.updateKeyValues(value!);
  //                                       print("Selected Key Values: ${addKeywordProvider.newKeyValues}");
  //                                     },
  //                                     items: addKeywordProvider.dropdownItems.map((item) {
  //                                       return DropdownMenuItem<String>(
  //                                         value: item,
  //                                         child: Text(item),
  //                                       );
  //                                     }).toList(),
  //                                     decoration: InputDecoration(
  //                                       contentPadding: EdgeInsets.only(top: 25, bottom: 25, left: 32, right: 22),
  //                                       labelText: 'Select Category',
  //                                       hintText: 'Select Category',
  //                                       labelStyle: TextStyle(color: Colors.black),
  //                                       border: OutlineInputBorder(
  //                                         borderSide: BorderSide(color: Colors.black),
  //                                         borderRadius: BorderRadius.circular(15),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: TypeAheadField(
  //                                     noItemsFoundBuilder: (c){
  //                                       return Container(
  //                                           child: Padding(
  //                                             padding: const EdgeInsets.all(15.0),
  //                                             child: Text("No Keywords Found",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
  //                                           )
  //                                       );
  //                                     },
  //                                     suggestionsBoxDecoration: SuggestionsBoxDecoration(
  //                                         scrollbarTrackAlwaysVisible: true,
  //                                         scrollbarThumbAlwaysVisible: true,
  //                                         hasScrollbar: true,
  //                                         borderRadius: BorderRadius.circular(5),
  //                                         color: Colors.white,
  //                                         constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, )
  //                                     ),
  //                                     suggestionsCallback: (value) async {
  //                                       return await KeywordServices.getSuggestions(value, (addKeywordProvider.newselectedValue == null) ? addKeywordProvider.newvalue : addKeywordProvider.newselectedValue);
  //                                     },
  //                                     itemBuilder: (context, String suggestion) {
  //                                       print('selected multiple items ${addKeywordProvider.newKeywordsList}');
  //                                       return Container(
  //                                         // color: Colors.black,
  //                                         child: Padding(
  //                                           padding: const EdgeInsets.all(15.0),
  //                                           child: Text(suggestion,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
  //                                         ),
  //                                       );
  //                                     },
  //                                     // onSuggestionSelected: (String suggestion) {
  //                                     //   print("Im selectedf $suggestion");
  //                                     //   print("Im selectedf ${tagscontroller.text}" );
  //                                     //   addKeywordProvider.updateSuggetion(suggestion);
  //                                     //   tagscontroller.text = addKeywordProvider.suggestion;
  //                                     //   addKeywordProvider.addkeywordschip(suggestion);
  //                                     // },
  //                                     onSuggestionSelected: (String suggestion) {
  //                                       addKeywordProvider.addkeywordschip(suggestion);
  //                                     },
  //                                     textFieldConfiguration: TextFieldConfiguration(
  //                                       controller: tagscontroller,
  //                                       onSubmitted: (text) {
  //                                         addKeywordProvider.addkeywordschip(tagscontroller.text.toString());
  //                                         // addKeywordProvider.addkeywordschip(addKeywordProvider.newselectedValue);
  //                                       },
  //                                       style: GoogleFonts.poppins(
  //                                         textStyle: Theme.of(context).textTheme.bodyLarge,
  //                                         color: Colors.black,
  //                                         fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
  //                                       ),
  //                                       decoration: InputDecoration(
  //                                         //errorText: userAccountSearchErrorText,
  //                                         contentPadding: EdgeInsets.all(25),
  //                                         labelText: "Add Keywords",
  //                                         hintText: "Add Keywords",
  //                                         /*prefixIcon: Padding(
  //                                 padding: const EdgeInsets.all(8.0),
  //                                 child: Icon(Icons.question_mark_outlined,
  //                                   //color: primaryColorOfApp
  //                                   ),
  //                               ),*/
  //                                         errorStyle: GoogleFonts.montserrat(
  //                                             textStyle: Theme.of(context).textTheme.bodyLarge,
  //                                             fontWeight: FontWeight.w400,
  //                                             color: Colors.redAccent),
  //
  //                                         focusedBorder: OutlineInputBorder(
  //                                             borderSide: BorderSide(color: Colors.black),
  //                                             borderRadius: BorderRadius.circular(15)),
  //                                         border: OutlineInputBorder(
  //                                             borderSide: BorderSide(color: Colors.black12),
  //                                             borderRadius: BorderRadius.circular(15)),
  //                                         //hintText: "e.g Abouzied",
  //                                         labelStyle: GoogleFonts.montserrat(
  //                                             textStyle: Theme.of(context).textTheme.bodyLarge,
  //                                             fontWeight: FontWeight.w400,
  //                                             color: Colors.black),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                                 SizedBox(height: 16),
  //
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(left: 15.0),
  //                                   child: Align(
  //                                     alignment: Alignment.centerLeft,
  //                                     child: Wrap(
  //                                       spacing: 10,
  //                                       runSpacing: 10,
  //                                       crossAxisAlignment: WrapCrossAlignment.start,
  //                                       alignment: WrapAlignment.start,
  //                                       runAlignment: WrapAlignment.start,
  //                                       children: addKeywordProvider.keywords.map((item){
  //                                         print("item: $item");
  //                                         print("addKeywordProvider.keywords: ${addKeywordProvider.keywords}");
  //                                         return Container(
  //                                           height: 50,
  //                                           // width: 200,
  //                                           padding: EdgeInsets.all(8),
  //                                           decoration: BoxDecoration(
  //                                               borderRadius: BorderRadius.circular(15),
  //                                               color: Colors.blue
  //                                           ),
  //                                           child: Row(
  //                                             mainAxisSize: MainAxisSize.min,
  //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                             children: [
  //                                               Text(item, style: TextStyle(
  //                                                   fontWeight: FontWeight.w700
  //                                               ),),
  //                                               IconButton(
  //                                                   onPressed: ()async{
  //                                                     // addKeywordProvider.newKeywordsList.remove(item);
  //                                                     _addKeywordProvider.removekeywords(item);
  //                                                     await ApiRepository.removeKeywordFromList(Id, item);
  //                                                     fetchDatas();
  //                                                     // setState(() {
  //                                                     //
  //                                                     // });
  //                                                     setState(() {
  //                                                       // Update other state variables if needed
  //                                                     });
  //
  //                                                   },
  //                                                   icon: Icon(Icons.close,size: 20, color: Colors.white,)
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         );
  //                                       }).toList(),
  //                                     ),
  //                                   ),
  //                                 ),
  //
  //                               ]
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //               });
  //         }
  //
  //     );
  //       }
  //   );
  // }

  void showEditThriverDialogBox(documentReference,Id, Label, Description, newvalues, keywords, createdat,createdby,tags, modifiedBy,modifiedDate,insideId) {


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
                              .width * 0.08),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  editoriginaltextEditingController.clear();
                                  editfinaltextcontroller.clear();
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
                              SizedBox(height: 5,width: 5,),
                              InkWell(
                                onTap: () async {


                                  if(editthriverNameTextEditingController.text.isEmpty ||
                                      // editthriverDescTextEditingController.text.isEmpty ||
                                      _editcontroller.document.isEmpty() ||
                                      editKeywordssss.isEmpty
                                      || edittags.isEmpty ||
                                      editstatusvalue == null ||
                                      editsourceValue == null
                                  ) {
                                    if(editthriverNameTextEditingController.text.isEmpty){
                                      // showSnackBar(context,"Enter Label", Colors.red);
                                      showEmptyAlert(context,"Enter Label");
                                    }
                                   else if(_editcontroller.document.isEmpty()){
                                   // else if(editthriverDescTextEditingController.text.isEmpty){
                                      // showSnackBar(context,"Enter Expanded Description",Colors.red);
                                      showEmptyAlert(context,"Enter Expanded\nDescription");
                                    }
                                    else if(editKeywordssss.isEmpty){
                                      // showSnackBar(context,"Add Some Categories", Colors.red);
                                      showEmptyAlert(context,"Add Some Categories");
                                    }
                                    else if(edittags.isEmpty){
                                      // showSnackBar(context,"Add Some Categories", Colors.red);
                                      showEmptyAlert(context,"Add Some Tags");
                                    }
                                    else if(editstatusvalue == null ){
                                      // showSnackBar(context,"Add Some Categories", Colors.red);
                                      showEmptyAlert(context,"Select status");
                                    }
                                    else if(editsourceValue == null ){
                                      // showSnackBar(context,"Add Some Categories", Colors.red);
                                      showEmptyAlert(context,"Select source");
                                    }
                                  }    else {
                                    ProgressDialog.show(context, "Update a Thriver", Icons.update);
                                    await ApiRepository().updateThriver({
                                      "Thirver Status": editstatusvalue,
                                      "Source": editsourceValue,
                                      "tags": edittags,
                                      "Created By": createdby,
                                      "Created Date": createdat,
                                      "Modified By": widget.AdminName,
                                      "Modified Date": ModifiedAt,
                                      'Label': editthriverNameTextEditingController.text,
                                      // 'Description': editthriverDescTextEditingController.text,
                                      'Original Description': editoriginaltextEditingController.text,
                                      'Final_description': editfinaltextcontroller.text,
                                      'Impact': editImpacttextcontroller.text,
                                      'Notes': editNotestextcontroller.text,
                                      'Description': _editcontroller.document.toPlainText(),
                                      'Category': (_addKeywordProvider.newselectedValue == null) ? newselectedValue.toString() : _addKeywordProvider.newselectedValue.toString(),
                                      // 'Keywords': addKeywordProvider.newKeywordsList,
                                      'Keywords': editKeywordssss,


                                      /// Add more fields as needed
                                    }, Id);
                                    addTagListToDocument(edittags);
                                    _addKeywordProvider.loadDataForPage(1);
                                    _addKeywordProvider.setFirstpageNo();
                                    ProgressDialog.hide();
                                    // print("After Update Description ${editthriverDescTextEditingController.text}");
                                    editoriginaltextEditingController.clear();
                                    editfinaltextcontroller.clear();
                                    Navigator.pop(context);
                                  }
                                  // _addKeywordProvider.newselectedValue = null;
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
                                      'Update',
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
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text("Edit A Solution",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ),
                            SizedBox(height: 5,width: 5,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text("Id: SH0$insideId",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(textStyle:
                                  Theme.of(context).textTheme.titleSmall,)
                              ),
                            ),
                            (createdby.toString().isNotEmpty) ? Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text("Entered By: $createdby",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(textStyle:
                                  Theme.of(context).textTheme.titleSmall,)
                              ),
                            ) : Container(),
                            (formattedDate.toString().isNotEmpty) ? Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text("Entered Date: $formattedDate",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(textStyle:
                                  Theme.of(context).textTheme.titleSmall,)
                              ),
                            ) : Container(),
                            (modifiedBy.toString().isNotEmpty) ? Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text("Modified By: $modifiedBy",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(textStyle:
                                  Theme.of(context).textTheme.titleSmall,)
                              ),
                            ) : Container(),
                            (modifiedDate.toString().isNotEmpty) ? Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text("Modified Date: $modifiedDate",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(textStyle:
                                  Theme.of(context).textTheme.titleSmall,)
                              ),
                            ) : Container(),
                          ],
                        ),
                          content:   SizedBox(
                                width: double.maxFinite,
                                //height: MediaQuery.of(context).size.height*0.5,
                                child:  StatefulBuilder(
                                    builder: (context,innerState) {
                                      return FutureBuilder(
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
                                                // Extracting data from snapshot object
                                                DocumentSnapshot? doc = snapshot.data;
                                                //Map valueMap = jsonDecode(data);
                                                // print("DocumentSnapshot : ${doc?.data()}");

                                                editthriverNameTextEditingController.text = doc?.get("Label");
                                                // editthriverDescTextEditingController.text = doc?.get("Description");
                                                editoriginaltextEditingController.text = doc?.get('Original Description');
                                                editfinaltextcontroller.text = doc?.get('Final_description');
                                                editImpacttextcontroller.text = doc?.get('Impact');
                                                editNotestextcontroller.text = doc?.get('Notes');
                                                // _editcontroller.document.toPlainText() = doc?.get("Description");

                                                // _editcontroller = QuillController(
                                                //   document: Document()..insert(0, doc?.get("Description")),
                                                //   selection: TextSelection.collapsed(offset: doc?.get("Description").length),
                                                // );

                                                _editcontroller.document = Document()..insert(0, (doc?.get("Description")=="" ||doc?.get("Description")==null) ?  "Expanded Description" : doc?.get("Description"));

                                                // (doc?.get("Description")=="" ||doc?.get("Description")==null) ? _editcontroller.document.insert(0, "Expanded Description") : _editcontroller.document.insert(0, doc?.get("Description"));

                                                newselectedValue = doc?.get("Category");
                                                editsourceValue = (doc?.get("Source") == "" ||doc?.get("Source") == null )?"MTH RfA email 20240130":doc?.get("Source");
                                                // editstatusvalue = doc?.get("Thirver Status");
                                                // editstatusvalue = 'New';//doc?.get("Thirver Status");
                                                editstatusvalue = (doc?.get("Thirver Status") == "" ||doc?.get("Thirver Status") == null ) ? 'New' : doc?.get("Thirver Status");
                                                editKeywordssss = doc?.get("Keywords");
                                                edittags = doc?.get("tags");
                                                // print("editKeywordssss: $editKeywordssss");
                                                // print("edittags: $edittags");

                                                _addKeywordProvider.addkeywordsList(editKeywordssss);
                                                _addKeywordProvider.addProviderEditTagsList(edittags);
                                                // print("_addKeywordProvider.addProviderEditTagsList(edittags) after: $editstatusvalue");

                                                //_mandatorySection = doc?.get("mandatory");

                                                return SingleChildScrollView(
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: DropdownButtonFormField<String>(
                                                                  value: editsourceValue,
                                                                  // value: 'Thrivers Category',
                                                                  // value: ,
                                                                  onChanged: (value) async {
                                                                    editsourceValue = value;
                                                                  },
                                                                  // onChanged: null,
                                                                  items: _addKeywordProvider.sourceItems.map((item) {
                                                                    return DropdownMenuItem<String>(
                                                                      value: item,
                                                                      child: Text(item),
                                                                    );
                                                                  }).toList(),
                                                                  // onTap: null,
                                                                  decoration: InputDecoration(
                                                                    // iconColor: Colors.black,
                                                                    contentPadding: EdgeInsets.only(
                                                                        top: 25, bottom: 25, left: 32, right: 22),
                                                                    labelText: 'Source',
                                                                    hintText: 'Source',
                                                                    labelStyle: TextStyle(color: Colors.black),
                                                                    border: OutlineInputBorder(
                                                                        borderSide: BorderSide(color: Colors.black),
                                                                        borderRadius: BorderRadius.circular(15)
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            Flexible(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: DropdownButtonFormField<String>(
                                                                  value: editstatusvalue,
                                                                  // value: 'Thrivers Category',
                                                                  // value: ,
                                                                  onChanged: (value) async {
                                                                    editstatusvalue = value;
                                                                  },
                                                                  // onChanged: null,
                                                                  items: _addKeywordProvider.ThriversStatusItems.map((item) {
                                                                    return DropdownMenuItem<String>(
                                                                      value: item,
                                                                      child: Text(item),
                                                                    );
                                                                  }).toList(),
                                                                  onTap: null,
                                                                  decoration: InputDecoration(
                                                                    // iconColor: Colors.black,
                                                                    contentPadding: EdgeInsets.only(
                                                                        top: 25, bottom: 25, left: 32, right: 22),
                                                                    labelText: 'Thriver Status',
                                                                    hintText: 'Thriver Status',
                                                                    labelStyle: TextStyle(color: Colors.black),
                                                                    border: OutlineInputBorder(
                                                                        borderSide: BorderSide(color: Colors.black),
                                                                        borderRadius: BorderRadius.circular(15)
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                          ],
                                                        ),

                                                        SizedBox(height: 10,),

                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextField(
                                                            maxLines: null,
                                                            controller: editoriginaltextEditingController,
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
                                                              labelText: "Original Description",
                                                              hintText: "Original Description",

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
                                                        ),
                                                        InkWell(
                                                          onTap: ()async{

                                                            // print(q1);
                                                            // print(editoriginaltextEditingController.text.toString());


                                                            var defaulttext ;
                                                            defaulttext = q1;
                                                            defaulttext = defaulttext +""+ "where xxx = ${editoriginaltextEditingController.text.toString()}";
                                                            // print(defaulttext);
                                                            await editThrivergetChatResponse(defaulttext);

                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.only(top: 20,left: 10,right: 10, bottom: 10),
                                                            width: 200,
                                                            height: 60,
                                                            decoration: BoxDecoration(
                                                              color:Colors.blue,
                                                              border: Border.all(
                                                                  color:Colors.blue,
                                                                  width: 2.0),
                                                              borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'Clean',
                                                                style: GoogleFonts.montserrat(
                                                                    textStyle:
                                                                    Theme.of(context).textTheme.titleSmall,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white),
                                                              ),
                                                            ),
                                                          ),

                                                        ),


                                                        Padding(


                                                          /// Final Description
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextField(
                                                            // maxLines: null,
                                                            maxLines: null,
                                                            controller: editfinaltextcontroller,
                                                            // cursorColor: primaryColorOfApp,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                                                            ],
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
                                                              labelText: "Description",
                                                              hintText: "Description",


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
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            // _editcontroller.clear();

                                                            // _addKeywordProvider.keywords.removeRange(0, _addKeywordProvider.keywords.length);
                                                            // _addKeywordProvider.ProviderEditTags.removeRange(0, _addKeywordProvider.ProviderEditTags.length);

                                                            // _addKeywordProvider.ProviderEditTags.clear();
                                                            var defaulttext ="";
                                                            // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                                                            defaulttext =  q2;
                                                            defaulttext =  defaulttext + " where yyy is "+editfinaltextcontroller.text.toString();
                                                            var defaulttextq3 ="";
                                                            // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                                                            defaulttextq3 =  q3;
                                                            defaulttextq3 =  defaulttextq3 + " where yyy is "+editfinaltextcontroller.text.toString();

                                                            var defaulttextq4 ="";
                                                            // defaulttext ="1."+ "$q1"+" "+originaltextEditingController.text.toString();
                                                            defaulttextq4 =  q4;
                                                            defaulttextq4 =  defaulttextq4 + " where yyy is "+editfinaltextcontroller.text.toString();
                                                            defaulttextq4 =  defaulttextq4 + " and select tags from "+"${resultString}";
                                                            print("defaulttextq4: ${defaulttextq4}");


                                                            var defaulttextq5 ="";
                                                            defaulttextq5 =  q5;
                                                            defaulttextq5 =  defaulttextq5 + " where yyy is "+editfinaltextcontroller.text.toString();

                                                            // defaulttext =defaulttext +" 3."+ "  $q3 "+originaltextEditingController.text.toString();
                                                            // defaulttext =defaulttext +" 4."+ "  $q4 "+originaltextEditingController.text.toString();
                                                            // defaulttext =defaulttext +" 5."+ "  $q5 "+originaltextEditingController.text.toString();
                                                            await editThrivergetChatResponsenew(defaulttext,defaulttextq3,defaulttextq4,defaulttextq5);

                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.all(10),
                                                            width: 200,
                                                            height: 60,
                                                            decoration: BoxDecoration(
                                                              color:Colors.blue,
                                                              border: Border.all(
                                                                  color:Colors.blue,
                                                                  width: 2.0),
                                                              borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'Expand',
                                                                style: GoogleFonts.montserrat(
                                                                    textStyle:
                                                                    Theme.of(context).textTheme.titleSmall,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextField(
                                                            controller: editthriverNameTextEditingController,
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
                                                              //errorText: userAccountSearchErrorText,
                                                              contentPadding: EdgeInsets.all(25),
                                                              labelText: "Label",
                                                              hintText: "Label",
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
                                                        ),

                                                        // Padding(
                                                        //   padding: const EdgeInsets.all(8.0),
                                                        //   child: TextField(
                                                        //     maxLines: null,
                                                        //     controller: editthriverDescTextEditingController,
                                                        //     //cursorColor: primaryColorOfApp,
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
                                                        //       labelText: "Expanded Description",
                                                        //       hintText: "Expanded Description",
                                                        //       /*prefixIcon: Padding(
                                                        //         padding: const EdgeInsets.all(8.0),
                                                        //         child: Icon(Icons.question_mark_outlined,
                                                        //           //color: primaryColorOfApp
                                                        //           ),
                                                        //       ),*/
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

                                                        Container(
                                                          /// Details
                                                          margin: const EdgeInsets.all(8.0),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              border: Border.all(color: Colors.black, width: 1)
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets.all(10),
                                                                child: QuillEditor.basic(
                                                                  configurations: QuillEditorConfigurations(
                                                                    // placeholder: "Expanded Description",

                                                                    maxContentWidth: null,
                                                                    // maxHeight: 200,
                                                                    padding: EdgeInsets.only(left: 10, top: 10),
                                                                    controller: _editcontroller,
                                                                    readOnly: false,
                                                                    maxHeight: null,
                                                                    sharedConfigurations: const QuillSharedConfigurations(
                                                                      locale: Locale('en'),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Divider(),
                                                              QuillToolbar.simple(
                                                                configurations: QuillSimpleToolbarConfigurations(
                                                                  controller: _editcontroller,
                                                                  sharedConfigurations: const QuillSharedConfigurations(
                                                                    locale: Locale('en'),
                                                                  ),
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                        ),


                                                        Padding(


                                                          /// Impact
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextField(
                                                            // maxLines: null,
                                                            maxLines: null,
                                                            controller: editImpacttextcontroller,
                                                            // cursorColor: primaryColorOfApp,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                                                            ],
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
                                                              labelText: "Impact",
                                                              hintText: "Impact",


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
                                                        ),


                                                        /// Category
                                                        // Consumer<AddKeywordProvider>(
                                                        //     builder: (c,addKeywordProvider, _){
                                                        //       return Padding (
                                                        //           padding: const EdgeInsets.all(8.0),
                                                        //           child: DropdownButtonFormField<String>(
                                                        //             value: (addKeywordProvider.newselectedValue == null) ? newselectedValue : addKeywordProvider.newselectedValue,
                                                        //             // value: newselectedValue,
                                                        //             // onChanged: (value) async {
                                                        //             //   addKeywordProvider.newselectedValue = value;
                                                        //             //   editKeywordssss.clear();
                                                        //             //   await addKeywordProvider.updateKeyValues(value!,newselectedValue);
                                                        //             //   print("Selected Key Values: ${addKeywordProvider.newKeyValues}");
                                                        //             //   print("addKeywordProvider.newselectedValue: ${_addKeywordProvider.newselectedValue}");
                                                        //             //   print("newselectedValue: ${newselectedValue}");
                                                        //             // },
                                                        //               onChanged: null,
                                                        //               items: addKeywordProvider.dropdownItems.map((item) {
                                                        //               return DropdownMenuItem<String>(
                                                        //                 value: item,
                                                        //                 child: Text(item),
                                                        //               );
                                                        //             }).toList(),
                                                        //             decoration: InputDecoration(
                                                        //               contentPadding: EdgeInsets.only(top: 25, bottom: 25, left: 32, right: 22),
                                                        //               labelText: 'Edit Category',
                                                        //               hintText: 'Edit Category',
                                                        //               labelStyle: TextStyle(color: Colors.black),
                                                        //               border: OutlineInputBorder(
                                                        //                 borderSide: BorderSide(color: Colors.black),
                                                        //                 borderRadius: BorderRadius.circular(15),
                                                        //               ),
                                                        //             ),
                                                        //           ),
                                                        //         );
                                                        //     }),

                                                        Consumer<AddKeywordProvider>(
                                                            builder: (c,addKeywordProvider, _){
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: TypeAheadField(
                                                                  noItemsFoundBuilder: (c){
                                                                    return Container(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(15.0),
                                                                          child: Text("No Category Found",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
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
                                                                  suggestionsCallback: (value) async {
                                                                    // return await KeywordServices.getSuggestions(value, (addKeywordProvider.newselectedValue == null) ? newselectedValue : addKeywordProvider.newselectedValue);
                                                                    return await KeywordServicessss.getSuggestions(value);
                                                                  },
                                                                  itemBuilder: (context, String suggestion) {
                                                                    // print('selected multiple items before newselectedValue ${suggestion}');
                                                                    // print('selected multiple items after newselectedValue ${addKeywordProvider.newKeyValues} ');
                                                                    return Container(
                                                                      // color: Colors.black,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(15.0),
                                                                        child: Text(suggestion,style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                                                                      ),
                                                                    );
                                                                  },
                                                                  direction: AxisDirection.up,
                                                                  onSuggestionSelected: (String suggestion) {
                                                                    // print('onSuggestionSelected before  ${editKeywordssss}');
                                                                    addKeywordProvider.addkeywordschip(suggestion,editKeywordssss);
                                                                    editcategorycontroller.clear();
                                                                    // print('onSuggestionSelected after  ${editKeywordssss}');
                                                                  },
                                                                  textFieldConfiguration: TextFieldConfiguration(
                                                                    controller: editcategorycontroller,
                                                                    // onSubmitted: (text) {
                                                                    //   addKeywordProvider.addkeywordschip(tagscontroller.text.toString(),editKeywordssss);
                                                                    //   // addKeywordProvider.addkeywordschip(addKeywordProvider.newselectedValue);
                                                                    // },
                                                                    style: GoogleFonts.poppins(
                                                                      textStyle: Theme.of(context).textTheme.bodyLarge,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                                                                    ),
                                                                    decoration: InputDecoration(
                                                                      //errorText: userAccountSearchErrorText,
                                                                      contentPadding: EdgeInsets.all(25),
                                                                      labelText: "Category",
                                                                      hintText: "Category",
                                                                      /*prefixIcon: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Icon(Icons.question_mark_outlined,
                                                                          //color: primaryColorOfApp
                                                                          ),
                                                                      ),*/
                                                                      errorStyle: GoogleFonts.montserrat(
                                                                          textStyle: Theme.of(context).textTheme.bodyLarge,
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
                                                                          textStyle: Theme.of(context).textTheme.bodyLarge,
                                                                          fontWeight: FontWeight.w400,
                                                                          color: Colors.black),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                        ),

                                                        SizedBox(height: 16),

                                                        Consumer<AddKeywordProvider>(
                                                            builder: (c,addKeywordProvider, _){
                                                              return Padding(
                                                                padding: const EdgeInsets.only(left: 15.0),
                                                                child: Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Wrap(
                                                                    spacing: 10,
                                                                    runSpacing: 10,
                                                                    crossAxisAlignment: WrapCrossAlignment.start,
                                                                    alignment: WrapAlignment.start,
                                                                    runAlignment: WrapAlignment.start,
                                                                    children: addKeywordProvider.keywords.map((item){
                                                                      // print("item: $item");
                                                                      // print("addKeywordProvider.keywords: ${addKeywordProvider.keywords}");
                                                                      return Container(
                                                                        height: 50,
                                                                        // width: 200,
                                                                        margin: EdgeInsets.only(bottom: 10),
                                                                        padding: EdgeInsets.all(8),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(15),
                                                                            color: Colors.blue
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(item, style: TextStyle(
                                                                                fontWeight: FontWeight.w700
                                                                            ),),
                                                                            // IconButton(
                                                                            //     onPressed: ()async{
                                                                            //       // addKeywordProvider.newKeywordsList.remove(item);
                                                                            //       _addKeywordProvider.removekeywords(item);
                                                                            //       await ApiRepository.removeKeywordFromList(Id, item);
                                                                            //       fetchDatas();
                                                                            //       // setState(() {
                                                                            //       //
                                                                            //       // });
                                                                            //       setState(() {
                                                                            //         // Update other state variables if needed
                                                                            //       });
                                                                            //
                                                                            //     },
                                                                            //     icon: Icon(Icons.close,size: 20, color: Colors.white,)
                                                                            // ),
                                                                            IconButton(
                                                                                onPressed: ()async{
                                                                                  // addKeywordProvider.newKeywordsList.remove(item);
                                                                                  _addKeywordProvider.removekeywords(item);
                                                                                  editKeywordssss.remove(item);
                                                                                },
                                                                                icon: Icon(Icons.close,size: 20, color: Colors.white,)
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                              );
                                                            }),


                                                        // Padding(
                                                        //   padding: const EdgeInsets.all(8.0),
                                                        //   child: TypeAheadField(
                                                        //     noItemsFoundBuilder: (c){
                                                        //       return Container(
                                                        //           child: Padding(
                                                        //             padding: const EdgeInsets.all(15.0),
                                                        //             child: Text("Add Tag: '${tagscontroller.text}'",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
                                                        //           )
                                                        //       );
                                                        //     },
                                                        //     suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                                        //         scrollbarTrackAlwaysVisible: true,
                                                        //         scrollbarThumbAlwaysVisible: true,
                                                        //         hasScrollbar: true,
                                                        //         borderRadius: BorderRadius.circular(5),
                                                        //         color: Colors.white,
                                                        //         constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, )
                                                        //     ),
                                                        //     suggestionsCallback: (String pattern) {
                                                        //      return ;
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
                                                        //       print("Im selectedf ${tagscontroller.text}" );
                                                        //       setState(() {
                                                        //         tagscontroller.text = suggestion;
                                                        //       });
                                                        //     },
                                                        //     textFieldConfiguration: TextFieldConfiguration(
                                                        //       controller: tagscontroller,
                                                        //       onSubmitted: (text) {
                                                        //
                                                        //       },
                                                        //       style: GoogleFonts.poppins(
                                                        //         textStyle: Theme.of(context).textTheme.bodyLarge,
                                                        //         color: Colors.white,
                                                        //         fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                                                        //       ),
                                                        //       decoration: InputDecoration(
                                                        //         //errorText: userAccountSearchErrorText,
                                                        //         contentPadding: EdgeInsets.all(25),
                                                        //         labelText: "Add Tags",
                                                        //         suffixIcon: IconButton(
                                                        //           icon: Icon(Icons.add, size: 20, color: primaryColorOfApp,),
                                                        //           onPressed: () {
                                                        //
                                                        //           },
                                                        //         ),
                                                        //
                                                        //         // hintText: "e.g 31st March 2023",
                                                        //         prefixIcon: Padding(
                                                        //           padding: const EdgeInsets.all(8.0),
                                                        //           child: Icon(Icons.tag,color: primaryColorOfApp,),
                                                        //         ),
                                                        //         errorStyle: GoogleFonts.montserrat(
                                                        //             textStyle: Theme.of(context).textTheme.bodyLarge,
                                                        //             fontWeight: FontWeight.w400,
                                                        //             color: Colors.redAccent),
                                                        //         enabledBorder:OutlineInputBorder(
                                                        //             borderSide: BorderSide(color: Colors.white12),
                                                        //             borderRadius: BorderRadius.circular(100)),
                                                        //         focusedBorder: OutlineInputBorder(
                                                        //             borderSide: BorderSide(color: Colors.white),
                                                        //             borderRadius: BorderRadius.circular(100)),
                                                        //         border: OutlineInputBorder(
                                                        //             borderSide: BorderSide(color: Colors.white12),
                                                        //             borderRadius: BorderRadius.circular(100)),
                                                        //         //hintText: "e.g Abouzied",
                                                        //         labelStyle: GoogleFonts.montserrat(
                                                        //             textStyle: Theme.of(context).textTheme.bodyLarge,
                                                        //             fontWeight: FontWeight.w400,
                                                        //             color: Colors.white54),
                                                        //       ),
                                                        //     ),
                                                        //   ),
                                                        // ),

                                                        // Padding(
                                                        //   padding: const EdgeInsets.all(8.0),
                                                        //   child: TextField(
                                                        //     controller: edittagscontroller,
                                                        //     // cursorColor: primaryColorOfApp,
                                                        //     onSubmitted: (value) {
                                                        //       _addKeywordProvider.addtags(value,edittags);
                                                        //       edittagscontroller.clear();
                                                        //       print("tags: $tags");
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
                                                        //       labelText: "Tags",
                                                        //       hintText: "Tags",
                                                        //       /*prefixIcon: Padding(
                                                        //         padding: const EdgeInsets.all(8.0),
                                                        //         child: Icon(Icons.question_mark_outlined,
                                                        //          // color: primaryColorOfApp
                                                        //           ),
                                                        //       ),*/
                                                        //       suffixIcon: IconButton(
                                                        //         icon: Icon(Icons.add, size: 20, color: primaryColorOfApp,),
                                                        //         onPressed: () {
                                                        //           _addKeywordProvider.addtags(tagscontroller.text.toString(),edittags);
                                                        //         },
                                                        //       ),
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

                                                        Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: TypeAheadField(
                                                            noItemsFoundBuilder: (c){
                                                              return Container(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(15.0),
                                                                    child: Text("Add Tag: '${edittagscontroller.text}'",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
                                                                    ),
                                                                  )
                                                              );
                                                            },
                                                            direction: AxisDirection.up,
                                                            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                                                scrollbarTrackAlwaysVisible: true,
                                                                scrollbarThumbAlwaysVisible: true,
                                                                hasScrollbar: true,
                                                                borderRadius: BorderRadius.circular(5),
                                                                // color: Colors.white,
                                                                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3, )
                                                            ),
                                                            suggestionsCallback: (value) async {
                                                              return await TagServices.getSuggestions(value);
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
                                                            onSuggestionSelected: (String suggestion) {
                                                              print("Im selectedf $suggestion" );
                                                              print("Im selectedf ${tagscontroller.text}" );
                                                              // setState(() {
                                                              edittagscontroller.text = suggestion;
                                                              _addKeywordProvider.addtags(edittagscontroller.text.toString(),edittags);
                                                              edittagscontroller.clear();

                                                              // });
                                                            },
                                                            textFieldConfiguration: TextFieldConfiguration(
                                                              controller: edittagscontroller,
                                                              onSubmitted: (text) {
                                                                _addKeywordProvider.addtags(text,edittags);
                                                                edittagscontroller.clear();
                                                                // print("tags: $tags");
                                                              },
                                                              style: GoogleFonts.poppins(
                                                                textStyle: Theme.of(context).textTheme.bodyLarge,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                                                              ),
                                                              decoration: InputDecoration(
                                                                //errorText: userAccountSearchErrorText,
                                                                contentPadding: EdgeInsets.all(25),
                                                                labelText: "Tags",
                                                                hintText: "Tags",
                                                                prefixIcon: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Icon(Icons.tag,color: primaryColorOfApp,),
                                                                ),
                                                                suffixIcon: IconButton(
                                                                  icon: Icon(Icons.add, size: 20, color: primaryColorOfApp,),
                                                                  onPressed: () {
                                                                    _addKeywordProvider.addtags(edittagscontroller.text.toString(),edittags);
                                                                    edittagscontroller.clear();

                                                                  },
                                                                ),
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
                                                        ),


                                                        SizedBox(height: 16),

                                                        Consumer<AddKeywordProvider>(
                                                            builder: (c,addKeywordProvider, _){
                                                              return Padding(
                                                                padding: const EdgeInsets.only(left: 15.0),
                                                                child: Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Wrap(
                                                                    spacing: 10,
                                                                    runSpacing: 10,
                                                                    crossAxisAlignment: WrapCrossAlignment.start,
                                                                    alignment: WrapAlignment.start,
                                                                    runAlignment: WrapAlignment.start,
                                                                    children: addKeywordProvider.ProviderEditTags.map((item){
                                                                      return Container(
                                                                        height: 50,
                                                                        // width: 200,
                                                                        padding: EdgeInsets.all(8),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(15),
                                                                            color: Colors.blue
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(item, style: TextStyle(
                                                                                fontWeight: FontWeight.w700
                                                                            ),),
                                                                            IconButton(
                                                                                onPressed: (){
                                                                                  // setState(() {
                                                                                    addKeywordProvider.removeedittags(item);
                                                                                    edittags.remove(item);
                                                                                  // });
                                                                                  },
                                                                                icon: Icon(Icons.close,size: 20, color: Colors.white,)
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                              );

                                                            }),

                                                        Padding(


                                                          /// Notes
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextField(
                                                            // maxLines: null,
                                                            maxLines: null,
                                                            controller: editNotestextcontroller,
                                                            // cursorColor: primaryColorOfApp,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                                                            ],
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
                                                              labelText: "Notes",
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
                                                        ),


                                                      ]
                                                  ),
                                                );
                                              }
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: primaryColorOfApp,
                                              ),
                                            );
                                      });
                            })
                              )
                      ),
                    );
                // });
        }
    );
  }

  void ViewSolutionDialog(documentReference,Id, Label, Description, newvalues, keywords, createdat,createdby,tags, modifiedBy,modifiedDate,insideId) {


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
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("SOLUTION VIEW",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          },
                              icon:Icon(Icons.close)
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5,width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Id: SH0$insideId",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(textStyle:
                          Theme.of(context).textTheme.titleSmall,)
                      ),
                    ),
                    (createdby.toString().isNotEmpty) ? Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Entered By: $createdby",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(textStyle:
                          Theme.of(context).textTheme.titleSmall,)
                      ),
                    ) : Container(),
                    (formattedDate.toString().isNotEmpty) ? Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Entered Date: $formattedDate",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(textStyle:
                          Theme.of(context).textTheme.titleSmall,)
                      ),
                    ) : Container(),
                    (modifiedBy.toString().isNotEmpty) ? Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Modified By: $modifiedBy",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(textStyle:
                          Theme.of(context).textTheme.titleSmall,)
                      ),
                    ) : Container(),
                    (modifiedDate.toString().isNotEmpty) ? Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Modified Date: $modifiedDate",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(textStyle:
                          Theme.of(context).textTheme.titleSmall,)
                      ),
                    ) : Container(),
                    // Divider()
                  ],
                ),
                content:   SizedBox(
                    width: double.maxFinite,
                    //height: MediaQuery.of(context).size.height*0.5,
                    child:  StatefulBuilder(
                        builder: (context,innerState) {
                          return FutureBuilder(
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
                                    var Description = doc?.get("Description");
                                var OriginalDescription = doc?.get('Original Description');

                                var Category = doc?.get("Category");
                                var Source = (doc?.get("Source") == "" ||doc?.get("Source") == null )?"MTH RfA email 20240130":doc?.get("Source");
                                var Status = (doc?.get("Thirver Status") == "" ||doc?.get("Thirver Status") == null ) ? 'New' : doc?.get("Thirver Status");

                                    editKeywordssss = doc?.get("Keywords");
                                    edittags = doc?.get("tags");

                                    _addKeywordProvider.addkeywordsList(editKeywordssss);
                                    _addKeywordProvider.addProviderEditTagsList(edittags);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 2,
                                            child: Container(
                                              height: 600,
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
                                                                                    
                                                      (Source==""|| Source==null) ? Container() :  Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Source: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                          Text(Source, style: TextStyle(fontSize: 20,),),
                                                                                    
                                                        ],
                                                      ),
                                                      SizedBox(height: 10,),
                                                      (Status==""|| Status==null) ? Container() :  Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Solution Status: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                          Text(Status, style: TextStyle(fontSize: 20, ),),
                                                                                    
                                                        ],
                                                      ),
                                                      SizedBox(height: 10,),
                                                      (name==""|| name==null) ? Container() : Row(
                                                        children: [
                                                          Text("Label: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                          Text(name, style: TextStyle(fontSize: 20, ),),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10,),
                                                      (OriginalDescription==""|| OriginalDescription==null) ? Container() :  Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Original Description: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                          Flexible(child: Text(OriginalDescription, style: TextStyle(fontSize: 20, ), maxLines: null,)),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10,),
                                                      (Description==""|| Description==null) ? Container() : Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Description: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                          Flexible(child: Text(Description, style: TextStyle(fontSize: 20, ), maxLines: null,)),
                                                        ],
                                                      ),
                                                                                    
                                                      SizedBox(height: 20,),
                                                                                    
                                                                                    
                                                                                    
                                                      (_addKeywordProvider.keywords==""|| _addKeywordProvider.keywords==null||_addKeywordProvider.keywords.isEmpty) ? Container() :     Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Category: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                          Consumer<AddKeywordProvider>(
                                                              builder: (c,addKeywordProvider, _){
                                                                return Padding(
                                                                  padding: const EdgeInsets.only(left: 15.0),
                                                                  child: Align(
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
                                                                        return Container(
                                                                          height: 50,
                                                                          // width: 200,
                                                                          margin: EdgeInsets.only(bottom: 10),
                                                                          padding: EdgeInsets.all(8),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                              color: Colors.blue
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(item, style: TextStyle(
                                                                                  fontWeight: FontWeight.w700
                                                                              ),),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                        ],
                                                      ),
                                                                                    
                                                      SizedBox(height: 10),
                                                                                    
                                                      (_addKeywordProvider.ProviderEditTags==""|| _addKeywordProvider.ProviderEditTags==null||_addKeywordProvider.ProviderEditTags.isEmpty) ? Container() :  Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Tags: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                                                                                    
                                                          Expanded(
                                                            child: Consumer<AddKeywordProvider>(
                                                                builder: (c,addKeywordProvider, _){
                                                                  return Padding(
                                                                    padding: const EdgeInsets.only(left: 15.0),
                                                                    child: Align(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Wrap(
                                                                        spacing: 10,
                                                                        runSpacing: 10,
                                                                        crossAxisAlignment: WrapCrossAlignment.start,
                                                                        alignment: WrapAlignment.start,
                                                                        runAlignment: WrapAlignment.start,
                                                                        children: addKeywordProvider.ProviderEditTags.map((item){
                                                                          return Container(
                                                                            height: 50,
                                                                            // width: 200,
                                                                            padding: EdgeInsets.all(8),
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                                color: Colors.blue
                                                                            ),
                                                                            child: Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(item, style: TextStyle(
                                                                                    fontWeight: FontWeight.w700
                                                                                ),),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                      ),
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
                                          SizedBox(width: 5,),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              height: 600,
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
                                                      height: 270 ,
                                                      child: FutureBuilder(
                                                        future: getRelatedSolutions(tags, keywords),
                                                        builder: (context, snapshot) {
                                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                                            return Container(
                                                                width: 470,
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
                                                                      relatedSolutionlength = relatedSolutions?.length;
                                                                      print("relatedSolutionlength: $relatedSolutionlength");
                                                                      var solutionData = relatedSolutions?[i].data() as Map<String, dynamic>;
                                                                      print("solutionData: ${solutionData}");
                                                                      return Container(
                                                                        margin: EdgeInsets.symmetric(horizontal: 15),
                                                                        padding: EdgeInsets.all(12),
                                                                        width: 470,
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(color: Colors.black),
                                                                          borderRadius: BorderRadius.circular(20),
                                                                        ),
                                                                        child: SingleChildScrollView(
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text("SH0${solutionData['id']}.",
                                                                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                      fontSize: 20,
                                                                                      color: Colors.black)),
                                                                              Text("${solutionData['Label']}",
                                                                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                      fontSize: 25,
                                                                                      color: Colors.black)),
                                                                              Text("${solutionData['Description']}",
                                                                                  maxLines: 3,
                                                                                  style: GoogleFonts.montserrat(
                                                                                      fontSize: 15,
                                                                                      color: Colors.black)),
                                                                              SizedBox(height: 5,),
                                                                              Text("Tags :",
                                                                                  style: GoogleFonts.montserrat(
                                                                                    fontWeight: FontWeight.bold,
                                                                                      fontSize: 15,
                                                                                      color: Colors.black)),
                                                                              Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Wrap(
                                                                                  spacing: 10,
                                                                                  runSpacing: 5,
                                                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                                                  alignment: WrapAlignment.start,
                                                                                  runAlignment: WrapAlignment.start,
                                                                                  children: (solutionData['tags'] as List<dynamic>).map<Widget>((item){
                                                                                    print("solutionDataitem: $item");
                                                                                    print("solutionData['tags']: ${solutionData['tags']}");
                                                                                    return Container(
                                                                                      height: 35,
                                                                                      // width: 200,
                                                                                      margin: EdgeInsets.only(bottom: 2),
                                                                                      padding: EdgeInsets.all(6),
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(15),
                                                                                          color: Colors.blue
                                                                                      ),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text("${item}", style: TextStyle(
                                                                                              fontWeight: FontWeight.w700,
                                                                                            fontSize: 14
                                                                                          ),),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  }).toList(),
                                                                                ),
                                                                              ),

                                                                              SizedBox(height: 5,),

                                                                              Text("Category :",
                                                                                  style: GoogleFonts.montserrat(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 15,
                                                                                      color: Colors.black)),
                                                                              Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Wrap(
                                                                                  spacing: 10,
                                                                                  runSpacing: 5,
                                                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                                                  alignment: WrapAlignment.start,
                                                                                  runAlignment: WrapAlignment.start,
                                                                                  children: (solutionData['Keywords'] as List<dynamic>).map<Widget>((item){
                                                                                    print("solutionDataitem: $item");
                                                                                    print("solutionData['Keywords']: ${solutionData['Keywords']}");
                                                                                    return Container(
                                                                                      height: 35,
                                                                                      // width: 200,
                                                                                      margin: EdgeInsets.only(bottom: 2),
                                                                                      padding: EdgeInsets.all(6),
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(15),
                                                                                          color: Colors.blue
                                                                                      ),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text("${item}", style: TextStyle(
                                                                                              fontWeight: FontWeight.w700,
                                                                                              fontSize: 14
                                                                                          ),),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  }).toList(),
                                                                                ),
                                                                              )
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
                                                      height: 270 ,
                                                      child: FutureBuilder(
                                                        future: getRelatedChallenges(tags, keywords),
                                                        builder: (context, snapshot) {
                                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                                            return Container(
                                                                width: 470,
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
                                                                      relatedSolutionlength = relatedChallenges?.length;
                                                                      print("relatedSolutionlength: $relatedSolutionlength");
                                                                      var challengesData = relatedChallenges?[i].data() as Map<String, dynamic>;
                                                                      print("solutionData: ${challengesData}");
                                                                      return Container(
                                                                        margin: EdgeInsets.symmetric(horizontal: 15),
                                                                        padding: EdgeInsets.all(12),
                                                                        width: 470,
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(color: Colors.black),
                                                                          borderRadius: BorderRadius.circular(20),
                                                                        ),
                                                                        child: SingleChildScrollView(
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text("CH0${challengesData['id']}.",
                                                                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                      fontSize: 20,
                                                                                      color: Colors.black)),
                                                                              Text("${challengesData['Label']}",
                                                                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                                                                      fontSize: 25,
                                                                                      color: Colors.black)),
                                                                              Text("${challengesData['Description']}",
                                                                                  maxLines: 3,
                                                                                  style: GoogleFonts.montserrat(
                                                                                      fontSize: 15,
                                                                                      color: Colors.black)),
                                                                              SizedBox(height: 5,),
                                                                              Text("Tags :",
                                                                                  style: GoogleFonts.montserrat(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 15,
                                                                                      color: Colors.black)),
                                                                              Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Wrap(
                                                                                  spacing: 10,
                                                                                  runSpacing: 5,
                                                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                                                  alignment: WrapAlignment.start,
                                                                                  runAlignment: WrapAlignment.start,
                                                                                  children: (challengesData['tags'] as List<dynamic>).map<Widget>((item){
                                                                                    print("solutionDataitem: $item");
                                                                                    print("solutionData['tags']: ${challengesData['tags']}");
                                                                                    return Container(
                                                                                      height: 35,
                                                                                      // width: 200,
                                                                                      margin: EdgeInsets.only(bottom: 2),
                                                                                      padding: EdgeInsets.all(6),
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(15),
                                                                                          color: Colors.blue
                                                                                      ),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text("${item}", style: TextStyle(
                                                                                              fontWeight: FontWeight.w700,
                                                                                              fontSize: 14
                                                                                          ),),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  }).toList(),
                                                                                ),
                                                                              ),

                                                                              SizedBox(height: 5,),

                                                                              Text("Category :",
                                                                                  style: GoogleFonts.montserrat(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontSize: 15,
                                                                                      color: Colors.black)),
                                                                              Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Wrap(
                                                                                  spacing: 10,
                                                                                  runSpacing: 5,
                                                                                  crossAxisAlignment: WrapCrossAlignment.start,
                                                                                  alignment: WrapAlignment.start,
                                                                                  runAlignment: WrapAlignment.start,
                                                                                  children: (challengesData['Keywords'] as List<dynamic>).map<Widget>((item){
                                                                                    print("solutionDataitem: $item");
                                                                                    print("solutionData['Keywords']: ${challengesData['Keywords']}");
                                                                                    return Container(
                                                                                      height: 35,
                                                                                      // width: 200,
                                                                                      margin: EdgeInsets.only(bottom: 2),
                                                                                      padding: EdgeInsets.all(6),
                                                                                      decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(15),
                                                                                          color: Colors.blue
                                                                                      ),
                                                                                      child: Row(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text("${item}", style: TextStyle(
                                                                                              fontWeight: FontWeight.w700,
                                                                                              fontSize: 14
                                                                                          ),),
                                                                                        ],
                                                                                      ),
                                                                                    );
                                                                                  }).toList(),
                                                                                ),
                                                                              )
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
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColorOfApp,
                                  ),
                                );
                              });
                        })
                )
            ),
          );
          // });
        }
    );
  }

}

// Future<List<DocumentSnapshot>> getRelatedSolutions(List<dynamic> tags, List<dynamic> keywords) async {
//   // Assuming your Firestore collection is named "solutions"
//   CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Thrivers');
//
//   print("relatedd tagsss: $tags");
//   // Perform a query based on tags and keywords
//   QuerySnapshot querySnapshot = await solutionsCollection
//       .where('tags', arrayContainsAny:  tags)
//       .where('Keywords', arrayContainsAny: keywords)
//       .get();
//
//   print("querySnapshot.docs: ${querySnapshot.docs}");
//   return querySnapshot.docs;
// }
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

Future<DocumentSnapshot> fetchDetails(DocumentReference docRef) async {
  return await docRef.get();
}


class KeywordServices {
  static Future<List<String>> getSuggestions(String query, String selectedValue) async {
    List<String> matches = [];
    // print("Getting Suggestions For $query");

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Keywords').limit(10).get();

      // print("querySnapshot ${querySnapshot}");

      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        dynamic data = snapshot.data();


        if (data != null && data.containsKey('Key')) {
          String key = data['Key'].toString().toLowerCase();

          if (key.contains(query.toLowerCase())) {
            // If the key matches, retrieve and add its values
            List<String> values = data.containsKey('Values') ? data['Values'].cast<String>() : [];
            print("matches $matches");
            print("matches values $values");

            if (key == selectedValue?.toLowerCase()) {
              // Add only the values for the selected key
              matches.addAll(values);
            }
          }
        }
      }
    } catch (e) {
      print("Error getting suggestions: $e");
    }

    return matches;
  }
}

class TagServices {
  static Future<List<String>> getSuggestions(String query) async {
    List<String> matches = [];
    print("Getting Suggestion For " + query);

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Keywords').doc("GEdua4iCBaakTpNB1NY5").get();

      if (snapshot.exists) {
        dynamic data = snapshot.data();

        if (data != null && data.containsKey('Values')) {
          List<dynamic> tags = data['Values'] as List<dynamic>;

          for (var tag in tags) {
            if (tag != null && tag.toString().toLowerCase().contains(query)) {
              matches.add(tag.toString());
            }
          }
        }
      }
    } catch (e) {
      print("Error getting suggestions: $e");
    }

    return matches;
  }
}

class KeywordServicessss {
  static Future<List<String>> getSuggestions(String query) async {
    List<String> matches = [];
    print("Getting Suggestion For " + query);

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Keywords').doc("aqTybsZWFxMuHPQt7u1T").get();

      if (snapshot.exists) {
        dynamic data = snapshot.data();

        if (data != null && data.containsKey('Values')) {
          List<dynamic> category = data['Values'] as List<dynamic>;

          for (var cat in category) {
            if (cat != null && cat.toString().toLowerCase().contains(query)) {
              matches.add(cat.toString());
            }
          }
        }
      }
    } catch (e) {
      print("Error getting suggestions: $e");
    }

    return matches;
  }
}



      //
          // /*  Padding(
          //   child: Container(
          //     child: TypeAheadField(
          //       textFieldConfiguration: TextFieldConfiguration(
          //         controller: solutionsTextEditingController,
          //         style: GoogleFonts.montserrat(
          //           textStyle: Theme.of(context).textTheme.bodyLarge,
          //           fontWeight: FontWeight.w400,),
          //         decoration: InputDecoration(
          //           contentPadding: EdgeInsets.all(25),
          //           hintText:  "Type & Search",
          //           labelText: "Select Solutions",
          //           errorStyle: GoogleFonts.montserrat(
          //               textStyle: Theme.of(context).textTheme.bodyLarge,
          //               fontWeight: FontWeight.w400,
          //               color: Colors.redAccent),
          //           enabledBorder:OutlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //               borderRadius: BorderRadius.circular(15)),
          //           focusedBorder: OutlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //               borderRadius: BorderRadius.circular(15)),
          //           border: OutlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //               borderRadius: BorderRadius.circular(15)),
          //           labelStyle: GoogleFonts.montserrat(
          //               textStyle: Theme.of(context).textTheme.bodyLarge,
          //               fontWeight: FontWeight.w400,
          //               color: Colors.black),
          //         ),
          //       ),
          //       suggestionsCallback: (pattern) async {
          //         List<DocumentSnapshot> itemList = [];
          //         await FirebaseFirestore.instance.collection('Solutions')
          //             .where('Label', isGreaterThanOrEqualTo: pattern)
          //             .where('Label', isLessThanOrEqualTo: pattern + '\uf8ff')
          //             .get().then((value) {
          //           itemList.addAll(value.docs);
          //         });
          //         return itemList;
          //       },
          //       itemBuilder: (context, suggestion) {
          //         return CheckboxListTile(
          //           value: solutions.contains(suggestion.get("Label")),
          //           title: Text(suggestion.get("Label")),
          //           onChanged: (value){
          //             if(solutions.contains(suggestion.get("Label"))){
          //               solutions.remove(suggestion.get("Label"));
          //               solutionsDocRefs.remove(suggestion.reference);
          //             }else{
          //               solutions.add(suggestion.get("Label"));
          //               solutionsDocRefs.add(suggestion.reference);
          //             }
          //             print("solutions");
          //             print(solutions);
          //           },
          //           //subtitle: Text("Add Some Details Here"),
          //         );
          //       },
          //
          //       onSuggestionSelected: (suggestion) {
          //         print("Im selected");
          //         print(suggestion);
          //         solutions.forEach((element) {
          //           solutionsTextEditingController.text +=element + ",";
          //         });
          //         //  challanges
          //         // textEditingController.clear();
          //         //mySelectedUsers.add(suggestion.toString());
          //         //innerState((){});
          //       },
          //     ),
          //   ),
          //   padding: const EdgeInsets.all(8.0),
          // ),*/
          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
          //   child: Text("Optional Fields",style: GoogleFonts.montserrat(
          //       color: Colors.black)),
          // ),
          //
          // //Country
          // Padding(
          //   child: Container(
          //     //width: size.width * 0.9,
          //     child: TypeAheadField(
          //       noItemsFoundBuilder: (BuildContext context) {
          //
          //         return ListTile(
          //
          //           title: Text("Enter a Valid Email Address",style: TextStyle(color: Colors.redAccent),),
          //           //subtitle: Text("Add Some Details Here"),
          //         );
          //       },
          //       textFieldConfiguration: TextFieldConfiguration(
          //         controller: countryTextEditingController,
          //         //autofocus: true,
          //
          //         style: GoogleFonts.montserrat(
          //           textStyle: Theme.of(context).textTheme.bodyLarge,
          //           fontWeight: FontWeight.w400,),
          //
          //         //   cursorColor: primaryColorOfApp,
          //
          //         decoration: InputDecoration(
          //           //errorText: firstNameErrorText,
          //
          //           contentPadding: EdgeInsets.all(25),
          //           hintText:  "Type & Search",
          //           labelText: "Select Country",
          //           errorStyle: GoogleFonts.montserrat(
          //               textStyle: Theme.of(context).textTheme.bodyLarge,
          //               fontWeight: FontWeight.w400,
          //               color: Colors.redAccent),
          //           enabledBorder:OutlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //               borderRadius: BorderRadius.circular(15)),
          //           focusedBorder: OutlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //               borderRadius: BorderRadius.circular(15)),
          //           border: OutlineInputBorder(
          //               borderSide: BorderSide(color: Colors.black),
          //               borderRadius: BorderRadius.circular(15)),
          //           //hintText: "e.g Abouzied",
          //           labelStyle: GoogleFonts.montserrat(
          //               textStyle: Theme.of(context).textTheme.bodyLarge,
          //               fontWeight: FontWeight.w400,
          //               color: Colors.black),
          //         ),
          //       ),
          //       suggestionsCallback: (pattern) async {
          //         List<String> itemList = [];
          //         await getAllCountries().then((value) {
          //           value.forEach((element) {
          //             if(element.name.contains(pattern)){
          //               itemList.add(element.name);
          //             }
          //           });
          //         });
          //         return itemList;
          //       },
          //       itemBuilder: (context, suggestion) {
          //         return ListTile(
          //           title: Text(suggestion.toString()),
          //           //subtitle: Text("Add Some Details Here"),
          //         );
          //       },
          //
          //       onSuggestionSelected: (suggestion) {
          //         print("Im selected");
          //         print(suggestion);
          //         countryTextEditingController.text = suggestion;
          //         // textEditingController.clear();
          //         //mySelectedUsers.add(suggestion.toString());
          //         //innerState((){});
          //       },
          //     ),
          //   ),
          //   padding: const EdgeInsets.all(8.0),
          // ),
          // //Job Roles
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     // maxLines: null,
          //     controller: textControllers[0],
          //     //cursorColor: primaryColorOfApp,
          //     onChanged: (value) {
          //
          //     },
          //     style: GoogleFonts.montserrat(
          //         textStyle: Theme.of(context).textTheme.bodyLarge,
          //         fontWeight: FontWeight.w400,
          //         color: Colors.black),
          //     decoration: InputDecoration(
          //       //errorText: userAccountSearchErrorText,
          //       contentPadding: EdgeInsets.all(25),
          //       labelText: "Job Roles",
          //       hintText: "Job Roles",
          //       /*prefixIcon: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Icon(Icons.question_mark_outlined,
          //          // color: primaryColorOfApp
          //           ),
          //       ),*/
          //       errorStyle: GoogleFonts.montserrat(
          //           textStyle: Theme.of(context).textTheme.bodyLarge,
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
          //           textStyle: Theme.of(context).textTheme.bodyLarge,
          //           fontWeight: FontWeight.w400,
          //           color: Colors.black),
          //     ),
          //   ),
          // ),
          // //Industry
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     // maxLines: null,
          //     controller: industryTextEditingController,
          //     //cursorColor: primaryColorOfApp,
          //     onChanged: (value) {
          //
          //     },
          //     style: GoogleFonts.montserrat(
          //         textStyle: Theme.of(context).textTheme.bodyLarge,
          //         fontWeight: FontWeight.w400,
          //         color: Colors.black),
          //     decoration: InputDecoration(
          //       //errorText: userAccountSearchErrorText,
          //       contentPadding: EdgeInsets.all(25),
          //       labelText: "Industry",
          //       hintText: "Industry",
          //       /*prefixIcon: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Icon(Icons.question_mark_outlined,
          //           // color: primaryColorOfApp
          //         ),
          //       ),*/
          //       errorStyle: GoogleFonts.montserrat(
          //           textStyle: Theme.of(context).textTheme.bodyLarge,
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
          //           textStyle: Theme.of(context).textTheme.bodyLarge,
          //           fontWeight: FontWeight.w400,
          //           color: Colors.black),
          //     ),
          //   ),
          // ),
          //
          //
          // /* Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10.0),
          //   child: TextButton(onPressed: (){
          //         showSelectChallengesWidget();
          //   }, child: Row(
          //     children: [
          //       Icon(Icons.arrow_drop_down_sharp),
          //       Text("Select Challenges",
          //             style: TextStyle(fontSize: 20),
          //
          //       ),
          //     ],
          //   )),
          // ),*/
          // false?Wrap(
          //   spacing: 5,
          //   children: List.generate(
          //     10,
          //         (index) {
          //       return Chip(
          //         label: Text(_animals[index].name),
          //         onDeleted: () {
          //           setState(() {
          //             _animals.removeAt(index);
          //           });
          //         },
          //       );
          //     },
          //   ),
          // ):Container(),
          // /* Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10.0),
          //   child: TextButton(onPressed: (){
          //     showSelectChallengesWidget();
          //   }, child: Row(
          //     children: [
          //       Icon(Icons.arrow_drop_down_sharp),
          //       Text("Select Solutions",
          //         style: TextStyle(fontSize: 20),
          //       ),
          //     ],
          //   )),
          // ),*/
          // false?Wrap(
          //   spacing: 5,
          //   children: List.generate(
          //     10,
          //         (index) {
          //       return Chip(
          //         label: Text(_animals[index].name),
          //         onDeleted: () {
          //           setState(() {
          //             _animals.removeAt(index);
          //           });
          //         },
          //       );
          //     },
          //   ),
          // ):Container(),