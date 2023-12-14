import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';

class FragmentPenjualan extends StatefulWidget {
  @override
  State<FragmentPenjualan> createState() => _FragmentPenjualan();
}

class Item {
  final String name;
  final String warna;
  int jumlah;
  int harga;
  int total;

  Item({
    required this.name,
    required this.warna,
    required this.jumlah,
    required this.harga,
    required this.total,
  });
}

class _FragmentPenjualan extends State<FragmentPenjualan> {
  int total = 0;
  TextEditingController _controller = TextEditingController();
  List<Item> items = [];
  List<Item> selectedItems = [];
  List<Item> searchResults = [];
  String? _selectedItem;
  List<String> _items = ['CASH', 'TENOR'];

  @override
  void initState() {
    super.initState();
    fetchData();
    searchResults = List.from(items);
    _selectedItem = _items[0];
  }

  Future<List<Document>> getData() async {
    List<Document> document = await Firestore.instance.collection('data').get();
    return document;
  }

  Future<void> fetchData() async {
    List<Document> database = await getData();
    for (Document doc in database) {
      items.add(Item(
          name: doc['NamaProduk'],
          warna: doc['warna'],
          jumlah: 1,
          harga: int.parse(doc['HargaJual']),
          total: total));
    }
    setState(() {
      searchResults = List.from(items);
    });
  }

  TextEditingController _dateController = TextEditingController();
  final nomor = TextEditingController();
  final nama = TextEditingController();
  final alamat = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
    }
  }

  Future<void> generatePDFInvoice(String noNota, String namaPembeli,
      String alamatPembeli, String pembayaran) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('ProfilNium',
                            style: pw.TextStyle(fontSize: 20)),
                        pw.Text(
                          _dateController.text,
                          style: pw.TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'Supplier Aluminium',
                                  style: pw.TextStyle(fontSize: 12),
                                ),
                                pw.Text(
                                  'Aluminium Extrusion, Aluminium & \n Glass Accessories, Glass Work',
                                  style: pw.TextStyle(fontSize: 8),
                                ),
                                pw.Text(
                                  'HP/WA : 0812 5737 395 \nJL. Trans Kalimantan-Ambawang',
                                  style: pw.TextStyle(fontSize: 12),
                                ),
                              ]),
                          pw.Center(
                            child: pw.Text(
                              'Invoice',
                              style: pw.TextStyle(
                                  fontSize: 20, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Text(
                            'No Nota: $noNota \nDitujukan kepada: $namaPembeli \nAlamat Pembeli: $alamatPembeli \nJenis Pembayaran: $pembayaran',
                            style: pw.TextStyle(fontSize: 8),
                          ),
                        ])
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                border: pw.TableBorder.all(),
                headers: <String>['Nama', 'Warna', 'Harga', 'Jumlah', 'Total'],
                data: selectedItems.map((item) {
                  return <String>[
                    item.name,
                    item.warna,
                    item.harga.toString(),
                    item.jumlah.toString(),
                    item.total.toString(),
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Placeholder for first signature
                  pw.Container(
                    width: 200,
                    height: 100,
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    child: pw.Center(child: pw.Text('Signature 1')),
                  ),

                  pw.Text(
                    'PERHATIAN!!!\nBarang  yang sudah dibeli tidak\ndapat ditukar atau dikembalikan',
                    style: pw.TextStyle(fontSize: 8),
                  ),

                  // Placeholder for second signature
                  pw.Container(
                    width: 200,
                    height: 100,
                    decoration: pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    child: pw.Center(child: pw.Text('Signature 2')),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice.pdf');
    await file.writeAsBytes(await pdf.save());

    print('PDF invoice generated: ${file.path}');

    // Open the PDF file using the default PDF viewer
    // await launch(file.path);

    await OpenFile.open(file.path);
  }

  void _generateInvoiceAndPDF() {
    String noNota = nomor.text;
    String namaPembeli = nama.text;
    String alamatPembeli = alamat.text;
    String pembayaran = _selectedItem ?? '';

    generatePDFInvoice(noNota, namaPembeli, alamatPembeli, pembayaran);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Penjualan',
                            style: TextStyle(
                              color: Color(0xFF343A40),
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                              height: 0.03,
                              letterSpacing: 3.10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.99),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'No Nota',
                                              style: TextStyle(
                                                color: Color(0xFF343A40),
                                                fontSize: 15,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    10), // Adjust the height as needed
                                            SizedBox(
                                              width: 180.0,
                                              height: 30.0,
                                              child: TextField(
                                                controller: nomor,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Masukkan No Nota",
                                                  hintStyle:
                                                      TextStyle(fontSize: 12),
                                                  border:
                                                      OutlineInputBorder(), // Adding border for better visibility
                                                ),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Tanggal',
                                              style: TextStyle(
                                                color: Color(0xFF343A40),
                                                fontSize: 15,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    10), // Adjust the height as needed
                                            SizedBox(
                                              width: 180.0,
                                              height: 30.0,
                                              child: TextFormField(
                                                controller: _dateController,
                                                onTap: () =>
                                                    _selectDate(context),
                                                readOnly: true,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Select Date",
                                                  hintStyle:
                                                      TextStyle(fontSize: 12),
                                                  border: OutlineInputBorder(),
                                                ),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Ditujukan kepada',
                                          style: TextStyle(
                                            color: Color(0xFF343A40),
                                            fontSize: 15,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                10), // Adjust the height as needed
                                        SizedBox(
                                          width: 180.0,
                                          height: 30.0,
                                          child: TextField(
                                            controller: nama,
                                            decoration: const InputDecoration(
                                              hintText: "Nama Pembeli",
                                              hintStyle:
                                                  TextStyle(fontSize: 12),
                                              border:
                                                  OutlineInputBorder(), // Adding border for better visibility
                                            ),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 180.0,
                                          height: 40.0,
                                          child: TextField(
                                            controller: alamat,
                                            decoration: const InputDecoration(
                                              hintText: "Alamat Pembeli",
                                              hintStyle:
                                                  TextStyle(fontSize: 12),
                                              border:
                                                  OutlineInputBorder(), // Adding border for better visibility
                                            ),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Pembayaran',
                                          style: TextStyle(
                                            color: Color(0xFF343A40),
                                            fontSize: 15,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                10), // Adjust the height as needed
                                        SizedBox(
                                          width: 180.0,
                                          height: 55.0,
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: _selectedItem,
                                            items: _items.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value:
                                                    value, // Ensure each value is unique
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectedItem = newValue;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: 'Select',
                                                labelText: 'JENIS PEMBAYARAN',
                                                hintStyle:
                                                    TextStyle(fontSize: 12)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 350.0,
                                    height: 35.0,
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        labelText: 'Search',
                                        hintText: 'Search items...',
                                        prefixIcon: Icon(Icons.search),
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          searchResults = items
                                              .where((item) => item.name
                                                  .toLowerCase()
                                                  .contains(
                                                      value.toLowerCase()))
                                              .toList();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100.0,
                                    width: 350.0,
                                    child: ListView.builder(
                                      itemCount: searchResults.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            '${searchResults[index].name} ${searchResults[index].warna}',
                                          ),
                                          onTap: () {
                                            setState(() {
                                              if (selectedItems.length < 12 &&
                                                  !selectedItems.contains(
                                                      searchResults[index])) {
                                                selectedItems
                                                    .add(searchResults[index]);
                                                searchResults.remove(
                                                    searchResults[index]);
                                                _controller
                                                    .clear(); // Clear search query after selection
                                              } else {
                                                // Inform user if the maximum limit is reached
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Maximum limit of 12 entries reached'),
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _generateInvoiceAndPDF();
                              },
                              child: Text('Generate PDF Invoice'),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Save'),
                            ),
                          ],
                        ),
                        DataTable(
                          border: TableBorder.all(
                            color: Colors.black,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          columns: [
                            DataColumn(label: Text('Nama')),
                            DataColumn(label: Text('Warna')),
                            DataColumn(label: Text('Harga')),
                            DataColumn(label: Text('Jumlah')),
                            DataColumn(label: Text('Total')),
                            DataColumn(label: Text('Hapus')),
                          ],
                          rows: selectedItems
                              .map(
                                (item) => DataRow(cells: [
                                  DataCell(Text(item.name)),
                                  DataCell(Text(item.warna)),
                                  DataCell(Text(item.harga.toString())),
                                  DataCell(
                                    TextFormField(
                                      initialValue: item.jumlah.toString(),
                                      keyboardType: TextInputType.number,
                                      onChanged: (newValue) {
                                        setState(() {
                                          item.jumlah =
                                              int.tryParse(newValue) ?? 0;
                                          item.total = item.jumlah * item.harga;
                                        });
                                      },
                                    ),
                                  ),
                                  DataCell(Text(item.total.toString())),
                                  DataCell(IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        selectedItems.remove(item);
                                        searchResults.add(item);
                                      });
                                    },
                                  )),
                                ]),
                              )
                              .toList(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
