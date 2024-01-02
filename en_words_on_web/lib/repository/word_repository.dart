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
        title: 'premise',
        description: '前提',
        urlString:
            'https://statsbomb.com/articles/soccer/introducing-hops-a-new-way-to-evaluate-heading-ability/'),
    Word(
        title: 'aggression',
        description: '攻撃',
        urlString:
            'https://statsbomb.com/articles/soccer/introducing-hops-a-new-way-to-evaluate-heading-ability/'),
    Word(
        title: 'strive',
        description: '努力する',
        urlString:
            'https://statsbomb.com/articles/soccer/introducing-hops-a-new-way-to-evaluate-heading-ability/'),
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
