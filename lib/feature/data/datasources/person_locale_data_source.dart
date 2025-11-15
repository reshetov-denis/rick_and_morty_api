import 'dart:convert';

import 'package:rick_and_morty_api/core/error/exception.dart';
import 'package:rick_and_morty_api/feature/data/models/person_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersonLocaleDataSource {
  /// Gets the cached [List<PersonModel>] which was gotten the last time
  /// the user had an internet connection.
  /// 
  /// Throws a [CacheException] if no cached data is present.

  Future<List<PersonModel>> getLastPersonsFromCache();
  Future<void> personsToCache(List<PersonModel> persons);
}

const CACHED_PERSONS_LIST = 'CACHED_PERSONS_LIST';

class PersonLocaleDataSourceImpl implements PersonLocaleDataSource {
  final SharedPreferences sharedPreferences; 

  PersonLocaleDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PersonModel>> getLastPersonsFromCache() {
    final jsonPersonsList = sharedPreferences.getStringList(CACHED_PERSONS_LIST);
    if (jsonPersonsList != null && jsonPersonsList.isNotEmpty) {
      print('Persons retrieved from cache: ${jsonPersonsList.length}');
      return Future.value(jsonPersonsList
        .map<PersonModel>((jsonPerson) => PersonModel.fromJson(
          json.decode(jsonPerson)))
        .toList());
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> personsToCache(List<PersonModel> persons) {
    final List<String> jsonPersonsList = persons
      .map<String>((person) => json.encode(person.toJson())).toList()
      .toList();
    
    sharedPreferences.setStringList(CACHED_PERSONS_LIST, jsonPersonsList);
    print('Persons cached: ${jsonPersonsList.length}');
    return Future.value(jsonPersonsList);
  }
}