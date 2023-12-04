import 'package:flutter/material.dart';

class FragmentStok extends StatefulWidget {
  @override
  State<FragmentStok> createState() => _FragmentStok();
}

class _FragmentStok extends State<FragmentStok> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Text("INI STOK");
        }
      ),
    );
  }
}