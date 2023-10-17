
import 'package:attendancerecords_vimigo/content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'people.dart';
import 'records.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final peopleRepository = PeopleRepository();
  final recordRepository = RecordRepository();
  final List<Person> loadedPeople = await peopleRepository.loadPeople();
  final List<Records> loadedRecords = await recordRepository.loadRecords();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecordProvider(loadedRecords)), // Provide your RecordProvider here
        ChangeNotifierProvider(create: (context) => PeopleProvider(loadedPeople)),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // Provide the navigator key here
        home: Navigate(), // Use the NavigationBar widget
      ),
    ),
  );
}






