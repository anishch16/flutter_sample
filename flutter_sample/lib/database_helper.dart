// database_helper.dart

import 'dart:convert'; // Import the dart:convert library
import 'package:shared_preferences/shared_preferences.dart';
import 'person.dart';

class DatabaseHelper {
  static const String _personsKey = 'persons';

  Future<List<Person>> getAllPersons() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? personsJsonList = prefs.getStringList(_personsKey);
    if (personsJsonList == null) {
      return [];
    }
    return personsJsonList.map((personJson) {
      final Map<String, dynamic> personMap =
          Map<String, dynamic>.from(jsonDecode(personJson));
      return Person.fromMap(personMap);
    }).toList();
  }

  Future<void> saveAllPersons(List<Person> persons) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> personsJsonList =
        persons.map((person) => jsonEncode(person.toMap())).toList();
    await prefs.setStringList(_personsKey, personsJsonList);
  }
}
