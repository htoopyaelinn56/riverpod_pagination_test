import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_pagination_test/item.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_pagination_test/main.dart';

final itemList = StateProvider<List<Data>>((ref) => []);

final pageProvider = StateProvider<int>((ref) => 1);

final getItemProvider = FutureProvider<Item>((ref) async {
  print('in api ${ref.read(pageProvider)}');
  var response = await http.get(
    Uri.parse(
        'https://api.instantwebtools.net/v1/passenger?page=${ref.read(pageProvider)}&size=10'),
  );

  print('page : ${ref.read(pageProvider)}');
  var result = Item.fromJson(jsonDecode(response.body));
  if (response.statusCode == 200) {
    if (ref.read(pageProvider) < maxPage) {
      ref.read(itemList).addAll(result.data!);
      print('return response ${ref.read(pageProvider)}');
      ref.read(pageProvider.state).state++;
      return result;
    }
  }
  throw Exception('IO Exception');
});
