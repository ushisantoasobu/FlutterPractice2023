import 'package:en_words_on_web/dataSource/word_data_source.dart';
import 'package:en_words_on_web/model/word.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
part 'iser_word.g.dart';

@collection
class IserWord {
  Id id = Isar.autoIncrement;
  String title = '';
  String? description;
  String? urlString;
}

// TODO: 別のファイルに

Isar? isar;

class Temp {
  Future<Isar> setupIsar() async {
    print('setupIsar');
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [IserWordSchema],
      directory: dir.path,
    );
  }

  Future<List<IserWord?>> fetch() async {
    isar ??= await setupIsar();
    return isar!.iserWords.where().findAll();
  }

  Future<void> add(IserWord word) async {
    isar ??= await setupIsar();
    await isar!.writeTxn(() async {
      await isar!.iserWords.put(word);
    });
  }
}
