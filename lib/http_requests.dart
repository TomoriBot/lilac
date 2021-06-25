import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/http_models.dart';

Future <List<News>> fetchNews() async {
  final response =
  await http.get(Uri.parse('https://minami.fun/api/news'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new News.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}