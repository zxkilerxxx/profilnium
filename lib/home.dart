import 'package:flutter/material.dart';

class FragmentHome extends StatefulWidget {
  @override
  State<FragmentHome> createState() => _FragmentHome();
}

class _FragmentHome extends State<FragmentHome> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Text("INI HOME");
        }
      ),
    );
  }
}