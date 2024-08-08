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
  List<Map<String, dynamic>> LinkedSolutionList = [];
  List<Map<String, dynamic>> LinkedChallengesList = [];
  List<Map<String, dynamic>> combinedSolutionList = [];
  List<Map<String, dynamic>> combinedChallengeList = [];

  List<Map<String, dynamic>> get getUniversalChallengesdata =>   filteredChallengesData;
  List<Map<String, dynamic>> get getUniversalSolutionsdata => filteredSolutionsData;
  List<Map<String, dynamic>> get getRelatedChallengesList =>  relatedChallengesList;
  List<Map<String, dynamic>> get getRelatedSolutionList =>  relatedSolutionList;
  List<Map<String, dynamic>> get getLinkedSolutionList =>  LinkedSolutionList;
  List<Map<String, dynamic>> get getLinkedChallengesList =>  LinkedChallengesList;
  List<Map<String, dynamic>> get getcombinedSolutionList =>  combinedSolutionList;
  List<Map<String, dynamic>> get getcombinedChallengeList =>  combinedChallengeList;

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

  void filterChallengesss(List<dynamic> tags) {
    // print("tagstags: ${tags}");
    relatedChallengesList = UniversalChallengesdata.where((challenge) {
      var hasMatch = (challenge['tags'] as List).any((tag) => tags.contains(tag));
      // var hasMatch = (challenge['Related_challenges_tags'] as List).any((tag) => tags.contains(tag));
      if (hasMatch) {
        challenge['matchedTags'] = challenge['tags'].where((tag) => tags.contains(tag)).toList();
        // challenge['matchedTags'] = challenge['Related_challenges_tags'].where((tag) => tags.contains(tag)).toList();
      }
      return hasMatch;
    }).toList();
    // print("relatedChallengesList: ${relatedChallengesList}");
    notifyListeners();
  }

  void filterChallenges(List<dynamic> tags) {
    // Normalize the input tags to lowercase
    List<String> normalizedTags = tags.map((tag) => tag.toString().toLowerCase()).toList();

    relatedChallengesList = UniversalChallengesdata.where((challenge) {
      // Normalize the tags in the challenge to lowercase
      var challengeTags = (challenge['tags'] as List).map((tag) => tag.toString().toLowerCase()).toList();

      // Check if there is any match
      var hasMatch = challengeTags.any((tag) => normalizedTags.contains(tag));

      if (hasMatch) {
        // Find matched tags
        challenge['matchedTags'] = challengeTags.where((tag) => normalizedTags.contains(tag)).toList();
      }

      return hasMatch;
    }).toList();

    combineChallenges();

    notifyListeners();
  }  /// this

  void filterLinkedChallengess(List<dynamic> Linkedsolutions) {
    LinkedChallengesList = UniversalChallengesdata.where((element) {
      var osdValue = element['OCD'];
      return Linkedsolutions.contains(osdValue);
    }).toList();

    // print("filterLinkedChallenges: ${LinkedChallengesList.length}");
    // print("filterLinkedChallenges: ${LinkedChallengesList.first}");
    // lengthOfdocumentSolutions = filteredSolutionsData.length;
    notifyListeners();
  }


  void filterLinkedChallenges(List<dynamic> linkedSolutions, List<dynamic> editPreviewTags) {
    // Normalize editPreviewTags to lowercase
    List<dynamic> normalizedEditPreviewTags = editPreviewTags.map((tag) => tag.toLowerCase()).toList();

    LinkedChallengesList = UniversalChallengesdata.where((element) {
      var ocdValue = element['OCD'];
      return linkedSolutions.contains(ocdValue);
    }).map((challenge) {
      var challengeTags = List<dynamic>.from(challenge['tags'] ?? []);
      // Normalize challenge tags to lowercase
      var normalizedChallengeTags = challengeTags.map((tag) => tag.toLowerCase()).toList();

      // Find matched tags
      var matchedTags = normalizedChallengeTags.where((tag) => normalizedEditPreviewTags.contains(tag)).toList();
      challenge['matchedTags'] = matchedTags; // Add matched tags to each challenge
      return challenge;
    }).toList();

    combineChallenges();

    notifyListeners();
  } /// this

  void filterSolutionss(List<dynamic> tags) {
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

  void filterSolutions(List<dynamic> tags) {
    // Normalize the input tags to lowercase
    List<String> normalizedTags = tags.map((tag) => tag.toString().toLowerCase()).toList();

    relatedSolutionList = UniversalSolutionsdata.where((solution) {
      // Normalize the tags in the solution to lowercase
      var solutionTags = (solution['tags'] as List).map((tag) => tag.toString().toLowerCase()).toList();

      // Check if there is any match
      var hasMatch = solutionTags.any((tag) => normalizedTags.contains(tag));

      if (hasMatch) {
        // Find matched tags
        solution['matchedTags'] = solutionTags.where((tag) => normalizedTags.contains(tag)).toList();
      }

      return hasMatch;
    }).toList();

    combineSolutions();

    notifyListeners();
  } /// this

  void filterLinkedSolutionss(List<dynamic> Linkedsolutions) {
    LinkedSolutionList = UniversalSolutionsdata.where((element) {
      var osdValue = element['OSD'];
      return Linkedsolutions.contains(osdValue);
    }).toList();

    // print("filterLinkedSolutions: ${LinkedSolutionList.length}");
    // print("filterLinkedSolutions: ${LinkedSolutionList.first}");
    // print("filterLinkedSolutions: $LinkedSolutionList");

    // lengthOfdocumentSolutions = filteredSolutionsData.length;
    notifyListeners();
  }

  void filterLinkedSolutions(List<dynamic> linkedSolutions, List<dynamic> editPreviewTags) {
    // Normalize editPreviewTags to lowercase
    List<dynamic> normalizedEditPreviewTags = editPreviewTags.map((tag) => tag.toLowerCase()).toList();

    LinkedSolutionList = UniversalSolutionsdata.where((element) {
      var ocdValue = element['OSD'];
      return linkedSolutions.contains(ocdValue);
    }).map((challenge) {
      var challengeTags = List<dynamic>.from(challenge['tags'] ?? []);
      // Normalize challenge tags to lowercase
      var normalizedChallengeTags = challengeTags.map((tag) => tag.toLowerCase()).toList();

      // Find matched tags
      var matchedTags = normalizedChallengeTags.where((tag) => normalizedEditPreviewTags.contains(tag)).toList();
      challenge['matchedTags'] = matchedTags; // Add matched tags to each challenge
      return challenge;
    }).toList();

    combineSolutions();

    notifyListeners();
  } /// this

  void combineSolutions() {
    combinedSolutionList = [...LinkedSolutionList, ...relatedSolutionList];
    print("combinedSolutionList: ${combinedSolutionList.length}");
    notifyListeners();
  }

  void combineChallenges() {
    combinedChallengeList = [...LinkedChallengesList, ...relatedChallengesList];
    print("combinedChallengeList: ${combinedChallengeList.length}");
    notifyListeners();
  }




  Future<void> fetchUniversalChallengesData() async {
    try {
      UniversalChallengesdata.clear();
      print("UniversalChallengesdata.clear(): ${UniversalChallengesdata}");
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Challenges').orderBy("id").get();
      UniversalChallengesdata = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      filteredChallengesData = UniversalChallengesdata;
      // print("UniversalChallengesdata: ${UniversalChallengesdata.first}");
      // print("UniversalChallengesdata: ${UniversalChallengesdata.first}");
      // print("UniversalChallengesdata: ${UniversalChallengesdata.first}");
      print("UniversalChallengesdata: ${UniversalChallengesdata.length}");
      notifyListeners();
    } catch (e) {
      print("Error fetching data: $e");
    }
  } /// this

  Future<void> fetchUniversalSolutionsdata() async {
    try {
      UniversalSolutionsdata.clear();
      print("fetchUniversalSolutionsdata: ${UniversalSolutionsdata}");
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Thrivers').orderBy("id").get();
      UniversalSolutionsdata = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      filteredSolutionsData = UniversalSolutionsdata;
      // print("fetchUniversalSolutionsdata: ${UniversalSolutionsdata.first}");
      // print("fetchUniversalSolutionsdata: ${UniversalSolutionsdata.first['Linked_solutions']}");
      // print("fetchUniversalSolutionsdata: ${UniversalSolutionsdata.first['Linked_solutions'].length}");
      print("fetchUniversalSolutionsdata: ${UniversalSolutionsdata.length}");
      notifyListeners();
    } catch (e) {
      print("Error fetching data: $e");
    }
  } /// this

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
    print("filteredChallengesData: $filteredChallengesData");
    print("filteredChallengesDataUniversalChallengesdata: $UniversalChallengesdata");
    notifyListeners();
  } /// this

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
  } /// this

  void filterChallengesAdminData(String keyword) {
    if (keyword.isEmpty) {
      filteredChallengesData = UniversalChallengesdata;
    } else {
      filteredChallengesData = UniversalChallengesdata.where((element) {
        var name = element['Label'].toString().toLowerCase();
        var description = element['OCD'].toString().toLowerCase();
        // var tags = element['tags'].toString().toLowerCase();
        // var category = element['Keywords'].toString().toLowerCase();

        return name.contains(keyword.toLowerCase()) ||
            description.contains(keyword.toLowerCase());
        // || tags.contains(keyword.toLowerCase()) ||
            // category.contains(keyword.toLowerCase());
      }).toList();
    }
    lengthOfdocument = filteredChallengesData.length;
    notifyListeners();
  } /// this

  void filterSolutionsAdminData(String keyword) {
    if (keyword.isEmpty) {
      filteredSolutionsData = UniversalSolutionsdata;
    } else {
      filteredSolutionsData = UniversalSolutionsdata.where((element) {
        var name = element['Label'].toString().toLowerCase();
        var description = element['OSD'].toString().toLowerCase();
        // var tags = element['tags'].toString().toLowerCase();
        // var category = element['Keywords'].toString().toLowerCase();

        return name.contains(keyword.toLowerCase()) ||
            description.contains(keyword.toLowerCase()) ;
            // || tags.contains(keyword.toLowerCase()) ||
            // category.contains(keyword.toLowerCase());
      }).toList();
    }
    lengthOfdocumentSolutions = filteredSolutionsData.length;
    notifyListeners();
  } /// this

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
  } /// this

  clearsuggestedChallenges(anytext){
    // anytext.clear();
    combinedResults.clear();
    issuggestedloading = true;
    filteredChallengesData = UniversalChallengesdata;
    lengthOfdocument = null;
    print("combinedResults is cleared: $combinedResults");
    notifyListeners();
  } /// this

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
  } /// this

  Map<int, bool> isEditSolutionListAdded = {};
  bool addedInLinked = false;
  List editsolutionss = [];
  List editchallengess = [];
  List OCDlist = [];
  List OSDlist = [];

  void EditRecommendedSolutionAddd( SolutionDetails) {
    // if (isEditSolutionListAdded[SolutionDetails] != value) {
    // Checkbox is checked, add to the list
    editsolutionss.add(SolutionDetails);
    // editsolutionss.add(SolutionModel(
    //   // id: SolutionDetails['id'],
    //   // label: SolutionDetails['Label'],
    //   // description: SolutionDetails['Description'],
    //   // notes: SolutionDetails['Notes'],
    //   // Source: SolutionDetails['Source'],
    //   // Status: SolutionDetails['Thirver Status'],
    //   // tags: SolutionDetails['tags'],
    //   // CreatedBy: SolutionDetails['Created By'],
    //   // CreatedDate: SolutionDetails['Created Date'],
    //   // ModifiedBy: SolutionDetails['Modified By'],
    //   // ModifiedDate: SolutionDetails['Modified Date'],
    //   // OriginalDescription: SolutionDetails['Original Description'],
    //   // Impact: SolutionDetails['Impact'],
    //   // Final_description: SolutionDetails['Final_description'],
    //   // Category: SolutionDetails['Category'],
    //   // Keywords: SolutionDetails['Keywords'],
    //   // Help: SolutionDetails['Helps'],
    //   // PositiveImpactstoEmployee: SolutionDetails['Positive_impacts_to_employee'],
    //   // PositiveImpactstoOrganisation: SolutionDetails['Positive_impacts_to_organisation'],
    //   // RelatedSolutionsTags: SolutionDetails['Related_solution_tags'],
    //   // SuggestedChallengesTags: SolutionDetails['Suggested_challenges_tags'],
    //   OSD: SolutionDetails['OSD'],
    //   // LinkedChallenges: SolutionDetails['Linked_challenges'],
    // ));
    // isEditSolutionListAdded[SolutionDetails] = value;

    // print("selectedrecommendedChallenges: ${editsolutionss.first.OSD}");
    print("selectedrecommendedChallenges: ${editsolutionss.first}");

    print("EditRecommendedChallengeAdd: $isEditSolutionListAdded");
    // }


    notifyListeners();

  }

  void EditRecommendedSolutionAdd(link,OCD) {
    print("linkeddddd: $link");

    // Check if the link is already in the list
    if (!editsolutionss.contains(link)) {
      editsolutionss.add(link);
      OSDlist.add(OCD);
      notifyListeners();
    }
  } /// this

  // addLinkedsolutions(link){
  //   editsolutionss.clear();
  //   print("linkeddddd: $link");
  //   editsolutionss.addAll(link);
  //   notifyListeners();
  // }

  addLinkedsolutions(link){
    editsolutionss.clear();
    OSDlist.clear();
    print("Linked editsolutionss: $link");

    // Check if UniversalSolutionsdata has been populated
    if (UniversalSolutionsdata.isEmpty) {
      print("No UniversalSolutionsdata available. Please fetch the data first.");
      return;
    }

    // Filter UniversalSolutionsdata based on the provided links
    for (var data in UniversalSolutionsdata) {
      // print("inside addLinkedchallenges: $UniversalSolutionsdata");
      // print("inside addLinkedchallenges data: ${data['OCD']}");
      // print("inside addLinkedchallenges data: ${data['Label']}");
      // Check if 'OSD' and 'Label' fields exist and are of the correct types
      if (data.containsKey('OSD') && data['OSD'] is String && data.containsKey('Label')) {
        String OSD = data['OSD'] as String;
        String label = data['Label'].toString();

        // If the OSD matches any link, add the Label to editsolutionss
        if (link.contains(OSD)) {
          editsolutionss.add(label);
          OSDlist.add(OSD);
        }
      }
    }

    print("addLinkedchallenges OSDlist: ${OSDlist}");

    notifyListeners();
  } /// this

  void removeedittags(item) {
    // print("Before removal: $ProviderEditTags");
    editsolutionss.remove(item);
    OSDlist.remove(item);
    // print("After removal: $ProviderEditTags");
    notifyListeners();
  } /// this

  void EditRecommendedChallengesAdd(link,OCD) {
    print("linkeddddd editchallengess: $link");
    // Check if the link is already in the list
    if (!editchallengess.contains(link)) {
      editchallengess.add(link);
      OCDlist.add(OCD);
      print("EditRecommendedChallengesAdd OCDlist: ${OCDlist}");
      notifyListeners();
    }
  } /// this

  // addLinkedchallenges(link){
  //   editchallengess.clear();
  //   print("linkeddddd editchallengess: $link");
  //   editchallengess.addAll(link);
  //   notifyListeners();
  // }

  void addLinkedchallenges(links) {
    editchallengess.clear();
    OCDlist.clear();
    print("Linked editchallengess: ${links}");
    print("Linked editchallengess: ${links.length}");

    // Check if UniversalSolutionsdata has been populated
    if (UniversalChallengesdata.isEmpty) {
      print("No UniversalChallengesdata available. Please fetch the data first.");
      return;
    }

    // Filter UniversalSolutionsdata based on the provided links
    for (var data in UniversalChallengesdata) {
      // print("inside addLinkedchallenges: $UniversalSolutionsdata");
      // print("inside addLinkedchallenges data: ${data['OCD']}");
      // print("inside addLinkedchallenges data: ${data['Label']}");
      // Check if 'OSD' and 'Label' fields exist and are of the correct types
      if (data.containsKey('OCD') && data['OCD'] is String && data.containsKey('Label')) {
        String OCD = data['OCD'] as String;
        String label = data['Label'].toString();

        // If the OSD matches any link, add the Label to editchallengess
        if (links.contains(OCD)) {
          editchallengess.add(label);
          OCDlist.add(OCD);
        }
      }
    }

    print("addLinkedchallenges OCDlist: ${OCDlist}");

    notifyListeners();
  } /// this


  void removeeditChallengess(item) {
    // print("Before removal: $ProviderEditTags");
    editchallengess.remove(item);
    OCDlist.remove(item);
    print("removeeditChallenges OCDlist: ${OCDlist}");
    notifyListeners();
  }

  void removeeditChallenges(String label) {
    int index = editchallengess.indexOf(label);
    if (index != -1) {
      // Remove the label from editchallengess
      editchallengess.removeAt(index);

      // Remove the corresponding OSD from OCDlist
      OCDlist.removeAt(index);

      print("removeeditChallenges OCDlist: ${OCDlist}");
      notifyListeners();
    }
  } /// this

  void removeeditSolutions(String label) {
    print("inside removeeditSolutions");
    int index = editsolutionss.indexOf(label);
    if (index != -1) {
      // Remove the label from editchallengess
      editsolutionss.removeAt(index);

      // Remove the corresponding OSD from OCDlist
      OSDlist.removeAt(index);

      print("removeeditSolutions OSDlist: ${OSDlist}");
      notifyListeners();
    }
  } /// this

}