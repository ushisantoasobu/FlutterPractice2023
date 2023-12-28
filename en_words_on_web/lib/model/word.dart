import 'package:uuid/uuid.dart';

class Word {
  // Word(this.title, this.description, this.urlString);
  Word({required this.title, this.description, this.urlString});

  String id = const Uuid().v4();
  String title;
  String? description;
  String? urlString;
}
