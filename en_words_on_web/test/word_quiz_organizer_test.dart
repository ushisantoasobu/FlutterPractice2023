import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/page/word_quiz_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("WordQuizOrganizer_createList", () {
    Word word_1 = Word.create(title: '1', description: 'fuga');
    Word word_2 = Word.create(title: '2', description: null);
    WordQuizOrganizer organizer = WordQuizOrganizer(words: [word_1, word_2]);
    List<Word> words = organizer.createList();

    // descriptionがnullのものは返ってこない
    expect(words.length, 1);
    expect(words.first.id, word_1.id);
  });
}
