import 'package:uuid/uuid.dart';

class Word {
  Word(this.title);

  String id = Uuid().v4();
  String title;
  String? description;
  String? urlString;
}
