import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FragmentPembelian extends StatefulWidget {
  @override
  State<FragmentPembelian> createState() => _FragmentPembelian();
}

class _FragmentPembelian extends State<FragmentPembelian> {
  final nameController = TextEditingController();
  final warnaController = TextEditingController();
  final jumlahController = TextEditingController();
  final hargaController = TextEditingController();

  void clearText() {
    nameController.text = "";
    warnaController.text = "";
    jumlahController.text = "";
    hargaController.text = "";
  }

  void tambahData(
      {required String namaproduk,
      required hargajual,
      required jumlah,
      required warna}) async {
    if (jumlah.toString().isEmpty) {
      jumlah = 0;
    }
    if (hargajual.toString().isEmpty) {
      hargajual = '0';
    }
    var collRef = Firestore.instance.collection('data');
    collRef.add({
      'NamaProduk': namaproduk,
      'HargaJual': hargajual,
      'Jumlah': jumlah,
      'warna': warna,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(children: [
          Text(
            "Tambah Produk Baru",
            style: TextStyle(
              color: Colors.black,
              fontSize: 44.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 47.99),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Nama Produk',
            ),
          ),
          const SizedBox(height: 47.99),
          TextFormField(
            controller: warnaController,
            decoration: const InputDecoration(
              hintText: 'Warna Produk',
            ),
          ),
          const SizedBox(height: 47.99),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            controller: hargaController,
            decoration: const InputDecoration(
              hintText: 'Harga Jual',
            ),
          ),
          const SizedBox(height: 47.99),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            controller: jumlahController,
            decoration: const InputDecoration(
              hintText: 'Jumlah Barang',
            ),
          ),
          const SizedBox(height: 47.99),
          ElevatedButton(
            onPressed: () {
              tambahData(
                  namaproduk: nameController.text,
                  hargajual: hargaController.text,
                  jumlah: int.parse(jumlahController.text),
                  warna: warnaController.text);
              clearText();
            },
            child: Text(
              'Submit',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
