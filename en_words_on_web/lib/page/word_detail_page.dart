import 'package:en_words_on_web/model/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WordDetailPage extends StatelessWidget {
  const WordDetailPage({super.key, required this.word});

  final Word word;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(word.title),
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('単語'),
              Text(
                word.title,
                style:
                    const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              // Description
              const Text('意味'),
              Text(
                word.description ?? '-',
                style: const TextStyle(fontSize: 16),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('check'),
              ),
              const SizedBox(height: 24),
              // URL
              const Text('URL'),
              Text(
                word.urlString ?? '-',
                style: const TextStyle(fontSize: 12),
              ),
            ])));
  }
}
