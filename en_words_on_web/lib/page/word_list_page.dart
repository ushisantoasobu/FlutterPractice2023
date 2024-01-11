import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/page/word_create_or_edit_page.dart';
import 'package:en_words_on_web/page/word_detail_page.dart';
import 'package:en_words_on_web/page/word_quiz_page.dart';
import 'package:en_words_on_web/repository/word_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:en_words_on_web/main.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({super.key, required this.title});

  final String title;

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
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
                  return WordQuizPage(repository: WordRepositoryImpl());
                }));
              },
              icon: const Icon(Icons.quiz))
        ],
      ),
      body: Consumer(builder: (context, ref, child) {
        return ListView.separated(
          itemCount: ref.watch(wordListProvider).length,
          itemBuilder: (BuildContext context, int index) {
            return WordItemView(
              word: ref.watch(wordListProvider)[index],
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return WordDetailPage(
                    word: ref.watch(wordListProvider)[index],
                  );
                }));
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(height: 1);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const WordCreateOrEditPage(
              title: '作成',
            );
          }));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WordItemView extends StatelessWidget {
  const WordItemView({super.key, required Word word, Function()? onTap})
      : _word = word,
        _onTap = onTap;

  final Word _word;
  final Function()? _onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _onTap?.call();
        },
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _word.title,
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold),
                ),
                if (_word.description != null)
                  Text(_word.description ?? '（未設定）')
                else
                  const Text(
                    '（未設定）',
                    style: TextStyle(color: Colors.grey),
                  )
              ],
            )));
  }
}
