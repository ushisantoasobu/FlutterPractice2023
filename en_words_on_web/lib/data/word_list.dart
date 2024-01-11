import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/repository/word_repository.dart';
import 'package:riverpod/riverpod.dart';

class WordList extends StateNotifier<List<Word>> {
  // TODO: repositoryはいらない??
  WordList() : super(WordRepositoryImpl().fetch());
  void changeState(state) => this.state = state;

  void add({required Word word}) {
    // TODO: この書き方は？
    state = [...state, word];
  }
}
