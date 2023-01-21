import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:interview/data/user.dart';
import 'package:interview/data/mock_data.dart';
import 'package:interview/widget/avatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {

  String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final searchController = TextEditingController();
  List<User> userList = [];
  List<User> filterData = [];
  late List<User> users;

  late SharedPreferences shared;

  @override
  void initState() {
    super.initState();
    saveUsers();
  }

  _filterList() async{
    shared = await SharedPreferences.getInstance();

    String? data = shared.getString('users');
    List<dynamic> list = jsonDecode(data!);
    List<User> userData = User.fromJsonToList(list);
    userList = userData;

    filterData = userList.where((element){
      final firstName = element.firstName.toLowerCase();
      final lastName = element.lastName.toLowerCase();
      final email = element.email.toLowerCase();
      final role = element.role.toLowerCase();

      return firstName.contains(searchController.text) || lastName.contains(searchController.text)
          || email.contains(searchController.text) || role.contains(searchController.text);
    }).toList();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // users = User.fromJsonToList(allData());
    // userList = users;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value)async{
                  _filterList();
                },
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: filterData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${filterData[index].firstName} ${filterData[index].lastName}'),
                  subtitle: Text('${filterData[index].role}'),
                  leading: filterData[index].avatar != null ?  Avatar(avatar: '${filterData[index].avatar}',) : CircleAvatar(child: FaIcon(FontAwesomeIcons.image),),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{

          shared = await SharedPreferences.getInstance();

          var newUser = User(id: "b32ec56c-21bb-4b7b-a3a0-635b8bca1f9d", avatar: null, firstName: "James", lastName: "May", email: "ssaull1c@tripod.com", role: "Developer");

          List<dynamic> list = jsonDecode(shared.getString('users')!);
          List<User> user = User.fromJsonToList(list);
          user.add(newUser);

          shared.setString('users', jsonEncode(user));

          _filterList();

          setState(() {

          });
        },
        tooltip: 'Add new',
        child: Icon(Icons.add),
      ),
    );
  }

  Future saveUsers()async{

    shared = await SharedPreferences.getInstance();
    shared.setString('users', jsonEncode(User.fromJsonToList(allData()))).then((value){
      _filterList();
    });

  }


}
