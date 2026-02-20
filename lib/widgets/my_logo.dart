import 'package:flutter/material.dart';

Widget MyLogo(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CircleAvatar(
            //   radius: 70,
            //   backgroundImage: NetworkImage(logo),
            // ),
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Loading..."),
            ),
          ],
        ),
      ),
    );
  }