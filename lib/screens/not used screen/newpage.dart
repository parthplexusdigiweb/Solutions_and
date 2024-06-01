import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
class newpage extends StatefulWidget {
  const newpage({super.key});

  @override
  State<newpage> createState() => _newpageState();
}

class _newpageState extends State<newpage> {
  final customBgColor = PdfColor.fromInt(0xFFD9E2F3);
  final customFontColor = PdfColor.fromInt(0xFF4478D4);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Uint8List pdfBytes = await makePdf();
            final title = 'Flutter Demo';
            await Printing.layoutPdf(onLayout: (format) => makePdf());
        print("object");
      }),
    );
  }
  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    final Reportfont = await PdfGoogleFonts.latoBoldItalic();
    final Reportansfont = await PdfGoogleFonts.latoItalic();

    final headingfont1 = await PdfGoogleFonts.latoBold();
    final bodyfont1 = await PdfGoogleFonts.latoRegular();

    pdf.addPage(
        pw.MultiPage(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            pageFormat: PdfPageFormat.a4,


            build: ( context) {
              return [
              pw.Container(
                width: 500,
                  decoration: pw.BoxDecoration(
                    color: customBgColor,border:pw.Border.all(color: PdfColors.black,width: 1)
                  ),
              padding: pw.EdgeInsets.only(left: 8),



                child: pw.Text(
                  'About me:',
                  style: pw.TextStyle(
                    fontSize: 20.0,
                    fontWeight: pw.FontWeight.bold,
                    color:  customFontColor ,
                  ),
                ),
              ),
                pw.SizedBox(height: 25,width: 5),
                //pw.Padding(padding: pw.EdgeInsets.all(20)),

                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Me and my circumstances:',style: pw.TextStyle(color:  customFontColor ,fontSize: 14)),
                    pw.SizedBox(width: 60),

                    pw.Container(
                      width: 250,
                      height: 190,
                      decoration: pw.BoxDecoration(
                          border:pw.Border.all(color: PdfColors.black,width: 1)
                      ),
                      padding: pw.EdgeInsets.only(left: 8),

                      child:   pw.Column(
                          children: [
                            pw.Text(
                              'I am neuro-divergent, diagnosed as autistic',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                font: bodyfont1,
                                color:  PdfColors.black ,
                              ),
                            ),
                            pw.SizedBox(height:10 ),
                            pw.Text(
                              'I like and need to do things in ways that are different from many other (neuro-typical) people',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                font: bodyfont1,
                                color:  PdfColors.black ,
                              ),
                            ),
                            pw.SizedBox(height:10 ),
                            pw.Text(
                              'This both gives me strengths through which I can add value but also presents me with challenges that I am learning to overcome',
                              style: pw.TextStyle(
                                fontSize: 12.0,
                                font: bodyfont1,
                                color:  PdfColors.black ,
                              ),
                            ),

                          ]
                      ),

                    ),


                  ]

                ),

              pw.SizedBox(height: 25,width: 5),
              //pw.Padding(padding: pw.EdgeInsets.all(20)),

              pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Container(
                  width: 180,
                  padding: const pw.EdgeInsets.all(5),
                  decoration: pw.BoxDecoration(
                  ),
                  child: pw.Text(
              'My strengths that I want to have the opportunity to use in my role:',
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: customFontColor,
                    ),
                  ),
                ),
              pw.SizedBox(width: 48),

              pw.Container(
              width: 250,
              height: 180,
              decoration: pw.BoxDecoration(
              border:pw.Border.all(color: PdfColors.black,width: 1)
              ),
              padding: pw.EdgeInsets.only(left: 8),

              child:   pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
              pw.Text(
              'Strong technical skills, including modelling and coding',
              style: pw.TextStyle(
              fontSize: 16.0,
              font: bodyfont1,
              color:  PdfColors.black ,
              ),
              ),
              pw.SizedBox(height:10 ),
              pw.Text(

              'Sharp attention to detail',
                style: pw.TextStyle(
              fontSize: 16.0,
              font: bodyfont1,
              color:  PdfColors.black ,

              ),
              ),
              pw.SizedBox(height:10 ),
              pw.Text(
              'Great networking and relationship building skills',
                style: pw.TextStyle(
              fontSize: 16.0,
              font: bodyfont1,
              color:  PdfColors.black ,
              ),
              ),
                pw.SizedBox(height:10 ),
                pw.Text(
                  'Mentoring others',
                  style: pw.TextStyle(
                    fontSize: 16.0,
                    font: bodyfont1,
                    color:  PdfColors.black ,
                  ),
                ),
              ]
              ),

              ),
            ]),
                pw.SizedBox(height: 15),
                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                    pw.Container(
                    width: 180,
                    padding: const pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                ),
                child: pw.Text(
                  'Things I find challenging in life that make it harder for me to perform my best:',
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: customFontColor,
                  ),
                ),
                    ),
                      pw.SizedBox(width: 50),

                      pw.Container(
                        width: 250,
                        height: 260,
                        decoration: pw.BoxDecoration(
                            border:pw.Border.all(color: PdfColors.black,width: 1)
                        ),
                        padding: pw.EdgeInsets.only(left: 8),

                        child:   pw.Column(
                            children: [
                              pw.Text(
                                'Noise sensory overload - sensitivity to noise that impacts my concentration and efficiency. Sometimes because we work in an open-plan office',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,
                                ),
                              ),
                              pw.SizedBox(height:10 ),
                              pw.Text(
                              'Fatigue - exhaustion due to energy depletion. Because I need to work harder to interpret people\'s communication and body language, and to stay focused',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,
                                ),
                              ),
                              pw.SizedBox(height:10 ),
                              pw.Text(
                                'Misinterpretation of requests - understanding what is being asked of me and what I am committing to deliver. I can misinterpret what I am being asked to deliver when someone speaks to me orally, and this only comes to light after I\'ve already put considerable effort into going down a different \'rabbit hole\' from that being requested',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,
                                ),
                              ),
                              pw.SizedBox(height:10 ),
                              pw.Text(
                              'Lack of direct communication - direct and open communication works best for me. Many people find it hard to communicate with openness and to be direct, and this makes it more challenging for me to understand. Similarly, some people feel uncomfortable and tell me I\'m \'too much\' with what they view as my directness',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,
                                ),
                              ),
                            ]
                        ),

                      ),
                    ]
                ),
              ];  })
    );
    pdf.addPage(
        pw.MultiPage(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            pageFormat: PdfPageFormat.a4,


            build: ( context) {
              return [
                pw.Container(
                  width: 500,
                  decoration: pw.BoxDecoration(
                      color: customBgColor,border:pw.Border.all(color: PdfColors.black,width: 1)
                  ),
                  padding: pw.EdgeInsets.only(left: 8),



                  child: pw.Text(
                     'What I find helps and hinders me in my workplace environment:',
                    style: pw.TextStyle(
                      fontSize: 18.0,
                      fontWeight: pw.FontWeight.bold,
                      color:  customFontColor ,
                    ),
                  ),
                ),
                pw.SizedBox(height: 25,width: 5),
                //pw.Padding(padding: pw.EdgeInsets.all(20)),

                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 180,
                        padding: const pw.EdgeInsets.all(5),
                        decoration: pw.BoxDecoration(
                        ),
                        child: pw.Text(
                          'What I value about [my organisation] and the workplace environment that helps me perform my best:',
                          // 'What I find challenging about [my organisation] and the workplace environment that make it harder for me to perform to my best:',
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: customFontColor,
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 60),

                      pw.Container(
                        width: 250,
                        height: 170,
                        decoration: pw.BoxDecoration(
                            border:pw.Border.all(color: PdfColors.black,width: 1)
                        ),
                        padding: pw.EdgeInsets.only(left: 8),

                        child:   pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Relaxed environment',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,
                                ),
                              ),
                              pw.SizedBox(height:10 ),
                              pw.Text(
                              'Team spirit - not competitive, everyone helps each other',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,
                                ),
                              ),
                              pw.SizedBox(height:10 ),
                              pw.Text(
                              'Desire to have fun',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,
                                ),
                              ),
                              pw.SizedBox(height:10 ),
                              pw.Text(
                                'Relaxed dress code',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,
                                ),
                              ),

                            ]
                        ),

                      ),


                    ]

                ),

                pw.SizedBox(height: 45,width: 5),
                //pw.Padding(padding: pw.EdgeInsets.all(20)),

                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 180,
                        padding: const pw.EdgeInsets.all(5),
                        decoration: pw.BoxDecoration(
                        ),
                        child: pw.Text(
                          'What I find challenging about [my organisation] and the workplace environment that make it harder for me to perform to my best:',                         // 'What I find challenging about [my organisation] and the workplace environment that make it harder for me to perform to my best:',
                          style: pw.TextStyle(
                            fontSize: 14,
                            color:  customFontColor,
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 60),

                      pw.Container(
                        width: 250,
                        height: 180,
                        decoration: pw.BoxDecoration(
                            border:pw.Border.all(color: PdfColors.black,width: 1)
                        ),
                        padding: pw.EdgeInsets.only(left: 8),

                        child:   pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Strong technical skills, including modelling and coding',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,
                                ),
                              ),
                              pw.SizedBox(height:10 ),
                              pw.Text(

                                'Long hours',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,

                                ),
                              ),
                              pw.SizedBox(height:10 ),
                              pw.Text(
                                'Hard to plan workflow, often due to spontaneous and changing needs',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,
                                ),
                              ),
                              pw.SizedBox(height:10 ),
                              pw.Text(
                                'Mentoring others',
                                style: pw.TextStyle(
                                  fontSize: 12.0,
                                  font: bodyfont1,
                                  color:  PdfColors.black ,
                                ),
                              ),
                            ]
                        ),

                      ),
                    ]),

              ];  })
    );
    return pdf.save();
   }
  Future<pw.MemoryImage> loadImage(String assetPath) async {
    final imageByteData = await rootBundle.load(assetPath);

    final imageUint8List = imageByteData.buffer
        .asUint8List(imageByteData.offsetInBytes, imageByteData.lengthInBytes);

    return pw.MemoryImage(imageUint8List);
  }
}
