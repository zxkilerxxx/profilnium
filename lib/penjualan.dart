import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';

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
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.datetime,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Masukkan Tanggal",
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
                                            // controller: pass1,
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
                                            // controller: pass1,
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
