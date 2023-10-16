import 'package:flutter/material.dart';
import 'people.dart';

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

