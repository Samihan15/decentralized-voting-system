import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Text(
      msg,
      style: const TextStyle(fontSize: 16, color: Colors.black),
    ),
    backgroundColor: (Colors.grey[200]),
    action: SnackBarAction(
      label: 'dismiss',
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
