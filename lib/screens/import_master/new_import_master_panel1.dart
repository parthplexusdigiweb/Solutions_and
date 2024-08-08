import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/importDataProvider.dart';

class ImportMasterPanel1 extends StatefulWidget {
  @override
  _ImportMasterPanel1State createState() => _ImportMasterPanel1State();
}

class _ImportMasterPanel1State extends State<ImportMasterPanel1> {

  late final ImportDataProvider _importDataProvider;


  @override
  void initState() {
    super.initState();
    _importDataProvider = Provider.of<ImportDataProvider>(context, listen: false);
    _importDataProvider.initializeParameters();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Import Master Panel')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ImportDataProvider>(
            builder: (c,importDataProvider, _){
              return Column(
                children: [
                  DropdownButton<String>(
                    value: importDataProvider.selectedCollection,
                    onChanged: importDataProvider.onCollectionChanged,
                    items: importDataProvider.collectionParameters.keys.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: importDataProvider.collectionParameters[importDataProvider.selectedCollection]!.length,
                      itemBuilder: (context, index) {
                        String parameter = importDataProvider.collectionParameters[importDataProvider.selectedCollection]![index];
                        int? currentValue = importDataProvider.parameterIndexMapping[parameter];

                        return Row(
                          children: [
                            Text(parameter),
                            SizedBox(width: 10),
                            Expanded(
                              child: DropdownButton<int?>(
                                value: importDataProvider.availableIndices.contains(currentValue) ? currentValue : null,
                                onChanged: (newValue) {
                                  importDataProvider.onIndexChanged(parameter, newValue);
                                },
                                items: importDataProvider.availableIndices.map<DropdownMenuItem<int?>>((int value) {
                                  return DropdownMenuItem<int?>(
                                    value: value,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                                hint: Text("Select Index"),
                                isExpanded: true,
                                underline: Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: (){importDataProvider.clearCollection(context);},
                        child: Text('Clear Collection'),
                      ),
                      ElevatedButton(
                        onPressed: (){importDataProvider.importDataFromFile(context);},
                        child: Text('Import Data'),
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}