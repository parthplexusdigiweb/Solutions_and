import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:thrivers/model/challenges_table_model.dart';
import 'package:thrivers/model/soluton_table_model.dart';

class UniversalListProvider with ChangeNotifier{
  List<Map<String, dynamic>> UniversalChallengesdata = [];
  List<Map<String, dynamic>> UniversalSolutionsdata = [];
  List<Map<String, dynamic>> filteredChallengesData = [];
  List<Map<String, dynamic>> filteredSolutionsData = [];
  List<Map<String, dynamic>> relatedChallengesList = [];
  List<Map<String, dynamic>> relatedSolutionList = [];

  List<Map<String, dynamic>> get getUniversalChallengesdata =>  filteredChallengesData.isEmpty ? UniversalChallengesdata : filteredChallengesData;
  List<Map<String, dynamic>> get getUniversalSolutionsdata =>  filteredSolutionsData.isEmpty ? UniversalSolutionsdata : filteredSolutionsData;
  List<Map<String, dynamic>> get getRelatedChallengesList =>  relatedChallengesList;
  List<Map<String, dynamic>> get getRelatedSolutionList =>  relatedSolutionList;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;
  int _perPage = 30;
  int currentPage = 1; // Current page number
  int totalPages = 1; // Total number of pages
  int? lengthOfdocument;
  int? lengthOfdocumentSolutions;

  List challengesdocuments = [];

  UniversalListProvider() {
    fetchUniversalChallengesData();
  }

  bool isRefinetextChange = false;

  updateisRefinetextChange(bool value){
    isRefinetextChange = value;
    print("isRefinetextChange: $isRefinetextChange");
    notifyListeners();
  }

  void filterChallengess(List<dynamic> tags) {
    // Apply your filtering logic here
    relatedChallengesList = UniversalChallengesdata.where((challenge) {
      return (challenge['tags'] as List).any((tag) => tags.contains(tag));
      // return (challenge['Related_challenges_tags'] as List).any((tag) => tags.contains(tag));
          // || (challenge['Keywords'] as List).any((keyword) => keywords.contains(keyword));
    }).toList();
    notifyListeners();
  }


  void filterChallenges(List<dynamic> tags) {
    print("tagstags: ${tags}");
    relatedChallengesList = UniversalChallengesdata.where((challenge) {
      var hasMatch = (challenge['tags'] as List).any((tag) => tags.contains(tag));
      // var hasMatch = (challenge['Related_challenges_tags'] as List).any((tag) => tags.contains(tag));
      if (hasMatch) {
        challenge['matchedTags'] = challenge['tags'].where((tag) => tags.contains(tag)).toList();
        // challenge['matchedTags'] = challenge['Related_challenges_tags'].where((tag) => tags.contains(tag)).toList();
      }
      return hasMatch;
    }).toList();
    print("relatedChallengesList: ${relatedChallengesList}");
    notifyListeners();
  }


  void filterSolutions(List<dynamic> tags) {
    // Apply your filtering logic here
    relatedSolutionList = UniversalSolutionsdata.where((challenge) {

      var hasMatch = (challenge['tags'] as List).any((tag) => tags.contains(tag));
      // var hasMatch = (challenge['Related_solution_tags'] as List).any((tag) => tags.contains(tag));
      // var hasMatch = (challenge['Label'] as List).any((tag) => tags.contains(tag));
      if (hasMatch) {
        challenge['matchedTags'] = challenge['tags'].where((tag) => tags.contains(tag)).toList();
        // challenge['matchedTags'] = challenge['Related_solution_tags'].where((tag) => tags.contains(tag)).toList();
        // challenge['matchedTags'] = challenge['Label'].where((tag) => tags.contains(tag)).toList();
      }
      return hasMatch;
    }).toList();
    notifyListeners();
  }

  Future<void> fetchUniversalChallengesData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Challenges').orderBy("id").get();
      UniversalChallengesdata = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      filteredChallengesData = UniversalChallengesdata;
      print("UniversalChallengesdata: ${UniversalChallengesdata.length}");
      notifyListeners();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> fetchUniversalSolutionsdata() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Thrivers').orderBy("id").get();
      UniversalSolutionsdata = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      filteredSolutionsData = UniversalSolutionsdata;
      print("fetchUniversalSolutionsdata: ${UniversalSolutionsdata.length}");
      notifyListeners();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void filterChallengesData(String keyword) {
    if (keyword.isEmpty) {
      filteredChallengesData = UniversalChallengesdata;
    } else {
      filteredChallengesData = UniversalChallengesdata.where((element) {
        var name = element['Label'].toString().toLowerCase();
        var description = element['Description'].toString().toLowerCase();
        var tags = element['tags'].toString().toLowerCase();
        var category = element['Keywords'].toString().toLowerCase();

        return name.contains(keyword.toLowerCase()) ||
            description.contains(keyword.toLowerCase()) ||
            tags.contains(keyword.toLowerCase()) ||
            category.contains(keyword.toLowerCase());
      }).toList();
    }
    lengthOfdocument = filteredChallengesData.length;
    notifyListeners();
  }

  void filterSolutionsData(String keyword) {
    if (keyword.isEmpty) {
      filteredSolutionsData = UniversalSolutionsdata;
    } else {
      filteredSolutionsData = UniversalSolutionsdata.where((element) {
        var name = element['Label'].toString().toLowerCase();
        var description = element['Description'].toString().toLowerCase();
        var tags = element['tags'].toString().toLowerCase();
        var category = element['Keywords'].toString().toLowerCase();

        return name.contains(keyword.toLowerCase()) ||
            description.contains(keyword.toLowerCase()) ||
            tags.contains(keyword.toLowerCase()) ||
            category.contains(keyword.toLowerCase());
      }).toList();
    }
    lengthOfdocumentSolutions = filteredSolutionsData.length;
    notifyListeners();
  }

  List<Map<String, dynamic>> combinedResults = [];
  bool issuggestedloading = false;

  Future<void> searchChallengess(String search) async {
    issuggestedloading = true;
    notifyListeners();

    List<String> keywordsList = [];
    if (search.isNotEmpty) {
      String refinedString = search.replaceAll("- ", "").replaceAll("\n", " ").replaceAll(",", " ");

      List<String> stopWords = [
        "and", "is", "if", "all", "the", "a", "an", "of", "to", "in", "that", "it", "with", "as", "for", "on", "at", "by", "this", "from", "or", "but", "not", "be", "are", "was", "were", "been", "being", "have", "has", "had", "do", "does", "did", "doing", "will", "would", "can", "could", "should", "shall", "may", "might", "must", "about", "above", "after", "again", "against", "among", "because", "before", "between", "during", "into", "through", "under", "over", "up", "down", "out", "off", "then", "than", "once", "here", "there", "when", "where", "why", "how"
      ];

      List<String> words = refinedString.split(RegExp(r'\s+'));
      Set<String> uniqueWords = {};
      words.forEach((word) {
        String lowerCaseWord = word.toLowerCase();
        if (lowerCaseWord.isNotEmpty && !stopWords.contains(lowerCaseWord)) {
          uniqueWords.add(lowerCaseWord);
        }
      });

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

    final labelMatches = UniversalChallengesdata.where((element) {
      var name = element['Label'].toString().toLowerCase();
      return keywordsList.any((keyword) => name.contains(keyword.toLowerCase()));
    }).toSet();

    final descriptionMatches = UniversalChallengesdata.where((element) {
      var description = element['Description'].toString().toLowerCase();
      var name = element['Label'].toString().toLowerCase();
      bool isInLabelMatches = labelMatches.any((e) => e['Label'] == name);
      return !isInLabelMatches && keywordsList.any((keyword) => description.contains(keyword.toLowerCase()));
    }).toSet();

    final tagsMatches = UniversalChallengesdata.where((element) {
      var tags = element['tags'].toString().toLowerCase();
      var name = element['Label'].toString().toLowerCase();
      var description = element['Description'].toString().toLowerCase();
      bool isInLabelMatches = labelMatches.any((e) => e['Label'] == name);
      bool isInDescriptionMatches = descriptionMatches.any((e) => e['Label'] == name);
      return !isInLabelMatches && !isInDescriptionMatches && keywordsList.any((keyword) => tags.contains(keyword.toLowerCase()));
    }).toSet();

    print("labelMatches: $labelMatches");
    print("descriptionMatches: $descriptionMatches");
    print("tagsMatches: $tagsMatches");

    Set<Map<String, dynamic>> combinedResultsSet = {...labelMatches.cast<Map<String, dynamic>>(), ...descriptionMatches.cast<Map<String, dynamic>>(), ...tagsMatches.cast<Map<String, dynamic>>()};
    combinedResults = combinedResultsSet.toList();
    lengthOfdocument = combinedResults.length;
    print("lengthOfdocument: $lengthOfdocument");

    Future.delayed(Duration(seconds: 1), () {
      issuggestedloading = false;
      notifyListeners();
    });
  }

  Future<void> searchChallenges(List searchQueries) async {
    issuggestedloading = true;
    notifyListeners();

    List<Map<String, dynamic>> combinedResults = [];
    List<String> stopWords = [
      "and", "is", "if", "all", "the", "a", "an", "of", "to", "in", "that", "it", "with", "as", "for", "on", "at", "by", "this", "from", "or", "but", "not", "be", "are", "was", "were", "been", "being", "have", "has", "had", "do", "does", "did", "doing", "will", "would", "can", "could", "should", "shall", "may", "might", "must", "about", "above", "after", "again", "against", "among", "because", "before", "between", "during", "into", "through", "under", "over", "up", "down", "out", "off", "then", "than", "once", "here", "there", "when", "where", "why", "how"
    ];

    // Filter out stop words from search queries
    searchQueries = searchQueries.where((query) => !stopWords.contains(query.toLowerCase())).toList();
    print("Filtered searchQueries: $searchQueries");

    for (String search in searchQueries) {
      if (search.isNotEmpty) {
        String refinedString = search.replaceAll("-", "").replaceAll("- ", "").replaceAll("\n", " ").replaceAll(",", " ");

        List<String> words = refinedString.split(RegExp(r'\s+'));
        print("words : $words");
        Set<String> uniqueWords = {};
        words.forEach((word) {
          String lowerCaseWord = word.toLowerCase();
          if (lowerCaseWord.isNotEmpty && !stopWords.contains(lowerCaseWord)) {
            uniqueWords.add(lowerCaseWord);
            print("uniqueWords: ${uniqueWords}");
          }
        });

        List<String> keywordsList = [];
        if (uniqueWords.length > 1) {
          print("inside words.length: ${uniqueWords.length}");
          keywordsList.addAll(uniqueWords);
        } else {
          print("inside refinedString: ${refinedString}");
          keywordsList.add(refinedString);
        }

        print("inside keywordsList: ${keywordsList}");

        final labelMatches = UniversalChallengesdata.where((element) {
          var name = element['Label'].toString().toLowerCase();
          return keywordsList.any((keyword) => name.contains(keyword.toLowerCase()));
        }).toList();

        final descriptionMatches = UniversalChallengesdata.where((element) {
          var description = element['Description'].toString().toLowerCase();
          var name = element['Label'].toString().toLowerCase();
          bool isInLabelMatches = labelMatches.any((e) => e['Label'] == name);
          return !isInLabelMatches && keywordsList.any((keyword) => description.contains(keyword.toLowerCase()));
        }).toList();

        final tagsMatches = UniversalChallengesdata.where((element) {
          var tags = element['tags'].toString().toLowerCase();
          var name = element['Label'].toString().toLowerCase();
          var description = element['Description'].toString().toLowerCase();
          bool isInLabelMatches = labelMatches.any((e) => e['Label'] == name);
          bool isInDescriptionMatches = descriptionMatches.any((e) => e['Label'] == name);
          return !isInLabelMatches && !isInDescriptionMatches && keywordsList.any((keyword) => tags.contains(keyword.toLowerCase()));
        }).toList();

        var queryResults = {...labelMatches, ...descriptionMatches, ...tagsMatches}.toList();
        // queryResults.sort((a, b) => a['Label'].toString().compareTo(b['Label'].toString()));

        combinedResults.addAll(queryResults.take(10));
      }
    }

    this.combinedResults = combinedResults;
    lengthOfdocument = combinedResults.length;

    Future.delayed(Duration(seconds: 1), () {
      issuggestedloading = false;
      notifyListeners();
    });
  }

  clearsuggestedChallenges(anytext){
    // anytext.clear();
    combinedResults.clear();
    issuggestedloading = true;
    filteredChallengesData = UniversalChallengesdata;
    lengthOfdocument = null;
    print("combinedResults is cleared: $combinedResults");
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getTagsfromInsightABme(List<dynamic> tags) async {

    // Perform a query based on tags and keywords
    if(tags.isNotEmpty){
      print("inside getTagsfromInsightABme => tags: $tags");
      final tagsQuery = UniversalChallengesdata.where((element) {
        var name = element['Related_challenges_tags'].toString().toLowerCase();
        return tags.any((keyword) => name.contains(keyword.toLowerCase()));
      }).toSet();

      print("tagsQuery tt: ${tagsQuery.length}");
      // Combine the results of both queries

      // Use a set to avoid duplicate documents
      if(combinedResults.isEmpty){
        combinedResults.addAll(tagsQuery);
      }
      else {
        // combinedResults = Set.from(tagsQuery).cast<Map<String, dynamic>>();
      }
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

  Map<int, bool> isEditSolutionListAdded = {};
  List<ChallengesModel> editsolutionss = [];

  void EditRecommendedSolutionAdd(bool value, SolutionDetails) {
    if (isEditSolutionListAdded[SolutionDetails['id']] != value) {
      // Checkbox is checked, add to the list
      editsolutionss.add(
          SolutionModel(
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
      )
      );
      isEditSolutionListAdded[SolutionDetails['id']] = value;

      print("selectedrecommendedChallenges: ${editsolutionss.first.id}");

      print("EditRecommendedChallengeAdd: $isEditSolutionListAdded");
    }


    notifyListeners();

  }

  void removeedittags(item) {
    // print("Before removal: $ProviderEditTags");
    editchallengess.remove(item);
    // print("After removal: $ProviderEditTags");
    notifyListeners();
  }


}