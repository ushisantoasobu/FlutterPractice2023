import 'package:en_words_on_web/data/word_list.dart';
import 'package:en_words_on_web/model/word.dart';
import 'package:en_words_on_web/page/word_list_page.dart';
import 'package:en_words_on_web/repository/word_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wordListProvider = StateNotifierProvider<WordList, List<Word>>(
    (ref) => WordList([], dataSource: WordDataSourceImpl()));

// TODO: 一覧画面のstateをListで管理していて、詳細画面で個別のitemを監視する方法は、、、これで良い？
final wordProvider = Provider.family<Word, String>((ref, wordId) {
  return ref
      .watch(wordListProvider)
      .firstWhere((element) => element.id == wordId);
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', ''),
        Locale('en', ''),
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WordListPage(title: '俺の単語帳'),
    );
  }
}
