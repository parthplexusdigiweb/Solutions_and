import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';
class UserListScreenForAdmin extends StatefulWidget {
  const UserListScreenForAdmin({super.key});

  @override
  State<UserListScreenForAdmin> createState() => _UserListScreenForAdminState();
}

class _UserListScreenForAdminState extends State<UserListScreenForAdmin> {

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');

  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10,),
                            Container(
                                child: Text("NO.",style: Theme.of(context).textTheme.titleLarge,)),
                            SizedBox(width: 20,),

                            Expanded(
                              flex: 1,
                              child: Container(
                                  child: Text("User Name",style: Theme.of(context).textTheme.titleLarge,overflow: TextOverflow.ellipsis)),
                            ),
                            SizedBox(width: 20),


                            Expanded(
                              flex: 3,
                              child: Container(
                                  child: Text("Email",style: Theme.of(context).textTheme.titleLarge)),
                            ),


                            Expanded(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    SizedBox(width: 20),
                                  ],
                                ),
                              ),
                            ),


                          ],
                        ),
                        // child: ListTile(
                        //   leading: Text("SR NO.",
                        //     style: Theme.of(context).textTheme.titleLarge,
                        //   ),
                        //   title: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       SizedBox(width: 50,),
                        //
                        //       Text("User Name", style: Theme.of(context).textTheme.titleLarge,
                        //       ),
                        //       SizedBox(width: 150,),
                        //
                        //       Text("Email", style: Theme.of(context).textTheme.titleLarge,),
                        //     ],
                        //   ),
                        //   trailing:  Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       SizedBox(width: 50,),
                        //       SizedBox(width: 50,),
                        //     ],
                        //   ),
                        // ),
                      ),
                      Divider(color: Colors.black,),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              FutureBuilder<QuerySnapshot>(
                                future: usersCollection.get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    List<QueryDocumentSnapshot> users = snapshot.data!.docs;

                                    print("users: ${users}");
                                    // return ListView.builder(
                                    //   itemCount: users.length,
                                    //   itemBuilder: (context, index) {
                                    //     Map<String, dynamic> userData = users[index].data() as Map<String, dynamic>;
                                    //
                                    //     // Access user data fields (adjust field names based on your schema)
                                    //     String userName = userData['name'];
                                    //     String userEmail = userData['email'];
                                    //
                                    //     return ListTile(
                                    //       title: Text(userName),
                                    //       subtitle: Text(userEmail),
                                    //     );
                                    //   },
                                    // );

                                    return ListView.separated(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      physics: NeverScrollableScrollPhysics(), // Disable scrolling
                                      shrinkWrap: true,
                                      itemCount: users.length,
                                      separatorBuilder: (BuildContext context, int index) {
                                        return Divider();
                                      },
                                      itemBuilder: (BuildContext context, int index) {
                                        Map<String, dynamic> userData = users[index].data() as Map<String, dynamic>;

                                        // Access user data fields (adjust field names based on your schema)
                                        String userName = userData['UserName'];
                                        String userEmail = userData['email'];

                                        // print("users[index] : ${users[index].id}");


                                        return Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(width: 10),

                                              Container(
                                                width: 30,
                                                child: Text("${index+1}.",
                                                  style: Theme.of(context).textTheme.titleSmall,
                                                ),
                                              ),

                                              SizedBox(width: 20),


                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: Text(userName, style: Theme.of(context).textTheme.titleMedium,
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 20,),

                                              Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                      child: Text(userEmail, style: Theme.of(context).textTheme.titleMedium,))),

                                              Expanded(
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    mainAxisSize: MainAxisSize.min,

                                                    children: [
                                                      IconButton(
                                                          iconSize: 25,
                                                          color: primaryColorOfApp,
                                                          onPressed: () async {
                                                            print("users[index]: ${users[index].id}");
                                                            ProgressDialog.show(context, "Deleting Users",Icons.person);
                                                            // await ApiRepository().deleteUserData(users[index].reference, users[index].id);
                                                            setState(() {
                                                               ApiRepository().DeleteSectionPreset(users[index].reference);
                                                            });
                                                            ProgressDialog.hide();
                                                          },
                                                          icon: Icon(Icons.delete,)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                        );
                                      },
                                    );
                                  }
                                },
                              ),
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
        'User`s List',
        style: TextStyle(
          color: Colors.black, // Change the text color to your desired color
          fontSize: 24.0, // Adjust the font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
