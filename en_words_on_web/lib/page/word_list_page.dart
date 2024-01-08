import 'dart:io';

import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/page/word_create_or_edit_page.dart';
import 'package:en_words_on_web/page/word_detail_page.dart';
import 'package:en_words_on_web/page/word_quiz_page.dart';
import 'package:en_words_on_web/repository/word_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({super.key, required this.title});

  final String title;

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  WordRepository repository = WordRepositoryImpl();
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
    if (Platform.isAndroid) {
      // Android
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
        body: ListView.separated(
          itemCount: _words.length,
          itemBuilder: (BuildContext context, int index) {
            return WordItemView(
              word: _words[index],
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return WordDetailPage(
                    word: _words[index],
                  );
                })).then((value) {
                  _refresh();
                });
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(height: 1);
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
    } else {
      // iOS
      return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return WordQuizPage(repository: WordRepositoryImpl());
                }));
              },
              child: const Icon(
                CupertinoIcons.question,
                color: CupertinoColors.black,
              ),
            ),
            middle: Text(widget.title),
            trailing: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const WordCreateOrEditPage(
                    title: '作成',
                  );
                })).then((value) {
                  _refresh();
                });
              },
              child: const Icon(
                CupertinoIcons.add,
                color: CupertinoColors.black,
              ),
            ),
          ),
          child: ListView.separated(
            itemCount: _words.length,
            itemBuilder: (BuildContext context, int index) {
              return WordItemView(
                word: _words[index],
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return WordDetailPage(
                      word: _words[index],
                    );
                  })).then((value) {
                    _refresh();
                  });
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(height: 1);
            },
          ));
    }
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
                if (word.description != null)
                  Text(word.description ?? '（未設定）')
                else
                  const Text(
                    '（未設定）',
                    style: TextStyle(color: Colors.grey),
                  )
              ],
            )));
  }
}
