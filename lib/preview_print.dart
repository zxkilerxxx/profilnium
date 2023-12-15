// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:profilnium/data_model.dart';
import 'package:profilnium/menu.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Print Preview'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MenuScreen()));
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
    final font = await PdfGoogleFonts.nunitoExtraLight();
    List<Item> barangJual = widget.invoice.barang;

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.Text(invoice.grandTotal.toString()),
              pw.SizedBox(
                  width: double.infinity,
                  child: pw.ListView.builder(
                    itemCount: barangJual.length,
                    itemBuilder: (pw.Context context, int index) {
                      return pw.Container(
                        padding: pw.EdgeInsets.symmetric(vertical: 8.0),
                        child: pw.Text(
                          barangJual[index].name,
                          style: pw.TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  )),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
