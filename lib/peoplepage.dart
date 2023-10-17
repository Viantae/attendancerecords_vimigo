  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'people.dart';
  import 'search.dart';
  import 'content.dart';
  import 'addpplpage.dart';


  class PeoplePage extends StatefulWidget {
    PeoplePage({Key? key}) : super(key: key);

    @override
    _MyAppState createState() => _MyAppState();
  }

  class _MyAppState extends State<PeoplePage> {
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
            title: Text('Attendance Records Demo'),
            backgroundColor: const Color.fromARGB(255, 255, 119, 0),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Transform.scale(scale: 1.22, child: Icon(Icons.search)),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: Searchbar(loadedPeople),
                  );
                },
              )
            ],
          ),
          floatingActionButton: customfloatingButton( 
            label: 'Add',
            iconData: Icons.person_add_rounded,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPeoplePage()),
              ).then((_) {
                // This code runs after returning from AddPeoplePage
                updateState(); // Refresh List
              });
            },
          ),
          body: ListView.builder(
            itemCount: loadedPeople.length,
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
                Text('Name: ${loadedPeople[index].name}'),
                Text('ID Number: ${loadedPeople[index].id}'),
                Text('Phone Number: ${loadedPeople[index].phone}'),
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
          ),
        ),
      );
    }
  }