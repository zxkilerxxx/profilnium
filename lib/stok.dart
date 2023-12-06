import 'dart:ui';

import 'package:flutter/material.dart';

class FragmentStok extends StatefulWidget {
  @override
  State<FragmentStok> createState() => _FragmentStok();
}

class _FragmentStok extends State<FragmentStok> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "List Produk",
            style: TextStyle(
              color: Colors.black,
              fontSize: 44.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                //controller: pass1,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: "Cari stok berdasarkan nama",
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                ),
              ),
              ElevatedButton(
                //width: double.infinity,
                onPressed: () {},
                child: Text("cari",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12.0,
                    )),
              ),
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Name',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Age',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Role',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: const <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Sarah')),
                      DataCell(Text('19')),
                      DataCell(Text('Student')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Janine')),
                      DataCell(Text('43')),
                      DataCell(Text('Professor')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('William')),
                      DataCell(Text('27')),
                      DataCell(Text('Associate Professor')),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    ));
  }
}
