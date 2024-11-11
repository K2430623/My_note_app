import 'package:flutter/material.dart';
import 'db helper.dart';
import 'getdata.dart';

class AllNotes extends StatefulWidget {
  @override
  State<AllNotes> createState() => _AllNotesState();
}

class _AllNotesState extends State<AllNotes> {
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await DatabaseHelper.instance.readAllNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    _loadNotes();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Note deleted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Notes"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Getdata()),
              );
              _loadNotes();
            },
          ),
        ],
      ),
      body: _notes.isEmpty
          ? Center(child: Text("No notes available"))
          : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note['title']),
            subtitle: Text(note['message']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteNote(note['id']);
              },
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Getdata(note: note),
                ),
              );
              _loadNotes();
            },
          );
        },
      ),
    );
  }
}
