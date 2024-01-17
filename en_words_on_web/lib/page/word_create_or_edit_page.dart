import 'package:en_words_on_web/main.dart';
import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/dataSource/word_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordCreateOrEditPage extends StatefulWidget {
  WordCreateOrEditPage({super.key, this.originalWord});

  final Word? originalWord;

  @override
  State<WordCreateOrEditPage> createState() => _WordCreateOrEditPageState();
}

class _WordCreateOrEditPageState extends State<WordCreateOrEditPage> {
  String _title = "";
  String _description = "";
  String _urlString = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final originalWord = widget.originalWord;
    if (originalWord != null) {
      _title = originalWord.title;
      _description = originalWord.description ?? "";
      _urlString = originalWord.urlString ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.originalWord == null ? '作成' : '編集'),
      ),
      body: Form(
          key: _formKey,
          child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _title,
                    decoration: const InputDecoration(
                        labelText: '単語', hintText: '例）Apple'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '入力必須項目です!';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _title = value;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: _description,
                    decoration: const InputDecoration(
                        labelText: '説明 (省略可)', hintText: '例）リンゴ'),
                    onChanged: (value) {
                      _description = value;
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    initialValue: _urlString,
                    decoration: const InputDecoration(labelText: 'URL (省略可)'),
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
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            // validate成功
                          } else {
                            return;
                          }

                          // Formのsave()でやるべき？？
                          String? finalDescription =
                              _description.isEmpty ? null : _description;
                          String? finalUrlString =
                              _urlString.isEmpty ? null : _urlString;

                          final originalWord = widget.originalWord;
                          if (originalWord == null) {
                            final word = Word.create(
                                title: _title,
                                description: finalDescription,
                                urlString: finalUrlString);
                            ref.read(wordListProvider.notifier).add(word: word);
                          } else {
                            final word = Word(originalWord.id, _title,
                                finalDescription, finalUrlString);
                            ref
                                .read(wordListProvider.notifier)
                                .edit(word: word);
                          }
                          Navigator.of(context).pop();
                        },
                      );
                    }),
                  ),
                ],
              ))),
    );
  }
}
