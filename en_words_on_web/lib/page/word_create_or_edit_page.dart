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
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Enter a search term'),
                onChanged: (value) {
                  title = value;
                },
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  child: Text('完了'),
                  onPressed: () {
                    if (title.isEmpty) {
                      return;
                    }

                    Word word = Word(title: title);
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
