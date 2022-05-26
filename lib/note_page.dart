import 'package:flutter/material.dart';
import 'package:tdd_note/mode/note.dart';

class NotePage extends StatefulWidget {
  final NotesCubit notesCubit;
  final Note? note;

  const NotePage({
    Key? key,
    required this.notesCubit,
    this.note = const Note(1, 'title', 'body'),
  }) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    if (widget.note == null) return;
    _titleController.text = widget.note!.title;
    _bodyController.text = widget.note!.body;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              key: ValueKey('title'),
              controller: _titleController,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            Expanded(
              child: TextField(
                key: ValueKey('body'),
                controller: _bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: 500,
                decoration:
                    InputDecoration(hintText: 'Enter your text here...'),
              ),
            ),
            ElevatedButton(onPressed: () => _finishEditing(), child: Text('Ok'))
          ],
        ),
      ),
    );
  }

  _finishEditing() {
    if (widget.note != null) {
      widget.notesCubit.updateNote(
          widget.note!.id, _titleController.text, _bodyController.text);
    } else {
      widget.notesCubit.createNote(_titleController.text, _bodyController.text);
    }
    Navigator.pop(context);
  }

  _deleteNote() {
    widget.notesCubit.deleteNote(widget.note!.id);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
