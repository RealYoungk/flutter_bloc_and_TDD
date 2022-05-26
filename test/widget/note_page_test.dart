import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_note/mode/note.dart';
import 'package:tdd_note/note_page.dart';

void main() {
  group('Note Page', () {
    _pumpTestWidget(WidgetTester tester, NotesCubit cubit, {Note? note}) =>
        tester.pumpWidget(MaterialApp(
          home: NotePage(
            notesCubit: cubit,
            note: note,
          ),
        ));

    testWidgets('empty state', (WidgetTester tester) async {
      await _pumpTestWidget(tester, NotesCubit());
      expect(find.text('Enter your text here...'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      var widgetFinder = find.widgetWithIcon(IconButton, Icons.delete);
      // evaluate : 현재의 상태가 test를 만족하는지 확인
      var deleteButton = widgetFinder.evaluate().single.widget as IconButton;
      expect(deleteButton.onPressed, isNull);
    });

    testWidgets('create note', (WidgetTester tester) async {
      var cubit = NotesCubit();
      await _pumpTestWidget(tester, NotesCubit());
      await tester.enterText(find.byKey(const ValueKey('title')), 'hi');
      await tester.enterText(find.byKey(const ValueKey('body')), 'there');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(cubit.state.notes, isNotEmpty);
      var note = cubit.state.notes.first;
      expect(note.title, 'hi');
      expect(note.body, 'there');
      expect(find.byType(NotePage), findsNothing);
    });

    testWidgets('create in edit mode', (WidgetTester tester) async {
      var note = Note(1, 'my note', 'note body');
      await _pumpTestWidget(tester, NotesCubit(), note: note);
      expect(find.text(note.title), findsOneWidget);
      expect(find.text(note.body), findsOneWidget);
      var widgetFinder = find.widgetWithIcon(IconButton, Icons.delete);
      var deleteButton = widgetFinder.evaluate().single.widget as IconButton;
      expect(deleteButton.onPressed, isNotNull);
    });

    testWidgets('edit note', (WidgetTester tester) async {
      var cubit = NotesCubit()..createNote('my note', 'note body');
      await _pumpTestWidget(tester, cubit, note: cubit.state.notes.first);
      await tester.enterText(find.byKey(ValueKey('title')), 'hi');
      await tester.enterText(find.byKey(ValueKey('body')), 'there');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(cubit.state.notes, isNotEmpty);
      var note = cubit.state.notes.first;
      expect(note.title, 'hi');
      expect(note.body, 'there');
      expect(find.byType(NotePage), findsNothing);
    });

    testWidgets('delete note', (WidgetTester tester) async {
      var cubit = NotesCubit();
      _pumpTestWidget(tester, cubit, note: cubit.state.notes.first);
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(cubit.state.notes, isEmpty);
      expect(find.byType(NotePage), findsNothing);
    });
  });
}
