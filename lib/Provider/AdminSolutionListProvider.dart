import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SolutionsListProvider with ChangeNotifier{
  List<Map<String, dynamic>> SolutionsdataList = [];
  List<Map<String, dynamic>> filteredSolutionsDataList = [];

  int? lengthOfdocumentSolutions;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;


  List<Map<String, dynamic>> get getUniversalSolutionsdata =>  filteredSolutionsDataList.isEmpty ? SolutionsdataList : filteredSolutionsDataList;

  Future<void> fetchSolutionsdataList() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Thrivers').orderBy('id').get();
      SolutionsdataList = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      filteredSolutionsDataList = SolutionsdataList;
      paginateData();
      print("fetchSolutionsdataList: ${SolutionsdataList.length}");
      notifyListeners();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void filterSolutionsData(String keyword) {
    if (keyword.isEmpty) {
      filteredSolutionsDataList = SolutionsdataList;
    } else {
      filteredSolutionsDataList = SolutionsdataList.where((element) {
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
    lengthOfdocumentSolutions = filteredSolutionsDataList.length;
    notifyListeners();
  }

  int currentPage = 1;
  int itemsPerPage = 30;
  List<Map<String, dynamic>> paginatedSolutionsDataList = [];

  void paginateData() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (endIndex > filteredSolutionsDataList.length) {
      endIndex = filteredSolutionsDataList.length;
    }
    paginatedSolutionsDataList = filteredSolutionsDataList.sublist(startIndex, endIndex);
  }

  void loadFirstPage() {
    currentPage = 1;
    paginateData();
    notifyListeners();
  }

  void loadPreviousPage() {
    if (currentPage > 1) {
      currentPage--;
      paginateData();
      notifyListeners();
    }
  }

  void loadNextPage() {
    if (currentPage < totalPages) {
      currentPage++;
      paginateData();
      notifyListeners();
    }
  }

  void loadLastPage() {
    currentPage = totalPages;
    paginateData();
    notifyListeners();
  }

  int get totalPages => (filteredSolutionsDataList.length / itemsPerPage).ceil();

}