import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';
class AdminUserSettingScreen extends StatefulWidget {
  const AdminUserSettingScreen({super.key});

  @override
  State<AdminUserSettingScreen> createState() => _AdminUserSettingScreenState();
}

class _AdminUserSettingScreenState extends State<AdminUserSettingScreen> {

  TextEditingController editadminusernameTextEditingController = TextEditingController();
  TextEditingController editadminpasswordTextEditingController = TextEditingController();
  TextEditingController newAdminUsertextEditingController = TextEditingController();
  TextEditingController newAdminPasswordtextEditingController = TextEditingController();

  bool _isLoadingMore = false;
  int _perPage = 10;
  int _currentPage = 1;

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('AdminDetails');

  List<DocumentSnapshot> documents = [];


  void _loadDataForPage(int page) {
    int startIndex = (page - 1) * _perPage;

    _isLoadingMore = true;

    usersCollection
        .limit(_perPage)
        .get()
        .then((QuerySnapshot querySnapshot) {
          print("querySnapshot: $querySnapshot");
      setState(() {
        documents.clear();
        documents.addAll(querySnapshot.docs);
        _isLoadingMore = false;
      });
    }).catchError((error) {
      print('Error loading data for page $page: $error');
      setState(() {
        _isLoadingMore = false;
      });
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadDataForPage(_currentPage);
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
            child: Wrap(
              children: [
                HeaderWidget(),
                Container(
                  height: MediaQuery.of(context).size.height * .65,
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        // child: Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Container(
                        //       width: MediaQuery.of(context).size.width*0.2,
                        //       child:Row(
                        //         children: [
                        //           SizedBox(width: 10,),
                        //           // Text(thriversDetails.id,style: Theme.of(context).textTheme.bodySmall),
                        //           Text("Sr.NO.",style: Theme.of(context).textTheme.titleMedium),
                        //           // Text("${thriversDetails['id']}",style: Theme.of(context).textTheme.bodySmall),
                        //           SizedBox(width: 20,),
                        //           Expanded(
                        //             child: Column(
                        //               mainAxisSize: MainAxisSize.min,
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //
                        //                 Text("Label & Description",style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis),
                        //
                        //                 // SizedBox(height: 10),
                        //
                        //
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     SizedBox(width: 50),
                        //
                        //
                        //     Container(
                        //       width: MediaQuery.of(context).size.width*0.3,
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text("Original Description",style: Theme.of(context).textTheme.titleMedium),
                        //         ],
                        //       ),
                        //     ),
                        //     Column(
                        //         children:[
                        //           Container(
                        //             width: MediaQuery.of(context).size.width*0.33,
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 // Padding(
                        //                 //   padding: const EdgeInsets.symmetric(vertical: 2.0),
                        //                 //   child: Icon(Icons.tag,size: 16,),
                        //                 // ),
                        //                 // SizedBox(width: 5,),
                        //                 // Expanded(child: Text(keys.toString(),style: Theme.of(context).textTheme.bodySmall, )),
                        //                 Expanded(
                        //                   child: Text('Category & Tags',style: Theme.of(context).textTheme.titleMedium,),
                        //                 ),
                        //                 // Expanded(child: Text("No Country",style: Theme.of(context).textTheme.bodySmall,overflow: TextOverflow.ellipsis,)),
                        //                 // SizedBox(width: 10,),
                        //               ],
                        //             ),
                        //           ),
                        //
                        //           SizedBox(height: 10,),
                        //
                        //         ]
                        //     ),
                        //
                        //
                        //   ],
                        // ),
                        child: ListTile(
                          leading: Text("NO.",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 90,),

                              Text("Admin User", style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(width: 150,),

                              // Text("Email", style: Theme.of(context).textTheme.titleLarge,),
                            ],
                          ),
                          trailing:  Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 50,),
                              IconButton(
                                  iconSize: 25,
                                  color: primaryColorOfApp,
                                  onPressed: () async {
                                    showAddNewAdminDialogBox();
                                  },
                                  icon: Icon(Icons.add,size: 30,)),
                              SizedBox(width: 50,),
                            ],
                          ),
                        ),
                      ),
                      Divider(color: Colors.black,),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                                     ListView.separated(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      physics: NeverScrollableScrollPhysics(), // Disable scrolling
                                      shrinkWrap: true,
                                      itemCount: documents.length,
                                      separatorBuilder: (BuildContext context, int index) {
                                        return Divider();
                                      },
                                      itemBuilder: (BuildContext context, int index) {

                                        print("objecttttt: $documents");
                                        Map<String, dynamic> userData = documents[index].data() as Map<String, dynamic>;

                                        // Access user data fields (adjust field names based on your schema)
                                        String userName = userData['adminusername'];
                                        String password = userData['adminpassword'];

                                        return ListTile(
                                          leading: Text("${index+1}.",
                                            style: Theme.of(context).textTheme.titleSmall,
                                          ),
                                          title: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 100,),

                                              Text(userName, style: Theme.of(context).textTheme.titleMedium,
                                              ),
                                              SizedBox(width: 100,),

                                              // Text(userEmail, style: Theme.of(context).textTheme.titleMedium,),
                                            ],
                                          ),
                                          trailing:  Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  iconSize: 25,
                                                  color: primaryColorOfApp,
                                                  onPressed: () async {
                                                    showEditAdminDetailsDialogBox(documents[index].reference,documents[index].id, userName, password);
                                                  },
                                                  icon: Icon(Icons.edit,)),
                                              SizedBox(width: 20,),
                                              IconButton(
                                                  iconSize: 25,
                                                  color: primaryColorOfApp,
                                                  onPressed: () async {
                                                    ProgressDialog.show(context, "Deleting Users",Icons.person);
                                                    await ApiRepository().DeleteSectionPreset(documents[index].reference);
                                                    _loadDataForPage(1);
                                                    ProgressDialog.hide();
                                                  },
                                                  icon: Icon(Icons.delete,)),
                                              SizedBox(width: 20,),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        )
    );
  }

  HeaderWidget() {
    return Container(
      padding: EdgeInsets.all(10.0),
      //color: Colors.deepPurple, // Change the color to your desired background color
      child: Text(
        'Admin User Settings',
        style: TextStyle(
          color: Colors.black, // Change the text color to your desired color
          fontSize: 24.0, // Adjust the font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<DocumentSnapshot> fetchDetails(DocumentReference docRef) async {
    return await docRef.get();
  }

  void showEditAdminDetailsDialogBox(documentReference,Id, adminName, password) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
            child: AlertDialog(
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
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
                          ProgressDialog.show(context, "Update a Thriver", Icons.update);
                          await ApiRepository().updateAdminSettings({
                            "adminusername": editadminusernameTextEditingController.text,
                            "adminpassword": editadminpasswordTextEditingController.text,
                            /// Add more fields as needed
                          }, Id);
                          _loadDataForPage(1);
                          Navigator.pop(context);
                          ProgressDialog.hide();

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
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Edit Admin Details",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                    SizedBox(height: 5,width: 5,),
                  ],
                ),
                content:   SizedBox(
                    width: double.maxFinite,
                    child:  StatefulBuilder(
                        builder: (context,innerState) {
                          return FutureBuilder(
                              future: fetchDetails(documentReference),
                              builder: (ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Text(
                                        snapshot.error.toString(),
                                        style: GoogleFonts.montserrat(
                                            textStyle:
                                            Theme.of(context).textTheme.bodyLarge,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black)
                                    );
                                  }
                                  else if (snapshot.hasData) {
                                    DocumentSnapshot? doc = snapshot.data;

                                    editadminusernameTextEditingController.text = doc?.get("adminusername");
                                    editadminpasswordTextEditingController.text = doc?.get("adminpassword");


                                    return SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[

                                            SizedBox(height: 10,),

                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
                                                maxLines: null,
                                                controller: editadminusernameTextEditingController,
                                                cursorColor: primaryColorOfApp,

                                                // readOnly: readonly,
                                                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                                  labelText: "Admin Username",
                                                  hintText: "Admin Username",
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
                                              /// Final Description
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
                                                // maxLines: null,
                                                maxLines: null,
                                                controller: editadminpasswordTextEditingController,
                                                // cursorColor: primaryColorOfApp,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                                                ],
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
                                                  labelText: "Admin Password",
                                                  hintText: "Admin Password",
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



                                          ]
                                      ),
                                    );
                                  }
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColorOfApp,
                                  ),
                                );
                              });
                        })
                )
            ),
          );
          // });
        }
    );
  }


  void showAddNewAdminDialogBox() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
                  data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
                  child: AlertDialog(
                    insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery
                        .of(context)
                        .size
                        .width * 0.08),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              newAdminUsertextEditingController.clear();
                              newAdminPasswordtextEditingController.clear();
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
                          SizedBox(width: 5, height: 5,),
                          InkWell(
                            onTap: () async {
                              ////ApiRepository().updateSecurityPINFor(userAccountId,newPinTextEditingController.text);

                              // print('createdAt: $createdAt');

                              ProgressDialog.show(context, "Adding New Admin", Icons.chair);
                              await ApiRepository().addNewAdmin({
                                "adminusername": newAdminUsertextEditingController.text,
                                "adminpassword": newAdminPasswordtextEditingController.text,
                              }
                              );
                              _loadDataForPage(1);
                              ProgressDialog.hide();
                              newAdminUsertextEditingController.clear();
                              newAdminPasswordtextEditingController.clear();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * .3,
                              padding: EdgeInsets.symmetric(horizontal: 15),
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

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text("Add New Admin",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ),
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


                              SizedBox(height: 10,),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                            maxLines: null,
                                            controller: newAdminUsertextEditingController,
                                            cursorColor: primaryColorOfApp,

                                            // readOnly: readonly,
                                            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                              labelText: "Admin Name",
                                              hintText: "Admin Name",


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


                                /// Final Description
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  maxLines: null,
                                  // maxLines: 2,
                                  controller: newAdminPasswordtextEditingController,
                                  // cursorColor: primaryColorOfApp,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(r'"')), // Disallow double quotes
                                  ],
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
                                    labelText: "Admin Password",
                                    hintText: "Admin Password",


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




                            ]
                        ),
                      ),
                    ),
                  ),
                );

        }
    );
  }

}
