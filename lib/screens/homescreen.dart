import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as htp;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<UserModel> getUser;

  @override
  void initState() {
    getUser = fetchuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: Colors.redAccent,
      //     onPressed: () {
      //       getuser();

      //       // .then((onValue) {
      //       //   print(onValue.email);
      //       //   print(onValue.firstname);
      //       // });

      //       //print(onValue.)
      //     }),
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder<UserModel>(
          future: getUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListTile(
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(snapshot.data!.photo)),
                title: Text(
                  '${snapshot.data!.firstname} ${snapshot.data!.lastname}',
                  style: const TextStyle(color: Colors.green),
                ),
                trailing: const Icon(
                  Icons.task_alt_outlined,
                  color: Colors.green,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class UserModel {
  final String firstname;
  final String title;
  final String lastname;
  final String email;
  final String photo;

  const UserModel({
    required this.firstname,
    required this.title,
    required this.lastname,
    required this.email,
    required this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        firstname: json['results'][0]['name']['first'],
        title: json['results'][0]['name']['title'],
        lastname: json['results'][0]['name']['last'],
        email: json['results'][0]['email'],
        photo: json['results'][0]['picture']['large']);
  }
}

Future<UserModel> fetchuser() async {
  final response =
      await htp.get(Uri.parse('https://randomuser.me/api/?results=1'));

  //print(response.statusCode);

  if (response.statusCode == 200) {
    return UserModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
