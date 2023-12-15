import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FragmentHome extends StatefulWidget {
  @override
  State<FragmentHome> createState() => _FragmentHome();
}

class _FragmentHome extends State<FragmentHome> {
  List<Document> result = [];
  int grandTotalToday = 0;
  List<Document> resultMonth = [];
  int grandTotalThisMonth = 0;
  List<Document> resultYear = [];
  int grandTotalThisYear = 0;

  @override
  void initState() {
    super.initState();
    fetchDataToday();
    fetchDataForCurrentMonth();
    fetchDataForCurrentYear();
  }

  Future<List<Document>> getPenjualanHariIni() async{
    List<Document> doc = await Firestore.instance.collection('invoice').where("Tanggal", isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now())).get();
    return doc;
  }

  void fetchDataToday() async {
    grandTotalToday = 0;
    result = await getPenjualanHariIni();
    for(Document data in result) {
      num total = data['grandTotal'];
      grandTotalToday = grandTotalToday + total.toInt();
    }
    setState(() {});
  }

  void fetchDataForCurrentMonth() async {
    grandTotalThisMonth = 0;
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));

    List<Document> documents = await Firestore.instance.collection('invoice').get();

    resultMonth = documents.where((doc) {
      String dateString = doc['Tanggal'];
      DateTime documentDate = DateTime.parse(dateString);
      return documentDate.isAfter(firstDayOfMonth.subtract(Duration(days: 1))) &&
        documentDate.isBefore(lastDayOfMonth.add(Duration(days: 1)));
    }).toList();
  
    for (Document document in resultMonth) {
      num total = document['grandTotal'];
      grandTotalThisMonth = grandTotalThisMonth + total.toInt();
    }
    setState(() {});
  }

  void fetchDataForCurrentYear() async {
    grandTotalThisYear = 0;
    DateTime now = DateTime.now();
    DateTime startOfYear = DateTime(now.year, 1, 1);
    DateTime endOfYear = DateTime(now.year, 12, 31);

    List<Document> documents = await Firestore.instance.collection('invoice').get();

    resultYear = documents.where((doc) {
      String dateString = doc['Tanggal'];
      DateTime documentDate = DateTime.parse(dateString);
      return documentDate.isAfter(startOfYear.subtract(Duration(days:1))) &&
      documentDate.isBefore(endOfYear.add(Duration(days:1)));
    }).toList();

    for(Document document in resultYear) {
      num total = document['grandTotal'];
      grandTotalThisYear = grandTotalThisYear + total.toInt();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(child: 
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Penjualan', 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                'Hari Ini',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              SizedBox(height: 10),
                              Text(
                                result.length.toString(),
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 128, 255),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                )
                              ),
                              Text(
                                DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(child: 
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Penjualan', 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                'Bulan Ini',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              SizedBox(height: 10),
                              Text(
                                resultMonth.length.toString(),
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 128, 255),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                )
                              ),
                              Text(
                                DateFormat('MMMM').format(DateTime.now()),
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(child: 
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pendapatan', 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                'Hari Ini',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              SizedBox(height: 10),
                              Text(
                                grandTotalToday.toString(),
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 128, 255),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                )
                              ),
                              Text(
                                DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(child: 
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pendapatan', 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                'Bulan Ini',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              SizedBox(height: 10),
                              Text(
                                grandTotalThisMonth.toString(),
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 128, 255),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                )
                              ),
                              Text(
                                DateFormat('MMMM').format(DateTime.now()),
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(child: 
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pendapatan', 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                'Tahun Ini',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              SizedBox(height: 10),
                              Text(
                                grandTotalThisYear.toString(),
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 128, 255),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                )
                              ),
                              Text(
                                DateFormat('yyyy').format(DateTime.now()).toString(),
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}