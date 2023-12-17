import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';

class FragmentInvoice extends StatefulWidget {
  @override
  State<FragmentInvoice> createState() => _FragmentInvoice();
}

class _FragmentInvoice extends State<FragmentInvoice> {
  final textSearch = TextEditingController();
  List<Document> data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  String calculateDateDifference(String tanggal) {
    DateTime parsedDate =
        DateTime.parse(tanggal); // Assuming 'Tanggal' is in a valid format
    DateTime now = DateTime.now();

    DateTime thirtyDaysLater = parsedDate.add(Duration(days: 30));
    Duration difference = thirtyDaysLater.difference(now);

    int daysDifference = difference.inDays;
    return '$daysDifference hari lagi${daysDifference != 1 ? '' : ''}';
  }

  Future<void> getData() async {
    data = await Firestore.instance
        .collection('invoice')
        .where("Pembayaran", isEqualTo: "TENOR")
        .get();
    setState(() {});
  }

  Future<void> deleteDocument(Document doc) async {
    await Firestore.instance.collection('invoice').document(doc.id).update({"Pembayaran": "CASH"});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  List<DataRow> generateRows() {
    List<DataRow> rows = [];
    for (var result in data) {
      rows.add(
        DataRow(
          cells: [
            DataCell(Text(result['Nama'])),
            DataCell(Text(result['Alamat'])),
            DataCell(Text((result['grandTotal'].toString()))),
            DataCell(Text(calculateDateDifference(result['Tanggal']))),
            DataCell(Text(result['Tanggal'])),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Invoice",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 44.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20.20),
                  SizedBox(
                    width: double.infinity,
                    child: PaginatedDataTable(
                      header: Text('List Tenor'),
                      rowsPerPage: 7,
                      source: MyDataTableSource(data, deleteDocument),
                      columns: <DataColumn>[
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Nama Pembeli',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Alamat',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Total Beli',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Sisa waktu tenor',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Tanggal Beli',
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
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<Document> _data;
  final Function(Document) deleteCallback;
  MyDataTableSource(
    this._data,
    this.deleteCallback,
  );

  String calculateDateDifference(String tanggal) {
    DateTime parsedDate =
        DateTime.parse(tanggal); // Assuming 'Tanggal' is in a valid format
    DateTime now = DateTime.now();

    DateTime thirtyDaysLater = parsedDate.add(Duration(days: 30));
    Duration difference = thirtyDaysLater.difference(now);

    int daysDifference = difference.inDays;
    return '$daysDifference hari lagi${daysDifference != 1 ? '' : ''}';
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) {
      return null;
    }
    final result = _data[index];
    return DataRow(
      cells: [
        DataCell(Text(result['Nama'])),
        DataCell(Text(result['Alamat'])),
        DataCell(Text((result['grandTotal'].toString()))),
        DataCell(Text(calculateDateDifference(result['Tanggal']))),
        DataCell(Text(result['Tanggal'])),
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
