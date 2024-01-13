import 'package:uuid/uuid.dart';

class Word {
  Word(this.id, this.title, this.description, this.urlString);

  // TODO: いい名前が思いつかない。コンストラクタ周りは整理する
  Word.create({required this.title, this.description, this.urlString})
      : id = const Uuid().v4();

  final String id; // = const Uuid().v4();
  final String title;
  final String? description;
  final String? urlString;

  Word updated(String title, String? description, String? urlString) {
    return Word(id, title, description, urlString);
  }
}
