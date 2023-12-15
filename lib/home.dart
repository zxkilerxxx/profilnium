import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(child: 
                      Column(
                        children: [

                        ],
                      )
                    )
                  ],
                )
              ],
            ),);
        }
      ),
    );
  }
}