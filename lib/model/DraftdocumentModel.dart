import 'package:cloud_firestore/cloud_firestore.dart';

class DraftDocumentResult {
  final DocumentSnapshot? document;
  final String? message;

  DraftDocumentResult({this.document, this.message});
}