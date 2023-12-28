import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/repository.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WordListPage(title: '俺の単語帳'),
    );
  }
}

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

  void _addItem() {
    setState(() {
      repository.add();
      _words = repository.fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _words.length,
        itemBuilder: (BuildContext context, int index) {
          return WordItemView(word: _words[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WordItemView extends StatelessWidget {
  const WordItemView({super.key, required this.word});

  final Word word;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word.title,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const Text('hoge')
          ],
        ));
  }
}
