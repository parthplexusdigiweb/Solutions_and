import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/Network/FirebaseApi.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';

class ChatGptSettingsScreen extends StatefulWidget {
  const ChatGptSettingsScreen({super.key});

  @override
  State<ChatGptSettingsScreen> createState() => _ChatGptSettingsScreenState();
}

class _ChatGptSettingsScreenState extends State<ChatGptSettingsScreen> {


  var openAiApiKeyFromFirebase;

  var _openAI;

  bool readonly = false;

  final ChatUser _currentUser =
  ChatUser(id: '1', firstName: 'Admin');

  final ChatUser _gptChatUser =
  ChatUser(id: '2', firstName: 'Chat', lastName: "GPT");

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  TextEditingController openAIApiKeyTextEditingController = TextEditingController();
  TextEditingController chatgptcontroller = TextEditingController();
  TextEditingController quetion1controller = TextEditingController();
  TextEditingController quetion2controller = TextEditingController();
  TextEditingController quetion3controller = TextEditingController();
  TextEditingController quetion4controller = TextEditingController();
  TextEditingController quetion5controller = TextEditingController();


  String? nameErrorText;

  late Future<String> ChatgptSettingsApiFuture;
  // var ChatgptSettingsApiFuture;

  Future<String> getChatgptSettingsApiKey() async {
    String apiKey = "";
    await FirebaseFirestore.instance.collection('ChatGpt-Settings').doc("OpenAI").get().then((value) {

      // Access the specific field
      apiKey = value['APIKey'];
      openAiApiKeyFromFirebase = apiKey;

      print("openAiApiKeyFromFirebase :$openAiApiKeyFromFirebase");
      // // Perform the update operation
      // _openAI = OpenAI.instance.build(
      //   // token: OPENAI_API_KEY,
      //   token: openAiApiKeyFromFirebase,
      //   baseOption: HttpSetup(
      //     receiveTimeout: const Duration(
      //       seconds: 20,
      //     ),
      //   ),
      //   enableLog: true,
      // );

    });
    // print("apenaikey :$apiKey");
    return apiKey;

  }

   getQuestions() async {
    // String apiKey = "";
    await FirebaseFirestore.instance.collection('Questions').doc("BuRiTTm0t4mBkTeTso7S").get().then((value) {

      // Access the specific field
      quetion1controller.text = value['Question 1'];
      quetion2controller.text = value['Question 2'];
      quetion3controller.text = value['Question 3'];
      quetion4controller.text = value['Question 4'];
      quetion5controller.text = value['Question 5'];
      // openAiApiKeyFromFirebase = apiKey;

      print("openAiApiKeyFromFirebase :$openAiApiKeyFromFirebase");
      // // Perform the update operation
      // _openAI = OpenAI.instance.build(
      //   // token: OPENAI_API_KEY,
      //   token: openAiApiKeyFromFirebase,
      //   baseOption: HttpSetup(
      //     receiveTimeout: const Duration(
      //       seconds: 20,
      //     ),
      //   ),
      //   enableLog: true,
      // );

    });
    // print("apenaikey :$apiKey");
    // return apiKey;

  }


  // HeaderWidget() {
  //   return Container(
  //     padding: EdgeInsets.all(16.0),
  //     //color: Colors.deepPurple, // Change the color to your desired background color
  //     child: Text(
  //       'Brevo',
  //       style: TextStyle(
  //         color: Colors.black, // Change the text color to your desired color
  //         fontSize: 24.0, // Adjust the font size as needed
  //         fontWeight: FontWeight.bold,
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readonly = true;
    // ChatgptSettingsApiFuture = ApiRepository().getChatgptSettingsApiKey();
    ChatgptSettingsApiFuture = getChatgptSettingsApiKey();
    getChatgptSettingsApiKey();
    getQuestions();
    print("openAiApiKeyFromFirebasessss: ${openAiApiKeyFromFirebase}");

    //  _openAI = OpenAI.instance.build(
    //   // token: OPENAI_API_KEY,
    //   token: openAiApiKeyFromFirebase,
    //   baseOption: HttpSetup(
    //     receiveTimeout: const Duration(
    //       seconds: 20,
    //     ),
    //   ),
    //   enableLog: true,
    // );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      // appBar: AppBar(
      //   backgroundColor: const Color.fromRGBO(0, 166, 126, 1,),
      //   title: const Text(
      //     'GPT Chat',
      //     style: TextStyle(
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder<String>(
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

                openAIApiKeyTextEditingController.text = data!;
                // openAiApiKeyFromFirebase = data!;
                print("openAiApiKeyFromFirebase : $openAiApiKeyFromFirebase");
                print("openAIApiKeyTextEditingController.text : ${openAIApiKeyTextEditingController.text}");

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderWidget(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: SizedBox(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: TextField(
                                  controller: openAIApiKeyTextEditingController,
                                  cursorColor: primaryColorOfApp,
                                  readOnly: readonly,
                                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: InputDecoration(
                                    //errorText: userAccountSearchErrorText,
                                    errorText: nameErrorText,
                                    contentPadding: EdgeInsets.all(25),
                                    labelText: "Change OPEN-AI API Key",
                                    hintText: "Change OPEN-AI API Key",
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.key),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                          onTap: (){
                                            setState(() {
                                              readonly = !readonly;
                                            });
                                          },
                                          child: Icon(Icons.edit, color: (readonly) ? Colors.black : Colors.green,)),
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

                            ],
                          ),

                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () async {

                            ////ApiRepository().updateSecurityPINFor(userAccountId,newPinTextEditingController.text);

                            ProgressDialog.show(context, "Updating Open AI\nAPI key", Icons.key);

                            // CollectionReference chatGptSettings =
                            // FirebaseFirestore.instance.collection('ChatGpt-Settings');
                            //
                            // // Specify the data you want to store
                            // Map<String, dynamic> dataToStore = {'APIKey': openAIApiKeyTextEditingController.text};
                            //
                            // // Specify the document name
                            // String documentName = 'OpenAI';
                            //
                            // // Add the data to Firestore
                            // chatGptSettings.doc(documentName).set(dataToStore).then((value) {
                            //
                            //   print('Data successfully written to Firestore!');
                            //
                            // }).catchError((error) {
                            //
                            //   print('Error writing data to Firestore: $error');
                            //
                            // });

                            DocumentReference documentReference = FirebaseFirestore.instance.collection('ChatGpt-Settings').doc("OpenAI");

                            // Perform the update operation
                            await documentReference.update({
                              'APIKey': openAIApiKeyTextEditingController.text,
                              // Add more fields if needed
                            });

                            ProgressDialog.hide();
                            // Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 25),
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

                      HeaderWidget2(),
                  
                  
                  
                  
                    ],
                  ),
                );
              }
            }

            // Displaying LoadingSpinner to indicate waiting state
            return Center(
              child: CircularProgressIndicator(),
            );
          },

          // Future that needs to be resolved
          // inorder to display something on the Canvas
          future: ChatgptSettingsApiFuture,
        ),
      ),
    );
  }

  HeaderWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      //color: Colors.deepPurple, // Change the color to your desired background color
      child: Text(
        'Solution Chat Gpt Settings',
        style: TextStyle(
          color: Colors.black, // Change the text color to your desired color
          fontSize: 24.0, // Adjust the font size as needed
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  HeaderWidget2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Original Description',
            style: TextStyle(
              color: Colors.black, // Change the text color to your desired color
              fontSize: 24.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: quetion1controller,
            maxLines: null,
            cursorColor: primaryColorOfApp,
            // readOnly: readonly,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              //errorText: userAccountSearchErrorText,
              errorText: nameErrorText,
              contentPadding: EdgeInsets.all(20),
              labelText: "Question 1",
              hintText: "Question 1",
              // prefixIcon: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Icon(Icons.key),
              // ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Q1"),
    
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: quetion2controller,
            maxLines: null,
            cursorColor: primaryColorOfApp,
            // readOnly: readonly,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              //errorText: userAccountSearchErrorText,
              errorText: nameErrorText,
              contentPadding: EdgeInsets.all(20),
              labelText: "Question 2",
              hintText: "Question 2",
              // prefixIcon: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Icon(Icons.key),
              // ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Q2"),
    
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: quetion3controller,
            maxLines: null,
            cursorColor: primaryColorOfApp,
            // readOnly: readonly,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              //errorText: userAccountSearchErrorText,
              errorText: nameErrorText,
              contentPadding: EdgeInsets.all(20),
              labelText: "Question 3",
              hintText: "Question 3",
              // prefixIcon: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Icon(Icons.key),
              // ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Q3"),
    
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: quetion4controller,
            maxLines: null,
            cursorColor: primaryColorOfApp,
            // readOnly: readonly,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              //errorText: userAccountSearchErrorText,
              errorText: nameErrorText,
              contentPadding: EdgeInsets.all(20),
              labelText: "Question 4",
              hintText: "Question 4",
              // prefixIcon: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Icon(Icons.key),
              // ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Q4"),
    
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: quetion5controller,
            maxLines: null,
            cursorColor: primaryColorOfApp,
            // readOnly: readonly,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              //errorText: userAccountSearchErrorText,
              errorText: nameErrorText,
              contentPadding: EdgeInsets.all(20),
              labelText: "Question 5",
              hintText: "Question 5",
              // prefixIcon: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Icon(Icons.key),
              // ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Q5"),
    
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
        Row(
          children: [
            // Padding(
            //   padding: EdgeInsets.all(20),
            //   child: InkWell(
            //     onTap: () async {
            //
            //       ////ApiRepository().updateSecurityPINFor(userAccountId,newPinTextEditingController.text);
            //
            //       ProgressDialog.show(context, "Adding All the\nQuestions", Icons.key);
            //
            //       CollectionReference chatGptSettings =
            //       FirebaseFirestore.instance.collection('Questions');
            //
            //       // Specify the data you want to store
            //       Map<String, dynamic> dataToStore = {
            //         'Question 1': quetion1controller.text,
            //         'Question 2': quetion2controller.text,
            //         'Question 3': quetion3controller.text,
            //         'Question 4': quetion4controller.text,
            //         'Question 5': quetion5controller.text,
            //
            //       };
            //
            //       // Specify the document name
            //       String documentName = 'OpenAI';
            //
            //       // Add the data to Firestore
            //       chatGptSettings.doc().set(dataToStore).then((value) {
            //
            //         print('Data successfully written to Firestore!');
            //
            //       }).catchError((error) {
            //
            //         print('Error writing data to Firestore: $error');
            //
            //       });
            //
            //       // DocumentReference documentReference = FirebaseFirestore.instance.collection('Questions').doc("OpenAI");
            //       //
            //       // // Perform the update operation
            //       // await documentReference.update({
            //       //   'APIKey': openAIApiKeyTextEditingController.text,
            //       //   // Add more fields if needed
            //       // });
            //
            //       ProgressDialog.hide();
            //       // Navigator.pop(context);
            //     },
            //     child: Container(
            //       width: 200,
            //       height: 60,
            //       decoration: BoxDecoration(
            //         color:Colors.blue,
            //         border: Border.all(
            //             color:Colors.blue,
            //             width: 2.0),
            //         borderRadius: BorderRadius.circular(10.0),
            //       ),
            //       child: Center(
            //         child: Text(
            //           'Save',
            //           style: GoogleFonts.montserrat(
            //               textStyle:
            //               Theme.of(context).textTheme.titleSmall,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white),
            //         ),
            //       ),
            //     ),
            //
            //   ),
            // ),
            // SizedBox(width: 20,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: InkWell(
                  onTap: () async {
                    
                    ////ApiRepository().updateSecurityPINFor(userAccountId,newPinTextEditingController.text);
                    
                    ProgressDialog.show(context, "Updating the\nQuestions", Icons.key);
                    
                    // CollectionReference chatGptSettings =
                    // FirebaseFirestore.instance.collection('Questions');
                    //
                    // // Specify the data you want to store
                    // Map<String, dynamic> dataToStore = {
                    //
                    //   'Question 1': quetion1controller.text,
                    //   'Question 2': quetion2controller.text,
                    //   'Question 3': quetion3controller.text,
                    //   'Question 4': quetion4controller.text,
                    //   'Question 5': quetion5controller.text,
                    //
                    // };
                    //
                    // // Specify the document name
                    // String documentName = 'OpenAI';
                    //
                    // // Add the data to Firestore
                    // chatGptSettings.doc().set(dataToStore).then((value) {
                    //
                    //   print('Data successfully written to Firestore!');
                    //
                    // }).catchError((error) {
                    //
                    //   print('Error writing data to Firestore: $error');
                    //
                    // });
                    
                    DocumentReference documentReference = FirebaseFirestore.instance.collection('Questions').doc("BuRiTTm0t4mBkTeTso7S");
                    
                    // Perform the update operation
                    await documentReference.update({
                      'Question 1': quetion1controller.text,
                      'Question 2': quetion2controller.text,
                      'Question 3': quetion3controller.text,
                      'Question 4': quetion4controller.text,
                      'Question 5': quetion5controller.text,
                      // Add more fields if needed
                    });
                    
                    ProgressDialog.hide();
                    // Navigator.pop(context);
                  },
                  child: Container(
                    // width: 200,
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
            ),
          ],
        ),
      ],
    );
  }
  //
  // String extractName(String response) {
  //   List<String> parts = response.split(',');
  //   return parts.length > 0 ? parts[0].trim() : '';
  // }
  //
  // String extractExpandedDescription(String response) {
  //   List<String> parts = response.split(',');
  //   return parts.length > 1 ? parts[1].trim() : '';
  // }
  //
  // String extractCategories(String response) {
  //   List<String> parts = response.split(',');
  //   return parts.length > 2 ? parts[2].trim() : '';
  // }
  //
  // String extractTags(String response) {
  //   List<String> parts = response.split(',');
  //   return parts.length > 3 ? parts[3].trim() : '';
  // }


  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });
    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();
    final request = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory,
      maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: element.message!.content),
          );
        });
        print("response: ${element.message!.content}");
      }
    }
    // for (var element in response!.choices) {
    //   if (element.message != null) {
    //     // Extract relevant information from the response
    //     String assistantResponse = element.message!.content;
    //     // Parse the assistant's response to extract Name, Expanded Description, Categories, and Tags
    //     String name = extractName(assistantResponse);
    //     String expandedDescription = extractExpandedDescription(assistantResponse);
    //     String categories = extractCategories(assistantResponse);
    //     String tags = extractTags(assistantResponse);
    //
    //     // Create a formatted response
    //     String formattedResponse = 'Name:$name\nDescription:$expandedDescription\nCategory:$categories\nTags:$tags';
    //
    //     // Insert the formatted response into the chat messages list
    //     setState(() {
    //       _messages.insert(
    //         0,
    //         ChatMessage(
    //           user: _gptChatUser,
    //           createdAt: DateTime.now(),
    //           text: formattedResponse,
    //         ),
    //       );
    //     });
    //     print("Formatted response: $formattedResponse");
    //   }
    // }

    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }

  // Future<void> getChatResponses(ChatMessage m) async {
  //   setState(() {
  //     _messages.insert(0, m);
  //     _typingUsers.add(_gptChatUser);
  //   });
  //
  //   // Extract topic from user's message
  //   String userMessage = m.text;
  //   String topic = extractTopic(userMessage);
  //
  //   // Use the topic in your request to ChatGPT
  //   List<Messages> _messagesHistory = _messages.reversed.map((m) {
  //     if (m.user == _currentUser) {
  //       // return Messages(role: Role.user, content: m.text);
  //       return Messages(role: Role.user, content: topic);
  //     } else {
  //       // return Messages(role: Role.assistant, content: m.text);
  //       return Messages(role: Role.assistant, content: topic);
  //     }
  //   }).toList();
  //
  //   final request = ChatCompleteText(
  //     model: Gpt4ChatModel(),
  //     messages: _messagesHistory,
  //     maxToken: 200,
  //
  //     // topic: topic,
  //   );
  //
  //   final response = await _openAI.onChatCompletion(request: request);
  //
  //   for (var element in response!.choices) {
  //     if (element.message != null) {
  //       // Extract relevant information from the assistant's response
  //       String assistantResponse = element.message!.content;
  //       // Parse the assistant's response to extract Name, Expanded Description, Categories, and Tags
  //       String name = extractName(assistantResponse);
  //       String expandedDescription = extractExpandedDescription(assistantResponse);
  //       String categories = extractCategories(assistantResponse);
  //       String tags = extractTags(assistantResponse);
  //
  //       // Create a formatted response
  //       String formattedResponse =
  //           'Name: $name\nExpanded Description: $expandedDescription\nCategories: $categories\nTags: $tags';
  //           // '$name\n$expandedDescription\n$categories\n$tags';
  //
  //       // Insert the formatted response into the chat messages list
  //       setState(() {
  //         _messages.insert(
  //           0,
  //           ChatMessage(
  //             user: _gptChatUser,
  //             createdAt: DateTime.now(),
  //             text: formattedResponse,
  //           ),
  //         );
  //       });
  //       print("Formatted response: $formattedResponse");
  //     }
  //   }
  //
  //   setState(() {
  //     _typingUsers.remove(_gptChatUser);
  //   });
  // }

  Future<void> getChatResponsesss(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _typingUsers.add(_gptChatUser);
    });

    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();

    final request = ChatCompleteText(
      model: Gpt4ChatModel(),
      messages: _messagesHistory,
      maxToken: 200,
    );

    final response = await _openAI.onChatCompletion(request: request);

    for (var element in response!.choices) {
      if (element.message != null) {
        // Extract relevant information from the response
        String assistantResponse = element.message!.content;
        String name = extractNameee(assistantResponse);
        String description = extractDescription(assistantResponse);
        String categories = extractCategoriessss(assistantResponse);
        String keywords = extractKeywordssss(assistantResponse);

        // Create a formatted response
        String formattedResponse =
            'Name: $name\nDescription: $description\nCategories: $categories\nKeywords: $keywords';

        // Insert the formatted response into the chat messages list
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _gptChatUser,
              createdAt: DateTime.now(),
              text: formattedResponse,
            ),
          );
        });

        print("Formatted response: $formattedResponse");
      }
    }

    setState(() {
      _typingUsers.remove(_gptChatUser);
    });
  }

  String extractNameee(String response) {
    RegExp nameRegex = RegExp(r'Name:\s*"([^"]*)"', multiLine: true);
    Match? match = nameRegex.firstMatch(response);
    return match?.group(1)?.trim() ?? '';
  }

  String extractDescription(String response) {
    RegExp descriptionRegex = RegExp(r'Description:\s*"([^"]*)"', multiLine: true);
    Match? match = descriptionRegex.firstMatch(response);
    return match?.group(1)?.trim() ?? '';
  }

  String extractCategoriessss(String response) {
    RegExp categoriesRegex = RegExp(r'Categories:\s*"([^"]*)"', multiLine: true);
    Match? match = categoriesRegex.firstMatch(response);
    return match?.group(1)?.trim() ?? '';
  }

  String extractKeywordssss(String response) {
    RegExp keywordsRegex = RegExp(r'Keywords:\s*"([^"]*)"', multiLine: true);
    Match? match = keywordsRegex.firstMatch(response);
    return match?.group(1)?.trim() ?? '';
  }





// Function to extract the topic from the user's message
  String extractTopic(String userMessage) {
    // Example: Assuming the topic is provided in the format "Tell me about [Topic]"
    // RegExp regex = RegExp(r'Tell me about (.+)', caseSensitive: false);
    RegExp regex = RegExp(r'Name about topic (only max 4 words) : ,Description of topic (only 256 letters): ,Categories in topic (minimun 2-3 words in list): ,Keywords which can use for topic(minimun 2-3 words in list): ', caseSensitive: false);
    RegExpMatch? match = regex.firstMatch(userMessage);
    return match != null ? match.group(1) ?? '' : '';
  }


}
