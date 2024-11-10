import 'package:flutter/material.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:person_generator/person.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PersonScreen(),
    );
  }
}

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  List<Person> personList = [];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
        title: const Text('Person List'),
        backgroundColor: Colors.yellow,
      ), 
      body: personList.isEmpty
      ? const Center(
        child: Text("NO DATA"),
      )
      : GridView.count(
        crossAxisCount: 2,
        children: List.generate(personList.length, (Index) {
          return Card(
            child: Column(
              children: [
                Text(personList[Index].name.toString()),
                Text(personList[Index].email.toString()),
              ],
            ),
          );
        })),
        floatingActionButton: FloatingActionButton(
        onPressed: onPressed,  
        child: const Icon(Icons.download),
      ),
    );
  }

    void onPressed() async {
      int c = 10;
      http.get(
        Uri.parse('https://slumberjer.com/myfaker/myfaker.php?count=10'),
      ).then((response) {
        if (response.statusCode == 200) {
          var data = convert.jsonDecode(response.body);
            if (data['status'] == 'success') {
              personList.clear();
              data['data'].forEach((v) {
                personList.add(Person.fromJson(v));
              
              });
              setState(() {});
            }
        }
    });
  }
}