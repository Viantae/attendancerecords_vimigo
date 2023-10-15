import 'package:flutter/material.dart';
import 'people.dart';

//List View
class ContentPage extends StatelessWidget {
  final Person person; // Accept a Person object as a parameter
  ContentPage(this.person);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double tileHeight = screenHeight * 0.13;

    return SizedBox(
      height: tileHeight,
      child: ListTile(
        leading: CircleAvatar(
          radius: tileHeight * 0.27,
          backgroundColor: const Color(0xff764abc),
          child: Text(person.name), // Access person's name
        ),
        title: Text(person.name), // Access person's name
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(person.phone, style: const TextStyle(height: 1.5)), // Access person's phone
            Text(person.time, style: const TextStyle(height: 1.5)), // Access person's time
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_sharp),
          onPressed: () {
            // Add your logic to handle the tap event here
          },
        ),
      ),
    );
  }
}
