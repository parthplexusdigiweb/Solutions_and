import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:thrivers/Provider/AddKeywordsProvider.dart';
import 'package:thrivers/screens/import_master/demo.dart';
class AddKeywordsScreen extends StatefulWidget {
  const AddKeywordsScreen({super.key});

  @override
  State<AddKeywordsScreen> createState() => _AddKeywordsScreenState();
}

class _AddKeywordsScreenState extends State<AddKeywordsScreen> {

  TextEditingController addcategory = TextEditingController();
  TextEditingController editcategorycontroller = TextEditingController();
  TextEditingController addkeywords = TextEditingController();
  TextEditingController editkeywordscontroller = TextEditingController();
  List<String> documentIds = [];


  HeaderWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      //color: Colors.deepPurple, // Change the color to your desired background color
      child: Text(
        'Keywords',
        style: TextStyle(
          color: Colors.black, // Change the text color to your desired color
          fontSize: 24.0, // Adjust the font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Future<List<String>> getDocumentIds() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Keywords').get();

      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        documentIds.add(snapshot.id);
      }
      print("fenildocumentIds :${documentIds}");
      return documentIds;
    } catch (e) {
      print('Error getting document IDs: $e');
      return [];
    }
  }

  late final AddKeywordProvider addKeywordProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addKeywordProvider = Provider.of<AddKeywordProvider>(context, listen: false);
    getDocumentIds();
    // editcategorycontroller.text = addKeywordProvider.key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      body: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  showAddThriverDialogBox(context);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Add Keywords',textAlign: TextAlign.center,style: GoogleFonts.montserrat(
                        textStyle: Theme.of(context).textTheme.titleSmall,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),)),
              ),
            ),
            Divider(
              indent: 10,
              endIndent: 10,
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 50,
            //       itemBuilder: (c,i){
            //         return Container(
            //           padding: EdgeInsets.all(10),
            //           child: ExpansionTile(
            //             collapsedShape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(10),
            //                 side: BorderSide(color: Colors.blue,)
            //             ),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //               side: BorderSide(color: Colors.cyan)
            //             ),
            //             title: Text("Fenil"),
            //             leading: Text("${i+1}."),
            //             children: List.generate(3, (index) =>
            //                 Align(
            //                   alignment: Alignment.centerLeft,
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: ListTile(
            //                       dense: true,
            //                     contentPadding: EdgeInsets.all(0),
            //                     leading: Text(" ${index+1}."),
            //                     title: Text("Patel"),
            //
            //                   ),
            //                 ))),
            //           ),
            //         );
            //       }
            //   ),
            // ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Keywords').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<DocumentSnapshot> documents = snapshot.data!.docs;

                print("documents : ${documents}");
                // print("documents : ${documents.first}");
                return Expanded(
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, i) {
                      Map<String, dynamic> keywordData = documents[i].data() as Map<String, dynamic>;

                      print("keywordData : ${keywordData}");
                      // print("documents[i].id : ${documents[i].id}");


                      var key = keywordData['Key'];
                      List<dynamic> values = keywordData['Values'];

                      print("key : $key");
                      // return ListTile(
                      //   title: Text(key),
                      //   subtitle: Text('Values: $values'),
                      // );
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: ExpansionTile(
                          onExpansionChanged: (value) {
                            print("documentIds[i]: ${documents[i].id}");
                          },
                          trailing: PopupMenuButton(
                              itemBuilder: (itemBuilder)=>[
                                PopupMenuItem(
                                  child: Text("Edit"),
                                  value: 1,
                                  onTap: (){
                                    showEditThriverDialogBox(context,documents[i].id, key, values);
                                  },
                                ),
                                PopupMenuItem(
                                  child: Text("Delete"),
                                  value: 2,
                                  onTap: (){
                                    addKeywordProvider.deleteKeyword(context,documents[i].id);
                                  },
                                ),
                              ]
                          ),

                          backgroundColor: Colors.black12,
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.blue,)
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.cyan)
                          ),
                          title: Text(key),
                          leading: Text("${i+1}."),
                          children: List.generate(values.length, (index) =>
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.all(0),
                                      leading: Text(" ${index+1}."),
                                      title: Text("${values[index]}"),

                                    ),
                                  ))),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            // Expanded(child: DSemo())
          ],
        ),
      ),
    );
  }
  void showAddThriverDialogBox(cox) {

    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
      return Consumer<AddKeywordProvider>(
          builder: (c,addKeywordProvider, _){
        return Theme(
        data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
        child: AlertDialog(
          // insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery
          //     .of(context)
          //     .size
          //     .width * 0.2),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    addcategory.clear();
                    addkeywords.clear();
                    Navigator.pop(context);
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
                SizedBox(height: 5, width: 5,),
                InkWell(
                  onTap: () async {
                    addKeywordProvider.addKeyword(cox,addcategory.text.toString(), addKeywordProvider.chips);
                    addcategory.clear();
                    addKeywordProvider.chips.clear();
                    Navigator.pop(context);
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
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Add Keywords",
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                        color: Colors.black)),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        // maxLines: null,
                        controller: addcategory,
                        //cursorColor: primaryColorOfApp,
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
                          labelText: "Add Category",
                          hintText: "Add Category",
                          /*prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.question_mark_outlined,
                                  //color: primaryColorOfApp
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: addkeywords,
                        onSubmitted: (text) {
                          addKeywordProvider.addChip(addkeywords.text.toString());
                          addkeywords.clear();
                        },                  // cursorColor: primaryColorOfApp,
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
                          labelText: "Add Keywords",
                          hintText: "Add Keywords",
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
                                        addKeywordProvider.remove(item);
                                        // setState(() {
                                        // addKeywordProvider.chips.remove(item);
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
                  ]
              ),
            ),
          ),
        ),
      );
          }
      );
        }
    );
  }

  void showEditThriverDialogBox(cox, Id, key, values) async {

    editcategorycontroller.text = key;

    List<TextEditingController> textControllers = [];
    for(int i=0;i<6;i++){
      textControllers.add(TextEditingController());
    }
    showDialog(

        context: context,
        builder: (BuildContext context) {
      return Consumer<AddKeywordProvider>(
          builder: (c,addKeywordProvider, _){
            addKeywordProvider.editkeywords = values;
            return Theme(
        data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
        child: AlertDialog(
          // insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery
          //     .of(context)
          //     .size
          //     .width * 0.2),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    editcategorycontroller.clear();
                    editkeywordscontroller.clear();
                    Navigator.pop(context);
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
                    addKeywordProvider.updateKeyword(cox,Id,editcategorycontroller.text.toString(), addKeywordProvider.editkeywords);
                    editcategorycontroller.clear();
                    addKeywordProvider.editkeywords.clear();
                    Navigator.pop(context);
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Edit Keywords",
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                        color: Colors.black)),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: null,
                        controller: editcategorycontroller,
                        //cursorColor: primaryColorOfApp,
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
                          labelText: "Add Category",
                          hintText: "Add Category",
                          /*prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.question_mark_outlined,
                                  //color: primaryColorOfApp
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: editkeywordscontroller,
                        onSubmitted: (text) {
                          addKeywordProvider.editaddKeywords(editkeywordscontroller.text.toString());
                          editkeywordscontroller.clear();
                        },                  // cursorColor: primaryColorOfApp,
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
                          labelText: "Add Keywords",
                          hintText: "Add Keywords",
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
                          children: addKeywordProvider.editkeywords.map((item){
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
                                        addKeywordProvider.editremovekeywords(item);
                                        // setState(() {
                                        // addKeywordProvider.chips.remove(item);
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
                  ]
              ),
            ),
          ),
        ),
      );
          }
      );
        }
    );
  }
}

