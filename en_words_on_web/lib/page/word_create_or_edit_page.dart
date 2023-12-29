import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/repository/word_repository.dart';
import 'package:flutter/material.dart';

class WordCreateOrEditPage extends StatefulWidget {
  const WordCreateOrEditPage({super.key, required this.title});

  final String title;

  @override
  State<WordCreateOrEditPage> createState() => _WordCreateOrEditPageState();
}

class _WordCreateOrEditPageState extends State<WordCreateOrEditPage> {
  String title = "";
  String description = "";
  String urlString = "";
  bool canFinish = false;

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
                  title = value;
                },
              ),
              const SizedBox(height: 24),
              TextField(
                decoration:
                    const InputDecoration(hintText: 'Description (optional)'),
                onChanged: (value) {
                  description = value;
                },
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: const InputDecoration(hintText: 'URL (optional)'),
                onChanged: (value) {
                  urlString = value;
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  child: const Text('完了'),
                  onPressed: () {
                    if (title.isEmpty) {
                      return;
                    }

                    String? finalDescription =
                        description.isEmpty ? null : description;
                    String? finalUrlString =
                        urlString.isEmpty ? null : urlString;
                    Word word = Word(
                        title: title,
                        description: finalDescription,
                        urlString: finalUrlString);
                    WordRepository().add(word);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          )),
    );
  }
}
