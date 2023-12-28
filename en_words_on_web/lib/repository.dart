import 'package:en_words_on_web/model/word.dart';

class WordRepository {
  List<Word> words = [
    Word('1', 'apple'),
    Word('2', 'orange'),
    Word('3', 'grape'),
    Word('4', 'pineapple'),
  ];

  List<Word> fetch() {
    return words;
  }

  void add() {
    words.add(Word('10000', 'wine'));
  }
}
