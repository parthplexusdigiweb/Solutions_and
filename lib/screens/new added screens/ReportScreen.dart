import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('AboutMe');

  List SolutionReport = [];
  List ChallengesReport = [];

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

                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .75,
                      width: MediaQuery.of(context).size.width * .35,
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

                            child: ListTile(
                              leading: Text("",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(width: 120,child: Text("Employer", style: Theme.of(context).textTheme.titleMedium,)),

                                  Container(width: 200,child: Center(child: Text("Challenges", style: Theme.of(context).textTheme.titleMedium,))),

                                  Container(width: 200,child: Center(child: Text("Solutions", style: Theme.of(context).textTheme.titleMedium,))),

                                  // Container(width: 200,child: Text("Challenges", style: Theme.of(context).textTheme.titleMedium,)),
                                ],
                              ),
                            ),
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

                                            var Employer = userData['Employer'];
                                            var Solutions = userData['Solutions'];
                                            var Challenges = userData['Challenges'];


                                            return ListTile(
                                              leading: Text("${index+1}.",
                                                style: Theme.of(context).textTheme.titleSmall,
                                              ),
                                              title: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [

                                                  Container(width: 120,child: Text(Employer, style: Theme.of(context).textTheme.titleMedium,)),

                                                  // Container(width: 200,child: Text("${Challenges.length}", style: Theme.of(context).textTheme.titleMedium,)),
                                                  //
                                                  // Container(width: 200,child: Text("${Solutions.length}", style: Theme.of(context).textTheme.titleMedium,)),

                                                  Container(
                                                      width: 210,
                                                      child: ExpansionTile(
                                                    controller: ExpansionTileController(),
                                                        title: Row(
                                                      children: [
                                                        Text("Challenges"),
                                                        SizedBox(width: 10,),
                                                        Text("(${Challenges.length})"),
                                                      ],
                                                    ),
                                                  children: List.generate(Challenges.length, (index) {
                                                    return Container(
                                                      margin: EdgeInsets.symmetric(vertical: 10),
                                                        // padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.blue)),
                                                        child: ListTile(title: Text("CH${Challenges[index]['id']}")));
                                                  }),
                                                  )),

                                                  SizedBox(width: 10,),

                                                  Container(width: 200,child: ExpansionTile(
                                                    controller: ExpansionTileController(),
                                                    title: Row(
                                                      children: [
                                                        Text("Solutions"),
                                                        SizedBox(width: 10,),
                                                        Text("(${Solutions.length})"),
                                                        // Text("(${solutionIdCounts.length})"), // Display the count of unique ids
                                                      ],
                                                    ),
                                                  children: List.generate(Solutions.length, (index) {
                                                    return Container(
                                                      margin: EdgeInsets.symmetric(vertical: 10),
                                                        // padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.blue)),
                                                        child: ListTile(
                                                            title: Text("SH${Solutions[index]['id']}"),
                                                        ));
                                                  }),
                                                  )),

                                                ],
                                              ),
                                            );
                                          },
                                        );

                                       // return Container(
                                       //    height: MediaQuery.of(context).size.height *.65,
                                       //    child: ListView.builder(
                                       //        itemCount:users.length ,
                                       //        // shrinkWrap: true,
                                       //        // physics: AlwaysScrollableScrollPhysics(),
                                       //        itemBuilder: (c,i){
                                       //          print(users[i]['Solutions']);
                                       //          int overallIndex = 0;
                                       //          for (int j = 0; j < i; j++) {
                                       //            overallIndex += (users[j]['Solutions'] as List).length;
                                       //          }
                                       //
                                       //          return Column(
                                       //            children: List.generate(
                                       //              users[i]['Solutions'].length,
                                       //                  (index) {
                                       //                overallIndex++;
                                       //                return Column(
                                       //                  children: [
                                       //                    Container(
                                       //                      padding: EdgeInsets.all(10),
                                       //                      child: Row(
                                       //                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       //                        crossAxisAlignment: CrossAxisAlignment.start,
                                       //                        children: [
                                       //                          Container(
                                       //                              width: 50,
                                       //                              child: Center(child: Text("${overallIndex}."))),
                                       //                          Container(
                                       //                              width: 120,
                                       //                              child: Center(child: Text("AB0${users[i]['AB_id'].toString()}",style: Theme.of(context).textTheme.bodySmall))),
                                       //                          // child: Center(child: Text("AB01")))),
                                       //                          Container(
                                       //                              width: 80,
                                       //                              child: Center(child: Text(users[i]['Solutions'][index]['id'].toString(), style: Theme.of(context).textTheme.bodySmall))),
                                       //                          Container(
                                       //                              width: 160,
                                       //                              // child: Center(child: Text(users[index]['User_Name'].toString())))),
                                       //                              child: Center(child: Text(users[i]['User_Name'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                                       //                          Container(
                                       //                              width: 250,
                                       //                              child: Center(child: Text(users[i]['Solutions'][index]['Label'].toString(),style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis))),
                                       //                          Container(
                                       //                              width: 400,
                                       //                              height: 80,
                                       //                              child: Center(child: Text(users[i]['Solutions'][index]['Description'].toString()))),
                                       //
                                       //                          Container(
                                       //                              width: 160,
                                       //                              child: Center(child: Text(users[i]['Solutions'][index]['Notes'].toString()))),
                                       //
                                       //                          Container(
                                       //                              width: 120,
                                       //                              child: Center(child: Text(users[i]['Solutions'][index]['Attachment'].toString()))),
                                       //                          Container(
                                       //                              width: 120,
                                       //                              child: Center(child: Text(users[i]['Solutions'][index]['Provider'].toString(),style: Theme.of(context).textTheme.titleMedium))),
                                       //                          Container(
                                       //                              width: 80,
                                       //                              child: Center(child: Text(users[i]['Solutions'][index]['InPlace'].toString(),style: Theme.of(context).textTheme.titleMedium))),
                                       //                          Container(
                                       //                              width: 160,
                                       //                              child: Center(child: Text(users[i]['Solutions'][index]['Priority'].toString(),style: Theme.of(context).textTheme.titleMedium))),
                                       //                        ],
                                       //                      ),
                                       //                    ),
                                       //                    Divider(),
                                       //                  ],
                                       //                );
                                       //              },
                                       //            ),
                                       //          );
                                       //
                                       //        }),
                                       //  );

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
                    Container(
                      height: MediaQuery.of(context).size.height * .75,
                      width: MediaQuery.of(context).size.width * .27,
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

                            child: ListTile(
                              leading: Text("",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Container(width: 120,child: Text("Solutions Id", style: Theme.of(context).textTheme.titleMedium,)),

                                  // Container(width: 200,child: Text("Challenges", style: Theme.of(context).textTheme.titleMedium,)),

                                  Container(width: 140,child: Text("Solutions Used", style: Theme.of(context).textTheme.titleMedium,)),

                                  Container(width: 120,child: Text("Employer", style: Theme.of(context).textTheme.titleMedium,)),

                                ],
                              ),
                            ),
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

                                        print("users: $users");

                                        var ab;

                                        for(var i in users){
                                          i["Solutions"];
                                          SolutionReport.addAll(i["Solutions"]);
                                          ChallengesReport.addAll(i["Challenges"]);
                                          print("Challenges: $ChallengesReport");
                                          print("Report: $SolutionReport");
                                          print("Challenges.length: ${ChallengesReport.length}");
                                          print("Report.length: ${SolutionReport.length}");
                                        }

                                        Map<dynamic, dynamic> idCounts = {};

                                        // Map<dynamic, int> idCounts = {};

// Iterate over all users
                                        for (var user in users) {
                                          var Employer = user['Employer'];
                                          var Solutions = user['Solutions'];

                                          // Count occurrences of each id in Solutions list for this user
                                          Set<dynamic> uniqueIds = Solutions.map<dynamic>((solution) => solution['id']).toSet();
                                          for (var id in uniqueIds) {
                                            idCounts[id] = (idCounts[id] ?? 0) + 1;
                                          }
                                        }

                                        return ListView.separated(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          physics: NeverScrollableScrollPhysics(), // Disable scrolling
                                          shrinkWrap: true,
                                          itemCount: idCounts.length,
                                          separatorBuilder: (BuildContext context, int index) {
                                            return Divider();
                                          },
                                          itemBuilder: (BuildContext context, int index) {
                                            var id = idCounts.keys.elementAt(index);
                                            var count = idCounts[id]!;

                                            // Retrieve the employers associated with this id
                                            List<String> employers = [];
                                            for (var user in users) {
                                              var Employer = user['Employer'];
                                              var Solutions = user['Solutions'];

                                              // Check if this user's Solutions list contains the current id
                                              if (Solutions.any((solution) => solution['id'] == id)) {
                                                employers.add(Employer);
                                              }
                                            }

                                            return ListTile(
                                              leading: Text("${index + 1}.",
                                                style: Theme.of(context).textTheme.titleSmall,
                                              ),
                                              title: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(width: 160, child: Text("SH$id", style: Theme.of(context).textTheme.titleMedium,)),
                                                  Container(width: 120, child: Text("$count", style: Theme.of(context).textTheme.titleMedium,)),
                                                  Container(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: employers.map((employer) => Text("$employer")).toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );


                                        // return ListView.separated(
                                        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        //   physics: NeverScrollableScrollPhysics(), // Disable scrolling
                                        //   shrinkWrap: true,
                                        //   itemCount: SolutionReport.length,
                                        //   separatorBuilder: (BuildContext context, int index) {
                                        //     return Divider();
                                        //   },
                                        //   itemBuilder: (BuildContext context, int index) {
                                        //
                                        //
                                        //     var Employer = SolutionReport[index]['id'];
                                        //     var Solutions = SolutionReport[index]['id'];
                                        //     var Challenges = ChallengesReport[index]['id'];
                                        //
                                        //     // for(var i in userData){
                                        //     //   Employer = i['id'];
                                        //     //   Solutions = i['id'];
                                        //     //   Challenges = i['id'];
                                        //     // }
                                        //
                                        //     print("userData: $Employer");
                                        //
                                        //     // for(var i in userEmail){
                                        //     //   id = i["id"];
                                        //     //   print("id of solution: ${id}");
                                        //     // }
                                        //
                                        //     return ListTile(
                                        //       leading: Text("${index+1}.",
                                        //         style: Theme.of(context).textTheme.titleSmall,
                                        //       ),
                                        //       title: Row(
                                        //         mainAxisAlignment: MainAxisAlignment.start,
                                        //         children: [
                                        //
                                        //           Container(width: 200,child: Text("${Employer}", style: Theme.of(context).textTheme.titleMedium,)),
                                        //
                                        //           Container(width: 200,child: Center(child: Text("CH0${Challenges}", style: Theme.of(context).textTheme.titleMedium,))),
                                        //
                                        //           Container(width: 200,child: Center(child: Text("SH0${Solutions}", style: Theme.of(context).textTheme.titleMedium,))),
                                        //         ],
                                        //       ),
                                        //     );
                                        //   },
                                        // );

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
                    Container(
                      height: MediaQuery.of(context).size.height * .75,
                      width: MediaQuery.of(context).size.width * .27,
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

                            child: ListTile(
                              leading: Text("",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Container(width: 120,child: Text("Challenges Id", style: Theme.of(context).textTheme.titleMedium,)),

                                  // Container(width: 200,child: Text("Challenges", style: Theme.of(context).textTheme.titleMedium,)),

                                  Container(width: 140,child: Text("Challenges Used", style: Theme.of(context).textTheme.titleMedium,)),

                                  Container(width: 120,child: Center(child: Text("Employer", style: Theme.of(context).textTheme.titleMedium,))),

                                ],
                              ),
                            ),
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

                                        print("users: $users");

                                        var ab;

                                        for(var i in users){
                                          i["Solutions"];
                                          SolutionReport.addAll(i["Solutions"]);
                                          ChallengesReport.addAll(i["Challenges"]);
                                          print("Challenges: $ChallengesReport");
                                          print("Report: $SolutionReport");
                                          print("Challenges.length: ${ChallengesReport.length}");
                                          print("Report.length: ${SolutionReport.length}");
                                        }

                                        Map<dynamic, dynamic> idCounts = {};


                                        for (var user in users) {
                                          var Employer = user['Employer'];
                                          var Challenges = user['Challenges'];

                                          // Count occurrences of each id in Solutions list for this user
                                          Set<dynamic> uniqueIds = Challenges.map<dynamic>((solution) => solution['id']).toSet();
                                          for (var id in uniqueIds) {
                                            idCounts[id] = (idCounts[id] ?? 0) + 1;
                                          }
                                        }

                                        return ListView.separated(
                                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          physics: NeverScrollableScrollPhysics(), // Disable scrolling
                                          shrinkWrap: true,
                                          itemCount: idCounts.length,
                                          separatorBuilder: (BuildContext context, int index) {
                                            return Divider();
                                          },
                                          itemBuilder: (BuildContext context, int index) {
                                            var id = idCounts.keys.elementAt(index);
                                            var count = idCounts[id]!;

                                            // Retrieve the employers associated with this id
                                            List<String> employers = [];
                                            for (var user in users) {
                                              var Employer = user['Employer'];
                                              var Challenges = user['Challenges'];

                                              // Check if this user's Solutions list contains the current id
                                              if (Challenges.any((solution) => solution['id'] == id)) {
                                                employers.add(Employer);
                                              }
                                            }

                                            return ListTile(
                                              leading: Text("${index + 1}.",
                                                style: Theme.of(context).textTheme.titleSmall,
                                              ),
                                              title: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  // Display id and count
                                                  Container(width: 160, child: Text("CH$id", style: Theme.of(context).textTheme.titleMedium,)),
                                                  Container(width: 80, child: Text("$count", style: Theme.of(context).textTheme.titleMedium,)),
                                                  // Container(
                                                  //   width: 120,
                                                  //   child: Column(
                                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                                  //     children: employers.map((employer) => Text("$employer")).toList(),
                                                  //   ),
                                                  // ),

                                                  Container(width: 160,child: Center(
                                                    child: ExpansionTile(
                                                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                                      title: Text("Employer"),
                                                      children:  employers.map((employer) => Container(

                                                          child: Text("$employer"))).toList()

                                                    ),
                                                  )),


                                                  // Display associated employers
                                                ],
                                              ),
                                            );
                                          },
                                        );


                                        // return ListView.separated(
                                        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        //   physics: NeverScrollableScrollPhysics(), // Disable scrolling
                                        //   shrinkWrap: true,
                                        //   itemCount: SolutionReport.length,
                                        //   separatorBuilder: (BuildContext context, int index) {
                                        //     return Divider();
                                        //   },
                                        //   itemBuilder: (BuildContext context, int index) {
                                        //
                                        //
                                        //     var Employer = SolutionReport[index]['id'];
                                        //     var Solutions = SolutionReport[index]['id'];
                                        //     var Challenges = ChallengesReport[index]['id'];
                                        //
                                        //     // for(var i in userData){
                                        //     //   Employer = i['id'];
                                        //     //   Solutions = i['id'];
                                        //     //   Challenges = i['id'];
                                        //     // }
                                        //
                                        //     print("userData: $Employer");
                                        //
                                        //     // for(var i in userEmail){
                                        //     //   id = i["id"];
                                        //     //   print("id of solution: ${id}");
                                        //     // }
                                        //
                                        //     return ListTile(
                                        //       leading: Text("${index+1}.",
                                        //         style: Theme.of(context).textTheme.titleSmall,
                                        //       ),
                                        //       title: Row(
                                        //         mainAxisAlignment: MainAxisAlignment.start,
                                        //         children: [
                                        //
                                        //           Container(width: 200,child: Text("${Employer}", style: Theme.of(context).textTheme.titleMedium,)),
                                        //
                                        //           Container(width: 200,child: Center(child: Text("CH0${Challenges}", style: Theme.of(context).textTheme.titleMedium,))),
                                        //
                                        //           Container(width: 200,child: Center(child: Text("SH0${Solutions}", style: Theme.of(context).textTheme.titleMedium,))),
                                        //         ],
                                        //       ),
                                        //     );
                                        //   },
                                        // );



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
                ),
              ],
            )
        )
    );
  }

  ExpansionTileController controller = ExpansionTileController();

  HeaderWidget(){
    return Container(
      padding: EdgeInsets.all(10.0),
      //color: Colors.deepPurple, // Change the color to your desired background color
      child: Text(
        'Report',
        style: TextStyle(
          color: Colors.black, // Change the text color to your desired color
          fontSize: 24.0, // Adjust the font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}
