import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';

class MailApp extends StatefulWidget {
  @override
  _MailAppState createState() => _MailAppState();
}

class _MailAppState extends State<MailApp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  // Example of SMTP server settings for Gmail
  String username = 'fenilpatel120501@gmail.com';
  String password = 'Fenil5789';

  Future<void> sendEmail() async {
    final smtpServer = gmail(username, password); // Configure the smtp server

    // Create the attachment
    // final Directory directory = await getApplicationDocumentsDirectory();
    // final File file = File('${directory.path}/yourfile.pdf'); // Make sure the file exists

    final message = Message()
      ..from = Address(username, 'Your name')
      ..recipients.add('destination@example.com')
      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>"
      ..attachments = [
        FileAttachment(File('assets/downloadapp.jpg'))
          ..location = Location.inline
          ..cid = '<myimg@3.141>'
      ];

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Message"),
          content: Text("Failed to send email", style: TextStyle(color: Colors.red)),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Mail Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(controller: nameController, decoration: InputDecoration(hintText: 'Name')),
            TextField(controller: emailController, decoration: InputDecoration(hintText: 'Email')),
            TextField(controller: messageController, decoration: InputDecoration(hintText: 'Message')),
            ElevatedButton(
              onPressed: sendEmail,
              child: const Text('Send email'),
            ),
          ],
        ),
      ),
    );
  }
}
