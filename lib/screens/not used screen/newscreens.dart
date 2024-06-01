import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _addController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _editingDocumentId;

  void _addItem() {
    if (_addController.text.isNotEmpty) {
      final itemText = '• ${_addController.text.trim()}';
      _firestore.collection('AboutMe').add({'My_Circumstance': itemText});
      _addController.clear();
    }
  }

  void _startEditing(DocumentSnapshot document) {
    setState(() {
      _editingDocumentId = document.id;
      _editController.text = document['My_Circumstance'];
    });
  }

  void _saveEditing() {
    if (_editController.text.isNotEmpty && _editingDocumentId != null) {
      _firestore
          .collection('AboutMe')
          .doc(_editingDocumentId)
          .update({'My_Circumstance': _editController.text});
      _editController.clear();
      setState(() {
        _editingDocumentId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unordered List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _addController,
              decoration: InputDecoration(
                hintText: 'Enter item',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addItem,
                ),
              ),
            ),
          ),
          Expanded(child: _buildList()),
          if (_editingDocumentId != null) _buildEditField(),
        ],
      ),
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('AboutMe').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        var documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var document = documents[index];
            var item = document['My_Circumstance'];
            return ListTile(
              leading: Icon(Icons.arrow_right),
              title: Text(item),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _startEditing(document),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEditField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: _editController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Edit item',
              suffixIcon: IconButton(
                icon: Icon(Icons.save),
                onPressed: _saveEditing,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
