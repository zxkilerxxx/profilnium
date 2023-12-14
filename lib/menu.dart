import 'package:flutter/material.dart';
import 'package:profilnium/home.dart';
import 'package:profilnium/invoice.dart';
import 'package:profilnium/stok.dart';
import 'package:profilnium/pembelian.dart';
import 'package:profilnium/penjualan.dart';
import 'package:profilnium/pengaturan.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = FragmentHome();
        break;
      case 1:
        page = FragmentStok();
        break;
      case 2:
        page = FragmentPembelian();
        break;
      case 3:
        page = FragmentPenjualan();
        break;
      case 4:
        page = FragmentInvoice();
        break;
      case 5:
        page = FragmentPengaturan();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var fragmentArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SafeArea(
                child: NavigationRail(
                  minWidth: 60,
                  backgroundColor: colorScheme.surfaceVariant,
                  extended: true,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text("Home"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.all_inbox),
                      label: Text("Stok"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text("Pembelian"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.attach_money),
                      label: Text("Penjualan"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.mail),
                      label: Text("Invoice"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text("Pengaturan"),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(child: fragmentArea),
            ],
          );
        },
      ),
    );
  }
}