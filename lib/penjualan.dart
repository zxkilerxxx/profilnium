import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';
import 'package:profilnium/data_model.dart';
import 'package:profilnium/preview_print.dart';

class FragmentPenjualan extends StatefulWidget {
  @override
  State<FragmentPenjualan> createState() => _FragmentPenjualan();
}

class Item {
  final String id;
  final String name;
  final String warna;
  int sisaStokDb;
  int jumlah;
  int harga;
  int total;
  int diskon;

  Item({
    required this.id,
    required this.name,
    required this.warna,
    required this.sisaStokDb,
    required this.jumlah,
    required this.harga,
    required this.total,
    required this.diskon,
  });
}

class _FragmentPenjualan extends State<FragmentPenjualan> {
  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  TextEditingController jumlahTerjual = TextEditingController();
  TextEditingController diskon = TextEditingController();
  int total = 0;
  int grandTotal = 0;
  int page1grandtotal = 0;
  int page2grandtotal = 0;
  int page3grandtotal = 0;
  TextEditingController _controller = TextEditingController();
  List<Item> items = [];
  List<Item> selectedItems = [];
  List<Item> searchResults = [];
  String? _selectedItem;
  List<String> _items = ['CASH', 'TEMPO'];
  Map<String, dynamic> invoiceData = {};
  Invoice invoice = Invoice(barang: [], grandTotal: 0, tanggal: '');

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
      total = int.parse(doc['HargaJual']);
      items.add(Item(
          id: doc.id,
          name: doc['NamaProduk'],
          warna: doc['warna'],
          sisaStokDb: doc['Jumlah'],
          jumlah: 1,
          diskon: 0,
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
  DateTime _selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate);
      });
    }
  }

  Future<void> generatePDFInvoice(String noNota, String namaPembeli,
      String alamatPembeli, String pembayaran) async {
    final pdf = pw.Document();

    final pageTheme = pw.PageTheme(
      pageFormat:
          PdfPageFormat(9.5 * PdfPageFormat.inch, 5.5 * PdfPageFormat.inch),
      margin: pw.EdgeInsets.zero,
    );

    pw.Widget buildFooter(pw.Context context) {
      return pw.Container(
        alignment: pw.Alignment.center,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            // Placeholder for first signature
            pw.Container(
              width: 200,
              height: 50,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColors.black,
                    width: 1,
                  ),
                ),
              ),
              child: pw.Center(
                  child: pw.Text('TANDA TERIMA',
                      style: pw.TextStyle(fontSize: 10))),
            ),
            pw.Text(
              'PERHATIAN!!!\nBarang  yang sudah dibeli tidak\ndapat ditukar atau dikembalikan',
              style: pw.TextStyle(fontSize: 8),
            ),
            // Placeholder for second signature
            pw.Container(
              width: 200,
              height: 50,
              decoration: pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColors.black,
                    width: 1,
                  ),
                ),
              ),
              child: pw.Center(
                  child: pw.Text('HORMAT KAMI,',
                      style: pw.TextStyle(fontSize: 10))),
            ),
          ],
        ),
      );
    }

    if (selectedItems.length <= 12) {
      pdf.addPage(
        pw.MultiPage(
          footer: buildFooter,
          pageTheme: pageTheme,
          build: (pw.Context context) {
            return [
              pw.Container(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('ProfilNium',
                                style: pw.TextStyle(fontSize: 20)),
                            pw.Text(
                              'Pontianak, ${_dateController.text}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
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
                                      style: pw.TextStyle(fontSize: 8),
                                    ),
                                  ]),
                              pw.Center(
                                child: pw.Text(
                                  'Invoice',
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Text(
                                'No Nota: $noNota \nKepada Yth. $namaPembeli \nAlamat Pembeli: $alamatPembeli \nJenis Pembayaran: $pembayaran',
                                style: pw.TextStyle(fontSize: 10),
                              ),
                            ])
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.TableHelper.fromTextArray(
                      columnWidths: {
                        0: pw.FlexColumnWidth(
                            4), // Adjusts width of the first column
                        1: pw.FlexColumnWidth(
                            1), // Adjusts width of the second column
                        2: pw.FlexColumnWidth(
                            1), // Adjusts width of the third column
                        3: pw.FlexColumnWidth(
                            1), // Adjusts width of the fourth column
                        4: pw.FlexColumnWidth(
                            1.5), // Adjusts width of the fifth column
                      },
                      border: pw.TableBorder.all(),
                      headers: <String>[
                        'Nama',
                        'Jumlah',
                        'Harga',
                        'Disc',
                        'Total',
                      ],
                      data: selectedItems.map((item) {
                        return <String>[
                          '${item.name} ${item.warna}',
                          item.jumlah.toString(),
                          item.harga.toString(),
                          item.diskon.toString(),
                          item.total.toString(),
                        ];
                      }).toList(),
                      cellPadding: pw.EdgeInsets.all(2),
                    ),
                    pw.Align(
                        alignment: pw.Alignment.topRight,
                        child: pw.Text(
                            'Total: ${currencyFormat.format(grandTotal)}')),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
            ];
          },
        ),
      );
    } else if (selectedItems.length <= 24) {
      page1grandtotal = 0;
      page2grandtotal = 0;
      List<Item> page1 = selectedItems.take(12).toList();
      List<Item> page2 = selectedItems.skip(12).toList();
      for (Item satu in page1) {
        page1grandtotal = page1grandtotal + satu.total;
      }
      for (Item dua in page2) {
        page2grandtotal = page2grandtotal + dua.total;
      }
      pdf.addPage(
        pw.MultiPage(
          footer: buildFooter,
          pageTheme: pageTheme,
          build: (pw.Context context) {
            return [
              pw.Container(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('ProfilNium',
                                style: pw.TextStyle(fontSize: 20)),
                            pw.Text(
                              'Pontianak, ${_dateController.text}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
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
                                      style: pw.TextStyle(fontSize: 8),
                                    ),
                                  ]),
                              pw.Center(
                                child: pw.Text(
                                  'Invoice',
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Text(
                                'No Nota: $noNota \nKepada Yth. $namaPembeli \nAlamat Pembeli: $alamatPembeli \nJenis Pembayaran: $pembayaran',
                                style: pw.TextStyle(fontSize: 10),
                              ),
                            ])
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.TableHelper.fromTextArray(
                      columnWidths: {
                        0: pw.FlexColumnWidth(
                            4), // Adjusts width of the first column
                        1: pw.FlexColumnWidth(
                            1), // Adjusts width of the second column
                        2: pw.FlexColumnWidth(
                            1), // Adjusts width of the third column
                        3: pw.FlexColumnWidth(
                            1), // Adjusts width of the fourth column
                        4: pw.FlexColumnWidth(
                            1.5), // Adjusts width of the fifth column
                      },
                      border: pw.TableBorder.all(),
                      headers: <String>[
                        'Nama',
                        'Jumlah',
                        'Harga',
                        'Disc',
                        'Total',
                      ],
                      data: page1.map((item) {
                        return <String>[
                          '${item.name} ${item.warna}',
                          item.jumlah.toString(),
                          item.harga.toString(),
                          item.diskon.toString(),
                          item.total.toString(),
                        ];
                      }).toList(),
                      cellPadding: pw.EdgeInsets.all(2),
                    ),
                    pw.Align(
                        alignment: pw.Alignment.topRight,
                        child: pw.Text(
                            'Total: ${currencyFormat.format(page1grandtotal)}')),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
            ];
          },
        ),
      );
      pdf.addPage(
        pw.MultiPage(
          footer: buildFooter,
          pageTheme: pageTheme,
          build: (pw.Context context) {
            return [
              pw.Container(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('ProfilNium',
                                style: pw.TextStyle(fontSize: 20)),
                            pw.Text(
                              'Pontianak, ${_dateController.text}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
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
                                      style: pw.TextStyle(fontSize: 8),
                                    ),
                                  ]),
                              pw.Center(
                                child: pw.Text(
                                  'Invoice',
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Text(
                                'No Nota: $noNota \nKepada Yth. $namaPembeli \nAlamat Pembeli: $alamatPembeli \nJenis Pembayaran: $pembayaran',
                                style: pw.TextStyle(fontSize: 10),
                              ),
                            ])
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.TableHelper.fromTextArray(
                      columnWidths: {
                        0: pw.FlexColumnWidth(
                            4), // Adjusts width of the first column
                        1: pw.FlexColumnWidth(
                            1), // Adjusts width of the second column
                        2: pw.FlexColumnWidth(
                            1), // Adjusts width of the third column
                        3: pw.FlexColumnWidth(
                            1), // Adjusts width of the fourth column
                        4: pw.FlexColumnWidth(
                            1.5), // Adjusts width of the fifth column
                      },
                      border: pw.TableBorder.all(),
                      headers: <String>[
                        'Nama',
                        'Jumlah',
                        'Harga',
                        'Disc',
                        'Total',
                      ],
                      data: page2.map((item) {
                        return <String>[
                          '${item.name} ${item.warna}',
                          item.jumlah.toString(),
                          item.harga.toString(),
                          item.diskon.toString(),
                          item.total.toString(),
                        ];
                      }).toList(),
                      cellPadding: pw.EdgeInsets.all(2),
                    ),
                    pw.Align(
                        alignment: pw.Alignment.topRight,
                        child: pw.Text(
                            'Total: ${currencyFormat.format(page2grandtotal)}')),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
            ];
          },
        ),
      );
    } else {
      page1grandtotal = 0;
      page2grandtotal = 0;
      page3grandtotal = 0;
      List<Item> page1 = selectedItems.take(12).toList();
      List<Item> page2 = selectedItems.skip(12).take(12).toList();
      List<Item> page3 = selectedItems.skip(24).take(12).toList();
      for (Item satu in page1) {
        page1grandtotal = page1grandtotal + satu.total;
      }
      for (Item dua in page2) {
        page2grandtotal = page2grandtotal + dua.total;
      }
      for (Item tiga in page3) {
        page3grandtotal = page3grandtotal + tiga.total;
      }
      pdf.addPage(
        pw.MultiPage(
          footer: buildFooter,
          pageTheme: pageTheme,
          build: (pw.Context context) {
            return [
              pw.Container(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('ProfilNium',
                                style: pw.TextStyle(fontSize: 20)),
                            pw.Text(
                              'Pontianak, ${_dateController.text}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
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
                                      style: pw.TextStyle(fontSize: 8),
                                    ),
                                  ]),
                              pw.Center(
                                child: pw.Text(
                                  'Invoice',
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Text(
                                'No Nota: $noNota \nKepada Yth. $namaPembeli \nAlamat Pembeli: $alamatPembeli \nJenis Pembayaran: $pembayaran',
                                style: pw.TextStyle(fontSize: 10),
                              ),
                            ])
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.TableHelper.fromTextArray(
                      columnWidths: {
                        0: pw.FlexColumnWidth(
                            4), // Adjusts width of the first column
                        1: pw.FlexColumnWidth(
                            1), // Adjusts width of the second column
                        2: pw.FlexColumnWidth(
                            1), // Adjusts width of the third column
                        3: pw.FlexColumnWidth(
                            1), // Adjusts width of the fourth column
                        4: pw.FlexColumnWidth(
                            1.5), // Adjusts width of the fifth column
                      },
                      border: pw.TableBorder.all(),
                      headers: <String>[
                        'Nama',
                        'Jumlah',
                        'Harga',
                        'Disc',
                        'Total',
                      ],
                      data: page1.map((item) {
                        return <String>[
                          '${item.name} ${item.warna}',
                          item.jumlah.toString(),
                          item.harga.toString(),
                          item.diskon.toString(),
                          item.total.toString(),
                        ];
                      }).toList(),
                      cellPadding: pw.EdgeInsets.all(2),
                    ),
                    pw.Align(
                        alignment: pw.Alignment.topRight,
                        child: pw.Text(
                            'Total: ${currencyFormat.format(page1grandtotal)}')),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
            ];
          },
        ),
      );
      pdf.addPage(
        pw.MultiPage(
          footer: buildFooter,
          pageTheme: pageTheme,
          build: (pw.Context context) {
            return [
              pw.Container(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('ProfilNium',
                                style: pw.TextStyle(fontSize: 20)),
                            pw.Text(
                              'Pontianak, ${_dateController.text}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
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
                                      style: pw.TextStyle(fontSize: 8),
                                    ),
                                  ]),
                              pw.Center(
                                child: pw.Text(
                                  'Invoice',
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Text(
                                'No Nota: $noNota \nKepada Yth. $namaPembeli \nAlamat Pembeli: $alamatPembeli \nJenis Pembayaran: $pembayaran',
                                style: pw.TextStyle(fontSize: 10),
                              ),
                            ])
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.TableHelper.fromTextArray(
                      columnWidths: {
                        0: pw.FlexColumnWidth(
                            4), // Adjusts width of the first column
                        1: pw.FlexColumnWidth(
                            1), // Adjusts width of the second column
                        2: pw.FlexColumnWidth(
                            1), // Adjusts width of the third column
                        3: pw.FlexColumnWidth(
                            1), // Adjusts width of the fourth column
                        4: pw.FlexColumnWidth(
                            1.5), // Adjusts width of the fifth column
                      },
                      border: pw.TableBorder.all(),
                      headers: <String>[
                        'Nama',
                        'Jumlah',
                        'Harga',
                        'Disc',
                        'Total',
                      ],
                      data: page2.map((item) {
                        return <String>[
                          '${item.name} ${item.warna}',
                          item.jumlah.toString(),
                          item.harga.toString(),
                          item.diskon.toString(),
                          item.total.toString(),
                        ];
                      }).toList(),
                      cellPadding: pw.EdgeInsets.all(2),
                    ),
                    pw.Align(
                        alignment: pw.Alignment.topRight,
                        child: pw.Text(
                            'Total: ${currencyFormat.format(page2grandtotal)}')),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
            ];
          },
        ),
      );
      pdf.addPage(
        pw.MultiPage(
          footer: buildFooter,
          pageTheme: pageTheme,
          build: (pw.Context context) {
            return [
              pw.Container(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('ProfilNium',
                                style: pw.TextStyle(fontSize: 20)),
                            pw.Text(
                              'Pontianak, ${_dateController.text}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
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
                                      style: pw.TextStyle(fontSize: 8),
                                    ),
                                  ]),
                              pw.Center(
                                child: pw.Text(
                                  'Invoice',
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Text(
                                'No Nota: $noNota \nKepada Yth. $namaPembeli \nAlamat Pembeli: $alamatPembeli \nJenis Pembayaran: $pembayaran',
                                style: pw.TextStyle(fontSize: 10),
                              ),
                            ])
                      ],
                    ),
                    pw.SizedBox(height: 5),
                    pw.TableHelper.fromTextArray(
                      columnWidths: {
                        0: pw.FlexColumnWidth(
                            4), // Adjusts width of the first column
                        1: pw.FlexColumnWidth(
                            1), // Adjusts width of the second column
                        2: pw.FlexColumnWidth(
                            1), // Adjusts width of the third column
                        3: pw.FlexColumnWidth(
                            1), // Adjusts width of the fourth column
                        4: pw.FlexColumnWidth(
                            1.5), // Adjusts width of the fifth column
                      },
                      border: pw.TableBorder.all(),
                      headers: <String>[
                        'Nama',
                        'Jumlah',
                        'Harga',
                        'Disc',
                        'Total',
                      ],
                      data: page3.map((item) {
                        return <String>[
                          '${item.name} ${item.warna}',
                          item.jumlah.toString(),
                          item.harga.toString(),
                          item.diskon.toString(),
                          item.total.toString(),
                        ];
                      }).toList(),
                      cellPadding: pw.EdgeInsets.all(2),
                    ),
                    pw.Align(
                        alignment: pw.Alignment.topRight,
                        child: pw.Text(
                            'Total: ${currencyFormat.format(page3grandtotal)}')),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
            ];
          },
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice.pdf');
    await file.writeAsBytes(await pdf.save());
    print('PDF invoice generated: ${file.path}');
    // Open the PDF file using the default PDF viewer
    // await launch(file.path);
    await OpenFile.open(file.path);
  }

  Future<void> _generateInvoiceAndPDF() async {
    String noNota = nomor.text;
    String namaPembeli = nama.text;
    String alamatPembeli = alamat.text;
    String pembayaran = _selectedItem ?? '';
    await generatePDFInvoice(noNota, namaPembeli, alamatPembeli, pembayaran);
  }

  void saveInvoice() async {
    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('MOHON ISI DATA DENGAN BENAR')));
      return;
    }
    grandTotal = 0;
    for (Item sold in selectedItems) {
      int sisaStok = sold.sisaStokDb - sold.jumlah;
      if (sisaStok < 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Stok tidak cukup')));
        return;
      }
    }
    for (Item sold in selectedItems) {
      grandTotal = grandTotal + sold.total;
      int sisaStok = sold.sisaStokDb - sold.jumlah;
      await Firestore.instance
          .collection('data')
          .document(sold.id)
          .update({'Jumlah': sisaStok});
    }
    await _generateInvoiceAndPDF();
    invoiceData = {
      'Nomor': nomor.text,
      'Nama': nama.text,
      'Alamat': alamat.text,
      'Tanggal': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'Pembayaran': _selectedItem,
      'JenisTerjual': selectedItems.length,
      'grandTotal': grandTotal,
    };
    await Firestore.instance
        .collection('invoice')
        .add({}).then((value) async => await addItem(value.id, selectedItems));
    refresh();
  }

  void printBluetooth() async {
    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('MOHON ISI DATA DENGAN BENAR')));
      return;
    }
    grandTotal = 0;
    for (Item sold in selectedItems) {
      int sisaStok = sold.sisaStokDb - sold.jumlah;
      if (sisaStok < 0) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Stok tidak cukup')));
        return;
      }
    }
    for (Item sold in selectedItems) {
      grandTotal = grandTotal + sold.total;
      int sisaStok = sold.sisaStokDb - sold.jumlah;
      await Firestore.instance
          .collection('data')
          .document(sold.id)
          .update({'Jumlah': sisaStok});
    }
    invoiceData = {
      'Nomor': nomor.text,
      'Nama': nama.text,
      'Alamat': alamat.text,
      'Tanggal': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'Pembayaran': _selectedItem,
      'JenisTerjual': selectedItems.length,
      'grandTotal': grandTotal,
    };
    await Firestore.instance
        .collection('invoice')
        .add({}).then((value) async => await addItem(value.id, selectedItems));

    invoice = Invoice(
        barang: selectedItems,
        tanggal: _dateController.text,
        grandTotal: grandTotal);

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PreviewPrint(invoice: invoice)));

    refresh();
  }

  Future<void> addItem(String id, List<Item> data) async {
    data.asMap().forEach((index, e) {
      invoiceData['IdBarang$index'] = e.id;
      invoiceData['JumlahTerjual$index'] = e.jumlah;
      invoiceData['diskon$index'] = e.diskon;
      invoiceData['HargaJual$index'] = e.harga;
    });
    await Firestore.instance.document('invoice/$id').set(invoiceData);
  }

  void refresh() async {
    items = [];
    searchResults = [];
    selectedItems = [];
    await fetchData();
    searchResults = List.from(items);
    _selectedItem = _items[0];
    invoiceData = {};

    setState(() {
      nomor.clear();
      _dateController.clear();
      nama.clear();
      alamat.clear();
      _controller.clear();
      diskon.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                      5), // Adjust the height as needed
                                              SizedBox(
                                                width: 180.0,
                                                height: 30.0,
                                                child: TextField(
                                                  controller: nomor,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        "Masukkan No Nota",
                                                    hintStyle:
                                                        TextStyle(fontSize: 12),
                                                    border:
                                                        OutlineInputBorder(), // Adding border for better visibility
                                                  ),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 25,
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
                                                      5), // Adjust the height as needed
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
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 25,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  5), // Adjust the height as needed
                                          SizedBox(
                                            width: 180.0,
                                            height: 50.0,
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
                                            height: 50.0,
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
                                        width: 25,
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
                                                  5), // Adjust the height as needed
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
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 350.0,
                                    height: 35.0,
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        labelText: 'Cari',
                                        hintText: 'Cari barang...',
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
                                    height: 144.0,
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
                                              if (!selectedItems.contains(
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
                                                        'Barang ini sudah ditambahkan'),
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
                              SizedBox(width: 25),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      saveInvoice();
                                    },
                                    child: Text('Simpan'),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      printBluetooth();
                                    },
                                    child: Text('Cetak'),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      refresh();
                                    },
                                    child: Text('Baru'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
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
                              DataColumn(label: Text('Sisa Stok')),
                              DataColumn(label: Text('Jumlah')),
                              DataColumn(label: Text('Harga')),
                              DataColumn(label: Text('Diskon')),
                              DataColumn(label: Text('Total')),
                              DataColumn(label: Text('Hapus')),
                            ],
                            rows: selectedItems
                                .map(
                                  (item) => DataRow(cells: [
                                    DataCell(Text(item.name)),
                                    DataCell(Text(item.warna)),
                                    DataCell(Text(item.sisaStokDb.toString())),
                                    DataCell(
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        onChanged: (newValue) {
                                          setState(() {
                                            item.jumlah =
                                                int.tryParse(newValue) ?? 1;
                                            item.total =
                                                item.jumlah * item.harga -
                                                    item.diskon;
                                          });
                                        },
                                      ),
                                    ),
                                    DataCell(Text(item.harga.toString())),
                                    DataCell(
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9]')),
                                        ],
                                        onChanged: (newValue) {
                                          setState(() {
                                            item.diskon =
                                                int.tryParse(newValue) ?? 0;
                                            item.total =
                                                item.jumlah * item.harga -
                                                    item.diskon;
                                          });
                                        },
                                      ),
                                    ),
                                    DataCell(Text(item.total.toString())),
                                    DataCell(IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          searchResults.add(item);
                                          selectedItems.remove(item);
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
