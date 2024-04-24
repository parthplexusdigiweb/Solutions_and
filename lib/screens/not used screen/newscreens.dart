import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:google_fonts/google_fonts.dart';

class PdfExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Data from your Flutter code
    final previewProvider = PreviewProvider();
    final AboutMeDatetextController = TextEditingController();
    final AboutMeLabeltextController = TextEditingController();

    // PDF document
    final pdf = pw.Document();

    // Define fonts
    final Reportfont = pw.Font.ttf(await rootBundle.load("assets/fonts/Lato-Regular.ttf"));
    final Reportansfont = pw.Font.ttf(await rootBundle.load("assets/fonts/Lato-Bold.ttf"));

    // Build PDF content
    pdf.addPage(
    pw.Page(
    build: (context) {
    return pw.Container(
    child: pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
    pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.start,
    children: [
    pw.Container(
    width: MediaQuery.of(context as BuildContext).size.width * 0.1,
    child: pw.Text(
    "Date:   ",
    style: pw.TextStyle(
    font: Reportansfont,
    fontWeight: pw.FontWeight.bold,
    ),
    ),
    ),
    pw.Flexible(
    flex: 1,
    child: pw.Container(
    height: 40,
    width: MediaQuery.of(context as BuildContext).size.width * 0.19,
    child: pw.TextField(
    controller: AboutMeDatetextController,
    style: pw.TextStyle(color: PdfColors.black),
    decoration: pw.InputDecoration(
    hintText: "",
    focusedBorder: pw.OutlineInputBorder(
    borderSide: pw.BorderSide(color: PdfColors.black),
    borderRadius: pw.BorderRadius.circular(10),
    ),
    border: pw.OutlineInputBorder(
    borderSide: pw.BorderSide(color: PdfColors.black12),
    borderRadius: pw.BorderRadius.circular(10),
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    pw.SizedBox(height: 10),

    pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.start,
    children: [
    pw.Container(
    width: MediaQuery.of(context as BuildContext).size.width * 0.1,
    child: pw.Text(
    "Role: ",
    style: pw.TextStyle(
    font: Reportansfont,
    fontWeight: pw.FontWeight.bold,
    ),
    ),
    ),
    pw.Expanded(
    flex: 5,
    child: pw.Text(
    "${previewProvider.role == null ? "" : previewProvider.role}",
    style: pw.TextStyle(font: Reportansfont),
    ),
    ),
    ],
    ),
    pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.start,
    children: [
    pw.Container(
    width: MediaQuery.of(context as BuildContext).size.width * 0.1,
    child: pw.Text(
    "Location: ",
    style: pw.TextStyle(
    font: Reportansfont,
    fontWeight: pw.FontWeight.bold,
    ),
    ),
    ),
    pw.Expanded(
    flex: 5,
    child: pw.Text(
    "${previewProvider.location == null ? "" : previewProvider.location}",
    style: pw.TextStyle(font: Reportansfont),
    ),
    ),
    ],
    ),
    pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.start,
    children: [
    pw.Container(
    width: MediaQuery.of(context as BuildContext).size.width * 0.1,
    child: pw.Text(
    "Employee number: ",
    style: pw.TextStyle(
    font: Reportansfont,
    fontWeight: pw.FontWeight.bold,
    ),
    ),
    ),
    pw.Expanded(
    flex: 5,
    child: pw.Text(
    "${previewProvider.employeeNumber == null ? "" : previewProvider.employeeNumber}",
    style: pw.TextStyle(font: Reportansfont),
    ),
    ),
    ],
    ),
    pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.start,
    children: [
    pw.Container(
    width: MediaQuery.of(context as BuildContext).size.width * 0.1,
    child: pw.Text(
    "Team Leader: ",
    style: pw.TextStyle(
    font: Reportansfont,
    fontWeight: pw.FontWeight.bold,
    ),
    ),
    ),
    pw.Expanded(
    flex: 5,
    child: pw.Text(
    "${previewProvider.linemanager == null ? "" : previewProvider.linemanager}",
    style: pw.TextStyle(font: Reportansfont),
    ),
    ),
    ],
    ),
    ],
    ),
    );
    },
    ),
    );

    // Save the PDF to disk
    savePdf(pdf);

    // Display a message or navigate to the saved PDF
    // depending on your application's requirements.

    return Container();
  }

  // Function to save the PDF to disk
  void savePdf(pw.Document pdf) async {
    final output = await getExternalStorageDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());
  }
}

// Mock class to represent data
class PreviewProvider {
  String name;
  String role;
  String location;
  String employeeNumber;
  String linemanager;
}

// Mock class to represent TextEditingController
class TextEditingController {}
