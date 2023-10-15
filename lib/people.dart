import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//Person attributes
class Person {
  String id, name, phone, time;
  Person
  (
      {
        required this.id,
        required this.name,
        required this.phone,
        required this.time}
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'time': time,
    };
  }

  // Create a Person object from a JSON map
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      time: json['time'] as String,
    );
  }
}

class PeopleProvider extends ChangeNotifier {
  List<Person> _people;

  PeopleProvider(List<Person> initialPeople) : _people = initialPeople;

  List<Person> get peopleList => _people; //returns the list of people
  void addPerson(Person person) {
    _people.add(person);
    notifyListeners();
  }

  void removePerson(Person person) {
    _people.remove(person);
    notifyListeners();
  }
}

class PeopleRepository { //stores the list in memory and saves it
  static const _key = 'people_key';

  Future<void> savePeople(List<Person> people) async {
    final prefs = await SharedPreferences.getInstance();
    final peopleJson = people.map((person) => json.encode(person.toJson())).toList();
    await prefs.setStringList(_key, peopleJson);
  }

  Future<List<Person>> loadPeople() async {
    final prefs = await SharedPreferences.getInstance();
    final peopleJson = prefs.getStringList(_key);

    if (peopleJson != null) {
      return peopleJson.map((json) => Person.fromJson(jsonDecode(json))).toList();
    }

    return [];
  }
}

