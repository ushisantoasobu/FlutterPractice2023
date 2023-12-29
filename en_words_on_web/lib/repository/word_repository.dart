import 'package:en_words_on_web/model/word.dart';

class WordRepository {
  // singleton: テスト用のため
  static final WordRepository _instance = WordRepository._internal();

  factory WordRepository() {
    return _instance;
  }

  WordRepository._internal();

  List<Word> words = [
    Word(
        title: 'apple',
        description: 'the color is red',
        urlString: "https://www.yahoo.co.jp/"),
    Word(
        title: 'orange',
        description: 'the color is orange',
        urlString: "https://www.yahoo.co.jp/"),
    Word(
        title: 'grape',
        description: 'the color is purple',
        urlString: "https://www.yahoo.co.jp/"),
    Word(
        title: 'pineapple',
        description: 'the color is yellow',
        urlString: "https://www.yahoo.co.jp/"),
  ];

  List<Word> fetch() {
    return words;
  }

  void add(Word word) {
    words.add(word);
    // words.add(Word(
    //     title: 'wine',
    //     description: 'the color is like blood',
    //     urlString: null));
  }
}
