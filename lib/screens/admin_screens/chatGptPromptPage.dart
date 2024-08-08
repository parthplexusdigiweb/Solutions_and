import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrivers/core/constants.dart';
import 'package:thrivers/core/progress_dialog.dart';

class ChatGptPromptScreen extends StatefulWidget {
  const ChatGptPromptScreen({super.key});

  @override
  State<ChatGptPromptScreen> createState() => _ChatGptPromptScreenState();
}

class _ChatGptPromptScreenState extends State<ChatGptPromptScreen> {

  TextEditingController prompt1controller = TextEditingController();
  TextEditingController prompt2controller = TextEditingController();

  getPrompt() async {
    await FirebaseFirestore.instance.collection('ChatGpt-Settings').doc("Prompt").get().then((value) {
      prompt1controller.text = value['prompt_1'];
      prompt2controller.text = value['prompt_2'];
      print("promptcontroller.text: ${prompt1controller.text}");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrompt();
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
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HeaderWidget(),
                      HeaderWidget2(),
                    ]
                )
            )
        )
    );
  }

  HeaderWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      //color: Colors.deepPurple, // Change the color to your desired background color
      child: Text(
        'Chat-Gpt Prompt',
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
            'Prompt',
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
            controller: prompt1controller,
            maxLines: null,
            cursorColor: primaryColorOfApp,
            // readOnly: readonly,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              //errorText: userAccountSearchErrorText,
              // errorText: nameErrorText,
              contentPadding: EdgeInsets.all(20),
              labelText: "Prompt 1",
              hintText: "Prompt 1",
              // prefixIcon: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Icon(Icons.key),
              // ),
              // suffixIcon: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text("Prompt"),
              //
              // ),
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
            controller: prompt2controller,
            maxLines: null,
            cursorColor: primaryColorOfApp,
            // readOnly: readonly,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              //errorText: userAccountSearchErrorText,
              // errorText: nameErrorText,
              contentPadding: EdgeInsets.all(20),
              labelText: "Prompt 2",
              hintText: "Prompt 2",
              // prefixIcon: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Icon(Icons.key),
              // ),
              // suffixIcon: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text("Prompt"),
              //
              // ),
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: InkWell(
                  onTap: () async {

                    ////ApiRepository().updateSecurityPINFor(userAccountId,newPinTextEditingController.text);

                    ProgressDialog.show(context, "Updating the\nQuestions", Icons.key);



                    DocumentReference documentReference = FirebaseFirestore.instance.collection('ChatGpt-Settings').doc("Prompt");

                    // Perform the update operation
                    await documentReference.update({
                      'prompt_1': prompt1controller.text,
                      'prompt_2': prompt2controller.text,
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


}
