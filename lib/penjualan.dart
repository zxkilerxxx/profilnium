import 'package:flutter/material.dart';

class FragmentPenjualan extends StatefulWidget {
  @override
  State<FragmentPenjualan> createState() => _FragmentPenjualan();
}

class _FragmentPenjualan extends State<FragmentPenjualan> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Text("INI PENJUALAN");
        }
      ),
    );
  }
}