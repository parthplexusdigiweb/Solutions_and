import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../Network/FirebaseApi.dart';

class NewImportMasterPanel extends StatefulWidget {
  @override
  _NewImportMasterPanelState createState() => _NewImportMasterPanelState();
}

class _NewImportMasterPanelState extends State<NewImportMasterPanel> {

  List<String> collections = [
    "Collection1", "Collection2", "Collection3", //... Add all 11 collections
  ];

  // Map<String, List<String>> collectionParameters = {
  //   "COLLECTIONS1": [
  //     "no", "OCD", "Label", "Description", "Impact Quote", "Detail",
  //     "Impacts to Employee", "Negative Impacts to Organisation", "Impacts to Coworkers",
  //     "Category(s)", "Related Challenges Tags", "Suggested Solutions Tags", "Linked Solutions"
  //   ],
  //   "Collection2": [
  //     "no", "OSD", "Label", "Description", "Impact Quote", "Final_Description",
  //     "Negative Impacts to Employee", "Negative Impacts to Organisation", "Impacts to Coworkers",
  //     "Category(s)", "Related Solutions Tags", "Suggested challenges Tags", "Linked challenges"
  //   ],
  //   // Add more collections as needed
  // };
  Map<String, List<String>> collectionParameters = {
    "COLLECTIONS1": [],
    "COLLECTIONS2": [],
  };

  String selectedCollection = "";
  Map<String, int?> parameterIndexMapping = {}; // Store index mapping for parameters

  void _clearCollection() async {
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

  void _initializeParameters() {
    parameterIndexMapping = {};
    for (var param in collectionParameters[selectedCollection]!) {
      parameterIndexMapping[param] = null; // Initialize with no selection
    }
  }

  void _importDataFromFileee() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final bytes = result.files.single.bytes!;
      String csvData = String.fromCharCodes(bytes);
      print("cssDaTA:$csvData");
      print("cssDaTA:${csvData.runtimeType}");
      List<List<dynamic>> csvList = CsvToListConverter().convert(csvData);

      // Transpose the data to handle column-wise import
      // List<List<dynamic>> transposedData = List.generate(
      //     csvList[0].length, (i) => List.generate(csvList.length, (j) => csvList[j][i]));

      // Skip the first row, which contains headers
      // transposedData.removeAt(0);

      for (var row in csvList) {
        // Skip empty rows
        if (row.where((element) => element.toString().trim().isNotEmpty).isEmpty) continue;

        Map<String, dynamic> dataMap = {};

        parameterIndexMapping.forEach((parameter, index) {
          if (index != null && index < row.length) {
            dataMap[parameter] = row[index].toString().trim();
          }
        });

        print("datamap:$parameterIndexMapping");
        // Add the data to Firestore
        // await FirebaseFirestore.instance
        //     .collection(selectedCollection)
        //     .add(dataMap);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data imported successfully'),
      ));
    }
  }

  Future<List<String>> _importDataFromFiless() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null && result.files.single.bytes != null) {
      var bytes = result.files.single.bytes!;
      var excel = Excel.decodeBytes(bytes);
      List<String> topics = [];


      // Assuming the topics are in column B (index 1) of the first sheet
      for (var row in excel.tables[excel.tables.keys.first]?.rows ?? []) {
        if (row[1] != null) {
          topics.add(row[1].value.toString()); // Adjust the index if the column is different
        }
      }

      // print(" topics topics $topics");
      return topics;
    } else {
      throw Exception('Failed to pick or read the Excel file');
    }
  }

  // Future<List<List<dynamic>>> _importDataFromFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['csv'],
  //   );
  //
  //   if (result != null && result.files.single.bytes != null) {
  //     var bytes = result.files.single.bytes!;
  //     String csvData = String.fromCharCodes(bytes);
  //
  //     // Convert CSV string to List of Lists
  //     List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);
  //
  //     // Explicitly loop through the rows and columns
  //     for (var row in csvTable) {
  //       for (var cell in row) {
  //         print(cell); // Process each cell
  //       }
  //     }
  //
  //     return csvTable;
  //   } else {
  //     throw Exception('Failed to pick or read the CSV file');
  //   }
  // }

  Future<void> _importDataFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.bytes != null) {
      var bytes = result.files.single.bytes!;
      String csvData = String.fromCharCodes(bytes);

      // Convert CSV string to List of Lists
      List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);

      // Define a map to store the data
      Map<String, dynamic> dataMap = {};

      // Iterate over the rows
      for (var i = 0; i < csvTable.length; i++) {
        var row = csvTable[i];
      print("csvTable[i]: ${csvTable[i]}");
      for(var i in row){
        print('iiiii: $i');
      }
      // print("row 0: ${row[0]}");
      // print("row 1: ${row[1]}");
      // print("row 2: ${row[2]}");
        // if (i == 0) {
        //   // Store sr_no from the first row
        //   if (row.isNotEmpty) {
        //     dataMap['sr_no'] = row[0];
        //   }
        // } else if (i == 1) {
        //   // Store label from the second row
        //   if (row.length > 1) {
        //     dataMap['label'] = row[1];
        //   }
        // }

        // Additional logic for other rows can be added here
      }

      // Print the map or use it as needed
      print(dataMap);
    } else {
      throw Exception('Failed to pick or read the CSV file');
    }
  }

  List<List<dynamic>> _data = [];

  Future<void> _pickAndLoadCSV() async {
    try {
      // Pick the file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.bytes != null) {
        var bytes = result.files.single.bytes!;
        String csvData = String.fromCharCodes(bytes);

        List<List<dynamic>> listData = CsvToListConverter().convert(csvData);

        setState(() {
          _data = listData;
        });

        // Process the data
        await _importData();
      } else {
        print("No file selected");
      }
    } catch (e) {
      print("Error picking or loading CSV file: $e");
    }
  }

  Future<void> _importData() async {
    int x = 0;
    var ImportDatas = [];
    for (var i in _data) {
      if(i[0] != "") {
        List<String> Keywordsarray = i[9].split(', ');
        List<String> NewTagsarray = i[12].split(', ');

        List<String> RelatedTagsarray = i[10].split(', ');
        List<String> SuggestedTagsarray = i[11].split(', ');

        List<String> Tagsarray = [];
        Tagsarray.addAll(RelatedTagsarray);
        Tagsarray.addAll(SuggestedTagsarray);

        x = x + 1;

        // print("RelatedTagsarray: ${RelatedTagsarray.length}");
        // print("Suggested: ${SuggestedTagsarray.length}");
        // print("Tagsarray: ${Tagsarray.length}");

        Map<String, dynamic> ImportData = {
          "Source": "",
          "sr_no": i[0].toString(),
          "OCD": i[1].toString(),
          "id": x,
          "Challenge Status": "New",
          "tags": Tagsarray,
          "Related_challenges_tags": RelatedTagsarray,
          "Suggested_solutions_tags": SuggestedTagsarray,
          "Linked_solutions": NewTagsarray,
          "new_linked_solutions": [],
          "Created By": "MK",
          "Created Date": DateTime.now(),
          "Modified By": "",
          "Modified Date": "",
          'Label': i[2].toString(),
          'Final_description': i[3].toString(),
          'Description': i[5].toString(),
          'Impact': i[4].toString(),
          'Impacts_to_employee': i[6].toString(),
          'Impacts_to_Coworkers': i[8].toString(),
          'Negative_impacts_to_organisation': i[7].toString(),
          'Category': "Challenge Category",
          'Keywords': Keywordsarray,
          "Original Description": "",
          "Notes": "",
          "Hidden Strengths": "",
          "Potential Strengths": "",
          // Add more fields as needed
        };
        ImportDatas.add(ImportData);

        await ApiRepository().createchallenges(ImportData);

      }

    }
    print("ImportData: ${ImportDatas}");
    print("ImportData: ${ImportDatas.length}");
  }

  void _onCollectionChanged(String? newValue) {
    setState(() {
      selectedCollection = newValue!;
      _initializeParameters();
    });
  }

  void _onIndexChanged(String parameter, String? newIndex) {
    setState(() {
      // Parse the index from the text input
      int? index = int.tryParse(newIndex ?? "");
      parameterIndexMapping[parameter] = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(),
              Divider(),
              SizedBox(height: 10,),
              DropdownButtonFormField<String>(
                value: null,
                onChanged: _onCollectionChanged,
                items: collectionParameters.keys.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Select a collection'), // Optional: Add a hint to guide the user
              ),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: collectionParameters[selectedCollection]!.length,
              //     itemBuilder: (context, index) {
              //       String parameter = collectionParameters[selectedCollection]![index];
              //       String? currentValue = parameterIndexMapping[parameter]?.toString();
              //
              //       return Row(
              //         children: [
              //           Text(parameter),
              //           SizedBox(width: 10),
              //           Expanded(
              //             child: TextField(
              //               onChanged: (newValue) {
              //                 _onIndexChanged(parameter, newValue);
              //               },
              //               keyboardType: TextInputType.number,
              //               decoration: InputDecoration(
              //                 hintText: "Enter Index",
              //                 border: OutlineInputBorder(),
              //                 contentPadding: EdgeInsets.symmetric(horizontal: 10),
              //               ),
              //               controller: TextEditingController(text: currentValue),
              //             ),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),

              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if(selectedCollection==null || selectedCollection==""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error'),
                          ));
                        }
                        else _clearCollection();
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text("Clear Collection",style: TextStyle(color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,),),
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        if(selectedCollection==null || selectedCollection==""){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Error'),
                          ));
                        }
                        else _pickAndLoadCSV();
                        },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                    
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text("Import Data",style: TextStyle(color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,),),
                          )
                    
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: _clearCollection,
                  //   child: Text('Clear Collection'),
                  // ),
                  // ElevatedButton(
                  //   onPressed: _pickAndLoadCSV,
                  //   child: Text('Import Data'),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  HeaderWidget() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Text(
        'Import Master',
        style: TextStyle(
          color: Colors.black, // Change the text color to your desired color
          fontSize: 24.0, // Adjust the font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
