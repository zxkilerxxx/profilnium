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
              const SizedBox(height: 20.20),
              ElevatedButton(
                //width: double.infinity,
                onPressed: () {},
                child: Text("cari",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12.0,
                    )),
              ),
              const SizedBox(height: 20.20),
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Nama Produk',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Warna',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Harga Jual',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Sisa Stok',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Edit',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Hapus',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Aluminium cap badak')),
                      DataCell(Text('putih')),
                      DataCell(Text('20 ribu je')),
                      DataCell(Text('kosong')),
                      DataCell(ElevatedButton(
                          onPressed: () {}, child: Text('edit'))),
                      DataCell(ElevatedButton(
                          onPressed: () {}, child: Text('hapus'))),
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
