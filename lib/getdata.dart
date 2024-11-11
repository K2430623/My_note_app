import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'db helper.dart';

class Getdata extends StatefulWidget {
  final Map<String, dynamic>? note;
  const Getdata({Key? key, this.note}) : super(key: key);

  @override
  State<Getdata> createState() => _GetdataState();
}

class _GetdataState extends State<Getdata> {
  late final TextEditingController titleController = TextEditingController();
  late final TextEditingController messageController = TextEditingController();
  String? date;

  void _getCurrentDate() {
    final now = DateTime.now();
    date = DateFormat('dd MMM, yyyy HH:mm:ss').format(now);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentDate();
    if (widget.note != null) {
      titleController.text = widget.note!['title'];
      messageController.text = widget.note!['message'];
    }
  }

  void _saveNote() async {
    final note = {
      'title': titleController.text,
      'message': messageController.text,
      'date': date,
    };
    if (widget.note == null) {
      await DatabaseHelper.instance.createNote(note);
    } else {
      await DatabaseHelper.instance.updateNote(widget.note!['id'], note);
    }
    Navigator.pop(context); // Close the form
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Enter title..."),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              maxLines: null,
              decoration: const InputDecoration(hintText: "Enter message..."),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              date ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
