class DictionaryWord {
  // Word(this.title, this.description, this.urlString);
  DictionaryWord({required this.content});

  String content;

  DictionaryWord.fromJson(Map<String, dynamic> json)
      : content = json['meanings'];
}
