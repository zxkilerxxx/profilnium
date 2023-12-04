import 'package:flutter/material.dart';

class FragmentPembelian extends StatefulWidget {
  @override
  State<FragmentPembelian> createState() => _FragmentPembelian();
}

class _FragmentPembelian extends State<FragmentPembelian> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Text("INI PEMBELIAN");
        }
      ),
    );
  }
}