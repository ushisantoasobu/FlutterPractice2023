import 'package:en_words_on_web/model/word.dart';

// MEMO:
// repositoryからDataSourceに置き換えたが、
// Riverpodのサイトではrepositoryという名前の例が使われてるのを見つけた
// ref: https://riverpod.dev/ja/docs/cookbooks/testing

class WordDataSource {
  List<Word> fetch() => [];
  void add(Word word) => {};
  void edit(Word word) => {};
}

class WordDataSourceImpl implements WordDataSource {
  // テスト用のためsingletonで
  // 本来はローカルデータベースを用いる
  static final WordDataSourceImpl _instance = WordDataSourceImpl._internal();

  factory WordDataSourceImpl() {
    return _instance;
  }

  WordDataSourceImpl._internal();

  final List<Word> _words = [
    Word.create(
        title: 'premise',
        description: '前提',
        urlString:
            'https://statsbomb.com/articles/soccer/introducing-hops-a-new-way-to-evaluate-heading-ability/'),
    Word.create(
        title: 'aggression',
        description: '攻撃',
        urlString:
            'https://statsbomb.com/articles/soccer/introducing-hops-a-new-way-to-evaluate-heading-ability/'),
    Word.create(
        title: 'strive',
        description: '努力する',
        urlString:
            'https://statsbomb.com/articles/soccer/introducing-hops-a-new-way-to-evaluate-heading-ability/'),
    Word.create(title: 'thrive', description: '繁栄する', urlString: null),
    Word.create(title: 'chevron', description: null, urlString: null),
  ];

  @override
  List<Word> fetch() {
    return _words;
  }

  @override
  void add(Word word) {
    _words.add(word);
  }

  @override
  void edit(Word word) {
    final index = _words.indexWhere((element) => element.id == word.id);
    if (index == -1) {
      return;
    }
    _words[index] = word;
  }
}
