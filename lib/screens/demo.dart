import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/Provider/AddKeywordsProvider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class DSemo extends StatefulWidget {
  const DSemo({super.key});

  @override
  State<DSemo> createState() => _DSemoState();
}

class _DSemoState extends State<DSemo> {

  TextEditingController tagscontroller = TextEditingController();
 late final AddKeywordProvider addKeywordProvider;


  void excelimporttt() async {

  ByteData data = await rootBundle.load('Thrivers_Import_test_flutter.xlsx');

  var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);

  for (var table in excel.tables.keys) {
  print(table); //sheet Name
  print(excel.tables[table]?.maxColumns);
  print(excel.tables[table]?.maxRows);
  // for (var row in excel.tables[table]!.rows) {
  // print('fenil $row');
  // }
  for (var columns in excel.tables[table]!.row(0)) {
  print('columns $columns');
  }
  }
}


  void excelimport() async{
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );
    if (pickedFile != null) {
      var bytes = pickedFile?.files.single.bytes;
      var excel = Excel.decodeBytes(bytes!);
      for (var table in excel.tables.keys) {
        print(table); //sheet Name
        print(excel.tables[table]?.maxColumns);
        print(excel.tables[table]?.maxRows);
        for (var row in excel.tables[table]!.rows) {
          print('$row');
        }
      }
    }
  }

  List<List<dynamic>> _data = [];

  void _loadCSV() async {
    try{
      print("inisde load csv");
      final _rawData = await rootBundle.loadString("Challenges_import_01082024.csv");
      // final _rawData = await rootBundle.loadString("Solutions_import_01082024.csv");
      List<List<dynamic>> _listData = const CsvToListConverter().convert(_rawData);

      setState(() {
        _data = _listData;
      });
    }
    catch(e){
      print("inisde load csv error: $e");
    }

  }

  void _loadCSVnew() async {
    final _rawData = await rootBundle.loadString("Thrivers_Import_test_flutter.csv");
    List<List<dynamic>> _listData = const CsvToListConverter().convert(_rawData);

    // Assuming you want to find a row with ID 1

    int targetId = 1;
    List<List<dynamic>> filteredData = _listData
        .where((row) => row.isNotEmpty && row[1] == targetId)
        .toList();
    print(filteredData);

    setState(() {
      _data = filteredData;
      print(_data);
    });
  }

  void _loadCSVvvvv() async {
    final _rawData = await rootBundle.loadString("Thrivers_Import_test_flutter.csv");
    List<List<dynamic>> _listData = const CsvToListConverter().convert(_rawData);

    // Specify the target ID you want to filter
    String targetId = "TH0080";

    // Find the row with the matching ID
    List<dynamic> matchingRow = _listData.firstWhere((row) => row.isNotEmpty && row[0] == targetId, orElse: () => List.filled(_listData[0].length, ''),);

    // Update _data with the matching row
    setState(() {
      _data = [matchingRow];
    });

    // If no matching row is found, print a message
    if (matchingRow.isEmpty) {
      print("No row found with ID: $targetId");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // KeywordServices();
    addKeywordProvider = Provider.of<AddKeywordProvider>(context, listen: false);
    _loadCSV(); /// this file is used
    // _loadCSVvvvv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: ()async{
            // _loadCSVnew();
            },
        child: Icon(Icons.add, color: Colors.white,),
      ),
      // body: NewDemo()
      body: Newexceldemo()

    );
  }

  Widget NewDemo () {
    return Consumer<AddKeywordProvider>(
      builder: (c,addKeywordProvider, _){
        return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TypeAheadField(
            noItemsFoundBuilder: (c){
              return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Add Tag: '${tagscontroller.text}'",style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),),
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
              return await KeywordServices.getSuggestions(value);
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
              print("Im selectedf $suggestion");
              print("Im selectedf ${tagscontroller.text}" );
              addKeywordProvider.updateSuggetion(suggestion);
              tagscontroller.text = addKeywordProvider.suggestion;
              addKeywordProvider.addChip(tagscontroller.text);
            },
            textFieldConfiguration: TextFieldConfiguration(
              controller: tagscontroller,
              onSubmitted: (text) {
                addKeywordProvider.addChip(tagscontroller.text.toString());
              },
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                color: Colors.black,
                fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
              ),
              decoration: InputDecoration(
                //errorText: userAccountSearchErrorText,
                contentPadding: EdgeInsets.all(25),
                labelText: "Add Keywords",
                hintText: "Add Keywords",
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

              // decoration: InputDecoration(
              //   //errorText: userAccountSearchErrorText,
              //   contentPadding: EdgeInsets.all(25),
              //   labelText: "Add Tags",
              //   suffixIcon: IconButton(
              //     icon: Icon(Icons.add, size: 20, color: Colors.blue,),
              //     onPressed: () {
              //       String text = tagscontroller.text.trim();
              //       if (text.isNotEmpty && !addKeywordProvider.chips.contains(text)) {
              //           addKeywordProvider.chips.add(text);
              //           tagscontroller.clear();
              //       };
              //     },
              //   ),
              //
              //   prefixIcon: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Icon(Icons.tag,color: Colors.blue,),
              //   ),
              //   errorStyle: GoogleFonts.montserrat(
              //       textStyle: Theme.of(context).textTheme.bodyLarge,
              //       fontWeight: FontWeight.w400,
              //       color: Colors.redAccent),
              //   enabledBorder:OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.white12),
              //       borderRadius: BorderRadius.circular(100)),
              //   focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(100)),
              //   border: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.white12),
              //       borderRadius: BorderRadius.circular(100)),
              //   labelStyle: GoogleFonts.montserrat(
              //       textStyle: Theme.of(context).textTheme.bodyLarge,
              //       fontWeight: FontWeight.w400,
              //       color: Colors.white54),
              // ),
            ),
          ),
        ),
        SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              children: addKeywordProvider.chips.map((item){
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
                            addKeywordProvider.chips.remove(item);
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
        ),

      ],
    );
  },
  );
  }


  Widget Newexceldemo(){
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            itemCount: _data.length,
            itemBuilder: (_, index) {
              // print("descripbjhfbcjdf${_data[index][13].toString()}");
              return GestureDetector(
                /// 1 challenges
                // onTap: () async {
                //
                //   int x = 0;
                //   for(var i in _data){
                //   List<String> Keywordsarray = i[9].split(', ');
                //   List<String> NewTagsarray = i[12].split(', ');
                //
                //   List<String> RelatedTagsarray = i[10].split(', ');
                //   List<String> SuggestedTagsarray = i[11].split(', ');
                //
                //
                //   List<String> Tagsarray = [];
                //   Tagsarray.addAll(RelatedTagsarray);
                //   Tagsarray.addAll(SuggestedTagsarray);
                //
                //   x = x + 1;
                //
                //   print("RelatedTagsarray: ${RelatedTagsarray.length}");
                //   print("Suggested: ${SuggestedTagsarray.length}");
                //   print("Tagsarray: ${Tagsarray.length}");
                //
                //   Map<String, dynamic> ImportData = {
                //     "Source" : "",
                //     "sr_no" : i[0].toString(),
                //     "OCD" : i[1].toString(),
                //     "id": x ,
                //     "Challenge Status" : "New",
                //     "tags": Tagsarray,
                //     "Related_challenges_tags": RelatedTagsarray,
                //     "Suggested_solutions_tags": SuggestedTagsarray,
                //     "Linked_solutions": NewTagsarray,
                //     "new_linked_solutions": [],
                //     "Created By": "MK",
                //     "Created Date": DateTime.now(),
                //     "Modified By": "",
                //     "Modified Date": "",
                //     'Label':  i[2].toString(),
                //     'Final_description': i[3].toString(),
                //     'Description':i[5].toString(),
                //     'Impact':i[4].toString(),
                //     'Impacts_to_employee':i[6].toString(),
                //     'Impacts_to_Coworkers':i[8].toString(),
                //     'Negative_impacts_to_organisation':i[7].toString(),
                //     // 'Details': _controller.document.insert(0, addDetailsController.text.toString()),
                //     // 'Category': addKeywordProvider.selectedValue.toString(),
                //     'Category': "Challenge Category",
                //     'Keywords':Keywordsarray,
                //     "Original Description": "",
                //     "Notes": "",//i[12].toString(),
                //     "Hidden Strengths": "",//i[10].toString(),
                //     "Potential Strengths":"",// i[11].toString(),
                //     // Add more fields as needed
                //   };
                //   // String solutionJson = json.encode(ImportData);
                //   // print(solutionJson);
                //    print("ImportData: ${ImportData}");
                //
                //     await ApiRepository().createchallenges(ImportData);
                //   }
                //
                // },
                /// 2 solutions
                // onTap: () async {
                //
                //   int x = 0;
                //   for(var i in _data){
                //   List<String> Keywordsarray = i[9].split(', ');
                //   // List<String> Tagsarray = i[9].split(', ');
                //   List<String> RelatedTagsarray = i[10].split(', ');
                //   List<String> Suggested = i[11].split(', ');
                //
                //   List<String> Tagsarray = [];
                //   Tagsarray.addAll(RelatedTagsarray);
                //   Tagsarray.addAll(Suggested);
                //
                //   x = x + 1;
                //
                //     print("RelatedTagsarray: ${RelatedTagsarray}");
                //     print("Suggested: ${Suggested}");
                //     print("Tagsarray: ${Tagsarray}");
                //
                //   Map<String, dynamic> ImportData = {
                //       "id": x,
                //       "sr_no" : i[0].toString(),
                //       "OSD" : i[1].toString(),
                //       "Source" : "",
                //       "Thirver Status" : addKeywordProvider.selectThriversStatusItems,
                //       "tags": Tagsarray,
                //       "Linked_challenges": [],
                //       "Related_solution_tags": RelatedTagsarray,
                //       "Suggested_challenges_tags": Suggested,
                //       "Positive_impacts_to_employee": i[7].toString(),
                //       "Positive_impacts_to_organisation": i[8].toString(),
                //       "Helps": i[6].toString(),
                //       "Created By": "MK",
                //       "Created Date": DateTime.now(),
                //       "Modified By": "",
                //       "Modified Date": "",
                //       'Label': i[2].toString(),
                //       // 'Description': thriverDescTextEditingController.text,
                //       'Description': i[5].toString(),
                //       'Original Description': "",
                //       'Final_description': i[3].toString(),
                //       'Impact': i[4].toString(),
                //       // 'Details': _controller.document.insert(0, addDetailsController.text.toString()),
                //       // 'Category': addKeywordProvider.selectedValue.toString(),
                //       'Category': "Thrivers Category",
                //       'Keywords': Keywordsarray,
                //       "Notes" :  "gpt4"
                //       // 'Associated Thrivers': "",
                //       // 'Associated Challenges': ""
                //     };
                //
                //   print("ImportData: ${ImportData}");
                //
                //     await ApiRepository().createThriversss(ImportData);
                //   }
                //
                // },
                /// 3 add tag list
                // onTap: () async {
                //   // for(var i in _data) {
                //   //
                //   List<String> TagsList = [
                //     "access barriers",
                //     "accessibility",
                //     "accommodation",
                //     "accidents",
                //     "ADHD",
                //     "administrative inefficiency",
                //     "anxiety",
                //     "aphasia",
                //     "attention issues",
                //     "auditory processing",
                //     "biased assessments",
                //     "burnout",
                //     "career challenges",
                //     "chronic illness",
                //     "chronic pain",
                //     "cliques",
                //     "clutter management",
                //     "cognitive challenges",
                //     "communication anxiety",
                //     "communication barriers",
                //     "comprehension difficulties",
                //     "computer strain",
                //     "cultural misunderstandings",
                //     "deadline pressures",
                //     "decreased productivity",
                //     "depression",
                //     "digital barriers",
                //     "disability accommodation",
                //     "discomfort at work",
                //     "discrimination",
                //     "dyslexia",
                //     "dyspraxia",
                //     "emotional distress",
                //     "environmental and ergonomic issues",
                //     "ethical concerns",
                //     "exclusion",
                //     "fatigue",
                //     "gossip",
                //     "group dynamics",
                //     "health and well-being",
                //     "high stress levels",
                //     "inefficiency",
                //     "information management issues",
                //     "integrity concerns",
                //     "isolation",
                //     "job rejection",
                //     "lack of advancement",
                //     "learning difficulties",
                //     "memory challenges",
                //     "mental health",
                //     "miscommunication",
                //     "mistakes",
                //     "mobility challenges",
                //     "multitasking difficulties",
                //     "noise distraction",
                //     "nonverbal communication",
                //     "organisational inefficiencies",
                //     "peer relations",
                //     "performance issues",
                //     "performance anxiety",
                //     "physical barriers",
                //     "physical exertion",
                //     "poor organisation",
                //     "procrastination",
                //     "prolonged screen time",
                //     "recruitment bias",
                //     "remote work challenges",
                //     "repetitive strain injuries",
                //     "scheduling challenges",
                //     "sensory challenges",
                //     "sensory overload",
                //     "social difficulties",
                //     "social anxiety",
                //     "task execution errors",
                //     "task management difficulties",
                //     "technology adaptation challenges",
                //     "time management problems",
                //     "tokenism",
                //     "underemployment",
                //     "visual discomfort",
                //     "web accessibility",
                //     "workplace conflicts",
                //     "workplace culture issues",
                //     "accessibility and inclusion",
                //     "accessible formats",
                //     "adaptable strategies",
                //     "adjustable furniture",
                //     "alternative communication",
                //     "assistive technology",
                //     "awareness training",
                //     "career guidance",
                //     "childcare support",
                //     "clear communication",
                //     "cognitive support",
                //     "comfort and ergonomics",
                //     "communication tools",
                //     "custom tools",
                //     "daily planning",
                //     "diverse hiring",
                //     "educational inclusion",
                //     "efficient workspace",
                //     "emergency preparedness",
                //     "emotional support",
                //     "environmental modifications",
                //     "equal opportunity",
                //     "ergonomic adjustments",
                //     "flexible schedules",
                //     "wellness programs",
                //     "inclusive hiring",
                //     "memory training",
                //     "mental health support",
                //     "mentorship programs",
                //     "neurodiversity inclusion",
                //     "noise management",
                //     "organisational tools",
                //     "peer reviews",
                //     "physical conditioning",
                //     "organisation planning",
                //     "productivity tools",
                //     "professional counselling",
                //     "professional development",
                //     "project management",
                //     "reliable VPNs",
                //     "risk management",
                //     "safe environment",
                //     "safety training",
                //     "schedule management",
                //     "skills workshops",
                //     "stress management",
                //     "support networks",
                //     "task management",
                //     "time management",
                //     "visual planning",
                //     "workflow automation"
                //   ];
                //   // SolutionList.addAll(_data[index][0].split(", "));
                //   //   print("SolutionList: ${TagsList}");
                //   //   print("SolutionList: ${TagsList.length}");
                //     // addKeywordProvider.addKeyword(context, "Challenges tags", Challenges);
                //     // addKeywordProvider.updateKeyword(context,"GEdua4iCBaakTpNB1NY5", "Tag List", TagsList);
                //   // }
                //
                // },
                child: Card(
                  margin: const EdgeInsets.all(3),
                  color: index == 0 ? Colors.amber : Colors.white,
                  child: ListTile(
                    leading: Column(
                      children: [
                        // Text(_data[index][13].toString()),
                        // Text(_data[index][12].toString()),
                        // Text(_data[index][3].toString()),
                        // Text(_data[index][4].toString()),
                        // Text(_data[index][5].toString()),
                        // Text(_data[index][6].toString()),
                        // Text(_data[index][7].toString()),
                        // Text(_data[index][8].toString()),
                        // Text(_data[index][9].toString()),
                      ],
                    ),
                    // trailing: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(_data[index][3]),
                    //     SizedBox(width: 10,),
                    //     Text(_data[index][5]),
                    //   ],
                    // ),
                    title: Text("${_data[index][12].split(", ")}"),
                    // subtitle: Text("${_data[index][1].split(", ")}"),
                  ),
                ),
              );
            },
          ),
        ),
        Text("data", style: TextStyle(fontSize: 40),),
      ],
    );
  }
}

class KeywordServices {
  static Future<List<String>> getSuggestions(String query) async {
    List<String> matches = [];
    print("Getting Suggestions For " + query);

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Keywords').get();

      print("querySnapshot ${querySnapshot}");

      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        dynamic data = snapshot.data();

        if (data != null && data.containsKey('Key')) {
          String key = data['Key'].toString().toLowerCase();

          if (key.contains(query.toLowerCase())) {
            matches.add(key);
          }
        }
      }
    } catch (e) {
      print("Error getting suggestions: $e");
    }

    return matches;
  }
}
