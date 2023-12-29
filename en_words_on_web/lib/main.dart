import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/repository.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          return WordItemView(
            word: _words[index],
            onTap: () {
              if (_words[index].urlString != null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("確認"),
                      content: const Text("ブラウザで開きますか？"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                            _launchInBrowserView(_words[index].urlString!);
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _launchInBrowserView(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
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
                Text(word.description ?? '')
              ],
            )));
  }
}
