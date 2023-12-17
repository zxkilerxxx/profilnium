import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FragmentStokUser extends StatefulWidget {
  @override
  State<FragmentStokUser> createState() => FragmentStokState();
}

class FragmentStokState extends State<FragmentStokUser> {
  final textSearch = TextEditingController();
  List<Document> data = [];
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    if (textSearch.text.isNotEmpty) {
      data = await Firestore.instance
          .collection('data')
          .where('NamaProduk', isEqualTo: textSearch.text)
          .orderBy('NamaProduk')
          .get();
    } else {
      data = await Firestore.instance
          .collection('data')
          .orderBy('NamaProduk')
          .get();
    }
    setState(() {});
  }

  List<DataRow> generateRows() {
    List<DataRow> rows = [];
    for (var result in data) {
      rows.add(
        DataRow(
          cells: [
            DataCell(Text(result['NamaProduk'])),
            DataCell(Text(result['warna'])),
            DataCell(
                Text(currencyFormat.format(double.parse(result['HargaJual'])))),
            DataCell(Text(result['Jumlah'].toString())),
          ],
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
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
                    controller: textSearch,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Cari stok berdasarkan nama",
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20.20),
                  ElevatedButton(
                    onPressed: () {
                      getData();
                    },
                    child: Text("cari",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12.0,
                        )),
                  ),
                  const SizedBox(height: 20.20),
                  SizedBox(
                    width: double.infinity,
                    child: PaginatedDataTable(
                      header: Text('List Produk'),
                      rowsPerPage: 7,
                      source: MyDataTableSource(data),
                      columns: <DataColumn>[
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
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<Document> _data;

  MyDataTableSource(this._data);

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) {
      return null;
    }
    final result = _data[index];
    return DataRow(
      cells: [
        DataCell(Text(result['NamaProduk'])),
        DataCell(Text(result['warna'])),
        DataCell(Text(FragmentStokState()
            .currencyFormat
            .format(double.parse(result['HargaJual'])))),
        DataCell(Text(result['Jumlah'].toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
