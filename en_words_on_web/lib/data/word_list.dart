import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/repository/word_data_source.dart';
import 'package:riverpod/riverpod.dart';

class WordList extends StateNotifier<List<Word>> {
  WordList(super._state, {required WordDataSource dataSource}) {
    _dataSource = dataSource;
    state = _dataSource.fetch();
  }

  late WordDataSource _dataSource;

  void add({required Word word}) {
    _dataSource.add(word);
    final words = _dataSource.fetch();
    state = [];
    state = words;
  }

  void edit({required Word word}) {
    _dataSource.edit(word);
    final words = _dataSource.fetch();
    state = [];
    state = words;
  }
}
