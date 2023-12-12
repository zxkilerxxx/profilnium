import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';

class FragmentPenjualan extends StatefulWidget {
  @override
  State<FragmentPenjualan> createState() => _FragmentPenjualan();
}

class Item {

  final String nama;
  final String warna;
  int jumlah;
  int harga;
  int total;

  Item({
    required this.nama,
    required this.warna,
    required this.jumlah,
    required this.harga,
    required this.total,
  });
}

class _FragmentPenjualan extends State<FragmentPenjualan> {
  TextEditingController _controller = TextEditingController();
  List<Item> items = List.generate(
    50,
    (index) => Item(
      nama: 'Item $index',
      warna: 'Data 1 for Item $index',
      jumlah: 1,
      harga: 0,
      total: 0,
    ),
  );
  List<Item> selectedItems = [];
  List<Item> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchResults = List.from(items);
    _selectedItem = _items[0];
  }

  String? _selectedItem;

  List<String> _items = ['CASH', 'TENOR'];

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
                            fontSize: 36,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            height: 0.03,
                            letterSpacing: 3.20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 47.99),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            ),
                            Padding(
                              padding: const EdgeInsets.all(50.0),
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
                                                .contains(value.toLowerCase()))
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
                                          title: Text(searchResults[index].name),
                                          onTap: () {
                                            setState(() {
                                              if (selectedItems.length < 12 &&
                                                  !selectedItems
                                                      .contains(searchResults[index])) {
                                                selectedItems.add(searchResults[index]);
                                                searchResults.remove(searchResults[index]);
                                                _controller
                                                    .clear(); // Clear search query after selection
                                              } else {
                                                // Inform user if the maximum limit is reached
                                                ScaffoldMessenger.of(context).showSnackBar(
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
                          ],
                        ),
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