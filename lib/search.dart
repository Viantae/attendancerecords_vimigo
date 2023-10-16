import 'content.dart';
import 'package:flutter/material.dart';
import 'people.dart';
import 'records.dart';

class Searchbar extends SearchDelegate<String> {
  final List items;

  Searchbar(this.items);

  @override
  String get searchFieldLabel => 'Search Here...';

  @override
  TextStyle get searchFieldStyle => TextStyle(color: Colors.white);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme:
          const AppBarTheme(backgroundColor: Color.fromARGB(255, 255, 119, 0)),
      primaryColor:
          const Color.fromARGB(255, 226, 137, 3), // Change the app bar color
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.black),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = items.where((item){
        if (item is Person) {
          final person = item as Person;
          return person.name.toLowerCase().contains(query.toLowerCase());
        }
        else if(item is Records){
          final record = item as Records;
          return record.id.contains(query);
        }
        return false;
  }).toList();

    if (results.isEmpty) {
      return Center(
        child: Text('No results found for "$query" '),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        if (results[index] is Person) {
          final person = results[index] as Person;
          List<Widget> contentWidgets = [
            const CircleAvatar(
              backgroundColor: const Color(0xff764abc),
              radius: 30.0,
              child: Icon(Icons.person),
            ),
            Text('Name: ${person.name}'),
            Text('ID Number: ${person.id}'),
            Text('Phone Number: ${person.phone}'),
            IconButton(
              icon: Icon(Icons.arrow_forward_sharp),
              onPressed: () {
                // Handle the button click
              },
            ),
          ];
          return ContentPage(contentWidgets);
        } else if (results[index] is Records) {
          final record = results[index] as Records;
          {
            // Create a list of content widgets for each Records
            List<Widget> contentWidgets = [
              const CircleAvatar(
                // backgroundImage: AssetImage('your_image_path'),
                backgroundColor: const Color(0xff764abc),
                radius: 30.0,
                child: Icon(
                  Icons.receipt,
                ),
              ),
              Text('Date: ${record.date}'),
              Text('Present: ${record.isPresent}'),
              Text('Checked in: ${record.checkinTime}'),
              Text('ID Number: ${record.id}'),
              IconButton(
                icon: Icon(Icons.arrow_forward_sharp),
                onPressed: () {
                  // Handle the button click
                },
              ),
            ];
            return ContentPage(contentWidgets);
          }
        }
        else{
          return const Center(
            child: Text('Search scope not defined'),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Type to search'),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }
}