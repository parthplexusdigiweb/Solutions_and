import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DownloadPDFButton extends StatelessWidget {
  DownloadPDFButton({Key? key}) : super(key: key);

  Future<Uint8List> generateAboutMePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('About Me', style: pw.TextStyle(fontSize: 24)),
              pw.Divider(),
              pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 10)),
              pw.Text('Name: ChatGPT', style: pw.TextStyle(fontSize: 18)),
              pw.Text('Profession: AI Assistant', style: pw.TextStyle(fontSize: 18)),
              pw.Padding(padding: pw.EdgeInsets.symmetric(vertical: 5)),
              pw.Text('I am an AI developed by OpenAI, designed to assist with a wide range of tasks. Whether it\'s generating code, composing music, or providing information, I\'m here to help make your life easier.'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> downloadAboutMePdf() async {
    final Uint8List pdfBytes = await generateAboutMePdf();
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "about_me.pdf")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        downloadAboutMePdf();
      },
      child: Text('Download About Me PDF'),
    );
  }
}