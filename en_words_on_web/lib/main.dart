import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/page/word_list_page.dart';
import 'package:en_words_on_web/repository/word_repository.dart';
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
