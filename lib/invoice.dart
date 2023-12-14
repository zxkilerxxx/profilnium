import 'package:flutter/material.dart';

class FragmentInvoice extends StatefulWidget {
  @override
  State<FragmentInvoice> createState() => _FragmentInvoice();
}

class _FragmentInvoice extends State<FragmentInvoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Text("INVOICE");
      }),
    );
  }
}
