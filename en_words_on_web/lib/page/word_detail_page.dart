import 'package:en_words_on_web/api/dictionary_request.dart';
import 'package:en_words_on_web/main.dart';
import 'package:en_words_on_web/model/dictionary_word.dart';
import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/page/word_create_or_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: ConsumerStatefulWidgetは全画面再構築になると思うが、、、これくらいの画面であれば問題ない？？
class WordDetailPage extends ConsumerStatefulWidget {
  const WordDetailPage({super.key, required this.wordId});

  final String wordId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _WordDetailPageState();
  }
}

class _WordDetailPageState extends ConsumerState<WordDetailPage> {
  bool _wordDictionaryError = false;
  DictionaryWord? _wordDictionary;
  bool _wordDictionaryLoading = false;

  void _showLoading() {
    setState(() {
      _wordDictionaryLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      _wordDictionaryLoading = false;
    });
  }

  void _setWordDictionary(String content) {
    setState(() {
      _wordDictionaryError = false;
      _wordDictionary = DictionaryWord(content: content);
    });
  }

  void _showWordDictionaryError() {
    setState(() {
      _wordDictionaryError = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(ref.watch(wordProvider(widget.wordId)).title),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return WordCreateOrEditPage(
                        originalWord: ref.watch(wordProvider(widget.wordId)));
                  }));
                },
                icon: const Icon(Icons.edit))
          ],
        ),
        body: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  ref.watch(wordProvider(widget.wordId)).title,
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
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
                                  ref
                                          .watch(wordProvider(widget.wordId))
                                          .description ??
                                      '-',
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 24),
                                OutlinedButton(
                                  onPressed: () {
                                    _showLoading();
                                    // DictionaryRequest().fetch('hogehoge').then((value) {
                                    DictionaryRequest()
                                        .fetch(ref
                                            .watch(wordProvider(widget.wordId))
                                            .title)
                                        .then((response) {
                                      _hideLoading();
                                      _setWordDictionary(response.meanings.first
                                          .definitions.first.definition);
                                    }).catchError((e) {
                                      _hideLoading();
                                      _showWordDictionaryError();
                                    });
                                  },
                                  child: _wordDictionaryLoading
                                      ? const Text('loading...')
                                      : const Text('check'),
                                ),
                                Visibility(
                                  visible: _wordDictionary != null,
                                  maintainSize: false,
                                  child: Text(_wordDictionary?.content ?? ''),
                                ),
                                Visibility(
                                  visible: _wordDictionaryError,
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
                                  ref
                                          .watch(wordProvider(widget.wordId))
                                          .urlString ??
                                      '-',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(height: 24),
                                if (ref
                                        .watch(wordProvider(widget.wordId))
                                        .urlString !=
                                    null)
                                  OutlinedButton(
                                    onPressed: () {
                                      if (ref
                                              .watch(
                                                  wordProvider(widget.wordId))
                                              .urlString !=
                                          null) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("確認"),
                                              content:
                                                  const Text("ブラウザで開きますか？"),
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
                                                    _launchInBrowserView(ref
                                                        .watch(wordProvider(
                                                            widget.wordId))
                                                        .urlString!);
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
                ]))));
  }

  Future<void> _launchInBrowserView(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}
