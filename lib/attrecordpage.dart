import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'people.dart';

class AttHead extends StatefulWidget {
  AttHead({Key? key}) : super(key: key);

  @override
  _AttHeadState createState() => _AttHeadState();
}

class _AttHeadState extends State<AttHead> {
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
                /* SEARCH FOR RECORD ID
                showSearch(
                  context: context,
                  delegate: SearchPeople(loadedPeople),
                );
                */
              },
            )
          ],
        ),
        floatingActionButton: LayoutBuilder(
          builder: (context, constraints) {
            return const FractionallySizedBox(
              widthFactor: 0.3,
              heightFactor: 0.09,
              /*
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,MaterialPageRoute
                    (builder: (context) => AddPeoplePage())).then
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
              */
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


//List View
class ContentPage extends StatelessWidget {
  final Person person; // Accept a Person object as a parameter
  const ContentPage(this.person, {super.key});


  Widget _TextWithPadding(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Text(text, style: const TextStyle(height: 1.3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double tileHeight = screenHeight * 0.12;

    return Column(
      children: [
        SizedBox(
          height: tileHeight,
          child: ListTile(
            leading: CircleAvatar(
              radius: tileHeight * 0.27,
              backgroundColor: const Color(0xff764abc),
              child: Text( 
                person.name, // Picture here
                style: const TextStyle(height: 1.5),
              ),
            ),
            title: _TextWithPadding('Name: ${person.name}'), // Name here
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _TextWithPadding('ID Number: ${person.id}'), // ID here
                _TextWithPadding('Phone Number: ${person.phone}'), // Phone Number here
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_sharp),
              onPressed: () {
                // See people attendance records
              },
            ),
          ),
        ),
        const Divider(
          height: 2, // Make it thicker
          color: Colors.black, 
        ),
      ],
    );
  }
}