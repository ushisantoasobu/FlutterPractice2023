import 'package:en_words_on_web/main.dart';
import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/repository/word_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordCreateOrEditPage extends StatefulWidget {
  const WordCreateOrEditPage({super.key, required this.title});

  final String title;

  @override
  State<WordCreateOrEditPage> createState() => _WordCreateOrEditPageState();
}

class _WordCreateOrEditPageState extends State<WordCreateOrEditPage> {
  String _title = "";
  String _description = "";
  String _urlString = "";
  // bool _canFinish = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          // TODO: Formで囲むと良い？？
          // https://qiita.com/kurun_pan/items/3378875ff034614f381a#form
          // validationの処理などを綺麗に書ける？
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Title'),
                onChanged: (value) {
                  _title = value;
                },
              ),
              const SizedBox(height: 24),
              TextField(
                decoration:
                    const InputDecoration(hintText: 'Description (optional)'),
                onChanged: (value) {
                  _description = value;
                },
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(hintText: 'URL (optional)'),
                onChanged: (value) {
                  _urlString = value;
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(10),
                child: Consumer(builder: (context, ref, child) {
                  return ElevatedButton(
                    child: const Text('完了'),
                    onPressed: () {
                      if (_title.isEmpty) {
                        return;
                      }

                      String? finalDescription =
                          _description.isEmpty ? null : _description;
                      String? finalUrlString =
                          _urlString.isEmpty ? null : _urlString;
                      Word word = Word(
                          title: _title,
                          description: finalDescription,
                          urlString: finalUrlString);
                      // WordRepositoryImpl().add(word);
                      ref.read(wordListProvider.notifier).add(word: word);
                      Navigator.of(context).pop();
                    },
                  );
                }),
              ),
            ],
          )),
    );
  }
}
