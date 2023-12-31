import 'package:en_words_on_web/api/dictionary_request.dart';
import 'package:en_words_on_web/model/dictionary_word.dart';
import 'package:en_words_on_web/model/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class WordDetailPage extends StatefulWidget {
  const WordDetailPage({super.key, required this.word});

  final Word word;

  @override
  State<StatefulWidget> createState() {
    return _WordDetailPageState();
  }
}

class _WordDetailPageState extends State<WordDetailPage> {
  bool wordDictionaryError = false;
  DictionaryWord? wordDictionary;
  bool wordDictionaryLoading = false;

  void _showLoading() {
    setState(() {
      wordDictionaryLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      wordDictionaryLoading = false;
    });
  }

  void _setWordDictionary(String content) {
    setState(() {
      wordDictionaryError = false;
      wordDictionary = DictionaryWord(content: content);
    });
  }

  void _showWordDictionaryError() {
    setState(() {
      wordDictionaryError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.word.title),
        ),
        body: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Card(
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('単語'),
                            const SizedBox(height: 8),
                            Text(
                              widget.word.title,
                              style: const TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.bold),
                            ),
                          ]))),
              const SizedBox(height: 16),
              // Description
              Card(
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('意味'),
                            const SizedBox(height: 8),
                            Text(
                              widget.word.description ?? '-',
                              style: const TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 24),
                            OutlinedButton(
                              onPressed: () {
                                _showLoading();
                                // DictionaryRequest().fetch('hogehoge').then((value) {
                                DictionaryRequest()
                                    .fetch(widget.word.title)
                                    .then((response) {
                                  _hideLoading();
                                  _setWordDictionary(response.meanings.first
                                      .definitions.first.definition);
                                }).catchError((e) {
                                  _hideLoading();
                                  _showWordDictionaryError();
                                });
                              },
                              child: wordDictionaryLoading
                                  ? const Text('loading...')
                                  : const Text('check'),
                            ),
                            Visibility(
                              visible: wordDictionary != null,
                              maintainSize: false,
                              child: Text(wordDictionary?.content ?? ''),
                            ),
                            Visibility(
                              visible: wordDictionaryError,
                              maintainSize: false,
                              child: const Text('エラーが発生しました'),
                            )
                          ]))),
              const SizedBox(height: 16),
              // URL
              Card(
                  child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('URL'),
                            const SizedBox(height: 8),
                            Text(
                              widget.word.urlString ?? '-',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 24),
                            if (widget.word.urlString != null)
                              OutlinedButton(
                                onPressed: () {
                                  if (widget.word.urlString != null) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("確認"),
                                          content: const Text("ブラウザで開きますか？"),
                                          actions: [
                                            TextButton(
                                              child: const Text("Cancel"),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            TextButton(
                                              child: const Text("OK"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _launchInBrowserView(
                                                    widget.word.urlString!);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: const Text('開く'),
                              ),
                          ]))),
            ])));
  }

  Future<void> _launchInBrowserView(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}
