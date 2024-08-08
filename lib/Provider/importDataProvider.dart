import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImportDataProvider with ChangeNotifier{

  Map<String, List<String>> collectionParameters = {
    "Collection1": [
      "no", "OCD", "Label", "Description", "Impact Quote", "Detail",
      "Impacts to Employee", "Negative Impacts to Organisation", "Impacts to Coworkers",
      "Category(s)", "Related Challenges Tags", "Suggested Solutions Tags", "Linked Solutions"
    ],
    "Collection2": [
      "no", "OSD", "Label", "Description", "Impact Quote", "Final_Description",
      "Negative Impacts to Employee", "Negative Impacts to Organisation", "Impacts to Coworkers",
      "Category(s)", "Related Solutions Tags", "Suggested challenges Tags", "Linked challenges"
    ],
    // Add more collections as needed
  };

   importDataFromFile(context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final bytes = result.files.single.bytes!;
      String csvData = String.fromCharCodes(bytes);
      List<List<dynamic>> csvList = CsvToListConverter().convert(csvData);

      for (var row in csvList.skip(1)) {
        Map<String, dynamic> dataMap = {};

        parameterIndexMapping.forEach((parameter, index) {
          dataMap[parameter] = row[index!].toString().trim();
        });

        await FirebaseFirestore.instance
            .collection(selectedCollection)
            .add(dataMap);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data imported successfully'),
      ));
    }
  }

  String selectedCollection = "Collection1";
  Map<String, int?> parameterIndexMapping = {};
  List<int> availableIndices = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; // [0-15]

  void initializeParameters() {
    parameterIndexMapping = {};
    for (var param in collectionParameters[selectedCollection]!) {
      parameterIndexMapping[param] = null; // Initialize with no selection
    }
  }

  void onCollectionChanged(String? newValue) {
      selectedCollection = newValue!;
      initializeParameters();
      availableIndices = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]; // Reset available indices
    notifyListeners();
  }

  void onIndexChanged(String parameter, int? newIndex) {
      // Return the old index to available indices if it exists
      int? oldIndex = parameterIndexMapping[parameter];
      if (oldIndex != null) {
        availableIndices.add(oldIndex);
        availableIndices.sort(); // Ensure the list is sorted after adding the old index back
      }

      // Remove the new index from available indices
      if (newIndex != null) {
        availableIndices.remove(newIndex);
      }

      // Update the mapping
      parameterIndexMapping[parameter] = newIndex;
      notifyListeners();
  }

  void clearCollection(context) async {
    FirebaseFirestore.instance
        .collection(selectedCollection)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Collection cleared successfully'),
      ));
    });
  }

}