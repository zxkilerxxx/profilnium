import 'package:flutter/material.dart';

class FragmentPenjualan extends StatefulWidget {
  @override
  State<FragmentPenjualan> createState() => _FragmentPenjualan();
}

class _FragmentPenjualan extends State<FragmentPenjualan> {
  String? _selectedItem;

  void initState() {
    super.initState();

    _selectedItem = _items[0];
  }

  List<String> _items = ['CASH', 'TENOR'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(
          'Penjualan',
          style: TextStyle(
            color: Color(0xFF343A40),
            fontSize: 36,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w300,
            height: 0.03,
            letterSpacing: 3.20,
          ),
        ),
        const SizedBox(height: 47.99),
        Column(
          children: [
            Row(
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
                    SizedBox(height: 10), // Adjust the height as needed
                    SizedBox(
                      width: 200.0,
                      height: 35.0,
                      child: TextField(
                        // controller: pass1,
                        decoration: const InputDecoration(
                          hintText: "Masukkan No Nota",
                          border:
                              OutlineInputBorder(), // Adding border for better visibility
                        ),
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
                    SizedBox(height: 10), // Adjust the height as needed
                    SizedBox(
                      width: 200.0,
                      height: 35.0,
                      child: TextField(
                        // controller: pass1,
                        keyboardType: TextInputType.datetime,
                        decoration: const InputDecoration(
                          hintText: "Masukkan Tanggal",
                          border:
                              OutlineInputBorder(), // Adding border for better visibility
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                SizedBox(
                  width: 350.0,
                  height: 35.0,
                  child: TextField(
                    // controller: pass1,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Cari stok berdasarkan nama",
                      prefixIcon: Icon(Icons.search,
                          color: Colors
                              .black), // Adding border for better visibility
                    ),
                  ),
                ),
                const SizedBox(height: 20.20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("tambah",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12.0,
                      )),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
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
                    SizedBox(height: 10), // Adjust the height as needed
                    SizedBox(
                      width: 200.0,
                      height: 35.0,
                      child: TextField(
                        // controller: pass1,
                        decoration: const InputDecoration(
                          hintText: "Nama Pembeli",
                          border:
                              OutlineInputBorder(), // Adding border for better visibility
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200.0,
                      height: 50.0,
                      child: TextField(
                        // controller: pass1,
                        decoration: const InputDecoration(
                          hintText: "Alamat Pembeli",
                          border:
                              OutlineInputBorder(), // Adding border for better visibility
                        ),
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
                    SizedBox(height: 10), // Adjust the height as needed
                    SizedBox(
                      width: 200.0,
                      height: 55.0,
                      child: DropdownButtonFormField<String>(
                        value: _selectedItem,
                        items: _items.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value, // Ensure each value is unique
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
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ]),
    ));
  }
}
