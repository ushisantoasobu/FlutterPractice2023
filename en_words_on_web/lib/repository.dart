import 'package:en_words_on_web/model/word.dart';

class WordRepository {
  List<Word> words = [
    Word('apple'),
    Word('orange'),
    Word('grape'),
    Word('pineapple'),
  ];

  List<Word> fetch() {
    return words;
  }

  void add() {
    words.add(Word('wine'));
  }
}
