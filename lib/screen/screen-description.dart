import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final int? id;

  Description({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID Movie ${id}'),
        elevation: 20,
      ),
    );
  }
}
