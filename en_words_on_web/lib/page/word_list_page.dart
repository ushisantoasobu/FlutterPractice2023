import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/page/word_create_or_edit_page.dart';
import 'package:en_words_on_web/page/word_detail_page.dart';
import 'package:en_words_on_web/page/word_quiz_page.dart';
import 'package:en_words_on_web/repository/word_repository.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({super.key, required this.title});

  final String title;

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  WordRepository repository = WordRepository();
  late List<Word> _words; // lateは強引？

  _WordListPageState() {
    _words = repository.fetch();
  }

  void _refresh() {
    setState(() {
      _words = repository.fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return WordQuizPage();
                }));
              },
              icon: const Icon(Icons.quiz))
        ],
      ),
      body: ListView.builder(
        itemCount: _words.length,
        itemBuilder: (BuildContext context, int index) {
          return WordItemView(
            word: _words[index],
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return WordDetailPage(
                  word: _words[index],
                );
              })).then((value) {
                _refresh();
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const WordCreateOrEditPage(
              title: '作成',
            );
          })).then((value) {
            _refresh();
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WordItemView extends StatelessWidget {
  const WordItemView({super.key, required this.word, this.onTap});

  final Word word;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onTap?.call();
        },
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word.title,
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold),
                ),
                Text(word.description ?? '')
              ],
            )));
  }
}
