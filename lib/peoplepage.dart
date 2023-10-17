import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
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

  void showSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

  void deletePerson(Person person){
    final peopleProvider = Provider.of<PeopleProvider>(context, listen: false);
    peopleProvider.removePerson(person);
  }

  void sharePerson(Person person)async {
  final String phonenum = 'tel:${person.phone}';

  Share.share(phonenum, subject: 'Share Contact Information');
}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access the PeopleProvider to retrieve the list of people
    final peopleProvider = Provider.of<PeopleProvider>(context);

    // Update the loadedPeople whenever the dependencies change
    loadedPeople = peopleProvider.peopleList;
  }

void showPopupMenu(BuildContext context, Person person) {
  showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          width: 200, 
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                  onTap: () {
                    Navigator.of(context).pop();
                    sharePerson(person);
                    showSuccessDialog(context, "Shared Sucessfully");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                  onTap: () {
                    deletePerson(person);
                    Navigator.of(context).pop();
                    updateState();
                    showSuccessDialog(context, "Deleted Sucessfully");
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
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
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showPopupMenu(context, loadedPeople[index]);
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