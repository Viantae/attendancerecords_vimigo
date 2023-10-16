import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'people.dart';
import 'homepage.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final peopleRepository = PeopleRepository();
  final List<Person> loadedPeople = await peopleRepository.loadPeople();
  runApp(
    ChangeNotifierProvider(
      create: (context) => PeopleProvider(loadedPeople),
      child: MaterialApp(
        navigatorKey: navigatorKey, // Provide the navigator key here
        home: MyApp(),
      ),
    ),
  );
}



