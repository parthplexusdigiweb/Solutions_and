import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class Pageone extends StatefulWidget {
  const Pageone({Key? key}) : super(key: key);

  @override
  State<Pageone> createState() => _PageoneState();
}

class _PageoneState extends State<Pageone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Uint8List pdfBytes = await makePdf();
          await Printing.layoutPdf(onLayout: (format) => pdfBytes);
          print("PDF generated");
        },
      ),
    );
  }

  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    final bodyfont1 = await PdfGoogleFonts.latoBlack();

    final customBgColor = PdfColor.fromInt(0xFFD9E2F3);
    final customFontColor = PdfColor.fromInt(0xFF4478D4);

    pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Center(
              child: pw.Container(
                width: 500,
                padding: const pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                  color: customBgColor,
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Text(
                  "Actions and adjustments that I've identified can help me perform to my best in my role for [my organisation]:",
                  style: pw.TextStyle(
                    font: bodyfont1,
                    fontSize: 16.5,
                    color: customFontColor,
                  ),
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "Here are things that can help me, for which I can and want to take Personal Responsibility.",
              style: pw.TextStyle(
                fontSize: 12,
                color: customFontColor,
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 150,
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                  ),
                  child: pw.Text(
                    "Things I already or will do to help myself:",
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: customFontColor,
                    ),
                  ),
                ),
                pw.SizedBox(width: 25),
                pw.Container(
                  width: 300,
                  height: 410,
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Asking clarifying questions - check for understanding to ensure I am interpreting the ask of me accurately ",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        "This reduces inefficiencies from proceeding to far down a process after there has been mis-communication between me and others arising from verbal-only conversation",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Managing my time and being organised - using schedules, to-do lists and being agile to changing them while also keeping other people informed",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Learning to prioritise - focusing on what matters most",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Career development responsibility - taking my own responsibility to develop my career in a direction through which I feel purpose and passion and that is aligned with my aspirations",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Manage energy levels - listening to my body and taking breaks and exercise when needed to replenish",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Time to reflect - setting aside regular breaks especially after long meetings or assignments to reflect on what is going well, what I can do better, and whose help I might want to ask for",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Seek feedback - regularly seeking feedback from a range of people with whom I am working, including seeking their views on how I can improve my effectiveness and impact",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Center(
              child: pw.Container(
                width: 500,
                padding: const pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                  color: customBgColor,
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Text(
                  "Actions and adjustments that I've identified can help me perform to my best in my role for [my organisation]:",
                  style: pw.TextStyle(
                    font: bodyfont1,
                    fontSize: 16.5,
                    color: customFontColor,
                  ),
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "Here are things that can help me that I wish to discuss requesting from my employer",
              style: pw.TextStyle(
                fontSize: 12,
                color: customFontColor,
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Text(
              "My request of [my organisation]",
              style: pw.TextStyle(
                fontSize: 12,
                color: customFontColor,
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 150,
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                  ),
                  child: pw.Text(
                    "[My organisation] already provides the following assistance to me, which I'd like if possible to continue to receive: ",
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: customFontColor,
                    ),
                  ),
                ),
                pw.SizedBox(width: 25),
                pw.Container(
                  width: 300,
                  height: 270,
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Written communications - people know (and are supporting me in) that I prefer written over oral communication",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        "This helps improve my understanding and alignment, enabling me to feel more motivated and efficient, and less self-critical when I have misinterpreted a request",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Regular feedback - from my Team Leader and colleagues working with me on assignments",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        "This provides me with a valuable source of insight around my strengths that I can deploy for value to [my organisation] and our clients and where and how I can look to improve my value, effectiveness and impact",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        "Private office use - flexibility to work in a private office when needed",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        "This helps me manage my sensory sensitivity to noise by removing myself from the open-plan environment that I find distracting",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            pw.SizedBox(height: 50),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 150,
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                  ),
                  child: pw.Text(
                    "I'm asking [my organisation] whether it is possible to start providing for me: ",
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: customFontColor,
                    ),
                  ),
                ),
                pw.SizedBox(width: 25),
                pw.Container(
                  width: 300,
                  height: 130,
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black, width: 1),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Noise-excluding headphones - to block out surrounding noise and improve sound quality of online and telephone conversations in noisy environments",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        "These reduce distractions for people with heightened noise sensitivity and those easily distracted by background noise or conversations. There are various models and designs available, with various levels of technical capability.",
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
            pw.SizedBox(height: 50),
            pw.Text(
              "My requests include workplace accommodations that I view as reasonable adjustments under the Equality Act 2010.",
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.black,
              ),
            ),
          ];
        },
      ),
    );
    return pdf.save();
  }

  Future<pw.MemoryImage> loadImage(String assetPath) async {
    final imageByteData = await rootBundle.load(assetPath);
    final imageUint8List = imageByteData.buffer.asUint8List(
        imageByteData.offsetInBytes, imageByteData.lengthInBytes);
    return pw.MemoryImage(imageUint8List);
  }
}
