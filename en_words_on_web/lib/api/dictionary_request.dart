import 'dart:convert';

import 'package:en_words_on_web/model/dictionary_word.dart';
import 'package:http/http.dart' as http;

class DictionaryRequest {
  Future<DictionaryResponse> fetch(String word) async {
    var url = Uri.https('api.dictionaryapi.dev', 'api/v2/entries/en/$word');
    var response = await http.get(url);
    if (response.statusCode != 200) {
      throw http.ClientException('not success');
    }
    try {
      List<dynamic> decodedList = json.decode(response.body);
      Map<String, dynamic> decodedFirst =
          decodedList.first as Map<String, dynamic>;
      return DictionaryResponse.fromJson(decodedFirst);
    } catch (e) {
      throw Exception('error occured when converting to model');
    }
  }
}

class DictionaryResponse {
  // TODO: lateをつけずに済む方法を調べる
  late List<DictionaryResponseMeaning> meanings;

  DictionaryResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> meaningList = json['meanings'];
    meanings =
        meaningList.map((e) => DictionaryResponseMeaning.fromJson(e)).toList();
  }
}

class DictionaryResponseMeaning {
  // TODO: lateをつけずに済む方法を調べる
  late String partOfSpeech;
  late List<DictionaryResponseMeaningDefinition> definitions;

  DictionaryResponseMeaning.fromJson(Map<String, dynamic> json) {
    partOfSpeech = json['partOfSpeech'];
    List<dynamic> definitionList = json['definitions'];
    definitions = definitionList
        .map((e) => DictionaryResponseMeaningDefinition.fromJson(e))
        .toList();
  }
}

class DictionaryResponseMeaningDefinition {
  String definition;

  DictionaryResponseMeaningDefinition.fromJson(Map<String, dynamic> json)
      : definition = json['definition'];
}
