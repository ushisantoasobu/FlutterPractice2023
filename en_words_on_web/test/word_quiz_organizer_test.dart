import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/page/word_quiz_page.dart';
import 'package:en_words_on_web/repository/word_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("WordQuizOrganizer_createList", () {
    DummyWordRepository repository = DummyWordRepository();
    Word word_1 = Word(title: '1', description: 'fuga');
    Word word_2 = Word(title: '2', description: null);
    repository.words = [word_1, word_2];
    WordQuizOrganizer organizer = WordQuizOrganizer(repository: repository);
    List<Word> words = organizer.createList();

    // descriptionがnullのものは返ってこない
    expect(words.length, 1);
    expect(words.first.id, word_1.id);
  });
}

// mock
class DummyWordRepository implements WordRepository {
  List<Word> words = [];

  @override
  List<Word> fetch() {
    return words;
  }
}
