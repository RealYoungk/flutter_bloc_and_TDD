import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_note/mode/note.dart';

import 'note_page.dart';

class MyHomePage extends StatelessWidget {
  final NotesCubit notesCubit;
  final String title;

  const MyHomePage({
    Key? key,
    required this.notesCubit,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        bloc: notesCubit,
        builder: (context, state) => ListView.builder(
          itemCount: state.notes.length,
          itemBuilder: (context, index) {
            var note = state.notes[index];
            return ListTile(
              title: Text(note.title),
              subtitle: Text(note.body),
              onTap: () => _goToNotePage(context, note: note),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToNotePage(context),
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  _goToNotePage(BuildContext context, {Note? note}) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NotePage(
                notesCubit: notesCubit,
                note: note,
              )));
}
