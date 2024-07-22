import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:thrivers/model/challenges_table_model.dart';
import 'package:thrivers/model/soluton_table_model.dart';

class UserAboutMEProvider with ChangeNotifier{

  Map<int, bool> isCheckedMap = {};
  Map<int, bool> isCheckedMapchallenge = {};
  Map<int, bool> isRecommendedChallengeCheckedMap = {};
  Map<int, bool> isEditChallengeListAdded = {};
  Map<int, bool> isEditSolutionListAdded = {};
  Map<int, bool> isRecommendedSolutionsCheckedMap = {};

  List<SolutionModel> selectedSolutions = [];
  List<SolutionModel> solutionss = [];
  List<SolutionModel> editsolutionss = [];
  List<ChallengesModel> challengess = [];
  List<ChallengesModel> editchallengess = [];
  List<ChallengesModel> selectedChallenges = [];



  var selectedPriorityValues;


  bool isConfirm = false;
  bool isxyz = false;
  bool issuggestedloading = false;

  String alertDialogTitle = "1. Personal Info:";

  List<String> provider = ['My Responsibilty', 'Request of my employer'];
  List<String> InPlace = ['Yes (Still Needed)','Yes (Not Needed Anymore)','No (Nice to have)', 'No (Must Have)'];
  List<String> Priority = ['Must have', 'Nice to have', 'No Longer needed'];

  var selectedProvider;
  var selectedInPlace;
  var selectedPriority ;

  Map<dynamic, dynamic> newprovider = {};
  Map<dynamic, dynamic> newInplace = {};

  int currentPageIndex = 0;

  Set<DocumentSnapshot> combinedResults = {};
  Set<DocumentSnapshot> combinedSolutionsResults = {};


  bool isRefinetextChange = false;
  bool issearchsolutionChange = false;

  var aadhar;
  String? downloadURL;
  Uint8List? fileBytes;

  bool _isHintTextVisible  = false;

  bool get isHintTextVisible  => _isHintTextVisible ;

  void isHintText(value) {
    _isHintTextVisible = value;
    notifyListeners();
  }

  void pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false
    );

    if (result != null && result.files.isNotEmpty) {
      fileBytes = result.files.first.bytes;
      aadhar = result.files.first.name;
      // File? file = File(result.files.first.bytes.toString());
      print("aadhar: $aadhar");
      // print("file: $file");

      notifyListeners();

      // upload file
      // await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);

    }
    else {
      print("no document selected");
      // User canceled the picker
    }
    notifyListeners();

  }

  Future uploadFile(Uint8List? fileByte, String? fileName) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('AboutMeFiles/$fileName');
      UploadTask uploadTask = ref.putData(fileByte!);
      TaskSnapshot snapshot = await uploadTask;
      downloadURL = await snapshot.ref.getDownloadURL();
      print("File uploaded. Download URL: $downloadURL");
      return downloadURL;
    } catch (e) {
      print("Error uploading file: $e");
    }
    notifyListeners();
  }


  updateisRefinetextChange(bool value){
    isRefinetextChange = value;
    print("isRefinetextChange: $isRefinetextChange");
    notifyListeners();
  }

  updateissearchsolutionChange(bool value){
    issearchsolutionChange = value;
    print("issearchsolutionChange: $issearchsolutionChange");
    notifyListeners();
  }

  updateconfirmList(listname, indexToUpdate,updatedData){
    listname[indexToUpdate] = updatedData;
    // print("listname.length: ${listname.length}");
    // print("listname: $listname");
    // print("indexToUpdate: $indexToUpdate");
    // print("updatedData: $updatedData");
    notifyListeners();
  }

   updateNotesByIdChallenges(listname,Id,newNotes) {
     listname.forEach((challenge) {
      if (challenge.id == Id) {
        challenge.notes = newNotes;
      }
    });
    notifyListeners();
  }

   updateNotesByIdSolutions(listname,Id,newNotes,InPlace,Provider) {
     listname.forEach((solution) {
      if (solution.id == Id) {
        solution.notes = newNotes;
        solution.InPlace = InPlace;
        solution.Provider = Provider;
      }
    });
    notifyListeners();
  }

  updateInplaceValue(value){
    value = null;
    print("updateInplaceValue: $value");
    notifyListeners();
  }

  updatenewprovider(value,id){
    newprovider[id] = value;
    print("newprovider: $newprovider");
    // notifyListeners();
  }

  updatenewInplace(value,id){
    newInplace[id] = value;
    print("newInplace: $newInplace");
    // notifyListeners();
  }

  List<dynamic> previewKeywordssss = [];
  List<dynamic> previewtags = [];
  List<dynamic> editpreviewKeywordssss = [];
  List<dynamic> editpreviewtags = [];
  List<dynamic> editpreviewRelatedChallengesTag = [];
  List<dynamic> editpreviewSuggestedChallengesTag = [];

  var previewname, previewDescription, previewFinalDescription, previewImpact, previewId, preview;

  bool borderColor = false;


  updateChallengePreview(name, Description, FinalDescription, Impact,Keywordssss,tags,Id,isTrueOrFalse, document,isborderColor){
   previewname = name;
   previewDescription = Description;
   previewFinalDescription = FinalDescription;
   previewImpact = Impact;
   previewKeywordssss = Keywordssss;
   previewtags = tags;
   previewId = Id;
   preview = document;
   isRecommendedChallengeCheckedMap = isTrueOrFalse;
   borderColor = isborderColor;
   // isRecommendedAddedChallenge = AddButton;
   notifyListeners();
 }

 updateSolutionPreview(name, Description, FinalDescription, Impact,Keywordssss,tags,Id,isTrueOrFalse, document,isborderColor){
   previewname = name;
   previewDescription = Description;
   previewFinalDescription = FinalDescription;
   previewImpact = Impact;
   previewKeywordssss = Keywordssss;
   previewtags = tags;
   previewId = Id;
   preview = document;
   isRecommendedSolutionsCheckedMap = isTrueOrFalse;
   borderColor = isborderColor;
   // isRecommendedAddedChallenge = AddButton;
   notifyListeners();
 }

  var editpreviewname, editpreviewDescription, editpreviewFinalDescription, editpreviewImpact, editpreviewId, editpreview;
  var editpreviewImpactToCoworker, editpreviewImpactToEmployee, editpreviewNegativeImpactToOrganisation;
  bool editborderColor = false;

  updateEditChallengePreview(name, Description, FinalDescription, Impact,Keywordssss,tags,Id,isTrueOrFalse, document,isborderColor,
      ImpactToCoworker,ImpactToEmployee,NegativeImpactToOrganisation,RelatedChallengesTag, SuggestedChallengesTag){
    editpreviewname = name;
    editpreviewDescription = Description;
    editpreviewFinalDescription = FinalDescription;
    editpreviewImpact = Impact;
    editpreviewKeywordssss = Keywordssss;
    editpreviewtags = tags;
    editpreviewId = Id;
    editpreview = document;
    isEditChallengeListAdded = isTrueOrFalse;
    editborderColor = isborderColor;
    editpreviewImpactToCoworker = ImpactToCoworker;
    editpreviewImpactToEmployee = ImpactToEmployee;
    editpreviewNegativeImpactToOrganisation = NegativeImpactToOrganisation;
    editpreviewRelatedChallengesTag = RelatedChallengesTag;
    editpreviewSuggestedChallengesTag = SuggestedChallengesTag;
    notifyListeners();
  }

  updateEditSolutionPreview(name, Description, FinalDescription, Impact,Keywordssss,tags,Id,isTrueOrFalse, document,isborderColor,
      Help,PositiveImpactstoEmployee,PositiveImpactstoOrganisation,RelatedSolutionsTags,SuggestedChallengesTags){
    editpreviewname = name;
    editpreviewDescription = Description;
    editpreviewFinalDescription = FinalDescription;
    editpreviewImpact = Impact;
    editpreviewKeywordssss = Keywordssss;
    editpreviewtags = tags;
    editpreviewId = Id;
    editpreview = document;
    isEditSolutionListAdded = isTrueOrFalse;
    editborderColor = isborderColor;
    editpreviewImpactToCoworker = Help;
    editpreviewImpactToEmployee = PositiveImpactstoEmployee;
    editpreviewNegativeImpactToOrganisation = PositiveImpactstoOrganisation;
    editpreviewRelatedChallengesTag = RelatedSolutionsTags;
    editpreviewSuggestedChallengesTag = SuggestedChallengesTags;
    notifyListeners();
  }

  Future<List<DocumentSnapshot>> getRelatedChallenges(List<dynamic> tags, List<dynamic> keywords) async {
    // Assuming your Firestore collection is named "solutions"
    CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Challenges');

    // print("relatedd tagsss: $tags");
    // print("relatedd keywords: $keywords");
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

    print("tagsChallengesResults: $tagsResults");
    print("keywordsChallengesResults: ${keywordsResults}");
    // Use a set to avoid duplicate documents
    combinedResults = Set.from(tagsResults);
    combinedResults.addAll(keywordsResults);

    // print("combinedResults: $combinedResults");
    print("combinedResults.length: ${combinedResults.length}");

    notifyListeners();

    return combinedResults.toList();
  }

  Future<List<DocumentSnapshot>> getSuggestChallengesUsingTags(List<dynamic> tags) async {
    // Assuming your Firestore collection is named "solutions"
    CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Challenges');

    // print("relatedd tagsss: $tags");
    // print("relatedd keywords: $keywords");
    // Perform a query based on tags and keywords
    QuerySnapshot tagsQuery = await solutionsCollection
        .where('tags', arrayContainsAny: tags)
        // .limit(100)
        .get();

    // QuerySnapshot keywordsQuery = await solutionsCollection
    //     .where('Keywords', arrayContainsAny: keywords).limit(10)
    //     .get();

    print("tagsQuery: $tagsQuery");
    // Combine the results of both queries
    List<DocumentSnapshot> tagsResults = tagsQuery.docs;
    // List<DocumentSnapshot> keywordsResults = keywordsQuery.docs;

    print("tagsChallengesResults: $tagsResults");
    // print("keywordsChallengesResults: ${keywordsResults}");
    // Use a set to avoid duplicate documents
    // combinedResults = Set.from(tagsResults);
    if(combinedResults.isNotEmpty) {
      combinedResults.addAll(tagsResults);
    } else{
      combinedResults = Set.from(tagsResults);
    }
    // combinedResults.addAll(keywordsResults);

    // print("combinedResults: $combinedResults");
    print("combinedResults.length: ${combinedResults.length}");

    notifyListeners();

    return combinedResults.toList();
  }

  Future<List<DocumentSnapshot>> getTagsfromInsightABme(List<dynamic> tags,List<dynamic> keywords) async {

    CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Challenges');

    // Perform a query based on tags and keywords
    if(tags.isNotEmpty){
      print("inside getTagsfromInsightABme => tags: $tags");
      QuerySnapshot tagsQuery = await solutionsCollection
          // .where('tags', arrayContainsAny: tags).orderBy("Label")
          .where('Related_challenges_tags', arrayContainsAny: tags).orderBy("Label")
      // .limit(100)
          .get();

      print("tagsQuery: $tagsQuery");
      // Combine the results of both queries
      List<DocumentSnapshot> tagsResults = tagsQuery.docs;

      print("tagsChallengesResults: $tagsResults");
      // Use a set to avoid duplicate documents
      if(combinedResults.isNotEmpty){
        combinedResults.addAll(tagsResults);
      }
      else combinedResults = Set.from(tagsResults);
      // combinedResults = Set.from(tagsResults);
      // combinedResults.add(tagsResults);
      print("combinedResults.length: ${combinedResults.length}");
    }
/// hide for now
  //   if(keywords.isNotEmpty) {
  //
  //     print("inside getTagsfromInsightABme => keywords: $keywords");
  //
  //     QuerySnapshot keywordsQuery = await solutionsCollection
  //     .where('tags', arrayContainsAny: keywords)
  // // .limit(10)
  //     .get();
  // List<DocumentSnapshot> keywordsResults = keywordsQuery.docs;
  // print("keywordsChallengesResults: ${keywordsResults}");
  // combinedResults.addAll(keywordsResults);
  // print("combinedResults.length: ${combinedResults.length}");
  //
  //   }

///
    // print("combinedResults:  ");
    print("combinedResults.length: ${combinedResults.length}");

    notifyListeners();

    return combinedResults.toList();
  }

  Future<List<DocumentSnapshot>> getSolutionsTagsfromInsightABme(List<dynamic> tags,List<dynamic> keywords) async {

    CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Thrivers');

    // Perform a query based on tags and keywords
    if(tags.isNotEmpty){
      print("inside getSolutionsTagsfromInsightABme => tags: $tags");
      QuerySnapshot tagsQuery = await solutionsCollection
          // .where('tags', arrayContainsAny: tags).orderBy("Label")
          .where('Related_solution_tags', arrayContainsAny: tags).orderBy("Label")
      // .limit(100)
          .get();

      print("tagsQuery: $tagsQuery");
      // Combine the results of both queries
      List<DocumentSnapshot> tagsResults = tagsQuery.docs;

      print("tagsSolutionResults: $tagsResults");
      // Use a set to avoid duplicate documents
      if(combinedSolutionsResults.isNotEmpty){
        combinedSolutionsResults.addAll(tagsResults);
      }
      else combinedSolutionsResults = Set.from(tagsResults);
      // combinedSolutionsResults = Set.from(tagsResults);
      // combinedSolutionsResults.add(tagsResults);
      print("combinedSolutionsResults.length: ${combinedSolutionsResults.length}");
    }
/// hide for now
//     if(keywords.isNotEmpty) {
//
//       print("inside getSolutionsTagsfromInsightABme => keywords: $keywords");
//
//       QuerySnapshot keywordsQuery = await solutionsCollection
//       .where('tags', arrayContainsAny: keywords)
//   // .limit(10)
//       .get();
//   List<DocumentSnapshot> keywordsResults = keywordsQuery.docs;
//   print("keywordsChallengesResults: ${keywordsResults}");
//   combinedSolutionsResults.addAll(keywordsResults);
//   print("combinedSolutionsResults.length: ${combinedSolutionsResults.length}");
//
//     }

///
    // print("combinedSolutionsResults: $combinedSolutionsResults");
    print("combinedSolutionsResults.length: ${combinedSolutionsResults.length}");

    notifyListeners();

    return combinedSolutionsResults.toList();
  }

  Future<List<DocumentSnapshot>> getSuggestedSolutions(List<dynamic> tags) async {
    // Assuming your Firestore collection is named "solutions"
    CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Thrivers');

    print("relatedd tagsss: $tags");
    // print("relatedd keywords: $keywords");
    // Perform a query based on tags and keywords
    QuerySnapshot tagsQuery = await solutionsCollection
        .where('tags', arrayContainsAny: tags)
    // .limit(100)
        .get();

    // QuerySnapshot keywordsQuery = await solutionsCollection
    //     .where('Keywords', arrayContainsAny: keywords).limit(10)
    //     .get();

    print("tagsQuery: $tagsQuery");
    // Combine the results of both queries
    List<DocumentSnapshot> tagsResults = tagsQuery.docs;
    // List<DocumentSnapshot> keywordsResults = keywordsQuery.docs;

    // print("tagsSoluionResults: $tagsResults");
    // print("keywordsChallengesResults: ${keywordsResults}");
    // Use a set to avoid duplicate documents
    // combinedResults = Set.from(tagsResults);
    if(combinedSolutionsResults.isNotEmpty) {
      combinedSolutionsResults.addAll(tagsResults);
    } else{
      combinedSolutionsResults = Set.from(tagsResults);
    }
    // combinedResults.addAll(keywordsResults);

    // print("combinedResults: $combinedResults");
    print("combinedSolutionsResults.length: ${combinedSolutionsResults.length}");

    notifyListeners();

    return combinedSolutionsResults.toList();
  }

  Future<List<DocumentSnapshot>> getRelatedSolutionss(List<dynamic> tags, List<dynamic> keywords) async {
    // Assuming your Firestore collection is named "solutions"
    CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Thrivers');

    print("search tagsss: $tags");
    print("search keywords: $keywords");
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

    print("Result tagsSolutionsResults: $tagsResults");
    print("Result keywordsSolutionsResults: ${keywordsResults}");
    // Use a set to avoid duplicate documents
    combinedSolutionsResults = Set.from(tagsResults);
    combinedSolutionsResults.addAll(keywordsResults);

    // print("combinedResults: $combinedResults");
    print("combinedSolutionsResults.length: ${combinedSolutionsResults.length}");

    return combinedSolutionsResults.toList();
  }

  Future<Set<DocumentSnapshot<Object?>>> getRelatedSolutions(List<dynamic> tags, List<dynamic> keywords) async {
    CollectionReference solutionsCollection = FirebaseFirestore.instance.collection('Thrivers');

    isLoadingMore = false;
    List<QuerySnapshot> allQueries = [];

    print("search tagsss: $tags");
    print("search keywords: $keywords");

    // Split the tags and keywords arrays into chunks of 30 elements each
    List<List<dynamic>> tagChunks = _splitList(tags, 30);
    List<List<dynamic>> keywordChunks = _splitList(keywords, 30);

    print("search tagChunkssssss: $tagChunks");
    // print("search keywordChunkssssss: $keywordChunks");


    // Perform queries for each chunk and store the results
    for (var tagChunk in tagChunks) {

      print("searching relevant tags: $tagChunk");

      QuerySnapshot tagsQuery = await solutionsCollection
          // .where('tags', arrayContainsAny: tagChunk)
          .where('Related_solution_tags', arrayContainsAny: tagChunk)
          // .limit(10)
          .get();
      allQueries.add(tagsQuery);
    }

    // for (var keywordChunk in keywordChunks) {
    //
    //
    //   print("search keywordChunk: $keywordChunk");
    //
    //   QuerySnapshot keywordsQuery = await solutionsCollection
    //       .where('Keywords', arrayContainsAny: keywordChunk)
    //       // .limit(10)
    //       .get();
    //   allQueries.add(keywordsQuery);
    // }

    // Combine the results from all queries
    // List<DocumentSnapshot> combinedResults = [];
    for (var query in allQueries) {
      combinedSolutionsResults= Set.from(query.docs);
    }

    // Remove duplicates if necessary
    combinedSolutionsResults = combinedSolutionsResults.toSet();

    notifyListeners();

    print("getRelatedSolutions: ${combinedSolutionsResults}");
    print("getRelatedSolutions: ${combinedSolutionsResults.length}");

    isLoadingMore = true;
    return combinedSolutionsResults;
  }

  List<List<T>> _splitList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i + chunkSize < list.length ? i + chunkSize : list.length));
    }
    return chunks;
  }




  updateProvider(value){
    selectedProvider = value;
    print("updateProvider: $selectedProvider");
    notifyListeners();
  }

  updateInPlace(value){
    selectedInPlace = value;
    print("updateInPlace: $selectedInPlace");
    notifyListeners();
  }

  updatePriority(value){
    selectedPriority = value;
    print("updatePriority: $selectedPriority");
    notifyListeners();
  }

  upadateTitle(value,index){
    alertDialogTitle = value;
    currentPageIndex = index;
    notifyListeners();
  }


  void confirmedd(value){
    isConfirm = value ?? false;
    print(isConfirm);
    notifyListeners();
  }


   confirmed(index, bool value, listname) {
    listname[index].isConfirmed = value;
    print("solutionss[index].isConfirmed: ${index}");
    notifyListeners();
  }



  bool isCheckedForTileSoltuions(DocumentSnapshot<Object?> SolutionsDetails) {
    return isCheckedMap[SolutionsDetails['id']] ?? false;
  }

  // bool isRecommendedcCheckedForTileSoltuions(int index) {
  //   return isRecommendedSolutionsCheckedMap[index] ?? false;
  // }


  bool isRecommendedcCheckedForTileSoltuions(DocumentSnapshot<Object?> SolutionsDetails) {
    return isRecommendedSolutionsCheckedMap[SolutionsDetails['id']] ?? false;
  }

  // bool isCheckedForTileChallenge(int index) {
  //   return isCheckedMapchallenge[index] ?? false;
  // }

  bool isCheckedForTileChallenge(DocumentSnapshot<Object?> ChallengesDetails) {
    return isCheckedMapchallenge[ChallengesDetails['id']] ?? false;
  }

  bool isRecommendedcCheckedForTileChallenge(DocumentSnapshot<Object?> ChallengesDetails) {
    return isRecommendedChallengeCheckedMap[ChallengesDetails['id']] ?? false;
  }


  void isClickedBoxSolution(bool? value, int index, DocumentSnapshot<Object?> thriversDetails) {
    isCheckedMap[thriversDetails['id']] = value ?? false;
    if (value ?? false) {
      // Checkbox is checked, add to the list
      selectedSolutions.add(SolutionModel(
        id: thriversDetails['id'],
        label: thriversDetails['Label'],
        description: thriversDetails['Description'],
          notes: "",
        Source: thriversDetails['Source'],
        Status: thriversDetails['Thirver Status'],
        tags: thriversDetails['tags'],
        CreatedBy: thriversDetails['Created By'],
        CreatedDate: thriversDetails['Created Date'],
        ModifiedBy: thriversDetails['Modified By'],
        ModifiedDate: thriversDetails['Modified Date'],
        OriginalDescription: thriversDetails['Original Description'],
        Impact: thriversDetails['Impact'],
        Final_description: thriversDetails['Final_description'],
        Category: thriversDetails['Category'],
        Keywords: thriversDetails['Keywords'],
          // attachments: "",
          // inPlace: "",
          // priority: "",
          // provider: ""
      ));
      print("selectedSolutions: $selectedSolutions");
    } else {
      // Checkbox is unchecked, remove from the list
      selectedSolutions.removeWhere((solution) => solution.id == thriversDetails['id']);
      print(selectedSolutions);

    }


    notifyListeners();

    // Do something with index or values if needed
  }

  void isClickedBoxChallenge(bool? value, int index, DocumentSnapshot<Object?> ChallengesDetails) {
    isCheckedMapchallenge[ChallengesDetails['id']] = value ?? false;

    if (value ?? false) {
      // Checkbox is checked, add to the list
      selectedChallenges.add(ChallengesModel(
        id: ChallengesDetails['id'],
        label: ChallengesDetails['Label'],
        description: ChallengesDetails['Description'],
        notes: "",
        Source: ChallengesDetails['Source'],
        Status: ChallengesDetails['Challenge Status'],
        tags: ChallengesDetails['tags'],
        CreatedBy: ChallengesDetails['Created By'],
        CreatedDate: ChallengesDetails['Created Date'],
        ModifiedBy: ChallengesDetails['Modified By'],
        ModifiedDate: ChallengesDetails['Modified Date'],
        OriginalDescription: ChallengesDetails['Original Description'],
        Impact: ChallengesDetails['Impact'],
        Final_description: ChallengesDetails['Final_description'],
        Category: ChallengesDetails['Category'],
        Keywords: ChallengesDetails['Keywords'],
        PotentialStrengths: ChallengesDetails['Potential Strengths'],
        HiddenStrengths: ChallengesDetails['Hidden Strengths'],
      ));
      print("selectedChallenges: $selectedChallenges");
    } else {
      // Checkbox is unchecked, remove from the list
      selectedChallenges.removeWhere((solution) => solution.id == ChallengesDetails['id']);
      print(selectedChallenges);

    }


    notifyListeners();

    // Do something with index or values if needed
  }

  void isRecommendedClickedBoxSolutions(bool? value, int index, DocumentSnapshot<Object?> thriversDetails) {
    isRecommendedSolutionsCheckedMap[thriversDetails['id']] = value ?? false;
    if (value ?? false) {
      // Checkbox is checked, add to the list
      solutionss.add(SolutionModel(
        id: thriversDetails['id'],
        label: thriversDetails['Label'],
        description: thriversDetails['Description'],
        notes: "",
        Source: thriversDetails['Source'],
        Status: thriversDetails['Thirver Status'],
        tags: thriversDetails['tags'],
        CreatedBy: thriversDetails['Created By'],
        CreatedDate: thriversDetails['Created Date'],
        ModifiedBy: thriversDetails['Modified By'],
        ModifiedDate: thriversDetails['Modified Date'],
        OriginalDescription: thriversDetails['Original Description'],
        Impact: thriversDetails['Impact'],
        Final_description: thriversDetails['Final_description'],
        Category: thriversDetails['Category'],
        Keywords: thriversDetails['Keywords'],
      ));
      print("solutionss: $solutionss");
    } else {
      // Checkbox is unchecked, remove from the list
      solutionss.removeWhere((solution) => solution.id == thriversDetails['id']);
      print(solutionss);

    }


    notifyListeners();

    // Do something with index or values if needed
  }

  void isRecommendedClickedBoxChallenge(bool? value, int index, DocumentSnapshot<Object?> ChallengesDetails) {
    isRecommendedChallengeCheckedMap[ChallengesDetails['id']] = value ?? false;
    if (value ?? false) {
      // Checkbox is checked, add to the list
      challengess.add(ChallengesModel(
        id: ChallengesDetails['id'],
        label: ChallengesDetails['Label'],
        description: ChallengesDetails['Description'],
        notes: "",
        Source: ChallengesDetails['Source'],
        Status: ChallengesDetails['Challenge Status'],
        tags: ChallengesDetails['tags'],
        CreatedBy: ChallengesDetails['Created By'],
        CreatedDate: ChallengesDetails['Created Date'],
        ModifiedBy: ChallengesDetails['Modified By'],
        ModifiedDate: ChallengesDetails['Modified Date'],
        OriginalDescription: ChallengesDetails['Original Description'],
        Impact: ChallengesDetails['Impact'],
        Final_description: ChallengesDetails['Final_description'],
        Category: ChallengesDetails['Category'],
        Keywords: ChallengesDetails['Keywords'],
        PotentialStrengths: ChallengesDetails['Potential Strengths'],
        HiddenStrengths: ChallengesDetails['Hidden Strengths'],
      ));
      print("selectedrecommendedChallenges: $challengess");

      print("isRecommendedChallengeCheckedMapADDING: $isRecommendedChallengeCheckedMap");

    } else {
      // Checkbox is unchecked, remove from the list
      challengess.removeWhere((solution) => (solution.id) == ChallengesDetails['id']);
      print(challengess);
      print("ChallengesDetails:${ChallengesDetails['id']}");

    }


    notifyListeners();

    // Do something with index or values if needed
  }

  void isRecommendedAddedChallenge(bool value, ChallengesDetails) {
    if (isRecommendedChallengeCheckedMap[ChallengesDetails['id']] != value) {
      // Checkbox is checked, add to the list
      challengess.add(ChallengesModel(
        id: ChallengesDetails['id'],
        label: ChallengesDetails['Label'],
        description: ChallengesDetails['Description'],
        notes: ChallengesDetails['Notes'],
        Source: ChallengesDetails['Source'],
        Status: ChallengesDetails['Challenge Status'],
        tags: ChallengesDetails['tags'],
        CreatedBy: ChallengesDetails['Created By'],
        CreatedDate: ChallengesDetails['Created Date'],
        ModifiedBy: ChallengesDetails['Modified By'],
        ModifiedDate: ChallengesDetails['Modified Date'],
        OriginalDescription: ChallengesDetails['Original Description'],
        Impact: ChallengesDetails['Impact'],
        Final_description: ChallengesDetails['Final_description'],
        Category: ChallengesDetails['Category'],
        Keywords: ChallengesDetails['Keywords'],
        PotentialStrengths: ChallengesDetails['Potential Strengths'],
        HiddenStrengths: ChallengesDetails['Hidden Strengths'],
      ));
      isRecommendedChallengeCheckedMap[ChallengesDetails['id']] = value;

      print("selectedrecommendedChallenges: $challengess");

      print("isRecommendedChallengeCheckedMapADDING: $isRecommendedChallengeCheckedMap");
    }


    notifyListeners();

  }

  void isRecommendedAddedSolutions(bool value, thriversDetails) {

    if (isRecommendedSolutionsCheckedMap[thriversDetails['id']] != value) {
      solutionss.add(SolutionModel(
        id: thriversDetails['id'],
        label: thriversDetails['Label'],
        description: thriversDetails['Description'],
        notes: thriversDetails['Notes'],
        Source: thriversDetails['Source'],
        Status: thriversDetails['Thirver Status'],
        tags: thriversDetails['tags'],
        CreatedBy: thriversDetails['Created By'],
        CreatedDate: thriversDetails['Created Date'],
        ModifiedBy: thriversDetails['Modified By'],
        ModifiedDate: thriversDetails['Modified Date'],
        OriginalDescription: thriversDetails['Original Description'],
        Impact: thriversDetails['Impact'],
        Final_description: thriversDetails['Final_description'],
        Category: thriversDetails['Category'],
        Keywords: thriversDetails['Keywords'],
      ));
      isRecommendedSolutionsCheckedMap[thriversDetails['id']] = value;

      print("isRecommendedSolutionsCheckedMap: $solutionss");

      print("isRecommendedSolutionsCheckedMapADDING: $isRecommendedSolutionsCheckedMap");    }


    notifyListeners();

  }


  void EditChallengeList(challengesList) {

    List<dynamic> allTags = [];

    for(var ChallengesDetails in challengesList) {
      editchallengess.add(ChallengesModel(
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
        isEditChallengeListAdded[ChallengesDetails['id']] = true;

      print("editchallengessAdded: $editchallengess");

      print("isEditChallengeListAddedADDING: $isEditChallengeListAdded");
      // notifyListeners();
      allTags.addAll(ChallengesDetails['tags']);

    }
    print("All tags combined: $allTags");
    print("All tags combined length: ${allTags.length}");

  // getSuggestedSolutions(allTags);

  }

  void EditChallengeListadd(mainList){
    for (var challenge in editchallengess) {
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

  void EditSolutionList(solutionList) {

    for(var SolutionDetails in solutionList) {

      editsolutionss.add(SolutionModel(
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
      isEditSolutionListAdded[SolutionDetails['id']] = true;


        print("isEditSolutionListAdded: $editsolutionss");

        print("isEditSolutionListAddedADDING: $isEditSolutionListAdded");
      // notifyListeners();

    }

  }

  void EditSolutionListadd(mainList){
    for (var solution in editsolutionss) {
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
      updatenewprovider(solutionData["Provider"], solutionData["id"]);
      updatenewInplace(solutionData["InPlace"], solutionData["id"]);
      print("mainList.length: ${mainList.length}");
      print("mainList: ${mainList}");
      // notifyListeners();

    }
  }

  void EditSolutionProvideradd(mainList){
    for (var solution in editsolutionss) {
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

  void EditSolutionInPlaceadd(mainList,mainList1,mainList2,mainList3){
    for (var solution in editsolutionss) {
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

  void EditRecommendedChallengeAdd(bool value, ChallengesDetails) {
    if (isEditChallengeListAdded[ChallengesDetails['id']] != value) {
      // Checkbox is checked, add to the list
      editchallengess.add(ChallengesModel(
        id: ChallengesDetails['id'],
        label: ChallengesDetails['Label'],
        description: ChallengesDetails['Description'],
        notes: ChallengesDetails['Notes'],
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
      ));
      isEditChallengeListAdded[ChallengesDetails['id']] = value;

      print("selectedrecommendedChallenges: ${editchallengess}");

      print("EditRecommendedChallengeAdd: $isEditChallengeListAdded");
    }


    notifyListeners();

  }

  void EditRecommendedSolutionAdd(bool value, SolutionDetails) {
    if (isEditSolutionListAdded[SolutionDetails['id']] != value) {
      // Checkbox is checked, add to the list
      editsolutionss.add(SolutionModel(
        id: SolutionDetails['id'],
        label: SolutionDetails['Label'],
        description: SolutionDetails['Description'],
        notes: SolutionDetails['Notes'],
        Source: SolutionDetails['Source'],
        Status: SolutionDetails['Thirver Status'],
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
        Help: SolutionDetails['Helps'],
        PositiveImpactstoEmployee: SolutionDetails['Positive_impacts_to_employee'],
        PositiveImpactstoOrganisation: SolutionDetails['Positive_impacts_to_organisation'],
        RelatedSolutionsTags: SolutionDetails['Related_solution_tags'],
        SuggestedChallengesTags: SolutionDetails['Suggested_challenges_tags'],
      ));
      isEditSolutionListAdded[SolutionDetails['id']] = value;

      print("selectedrecommendedChallenges: ${editsolutionss.first.id}");

      print("EditRecommendedChallengeAdd: $isEditSolutionListAdded");
    }


    notifyListeners();

  }

  void manuallyAddChallenge(ChallengesDetails){
    challengess.add(ChallengesModel(
      id: ChallengesDetails['id'],
      label: ChallengesDetails['Label'],
      description: ChallengesDetails['Description'],
      notes: ChallengesDetails['Notes'],
      Source: ChallengesDetails['Source'],
      Status: ChallengesDetails['Challenge Status'],
      tags: ChallengesDetails['tags'],
      CreatedBy: ChallengesDetails['Created By'],
      CreatedDate: ChallengesDetails['Created Date'],
      ModifiedBy: ChallengesDetails['Modified By'],
      ModifiedDate: ChallengesDetails['Modified Date'],
      OriginalDescription: ChallengesDetails['Original Description'],
      Impact: ChallengesDetails['Impact'],
      Final_description: ChallengesDetails['Final_description'],
      Category: ChallengesDetails['Category'],
      Keywords: ChallengesDetails['Keywords'],
      PotentialStrengths: ChallengesDetails['Potential Strengths'],
      HiddenStrengths: ChallengesDetails['Hidden Strengths'],
      RelatedChallengesTag: ChallengesDetails['Related_challenges_tags'],
      SuggestedChallengesTag: ChallengesDetails['Suggested_solutions_tags'],
      ImpactToCoworker: ChallengesDetails['Impacts_to_Coworkers'],
      ImpactToEmployee: ChallengesDetails['Impacts_to_employee'],
      NegativeImpactToOrganisation: ChallengesDetails['Negative_impacts_to_organisation'],
    ));

    print("ChallengesData:${challengess.first.Keywords}");
    print("ChallengesData:${challengess.first.tags}");
    isRecommendedChallengeCheckedMap[ChallengesDetails['id']] = true;

    notifyListeners();

  }

  void EditmanuallyAddChallenge(ChallengesDetails){
    editchallengess.add(ChallengesModel(
      id: ChallengesDetails['id'],
      label: ChallengesDetails['Label'],
      description: ChallengesDetails['Description'],
      notes: ChallengesDetails['Notes'],
      Source: ChallengesDetails['Source'],
      Status: ChallengesDetails['Challenge Status'],
      tags: ChallengesDetails['tags'],
      CreatedBy: ChallengesDetails['Created By'],
      CreatedDate: ChallengesDetails['Created Date'],
      ModifiedBy: ChallengesDetails['Modified By'],
      ModifiedDate: ChallengesDetails['Modified Date'],
      OriginalDescription: ChallengesDetails['Original Description'],
      Impact: ChallengesDetails['Impact'],
      Final_description: ChallengesDetails['Final_description'],
      Category: ChallengesDetails['Category'],
      Keywords: ChallengesDetails['Keywords'],
      PotentialStrengths: ChallengesDetails['Potential Strengths'],
      HiddenStrengths: ChallengesDetails['Hidden Strengths'],
      RelatedChallengesTag: ChallengesDetails['Related_challenges_tags'],
      SuggestedChallengesTag: ChallengesDetails['Suggested_solutions_tags'],
      ImpactToCoworker: ChallengesDetails['Impacts_to_Coworkers'],
      ImpactToEmployee: ChallengesDetails['Impacts_to_employee'],
      NegativeImpactToOrganisation: ChallengesDetails['Negative_impacts_to_organisation'],
    ));

    print("ChallengesData:${editchallengess}");
    isEditChallengeListAdded[ChallengesDetails['id']] = true;

    notifyListeners();

  }

  void manuallyAddSolution(SolutionDetails){
    solutionss.add(SolutionModel(
      id: SolutionDetails['id'],
      label: SolutionDetails['Label'],
      description: SolutionDetails['Description'],
      notes: SolutionDetails['Notes'],
      Source: SolutionDetails['Source'],
      Status: SolutionDetails['Thirver Status'],
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
      Help: SolutionDetails['Helps'],
      PositiveImpactstoEmployee: SolutionDetails['Positive_impacts_to_employee'],
      PositiveImpactstoOrganisation: SolutionDetails['Positive_impacts_to_organisation'],
      RelatedSolutionsTags: SolutionDetails['Related_solution_tags'],
      SuggestedChallengesTags: SolutionDetails['Suggested_challenges_tags'],
    ));

    print("SolutionsData:${solutionss}");
    isRecommendedSolutionsCheckedMap[SolutionDetails['id']] = true;

    notifyListeners();

  }

  void EditmanuallyAddSolution(SolutionDetails){
    editsolutionss.add(SolutionModel(
      id: SolutionDetails['id'],
      label: SolutionDetails['Label'],
      description: SolutionDetails['Description'],
      notes: SolutionDetails['Notes'],
      Source: SolutionDetails['Source'],
      Status: SolutionDetails['Thirver Status'],
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
      Help: SolutionDetails['Helps'],
      PositiveImpactstoEmployee: SolutionDetails['Positive_impacts_to_employee'],
      PositiveImpactstoOrganisation: SolutionDetails['Positive_impacts_to_organisation'],
      RelatedSolutionsTags: SolutionDetails['Related_solution_tags'],
      SuggestedChallengesTags: SolutionDetails['Suggested_challenges_tags'],
    ));
    print("SolutionsData:${editsolutionss}");
    isEditSolutionListAdded[SolutionDetails['id']] = true;
    notifyListeners();
  }

  List<SolutionModel> getSelectedSolutions() {
    return List.from(selectedSolutions);
  }

  List<ChallengesModel> getSelectedChallenges() {
    return List.from(selectedChallenges);
  }

  List<ChallengesModel> getSelectedRecommendedChallenges(recommendedChallenge) {
    return List.from(recommendedChallenge);
  }



  void clearSelectedSolutions() {
    selectedSolutions.clear();
    print("selectedSolutions.clear(): $selectedSolutions");
    notifyListeners();
  }

  void clearSelectedChallenges() {
    selectedChallenges.clear();
    print("selectedChallenges.clear(): $selectedChallenges");
    notifyListeners();
  }

  void updateConfirmSolution( id,ConfirmSolution, providerlist1,providerlist2,providerlist3,providerlist4,providerlist5) {
    List<dynamic> solutionsList = ConfirmSolution ?? [];
    Iterable<Map<String, dynamic>> solutionIterable = solutionsList.map((
        item) => item as Map<String, dynamic>);

    for (var solutionData in solutionIterable) {

      if (solutionData["id"] == id) {
        print("solutionData: ${solutionData["id"]}");

        if (solutionData["Provider"] == "My Responsibilty") {
          providerlist1.remove(solutionData);
          print("providerlist: My Responsibilty");
        }
        else if (solutionData["InPlace"] == "Yes (Still Needed)") {
          providerlist2.remove(solutionData);
          print("providerlist: Yes (Still Needed)");

        }
        else if (solutionData["InPlace"] == "Yes (Not Needed Anymore)") {
          providerlist3.remove(solutionData);
          print("providerlist: Yes (Not Needed Anymore)");
        }
        else if (solutionData["InPlace"] == "No (Nice to have)") {
          providerlist4.remove(solutionData);
          print("providerlist: No (Nice to have)");

        }
        else if (solutionData["InPlace"] == "No (Must Have)") {
          providerlist5.remove(solutionData);
          print("providerlist: No (Must Have)");
          print("providerlist: $providerlist5");

        }
        break;
      }
      notifyListeners();
    }
  }

  void updateEditConfirmSolution18(id, providerlist1) {
    List<dynamic> itemsToRemove = [];

    for (var solutionData in providerlist1) {
      if (solutionData["id"] == id && solutionData["Provider"] == "My Responsibilty") {
        itemsToRemove.add(solutionData);
      }
    }

    for (var item in itemsToRemove) {
      providerlist1.remove(item);
    }

    notifyListeners();
  }

  void updateEditConfirmSolution28(id, providerlist1) {
    List<dynamic> itemsToRemove = [];

    for (var solutionData in providerlist1) {
      if (solutionData["id"] == id && solutionData["InPlace"] == "Yes (Still Needed)") {
        itemsToRemove.add(solutionData);
      }
    }

    for (var item in itemsToRemove) {
      providerlist1.remove(item);
    }

    notifyListeners();
  }

  void updateEditConfirmSolution38(id, providerlist1) {
    List<dynamic> itemsToRemove = [];

    for (var solutionData in providerlist1) {
      if (solutionData["id"] == id && solutionData["InPlace"] == "Yes (Not Needed Anymore)") {
        itemsToRemove.add(solutionData);
      }
    }

    for (var item in itemsToRemove) {
      providerlist1.remove(item);
    }

    notifyListeners();
  }

  void updateEditConfirmSolution48(id, providerlist1) {
    List<dynamic> itemsToRemove = [];

    for (var solutionData in providerlist1) {
      if (solutionData["id"] == id && solutionData["InPlace"] == "No (Nice to have)") {
        itemsToRemove.add(solutionData);
      }
    }

    for (var item in itemsToRemove) {
      providerlist1.remove(item);
    }

    notifyListeners();
  }

  void updateEditConfirmSolution58(id, providerlist1) {
    List<dynamic> itemsToRemove = [];

    for (var solutionData in providerlist1) {
      if (solutionData["id"] == id && solutionData["InPlace"] == "No (Must Have)") {
        itemsToRemove.add(solutionData);
      }
    }

    for (var item in itemsToRemove) {
      providerlist1.remove(item);
    }

    notifyListeners();
  }

  void updateEditConfirmSolution1(id, providerlist1,) {
    // List<dynamic> solutionsList = ConfirmSolution ?? [];
    //
    List<dynamic> providersolutionsList1 = providerlist1 ?? [];
    // List<dynamic> providersolutionsList2 = providerlist2 ?? [];
    // List<dynamic> providersolutionsList3 = providerlist3 ?? [];
    // List<dynamic> providersolutionsList4 = providerlist4 ?? [];

    // Iterable<Map<String, dynamic>> solutionIterable = solutionsList.map((item) => item as Map<String, dynamic>);

    Iterable<Map<String, dynamic>> providerIterable1 = providersolutionsList1.map((item) => item as Map<String, dynamic>);
    // Iterable<Map<String, dynamic>> providerIterable2 = providersolutionsList2.map((item) => item as Map<String, dynamic>);
    // Iterable<Map<String, dynamic>> providerIterable3 = providersolutionsList3.map((item) => item as Map<String, dynamic>);
    // Iterable<Map<String, dynamic>> providerIterable4 = providersolutionsList4.map((item) => item as Map<String, dynamic>);

    print("Before remove from _previewProvider.PreviewSolutionMyResposibilty");
    print(providerlist1.length);
    print(providerlist1);

    for (var solutionData in providerIterable1){
      print("remove from My Responsibilty");
      print(" solutionData id: ${solutionData["id"]}");
      print(" id: $id");
      print(" InPlace: ${solutionData["InPlace"]}");
      print(" Provider: ${solutionData["Provider"]}");
      if (solutionData["id"] == id && solutionData["Provider"] == "My Responsibilty") {

        print("if solutionData id : ${solutionData["id"]}");
        print("if id : $id");
        print("if Provider: ${solutionData["Provider"]}");
        providerlist1.remove(solutionData);

        print("After remove from My Responsibilty: $providerlist1");
        print("After remove from My Responsibilty length: ${providerlist1.length}");


      }
      break;
    }
    notifyListeners();

  }

  void updateEditConfirmSolution2(id,providerlist2){

    List<dynamic> providersolutionsList2 = providerlist2 ?? [];
    Iterable<Map<String, dynamic>> providerIterable2 = providersolutionsList2.map((item) => item as Map<String, dynamic>);


    for (var solutionData in providerIterable2){
      print("remove from Yes (Still Needed)");
      print("solutionData id: ${solutionData["id"]}");
      print(" id: ${id}");
      print(" InPlace: ${solutionData["InPlace"]}");
      if (solutionData["id"] == id && solutionData["InPlace"] == "Yes (Still Needed)") {
        print("inside if Yes (Still Needed) id: ${solutionData["id"]}");
        print("inside if Yes (Still Needed) InPlace: ${solutionData["InPlace"]}");
        providerlist2.remove(solutionData);
        print("After remove from Yes (Still Needed): $providerlist2");
        print("After remove from Yes (Still Needed) length: ${providerlist2.length}");
      }
      break;
    }
    notifyListeners();
  }

  void updateEditConfirmSolution3(id,providerlist2){

    List<dynamic> providersolutionsList2 = providerlist2 ?? [];
    Iterable<Map<String, dynamic>> providerIterable2 = providersolutionsList2.map((item) => item as Map<String, dynamic>);


    for (var solutionData in providerIterable2){
      print("remove from Yes (Not Needed Anymore)");
      print("solutionData id: ${solutionData["id"]}");
      print(" id: ${id}");
      print(" InPlace: ${solutionData["InPlace"]}");
      if (solutionData["id"] == id && solutionData["InPlace"] == "Yes (Not Needed Anymore)") {

        print("inside if Yes (Not Needed Anymore) id: ${solutionData["id"]}");
        print("inside if Yes (Not Needed Anymore) InPlace: ${solutionData["InPlace"]}");
        providerlist2.remove(solutionData);

        print("After remove from Yes (Not Needed Anymore): $providerlist2");

        print("After remove from Yes (Not Needed Anymore) length: ${providerlist2.length}");

      }
      break;
    }
    notifyListeners();
  }

  void updateEditConfirmSolution4(id,providerlist2){

    List<dynamic> providersolutionsList2 = providerlist2 ?? [];
    Iterable<Map<String, dynamic>> providerIterable2 = providersolutionsList2.map((item) => item as Map<String, dynamic>);


    for (var solutionData in providerIterable2){
      print("remove from Yes (Not Needed Anymore)");
      print("solutionData id: ${solutionData["id"]}");
      print(" id: ${id}");
      print(" InPlace: ${solutionData["InPlace"]}");
      if (solutionData["id"] == id && solutionData["InPlace"] == "No (Nice to have)") {
        print("inside if No (Nice to have) id: ${solutionData["id"]}");
        print("inside if No (Nice to have) InPlace: ${solutionData["InPlace"]}");
        providerlist2.remove(solutionData);
        print("After remove from No (Nice to have): $providerlist2");

        print("After remove from No (Nice to have) length: ${providerlist2.length}");

      }
      break;
    }
    notifyListeners();
  }

  void updateEditConfirmSolution5(id,providerlist5){

    List<dynamic> providersolutionsList5 = providerlist5 ?? [];
    Iterable<Map<String, dynamic>> providerIterable5 = providersolutionsList5.map((item) => item as Map<String, dynamic>);


    for (var solutionData in providerIterable5){
      print("remove from(Must Have)");
      print("solutionData id: ${solutionData["id"]}");
      print(" id: ${id}");
      print(" InPlace: ${solutionData["InPlace"]}");
      if (solutionData["id"] == id && solutionData["InPlace"] == "No (Must Have)") {
        print("inside if No (Must Have) id: ${solutionData["id"]}");
        print("inside if No (Must Have) InPlace: ${solutionData["InPlace"]}");
        providerlist5.remove(solutionData);
        print("After remove from No (Must Have): $providerlist5");

        print("After remove from No (Must Have) length: ${providerlist5.length}");

      }
      break;
    }
    notifyListeners();
  }

  void removeSolution(int index, solution) {
    if (solutionss.length > index) {
      // Remove the solution at the specified index
      SolutionModel removedSolution = solutionss.removeAt(index);

      // Update isCheckedMap and remove the corresponding entry
      isCheckedMap.remove(index);
      // isCheckedMapchallenge.remove(index);

      // Remove the corresponding solution from selectedSolutions
      selectedSolutions.removeWhere((solution) => solution.id == removedSolution.id);
      // selectedSolutions.removeWhere((solution) => solution.id == "CH0${removedSolution.id}");

      isRecommendedSolutionsCheckedMap[solution.id] = false;

      print("isRecommendedSolutionsCheckedMapREMOVEED: ${isRecommendedSolutionsCheckedMap}");

      notifyListeners();
    }
  }

  void removeChallenge(int index, challenge) {

    print("challenge.id: ${challenge.id}");
    print("challenge.id: ${challenge.id.runtimeType}");
    if (challengess.length > index) {
      ChallengesModel removedSolution = challengess.removeAt(index);

      isCheckedMapchallenge.remove(index);

      selectedChallenges.removeWhere((solution) => solution.id == removedSolution.id);

      isRecommendedChallengeCheckedMap[challenge.id] = false;

      print("isRecommendedChallengeCheckedMapREMOVEED: ${isRecommendedChallengeCheckedMap}");

      // print("removedSolution :${removedSolution.label}");


      notifyListeners();
    }
  }

  void removeConfirmChallenge(int index, id ,ConfirmChallenge,providerlist) {
    List<dynamic> challengesList = ConfirmChallenge ?? [];
    Iterable<Map<String, dynamic>> challengesIterable = challengesList.map((
        item) => item as Map<String, dynamic>);

    for (var solutionData in challengesIterable) {
      print("solutionData iddddd: ${solutionData["id"]}");

      if (solutionData["id"] == id) {
        print("solutionData: ${solutionData["id"]}");

        ConfirmChallenge.remove(solutionData);
        providerlist.remove(solutionData);
        // print("providerlist challenges: ${providerlist}");

        if (challengess.length > index) {
          ChallengesModel removedSolution = challengess.removeAt(index);

          isCheckedMapchallenge.remove(index);

          selectedChallenges.removeWhere((solution) => solution.id == removedSolution.id);

          isRecommendedChallengeCheckedMap[id] = false;

          print("isRecommendedChallengeCheckedMapREMOVEED: ${isRecommendedChallengeCheckedMap}");

          notifyListeners();
        }
        // isRecommendedChallengeCheckedMap[challenge.id] = false;
        // print("isRecommendedChallengeCheckedMapREMOVEED: ${isRecommendedChallengeCheckedMap}");
        print("challengesListREMOVEED: ${solutionData['Label']}");
        print("challengesList.length: ${ConfirmChallenge.length}");
        print("challengesList: ${ConfirmChallenge}");
        break;
      }
      notifyListeners();
    }
  }

  void removeEditConfirmChallenge(int index, id,ConfirmChallenge,providerlist) {
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

    if (editchallengess.length > index) {
      ChallengesModel removedSolution = editchallengess.removeAt(index);

      isCheckedMapchallenge.remove(index);

      selectedChallenges.removeWhere((solution) => solution.id == removedSolution.id);

      isEditChallengeListAdded[id] = false;

      print("isEditChallengeListAddedREMOVEED: ${isEditChallengeListAdded}");

      notifyListeners();
    }

  }

  void removeConfirmSolution(int index, id,ConfirmSolution, providerlist1,providerlist2,providerlist3,providerlist4,providerlist5) {
    List<dynamic> solutionsList = ConfirmSolution ?? [];
    Iterable<Map<String, dynamic>> solutionIterable = solutionsList.map((
        item) => item as Map<String, dynamic>);

    for (var solutionData in solutionIterable) {
      print("solutionData iddddd: ${solutionData["id"]}");

      print("solutionsListREMOVEED: ${solutionData['Label']}");
      print("ConfirmSolution.length: ${ConfirmSolution.length}");
      print("ConfirmSolution: ${ConfirmSolution}");

      if (solutionData["id"] == id) {
        print("solutionData: ${solutionData["id"]}");

        ConfirmSolution.remove(solutionData);

        if (solutionData["Provider"] == "My Responsibilty") {
          providerlist1.remove(solutionData);
          print("providerlist: My Responsibilty");
        }
       else if (solutionData["InPlace"] == "Yes (Still Needed)") {
          providerlist2.remove(solutionData);
          print("providerlist: Yes (Still Needed)");

        }
        else if (solutionData["InPlace"] == "Yes (Not Needed Anymore)") {
          providerlist3.remove(solutionData);
          print("providerlist: Yes (Not Needed Anymore)");
        }
        else if (solutionData["InPlace"] == "No (Nice to have)") {
          providerlist4.remove(solutionData);
          print("providerlist: No (Nice to have)");

        }
        else if (solutionData["InPlace"] == "No (Must Have)") {
          providerlist5.remove(solutionData);
          print("providerlist: No (Must Have)");

        }
        // if (solutionss.length > index) {
        //   SolutionModel removedSolution = solutionss.removeAt(index);
        //
        //   isCheckedMap.remove(index);
        //
        //   solutionss.removeWhere((solution) => solution.id == id);
        //
        //   isRecommendedSolutionsCheckedMap[id] = false;
        //
        //   print("isRecommendedSolutionsCheckedMapREMOVEED: ${isRecommendedSolutionsCheckedMap}");
        //
        //   notifyListeners();
        // }

        solutionss.removeWhere((solution) => solution.id == id);

        isRecommendedSolutionsCheckedMap[id] = false;

        print("isRecommendedSolutionsCheckedMapREMOVEED: ${isRecommendedSolutionsCheckedMap}");
        print("solutionsslist: ${solutionss}");
        notifyListeners();

        break;
      }
      notifyListeners();
    }
  }

  void removeEditConfirmSolution(id,ConfirmSolution, providerlist1,providerlist2,providerlist3,providerlist4,providerlist5) {
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

    editsolutionss.removeWhere((solution) => solution.id == id);
    isEditSolutionListAdded[id] = false;

    print("isEditSolutionListAddedREMOVEED: ${isEditSolutionListAdded}");

    notifyListeners();


  }

  void removeEditChallenge(int index, challenge) {

    print("editchallengess.id: ${challenge.id}");
    print("editchallengess.id: ${challenge.id.runtimeType}");
    if (editchallengess.length > index) {
      ChallengesModel removedSolution = editchallengess.removeAt(index);

      isCheckedMapchallenge.remove(index);

      selectedChallenges.removeWhere((solution) => solution.id == removedSolution.id);

      isEditChallengeListAdded[challenge.id] = false;

      print("isEditChallengeListAddedREMOVEED: ${isEditChallengeListAdded}");

      // print("removedSolution :${removedSolution.label}");


      notifyListeners();
    }
  }

  void removeEditSolution(int index, solution) {
    if (editsolutionss.length > index) {
      // Remove the solution at the specified index
      SolutionModel removedSolution = editsolutionss.removeAt(index);

      // Update isCheckedMap and remove the corresponding entry
      isCheckedMap.remove(index);
      // isCheckedMapchallenge.remove(index);

      // Remove the corresponding solution from selectedSolutions
      selectedSolutions.removeWhere((solution) => solution.id == removedSolution.id);
      // selectedSolutions.removeWhere((solution) => solution.id == "CH0${removedSolution.id}");

      isEditSolutionListAdded[solution.id] = false;

      print("isEditSolutionListAddedREMOVEED: ${isEditSolutionListAdded}");

      notifyListeners();
    }
  }


// Assuming the id is unique and starts from 0, and increment by 1
  void removeRecommendedChallenge(int id) {
    print("Iddddd: $id");
    // Find the index of the challenge with the given id
    int indexToRemove = -1;
    for (int i = 0; i < challengess.length; i++) {
      if (challengess[i].id == id) {
        indexToRemove = i;
        break;
      }
    }

    // If the challenge with the given id is found
    if (indexToRemove != -1) {

      isRecommendedChallengeCheckedMap[id] = false;

      ChallengesModel removedSolution = challengess.removeAt(indexToRemove);

      // Remove from isCheckedMapchallenge using the index
      isCheckedMapchallenge.remove(indexToRemove);

      // Remove from selectedChallenges based on id
      selectedChallenges.removeWhere((solution) => solution.id == id);

      // Remove from isRecommendedChallengeCheckedMap based on index

      print("isRecommendedChallengeCheckedMapREMOVEED: ${isRecommendedChallengeCheckedMap}");
      print("removedSolution: ${removedSolution.label}");

      notifyListeners();
    }
  }


  void removeRecommendedChallenges(int index){
    if (challengess.length > index) {
      // Remove the solution at the specified index
      ChallengesModel removedSolution = challengess.removeAt(index);

      // Update isCheckedMap and remove the corresponding entry
      // isCheckedMapchallenge.remove(index);
      isRecommendedChallengeCheckedMap.remove(index);
      isRecommendedChallengeCheckedMap[index] = false;

      // Remove the corresponding solution from selectedSolutions
      // challengess.removeWhere((solution) => solution.label == removedSolution.label);

      print("Removed challenge: ${removedSolution.label}");

      notifyListeners();
    }
  }

  void addsolutions(){
    solutionss = getSelectedSolutions();
    notifyListeners();
  }

  void addchallenges(){
    challengess.addAll(getSelectedChallenges());
    notifyListeners();
  }

  void updateSelectedPriorityValues(ind, value){
    selectedPriorityValues[ind] = value;
    notifyListeners();
  }

  bool _isChecked = false;

  bool get isChecked => _isChecked;

  void updatevalue(value, newvalue) {
   value = newvalue;
   print(value);
    notifyListeners();
  }


  void isClickedBosx(bool? value, DocumentSnapshot<Object?> thriversDetails) {
    _isChecked = value!;
    print((value, thriversDetails["Label"]));
    notifyListeners();
  }

  bool isLoadingMore = false;
  bool get isLoadingMoree => isLoadingMore;

  Future<void> searchchallenges(search) async   {

    try {
      issuggestedloading = true;

      List<QueryDocumentSnapshot<Object?>>? docssssss;
      final CollectionReference productsCollection = FirebaseFirestore.instance.collection('Challenges');
      QuerySnapshot? querySnapshotsss = await productsCollection.orderBy("Label").get();
      docssssss  = querySnapshotsss?.docs;

      print("_addKeywordProvider.searchbycategory ${search}");
      List<String> keywordsList = [];
      if (search.isNotEmpty) {
        // Remove "- " from the string and replace newlines with spaces
        String refinedString = search.replaceAll("- ", "").replaceAll("\n", " ").replaceAll(",", " ");

        List<String> stopWords = [
          "and", "is", "if", "all", "the", "a", "an", "of", "to", "in", "that", "it", "with", "as", "for", "on", "at", "by", "this", "from", "or", "but", "not", "be", "are", "was", "were", "been", "being", "have", "has", "had", "do", "does", "did", "doing", "will", "would", "can", "could", "should", "shall", "may", "might", "must", "about", "above", "after", "again", "against", "among", "because", "before", "between", "during", "into", "through", "under", "over", "up", "down", "out", "off", "then", "than", "once", "here", "there", "when", "where", "why", "how"
        ];
        // Split the string into words
        List<String> words = refinedString.split(RegExp(r'\s+'));

        // Remove any empty strings that may result from splitting

        // words.removeWhere((word) => word.isEmpty);

        Set<String> uniqueWords = {};
        words.forEach((word) {
          String lowerCaseWord = word.toLowerCase();
          if (lowerCaseWord.isNotEmpty && !stopWords.contains(lowerCaseWord)) {
            uniqueWords.add(lowerCaseWord);
          }
        });

        // Check if the string has more than 2 words
        if (uniqueWords.length > 1) {
          print("inside words.length: ${uniqueWords.length}");
          keywordsList.addAll(uniqueWords);
        } else {
          print("inside refinedString: ${refinedString}");
          keywordsList.add(refinedString);
        }
      } else {
        print("inside search: ${search}");
        keywordsList.add(search);
      }
      print("keywordsList ${keywordsList}");

      // if (search.isEmpty) {
      //   loadDataForPage(1);
      // } else {
      //   challengesdocuments.clear();

      docssssss?.map((e) => print("$e"));

      // final dc = docssssss?.where((element) {
      //   var name = element.get("Label").toLowerCase();
      //   var description = element.get("Description").toLowerCase();
      //   var tags = element.get('tags').toString().toLowerCase();
      //   var category = element.get('Keywords').toString().toLowerCase();
      //
      //   // Check if selectAllAny is "All"
      //   // if (selectAllAny == "All") {
      //   // return name.contains(search.toLowerCase()) ||
      //   //     description.contains(search.toLowerCase()) ||
      //   //     tags.contains(search.toLowerCase()) ||
      //   //     category.contains(search.toLowerCase());
      //   // } else {
      //   //   // Otherwise, search for individual words
      //     return keywordsList.any((keyword) =>
      //     name.contains(keyword.toLowerCase()) ||
      //         description.contains(keyword.toLowerCase())
      //         // ||
      //         // tags.contains(keyword.toLowerCase()) ||
      //         // category.contains(keyword.toLowerCase())
      //     );
      //   // }
      // }).toList();
      // // combinedResults.addAll(dc!);
      // // if(combinedResults.isNotEmpty){
      // //   combinedResults.addAll(dc!);
      // // }
      // // else
      //   combinedResults = Set.from(dc!);


      // Notify listeners after a delay to ensure the UI is updated

      final labelMatches = docssssss
          ?.where((element) {
        var name = element['Label'].toString().toLowerCase();
        return keywordsList.any((keyword) => name.contains(keyword.toLowerCase()));
      })
          .toList();

      // Filter elements that match keywords in Description but are not in labelMatches
      final descriptionMatches = docssssss
          ?.where((element) {
        var description = element['Description'].toString().toLowerCase();
        // Ensure element is not already in labelMatches
        var name = element['Label'].toString().toLowerCase();
        bool? isInLabelMatches = labelMatches?.any((e) => e['Label'] == element['Label']);
        return !isInLabelMatches! && keywordsList.any((keyword) => description.contains(keyword.toLowerCase()));
      })
          .toList();

      final tagsMatches = docssssss
          ?.where((element) {
        var tags = element.get('tags').toString().toLowerCase();
        var name = element.get('Label').toString().toLowerCase();
        var description = element.get('Description').toString().toLowerCase();
        bool? isInLabelMatches = labelMatches?.any((e) => e.get('Label') == element.get('Label'));
        bool? isInDescriptionMatches = descriptionMatches?.any((e) => e.get('Label') == element.get('Label'));
        return !isInLabelMatches! && !isInDescriptionMatches! && keywordsList.any((keyword) => tags.contains(keyword.toLowerCase()));
      })
          .toList();

      // Combine results, ensuring elements from labelMatches come first
      combinedResults = {...?labelMatches, ...?descriptionMatches, ...?tagsMatches,};

      Future.delayed(Duration(seconds: 1), () {
        issuggestedloading = false;
        var lengthOfdocument = combinedResults.length;
        print("length of lengthOfdocument: ${lengthOfdocument}");
        notifyListeners();
      });
      notifyListeners();

    }

    catch (error) {
      print('Error loading data: $error');
    } finally {
      // Notify listeners after a delay to ensure the UI is updated
      Future.delayed(Duration(seconds: 1), () {
        issuggestedloading = false;
        var lengthOfdocument = combinedResults.length;
        print("length of lengthOfdocument: ${lengthOfdocument}");
        notifyListeners(); // This will trigger UI update if necessary
      });
      notifyListeners();
    }
  }

  Future<void> searchsolutions(search) async   {

    isLoadingMore = false;
    try {

      print("try isLoadingMore: ${isLoadingMore}");

      List<QueryDocumentSnapshot<Object?>>? docssssss;
      final CollectionReference productsCollection = FirebaseFirestore.instance.collection('Thrivers');
      QuerySnapshot? querySnapshotsss = await productsCollection.orderBy("Label").get();
      docssssss  = querySnapshotsss?.docs;

      print("_addKeywordProvider.searchbycategory ${search}");
      List<String> keywordsList = [];
      if (search.isNotEmpty) {
        // Remove "- " from the string and replace newlines with spaces
        String refinedString = search.replaceAll("- ", "").replaceAll("\n", " ").replaceAll(",", " ");

        List<String> stopWords = [
          "and", "is", "if", "all", "the", "a", "an", "of", "to", "in", "that", "it", "with", "as", "for", "on", "at", "by", "this", "from", "or", "but", "not", "be", "are", "was", "were", "been", "being", "have", "has", "had", "do", "does", "did", "doing", "will", "would", "can", "could", "should", "shall", "may", "might", "must", "about", "above", "after", "again", "against", "among", "because", "before", "between", "during", "into", "through", "under", "over", "up", "down", "out", "off", "then", "than", "once", "here", "there", "when", "where", "why", "how"
        ];
        // Split the string into words
        List<String> words = refinedString.split(RegExp(r'\s+'));

        // Remove any empty strings that may result from splitting
        // words.removeWhere((word) => word.isEmpty);

        // words = words.where((word) => word.isNotEmpty && !stopWords.contains(word.toLowerCase())).toList();

        Set<String> uniqueWords = {};
        words.forEach((word) {
          String lowerCaseWord = word.toLowerCase();
          if (lowerCaseWord.isNotEmpty && !stopWords.contains(lowerCaseWord)) {
            uniqueWords.add(lowerCaseWord);
          }
        });
        // Check if the string has more than 2 words
        if (uniqueWords.length > 1) {
          print("inside words.length: ${uniqueWords.length}");
          keywordsList.addAll(uniqueWords);
        } else {
          print("inside refinedString: ${refinedString}");
          keywordsList.add(refinedString);
        }
      } else {
        print("inside search: ${search}");
        keywordsList.add(search);
      }
      print("keywordsList ${keywordsList}");

      // if (search.isEmpty) {
      //   loadDataForPage(1);
      // } else {
      //   challengesdocuments.clear();

      docssssss?.map((e) => print("$e"));

      // final dc = docssssss?.where((element) {
      //   var name = element.get("Label").toLowerCase();
      //   var description = element.get("Description").toLowerCase();
      //   var tags = element.get('tags').toString().toLowerCase();
      //   var category = element.get('Keywords').toString().toLowerCase();
      //
      //   // Check if selectAllAny is "All"
      //   // if (selectAllAny == "All") {
      //   // return name.contains(search.toLowerCase()) ||
      //   //     description.contains(search.toLowerCase()) ||
      //   //     tags.contains(search.toLowerCase()) ||
      //   //     category.contains(search.toLowerCase());
      //   // } else {
      //   //   // Otherwise, search for individual words
      //     return keywordsList.any((keyword) =>
      //     name.contains(keyword.toLowerCase()) ||
      //         description.contains(keyword.toLowerCase())
      //         // ||
      //         // tags.contains(keyword.toLowerCase()) ||
      //         // category.contains(keyword.toLowerCase())
      //     );
      //   // }
      // }).toList();
      //
      // // combinedResults.addAll(dc!);
      // combinedSolutionsResults = Set.from(dc!);

      final labelMatches = docssssss
          ?.where((element) {
        var name = element['Label'].toString().toLowerCase();
        return keywordsList.any((keyword) => name.contains(keyword.toLowerCase()));
      })
          .toList();

      // Filter elements that match keywords in Description but are not in labelMatches
      final descriptionMatches = docssssss
          ?.where((element) {
        var description = element['Description'].toString().toLowerCase();
        // Ensure element is not already in labelMatches
        var name = element['Label'].toString().toLowerCase();
        bool? isInLabelMatches = labelMatches?.any((e) => e['Label'] == element['Label']);
        return !isInLabelMatches! && keywordsList.any((keyword) => description.contains(keyword.toLowerCase()));
      })
          .toList();

      final tagsMatches = docssssss
          ?.where((element) {
        var tags = element.get('tags').toString().toLowerCase();
        var name = element.get('Label').toString().toLowerCase();
        var description = element.get('Description').toString().toLowerCase();
        bool? isInLabelMatches = labelMatches?.any((e) => e.get('Label') == element.get('Label'));
        bool? isInDescriptionMatches = descriptionMatches?.any((e) => e.get('Label') == element.get('Label'));
        return !isInLabelMatches! && !isInDescriptionMatches! && keywordsList.any((keyword) => tags.contains(keyword.toLowerCase()));
      })
          .toList();

      // Combine results, ensuring elements from labelMatches come first
       combinedSolutionsResults = {...?labelMatches, ...?descriptionMatches, ...?tagsMatches,};


      // Notify listeners after a delay to ensure the UI is updated
      Future.delayed(Duration(seconds: 1), () {
        isLoadingMore = true;
        var lengthOfdocument = combinedSolutionsResults.length;
        print("length of lengthOfdocument: ${lengthOfdocument}");
        notifyListeners();
      });
      notifyListeners();

    }

    catch (error) {
      print('Error loading data: $error');
    } finally {
      // Notify listeners after a delay to ensure the UI is updated
      Future.delayed(Duration(seconds: 1), () {
        isLoadingMore = true;
        print("finally isLoadingMore: ${isLoadingMore}");
        var lengthOfdocument = combinedSolutionsResults.length;
        print("finally length of lengthOfdocument: ${lengthOfdocument}");
        notifyListeners(); // This will trigger UI update if necessary
      });
      notifyListeners();
    }
  }

  clearsuggestedChallenges(anytext){
    // anytext.clear();
    combinedResults.clear();
    issuggestedloading = true;
    print("combinedResults is cleared: $combinedResults");
    notifyListeners();
  }

  clearsuggestedsolutions(anytext){
    // anytext.clear();
    combinedSolutionsResults.clear();
    isLoadingMore = true;
    print("combinedSolutionsResults is cleared: $combinedSolutionsResults");
    notifyListeners();
  }


}