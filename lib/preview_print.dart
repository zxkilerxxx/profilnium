// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:profilnium/data_model.dart';
import 'package:profilnium/menu.dart';
import 'package:profilnium/menu_user.dart';
import 'package:profilnium/penjualan.dart';

class PreviewPrint extends StatefulWidget {
  final Invoice invoice;

  PreviewPrint({required this.invoice});

  @override
  State<PreviewPrint> createState() => _PreviewPrint();
}

class ReceiveData {
  Invoice invoice = Invoice(barang: [], tanggal: '', grandTotal: 0);
  void setInvoice(Invoice newInvoice) {
    invoice = newInvoice;
  }
}

class _PreviewPrint extends State<PreviewPrint> {
  String _formatCurrency(int amount) {
    // Convert the amount to a string
    String formattedAmount = amount.toString();

    // Add dots as thousand separators
    final RegExp regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    formattedAmount = formattedAmount.replaceAllMapped(
        regExp, (Match match) => '${match[1]}.');

    return formattedAmount;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Print Preview'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              // Navigate back to the previous screen
              User user = await FirebaseAuth.instance.getUser();
              if (user.email == 'admin@admin.com') {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MenuScreen()));
              } else {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MenuUserScreen()));
              }
            },
          ),
        ),
        body: PdfPreview(
          build: (format) => _generatePdf(format, widget.invoice),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, Invoice invoice) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    List<Item> barangJual = widget.invoice.barang;

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header Section
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('ProfilNium',
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Supplier Aluminium', // Address text
                        style: pw.TextStyle(fontSize: 12)),
                    pw.Text(
                      'Aluminium Extrusion, Aluminium & \n Glass Accessories, Glass Work \n HP/WA : 0812 5737 395 \nJL. Trans Kalimantan-Ambawang ',
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      _getFormattedDateTime(),
                      style: pw.TextStyle(fontSize: 10),
                    ),
                    pw.Divider(
                        thickness: 1, color: PdfColors.grey), // Divider line
                  ],
                ),
              ),
              // Adjust spacing between header and address // Your existing content
              pw.SizedBox(
                width: double.infinity,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex:
                                3, // Adjust flex values according to your requirement
                            child: pw.Text(
                              'Item Names',
                              style: pw.TextStyle(
                                  fontSize: 12, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              'Qty',
                              style: pw.TextStyle(
                                  fontSize: 12, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              'Prices',
                              style: pw.TextStyle(
                                  fontSize: 12, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      pw.Divider(
                          thickness: 1, color: PdfColors.grey), // Divider line
                      pw.Column(
                        children: List.generate(
                          barangJual.length,
                          (index) => pw.Row(
                            children: [
                              pw.Expanded(
                                flex: 3,
                                child: pw.Text(
                                  barangJual[index].name,
                                  style: pw.TextStyle(fontSize: 12),
                                ),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  barangJual[index].jumlah.toString(),
                                  style: pw.TextStyle(fontSize: 12),
                                ),
                              ),
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                  barangJual[index].harga.toString(),
                                  style: pw.TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      pw.Divider(thickness: 1, color: PdfColors.grey),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Grand Total: ',
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Text(
                            'Rp ${_formatCurrency(invoice.grandTotal)}',
                            style: pw.TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      pw.Divider(thickness: 1, color: PdfColors.grey),
                      pw.Center(
                        child: pw.Text(
                          'Barang TIDAK DAPAT ditukar/dikembalikan\n dengan ALASAN APAPUN. Sebelum dibayar silahkan\n dilakukan pengecekan terlebih dahulu, kerusakan barang\n bukan tanggung jawab kami.',
                          style: pw.TextStyle(fontSize: 8),
                          textAlign: pw.TextAlign.center,
                        ),
                      )
                    ]),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  String _getFormattedDateTime() {
    final now = DateTime.now();
    final formattedDate = '${now.day}/${now.month}/${now.year}';
    final formattedTime = '${now.hour}:${now.minute}:${now.second}';
    return '$formattedDate - $formattedTime';
  }
}
