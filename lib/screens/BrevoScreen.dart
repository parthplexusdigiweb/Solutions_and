import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/Network/FirebaseApi.dart';

import '../core/constants.dart';
import '../core/progress_dialog.dart';

class BrevoScreen extends StatefulWidget {
  const BrevoScreen({Key? key}) : super(key: key);

  @override
  State<BrevoScreen> createState() => _BrevoScreenState();
}

class _BrevoScreenState extends State<BrevoScreen> {

  TextEditingController brevoApiKeyTextEditingController = TextEditingController();

  String? nameErrorText;

  late Future<String> brevoApiFuture;

  HeaderWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      //color: Colors.deepPurple, // Change the color to your desired background color
      child: Text(
        'Brevo',
        style: TextStyle(
          color: Colors.black, // Change the text color to your desired color
          fontSize: 24.0, // Adjust the font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void initState() {
    brevoApiFuture = ApiRepository().getBrevoApiKey();
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

        child :FutureBuilder<String>(
          builder: (ctx, snapshot) {
            // Checking if future is resolved or not
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                print("Aapko Error Aaya hai");
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                // Extracting data from snapshot object
                final data = snapshot.data;


                brevoApiKeyTextEditingController.text = data!;




                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: SizedBox(
                        child: TextField(
                          controller: brevoApiKeyTextEditingController,
                          cursorColor: primaryColorOfApp,
                          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            //errorText: userAccountSearchErrorText,
                            errorText: nameErrorText,
                            contentPadding: EdgeInsets.all(25),
                            labelText: "Change API Key",
                            hintText: "Change API Key",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.key),
                            ),
                            errorStyle: GoogleFonts.montserrat(
                                textStyle: Theme.of(context).textTheme.bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.redAccent),

                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10)),
                            //hintText: "e.g Abouzied",
                            labelStyle: GoogleFonts.poppins(
                                textStyle: Theme.of(context).textTheme.bodyLarge,
                                fontWeight: FontWeight.w400,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.all(20),
                      child: InkWell(
                        onTap: () async {
                          ////ApiRepository().updateSecurityPINFor(userAccountId,newPinTextEditingController.text);

                          ProgressDialog.show(context, "Updating API key\nfor Brevo", Icons.key);
                          DocumentReference documentReference = FirebaseFirestore.instance.collection('Brevo').doc("4u6D48cqxOelszc3vg5i");

                          // Perform the update operation
                          await documentReference.update({
                            'APIKey': brevoApiKeyTextEditingController.text,
                            // Add more fields if needed
                          });
                          ProgressDialog.hide();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 200,
                          height: 60,
                          decoration: BoxDecoration(
                            color:Colors.blue,
                            border: Border.all(
                                color:Colors.blue,
                                width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              'Update',
                              style: GoogleFonts.montserrat(
                                  textStyle:
                                  Theme.of(context).textTheme.titleSmall,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),

                      ),
                    ),

                  ],
                );

                /* return Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.settings,color: primaryColorOfApp,size: 60,),
                            Padding(padding: const EdgeInsets.all(8.0),child: Text("Settings",style: GoogleFonts.poppins(textStyle: Theme.of(context).textTheme.titleLarge,fontWeight:FontWeight.bold,color: primaryColorOfApp)),),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                    border: Border.all(color: primaryColorOfApp),
                    borderRadius: BorderRadius.circular(10)
                  ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("You have ,"),
                                  Container(

                                    child: Text("${data!["Credits"]} Credits",style: TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 2,),
                                  ),

                                ],
                              ),
                              SizedBox(width: 20,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Do You Want to Add More Credits ?",textScaleFactor: 0.7,),
                                  SizedBox(height: 5,),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                      ),
                                      onPressed: (){

                                      }, child: Text("Add Credits"))
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:20.0),
                          child: Divider(height: 2,color: Colors.black,),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Change User Name"),
                        ),
                        SizedBox(
                          child: TextField(
                            controller: userNameTextEditingController,
                            cursorColor: primaryColorOfApp,
                             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                            onChanged: (value) {

                            },
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                            ),
                            decoration: InputDecoration(
                              //errorText: userAccountSearchErrorText,
                              contentPadding: EdgeInsets.all(25),
                              labelText: "Change User Name",
                              hintText: "Change User Name",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.person_outline_outlined),
                              ),
                              errorStyle: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),

                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(0)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(0)),
                              //hintText: "e.g Abouzied",
                              labelStyle: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Change Email Address"),
                        ),
                        SizedBox(
                          child: TextField(
                            controller: emailIDTextEditingController,
                            cursorColor: primaryColorOfApp,
                             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                            onChanged: (value) {

                            },
                            style: GoogleFonts.poppins(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                              fontWeight: FontWeight.w400,fontStyle: FontStyle.normal,
                            ),
                            decoration: InputDecoration(
                              //errorText: userAccountSearchErrorText,
                              contentPadding: EdgeInsets.all(25),
                              labelText: "Change Email Address",
                              hintText: "Change Email Address",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.email_outlined,),
                              ),
                              errorStyle: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.redAccent),

                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(0)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(0)),
                              //hintText: "e.g Abouzied",
                              labelStyle: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.bodyLarge,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black45),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Your Invoices",style: TextStyle(fontWeight: FontWeight.normal),textScaleFactor: 1.5,),
                        ),
                        Flexible(
                          child: ListView.separated(
                            separatorBuilder: (c,i){
                              return Divider();
                            },
                            shrinkWrap: true,
                            itemBuilder: (c,i){
                              return ListTile(
                                title: Text("Amplifi Test 1"),
                                subtitle: Text("Bought Yesterday"),
                                trailing: Text("12\$",style: TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 2,),
                              );
                            },itemCount: 100,

                          ),
                        )
                      ],
                    ),
                  );*/
              }
            }

            // Displaying LoadingSpinner to indicate waiting state
            return Center(
              child: CircularProgressIndicator(),
            );
          },

          // Future that needs to be resolved
          // inorder to display something on the Canvas
          future: brevoApiFuture,
        ),
      ),
    );
  }



}
