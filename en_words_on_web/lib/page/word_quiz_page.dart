import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/repository/word_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WordQuizPage extends StatefulWidget {
  // TODO: どうinjectするのが良いのか分からず...
  // ignore: prefer_const_constructors_in_immutables
  WordQuizPage({super.key, required this.repository});

  late final WordRepository repository;

  @override
  State<StatefulWidget> createState() => _WordQuizPageState();
}

class _WordQuizPageState extends State<WordQuizPage> {
  late List<Word> words;
  int currentIndex = 0;
  bool wordIsEmpty = false;
  bool canSeeDescription = false;
  bool canGoToLeft = false;
  bool canGoToRight = false;

  @override
  void initState() {
    super.initState();

    words = WordQuizOrganizer(repository: widget.repository).createList();
    _updateButtonStatus();
  }

  void _checkTapped() {
    setState(() {
      canSeeDescription = true;
    });
  }

  void _leftTapped() {
    setState(() {
      canSeeDescription = false;
      currentIndex -= 1;
      _updateButtonStatus();
    });
  }

  void _rightTapped() {
    setState(() {
      canSeeDescription = false;
      currentIndex += 1;
      _updateButtonStatus();
    });
  }

  void _updateButtonStatus() {
    canGoToLeft = currentIndex > 0;
    canGoToRight = currentIndex < words.length - 1;
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
              Text(words[currentIndex].title,
                  style: const TextStyle(
                      fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              AnimatedOpacity(
                  opacity: canSeeDescription ? 1.0 : 0.0,
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 300),
                  child: Visibility(
                      visible: canSeeDescription,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Text(words[currentIndex].description ?? "",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.red)))),
            ]),
            Expanded(child: Container()),
            Row(children: [
              IconButton(
                  onPressed: canGoToLeft ? _leftTapped : null,
                  icon: const Icon(Icons.chevron_left)),
              Expanded(child: Container()),
              TextButton(onPressed: _checkTapped, child: const Text('正解を見る')),
              Expanded(child: Container()),
              IconButton(
                  onPressed: canGoToRight ? _rightTapped : null,
                  icon: const Icon(Icons.chevron_right)),
            ])
          ],
        )));
  }
}

// TODO: 個別のファイルに移す
class WordQuizOrganizer {
  WordQuizOrganizer({
    required WordRepository repository,
  }) : _repository = repository;

  final WordRepository _repository;

  List<Word> createList() {
    // TODO: 仮
    List<Word> list = _repository
        .fetch()
        .where((element) => element.description != null)
        .toList();
    list.shuffle();
    return list;
  }
}
