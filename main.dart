import 'package:flutter/material.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesScreen(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];
  String _selectedCategory = "All"; // Initialize with "All"

  // Function to filter notes based on the selected category
  List<Note> _getFilteredNotes() {
    if (_selectedCategory == "All") {
      return _notes;
    } else {
      return _notes.where((note) => note.category == _selectedCategory).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.category),
            onPressed: () {
              // Show category selection dialog
              _showCategorySelectionDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _getFilteredNotes().length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(_getFilteredNotes()[index].subject),
              subtitle: Text(_getFilteredNotes()[index].content),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddNoteDialog(context);
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  // Function to show category selection dialog
  void _showCategorySelectionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Category'),
          content: DropdownButton<String>(
            value: _selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
              Navigator.of(context).pop(); // Close dialog
            },
            items: <String>['All', 'Work', 'Personal', 'Study'] // Add your categories here
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Function to show add note dialog
  Future<void> _showAddNoteDialog(BuildContext context) async {
    TextEditingController subjectController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Note'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(labelText: 'Subject'),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: 'Content'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: <String>['All', 'Work', 'Personal', 'Study']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  _notes.add(
                    Note(
                      subject: subjectController.text,
                      content: contentController.text,
                      category: _selectedCategory,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Note {
  final String subject;
  final String content;
  final String category;

  Note({
    required this.subject,
    required this.content,
    required this.category,
  });
}
