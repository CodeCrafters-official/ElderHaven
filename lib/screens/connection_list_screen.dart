// connection_list_screen.dart
import 'package:flutter/material.dart';
import 'profile_screen.dart';

class ConnectionListScreen extends StatelessWidget {
  final List<Map<String, String>> connections = [
    {'username': 'arsathmuha', 'bio': 'AI enthusiast and tech lover'},
    {'username': 'kausika', 'bio': 'Flutter developer and designer'},
    {'username': 'pavithra', 'bio': 'Data Scientist in the making'},
    {'username': 'priyadharshini', 'bio': 'Loves Python programming'},
    {'username': 'pradeepa', 'bio': 'Software developer and problem solver'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connections'),
      ),
      body: ListView.builder(
        itemCount: connections.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(connections[index]['username']!),
            subtitle: Text(connections[index]['bio']!),
            trailing: Icon(Icons.person),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    username: connections[index]['username']!,
                    bio: connections[index]['bio']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
