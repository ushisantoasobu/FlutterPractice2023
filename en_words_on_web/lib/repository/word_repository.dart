import 'package:en_words_on_web/model/word.dart';

class WordRepository {
  List<Word> fetch() => [];
}

class WordRepositoryImpl implements WordRepository {
  // singleton: テスト用のため
  static final WordRepositoryImpl _instance = WordRepositoryImpl._internal();

  factory WordRepositoryImpl() {
    return _instance;
  }

  WordRepositoryImpl._internal();

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
    Word(title: 'thrive', description: '繁栄する', urlString: null),
    Word(title: 'chevron', description: null, urlString: null),
  ];

  @override
  List<Word> fetch() {
    return words;
  }

  void add(Word word) {
    words.add(word);
  }
}
