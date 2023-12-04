import 'package:flutter/material.dart';

class FragmentPengaturan extends StatefulWidget {
  @override
  State<FragmentPengaturan> createState() => _FragmentPengaturan();
}

class _FragmentPengaturan extends State<FragmentPengaturan> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Text("INI PENGATURAN");
        }
      ),
    );
  }
}