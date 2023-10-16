import 'package:flutter/material.dart';

//List View
class ContentPage extends StatelessWidget {
  final List<Widget> contentWidgets;
  const ContentPage(this.contentWidgets, {Key? key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double tileHeight = screenHeight * 0.12;

    /*
    Design include:
      - Circular avatar on the left
      - Text details on the next to avatar 
      - Trailing icon on the most right
    */
    return Column(
      children: [
        SizedBox(
          height: tileHeight,
          child: ListTile(
            leading: CircleAvatar(
              radius: tileHeight * 0.27,
              backgroundColor: const Color(0xff764abc),
              child: contentWidgets[0], // First widget (e.g., an image)
            ),
            title: _TextWithPadding(contentWidgets[1]), // Title widget (e.g., a name)
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[ //Other accompanying text
                for (int i = 2; i < contentWidgets.length - 1; i++)
                  _TextWithPadding(contentWidgets[i]),
              ],
            ),
            trailing: contentWidgets[contentWidgets.length - 1], // Last widget (e.g., a trailing widget)
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _TextWithPadding(Widget widget) {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: widget,
    );
  }
}



