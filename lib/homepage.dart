import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'people.dart';
import 'search.dart';
import 'content.dart';
import 'addpplpage.dart';


class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // A variable to hold the loaded people
  List<Person> loadedPeople = [];

  void updateState() {
  setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access the PeopleProvider to retrieve the list of people
    final peopleProvider = Provider.of<PeopleProvider>(context);

    // Update the loadedPeople whenever the dependencies change
    loadedPeople = peopleProvider.peopleList;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Record Demo'),
          backgroundColor: const Color.fromARGB(255, 255, 119, 0),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Transform.scale(scale: 1.22, child: Icon(Icons.search)),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchPeople(loadedPeople),
                );
              },
            )
          ],
        ),
        floatingActionButton: LayoutBuilder(
          builder: (context, constraints) {
            return FractionallySizedBox(
              widthFactor: 0.3,
              heightFactor: 0.09,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,MaterialPageRoute
                    (builder: (context) => addpplPage())).then
                    (
                      (_) 
                      {// This code runs after returning from addpplPage
                        updateState(); // Refresh List
                      }
                    );
                },
                label: Text('Add', style: TextStyle(fontSize: 16.0)),
                icon: Transform.scale(scale: 1.25, child: Icon(Icons.person_add_rounded)),
                backgroundColor: const Color(0xff764abc),
                foregroundColor: Colors.white,
              ),
            );
          },
        ),
        body: ListView.builder(
          itemCount: loadedPeople.length,
          itemBuilder: (context, index) {
            return ContentPage(loadedPeople[index]);
          },
        ),
      ),
    );
  }
}