import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/page/word_quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'word_quiz_organizer_test.dart';

void main() {
  testWidgets('WordQuizPage データが１つのとき', (WidgetTester tester) async {
    DummyWordRepository repository = DummyWordRepository();
    repository.words = [
      Word(title: 'some title', description: 'some description')
    ];
    // MEMO: MaterialAppで囲んであげないとエラーになった
    await tester.pumpWidget(MaterialApp(
      home: WordQuizPage(repository: repository),
    ));

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
    DummyWordRepository repository = DummyWordRepository();
    repository.words = [
      Word(title: 'some title 1', description: 'some description 1'),
      Word(title: 'some title 2', description: 'some description 2'),
    ];
    // MEMO: MaterialAppで囲んであげないとエラーになった
    await tester.pumpWidget(MaterialApp(
      home: WordQuizPage(repository: repository),
    ));

    await tester.pump(Durations.long1);

    late String first;
    late String second;
    if (find.text('some title 1').evaluate().firstOrNull != null) {
      first = 'some title 1';
      second = 'some title 2';
      print('pattern 1');
    } else {
      first = 'some title 2';
      second = 'some title 1';
      print('pattern 2');
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
