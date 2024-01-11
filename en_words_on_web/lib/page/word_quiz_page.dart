import 'package:en_words_on_web/main.dart';
import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/repository/word_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// about ConsumerStatefulWidget, ref: https://riverpod.dev/docs/concepts/reading#myproviderreadbuildcontext
class WordQuizPage extends ConsumerStatefulWidget {
  // TODO: どうinjectするのが良いのか分からず...
  // ignore: prefer_const_constructors_in_immutables
  WordQuizPage({super.key, required this.repository});

  late final WordRepository repository;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WordQuizPageState();
}

class _WordQuizPageState extends ConsumerState<WordQuizPage> {
  late List<Word> _words;
  int _currentIndex = 0;
  // bool wordIsEmpty = false;
  bool _canSeeDescription = false;
  bool _canGoToLeft = false;
  bool _canGoToRight = false;

  @override
  void initState() {
    super.initState();

    _words = WordQuizOrganizer(words: ref.read(wordListProvider)).createList();
    _updateButtonStatus();
  }

  void _checkTapped() {
    setState(() {
      _canSeeDescription = true;
    });
  }

  void _leftTapped() {
    setState(() {
      _canSeeDescription = false;
      _currentIndex -= 1;
      _updateButtonStatus();
    });
  }

  void _rightTapped() {
    setState(() {
      _canSeeDescription = false;
      _currentIndex += 1;
      _updateButtonStatus();
    });
  }

  void _updateButtonStatus() {
    _canGoToLeft = _currentIndex > 0;
    _canGoToRight = _currentIndex < _words.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('クイズ')),
        // title: Text(AppLocalizations.of(context)!.helloWorld)),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Column(children: [
              Text(_words[_currentIndex].title,
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              AnimatedOpacity(
                  opacity: _canSeeDescription ? 1.0 : 0.0,
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 300),
                  child: Visibility(
                      visible: _canSeeDescription,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Text(_words[_currentIndex].description ?? "",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.red)))),
            ]),
            Expanded(child: Container()),
            Row(children: [
              IconButton(
                  onPressed: _canGoToLeft ? _leftTapped : null,
                  icon: const Icon(Icons.chevron_left)),
              Expanded(child: Container()),
              TextButton(onPressed: _checkTapped, child: const Text('正解を見る')),
              Expanded(child: Container()),
              IconButton(
                  onPressed: _canGoToRight ? _rightTapped : null,
                  icon: const Icon(Icons.chevron_right)),
            ])
          ],
        )));
  }
}

class WordQuizOrganizer {
  WordQuizOrganizer({
    required List<Word> words,
  }) : _words = words;

  final List<Word> _words;

  List<Word> createList() {
    // TODO: 仮
    List<Word> list =
        _words.where((element) => element.description != null).toList();
    list.shuffle();
    return list;
  }
}
