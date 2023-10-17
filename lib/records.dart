import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//Records attributes
class Records {
  String id, checkinTime, date;
  bool isPresent;

  Records({
    required this.id,
    required this.checkinTime,
    required this.date,
    required this.isPresent,
  });

  // Add a factory constructor to create a Records from JSON
  factory Records.fromJson(Map<String, dynamic> json) {
    return Records(
      id: json['id'] as String,
      checkinTime: json['checkinTime'] as String,
      date: json['date'] as String,
      isPresent: json['isPresent'] as bool,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkinTime': checkinTime,
      'date': date,
      'isPresent': isPresent
    };
  }
}

class RecordProvider extends ChangeNotifier {
  List<Records> _record;

  RecordProvider(List<Records> initialRecords) : _record = initialRecords;

  List<Records> get recordList => _record; //returns the list of attendance records
  void addRecords(Records Records) {
    _record.add(Records);
    notifyListeners();
  }

  void removeRecords(Records Records) {
    _record.remove(Records);
    notifyListeners();
  }
}

class RecordRepository { //stores the list in memory and saves it
  static const _key = 'record_key';
  Future<void> saveRecords(List<Records> record) async {
    final prefs = await SharedPreferences.getInstance();
    final recordJson = record.map((Records) => json.encode(Records.toJson())).toList();
    await prefs.setStringList(_key, recordJson);
  }

  Future<List<Records>> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordJson = prefs.getStringList(_key);

    if (recordJson != null) {
      return recordJson.map((json) => Records.fromJson(jsonDecode(json))).toList();
    }

    return [];
  }
}