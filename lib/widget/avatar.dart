import 'package:flutter/material.dart';

class Avatar extends StatelessWidget{

  Avatar({required this.avatar});

  final String avatar;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CircleAvatar(
      backgroundImage: NetworkImage(avatar),
    );
  }

}