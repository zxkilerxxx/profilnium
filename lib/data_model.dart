import 'package:profilnium/penjualan.dart';

class Invoice {
  List<Item> barang = [];
  String tanggal = '';
  int grandTotal = 0;

  Invoice(
      {required this.barang, required this.tanggal, required this.grandTotal});
}
