import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImportMasterPanel extends StatefulWidget {
  @override
  _ImportMasterPanelState createState() => _ImportMasterPanelState();
}

class _ImportMasterPanelState extends State<ImportMasterPanel> {
  String? selectedCollection;
  Map<String, dynamic> selectedParameters = {};

  final Map<String, List<String>> collectionParameters = {
    "collection1": ["parameter1", "parameter2", "parameter3"],
    "collection2": ["parameter1", "parameter2"],
    "collection3": ["parameter1", "parameter2", "parameter3", "parameter4"],
    // Add more collections and their parameters
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import Master Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              hint: Text("Select Collection"),
              value: selectedCollection,
              items: collectionParameters.keys.map((String collection) {
                return DropdownMenuItem<String>(
                  value: collection,
                  child: Text(collection),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCollection = newValue;
                  selectedParameters.clear();
                });
              },
            ),
            SizedBox(height: 16),
            if (selectedCollection != null)
              ...collectionParameters[selectedCollection!]!.map((parameter) {
                return CheckboxListTile(
                  title: Text(parameter),
                  value: selectedParameters[parameter] ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      selectedParameters[parameter] = value;
                    });
                  },
                );
              }).toList(),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.delete),
              label: Text('Clear Collection'),
              onPressed: () => _clearCollection(context, selectedCollection!),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.file_upload),
              label: Text('Import Data from Excel'),
              onPressed: () => _importDataFromExcel(context, selectedCollection!, selectedParameters),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _clearCollection(BuildContext context, String collection) async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(collection);
      QuerySnapshot snapshot = await collectionRef.get();

      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$collection cleared successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to clear $collection: $e')),
      );
    }
  }


  Future<void> _importDataFromExcel(BuildContext context, String collection, Map<String, dynamic> parameters) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        var bytes = file.readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            Map<String, dynamic> data = {};

            // Map selected parameters to the row data
            int index = 0;
            parameters.forEach((key, value) {
              if (value) {
                data[key] = row[index]?.value;
                index++;
              }
            });

            await FirebaseFirestore.instance.collection(collection).add(data);
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data imported successfully into $collection')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to import data: $e')),
      );
    }
  }
}
