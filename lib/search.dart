import 'content.dart';
import 'package:flutter/material.dart';
import 'people.dart';

class SearchPeople extends SearchDelegate<String> {
  final List<Person> people;

  SearchPeople(this.people);

//placeholder text
  @override
  String get searchFieldLabel => 'Search People';

//User input text color
  @override
  TextStyle get searchFieldStyle => TextStyle(color: Colors.white);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme:
          const AppBarTheme(backgroundColor:Color.fromARGB(255, 255, 119, 0)),
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
    final results = people
        .where((person) => person.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text('No results found for "$query" '),
      );
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
            // Create a list of content widgets for each person
            List<Widget> contentWidgets = [
              const CircleAvatar(
                // backgroundImage: AssetImage('your_image_path'),
                backgroundColor: const Color(0xff764abc),
                radius: 30.0,
                child: Icon(
                  Icons.person,
                ),
              ),
              Text('Name: ${results[index].name}'),
              Text('ID Number: ${results[index].id}'),
              Text('Phone Number: ${results[index].phone}'),
              IconButton(
                icon: Icon(Icons.arrow_forward_sharp),
                onPressed: () {
                  // Handle the button click
                },
              ),
            ];
            // Pass the contentWidgets to ContentPage
            return ContentPage(contentWidgets);
          },
    );
  }

//text in the middle before search
  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Type the persons name to search'),
    );
  }

// Return to the previous screen
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
