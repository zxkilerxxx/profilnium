import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FragmentStok extends StatefulWidget {
  @override
  State<FragmentStok> createState() => FragmentStokState();
}

class FragmentStokState extends State<FragmentStok> {
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

  Future<void> deleteDocument(Document doc) async {
    await Firestore.instance.collection('data').document(doc.id).delete();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> editDocument(Document doc) async {
    String editedNamaProduk = doc['NamaProduk'];
    String editedWarna = doc['warna'];
    String editedHargaJual = doc['HargaJual'];
    String editedJumlah = doc['Jumlah'];

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Data'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => editedNamaProduk = value,
                  decoration: InputDecoration(labelText: 'Nama Produk'),
                  controller: TextEditingController(text: editedNamaProduk),
                ),
                TextField(
                  onChanged: (value) => editedWarna = value,
                  decoration: InputDecoration(labelText: 'Warna'),
                  controller: TextEditingController(text: editedWarna),
                ),
                TextField(
                  onChanged: (value) => editedHargaJual = value,
                  decoration: InputDecoration(labelText: 'Harga Jual'),
                  controller: TextEditingController(text: editedHargaJual),
                ),
                TextField(
                  onChanged: (value) => editedJumlah = value,
                  decoration: InputDecoration(labelText: 'Jumlah'),
                  controller: TextEditingController(text: editedJumlah),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await Firestore.instance
                    .collection('data')
                    .document(doc.id)
                    .update({
                  'NamaProduk': editedNamaProduk,
                  'warna': editedWarna,
                  'HargaJual': editedHargaJual,
                  'Jumlah': editedJumlah,
                });
                Navigator.of(context).pop();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  getData();
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
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
            DataCell(Text(result['Jumlah'])),
            DataCell(ElevatedButton(
              onPressed: () {
                editDocument(result);
              },
              child: Text('edit'),
            )),
            DataCell(ElevatedButton(
              onPressed: () {
                deleteDocument(result);
              },
              child: Text('hapus'),
            )),
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
                    source:
                        MyDataTableSource(data, deleteDocument, editDocument),
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
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<Document> _data;
  final Function(Document) deleteCallback;
  final Function(Document) editCallback;

  MyDataTableSource(
    this._data,
    this.deleteCallback,
    this.editCallback,
  );

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
        DataCell(Text(result['Jumlah'])),
        DataCell(
          ElevatedButton(
            onPressed: () {
              editCallback(result);
            },
            child: Text('edit'),
          ),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () {
              deleteCallback(result);
            },
            child: Text('hapus'),
          ),
        ),
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
