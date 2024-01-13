import 'package:en_words_on_web/data/word_list.dart';
import 'package:en_words_on_web/main.dart';
import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/page/word_quiz_page.dart';
import 'package:en_words_on_web/repository/word_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'word_quiz_organizer_test.dart';

void main() {
  testWidgets('WordQuizPage データが１つのとき', (WidgetTester tester) async {
    DummyWordDataSource dataSource = DummyWordDataSource();
    dataSource.words = [
      Word.create(title: 'some title', description: 'some description')
    ];

    await tester.pumpWidget(ProviderScope(
        overrides: [
          wordListProvider
              .overrideWith((ref) => WordList([], dataSource: dataSource))
        ],
        // MEMO: MaterialAppで囲んであげないとエラーになった
        child: const MaterialApp(
          home: WordQuizPage(),
        )));

    expect(find.text('some title'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pump();

    // データが１つなので変わらない
    expect(find.text('some title'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  // 現状のテストだとshuffleに影響を受けてしまうため良いテストではない。そこもスタブを返せるようにするべき
  testWidgets('WordQuizPage データが2つのとき', (WidgetTester tester) async {
    DummyWordDataSource dataSource = DummyWordDataSource();
    dataSource.words = [
      Word.create(title: 'some title 1', description: 'some description 1'),
      Word.create(title: 'some title 2', description: 'some description 2'),
    ];

    await tester.pumpWidget(ProviderScope(
        overrides: [
          wordListProvider
              .overrideWith((ref) => WordList([], dataSource: dataSource))
        ],
        // MEMO: MaterialAppで囲んであげないとエラーになった
        child: const MaterialApp(
          home: WordQuizPage(),
        )));

    await tester.pump(Durations.long1);

    late String first;
    late String second;
    if (find.text('some title 1').evaluate().firstOrNull != null) {
      first = 'some title 1';
      second = 'some title 2';
      print('some title 1');
    } else {
      first = 'some title 2';
      second = 'some title 1';
      print('some title 2');
    }

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pump();

    expect(find.text(second), findsOneWidget);
    expect(find.text(first), findsNothing);

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pump();

    expect(find.text(second), findsOneWidget);
    expect(find.text(first), findsNothing);

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pump();

    expect(find.text(first), findsOneWidget);
    expect(find.text(second), findsNothing);
  });
}

class DummyWordDataSource implements WordDataSource {
  List<Word> words = [];

  @override
  List<Word> fetch() {
    return words;
  }

  @override
  void add(Word word) {}

  @override
  void edit(Word word) {}
}
