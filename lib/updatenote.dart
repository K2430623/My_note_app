import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'db helper.dart';

class UpdateNote extends StatefulWidget {
  final Map<String, dynamic> note;

  const UpdateNote({Key? key, required this.note}) : super(key: key);

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  late final TextEditingController titleController;
  late final TextEditingController messageController;
  String? date;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note['title']);
    messageController = TextEditingController(text: widget.note['message']);
    date = widget.note['date'];
  }

  Future<void> updateNote() async {
    if (titleController.text.isEmpty || messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and message cannot be empty")),
      );
      return;
    }

    final updatedNote = {
      'title': titleController.text,
      'message': messageController.text,
      'date': DateFormat('dd MMM, yyyy HH:mm:ss').format(DateTime.now()),
    };

    await DatabaseHelper.instance.updateNote(widget.note['id'], updatedNote);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Note updated successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Note'),
        actions: [
          TextButton(
            onPressed: updateNote,
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: messageController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Message",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
