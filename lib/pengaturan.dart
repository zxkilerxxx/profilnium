import 'package:firedart/auth/user_gateway.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';

class FragmentPengaturan extends StatefulWidget {
  @override
  State<FragmentPengaturan> createState() => _FragmentPengaturan();
}

class _FragmentPengaturan extends State<FragmentPengaturan> {
  final pass1 = TextEditingController();
  final pass2 = TextEditingController();
  bool isButtonDisabled = false;

  void clearText() {
    pass1.text = "";
    pass2.text = "";
  }

  Future<void> updateData({required String password}) async {
    User user = await FirebaseAuth.instance.getUser();
    await Firestore.instance
        .document('user/${user.id}')
        .update({'password': password});
  }

  showAlertDialog(BuildContext context, String title, String newMsg) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(newMsg),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UBAH PROFILE',
                  style: TextStyle(
                    color: Color(0xFF343A40),
                    fontSize: 36,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                    height: 0.03,
                    letterSpacing: 7.20,
                  ),
                ),
                const SizedBox(height: 47.99),
                const SizedBox(height: 47.99),
                Text(
                  'UBAH PASSWORD',
                  style: TextStyle(
                    color: Color(0xFF828282),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 2,
                  ),
                ),
                TextField(
                  controller: pass1,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Masukkan Password Baru",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 47.99),
                Text(
                  'KONFIRMASI PASSWORD',
                  style: TextStyle(
                    color: Color(0xFF828282),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 2,
                  ),
                ),
                TextField(
                  controller: pass2,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Konfirmasi Password Baru",
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 88.0,
                ),
              ]
            ),
          ElevatedButton(
            onPressed: () async {
              if (pass1.text == pass2.text && !isButtonDisabled) {
                try {
                  isButtonDisabled = true;
                  await updateData(password: pass1.text);
                  showAlertDialog(context, 'Sukses', 'Ubah password berhasil');
                } catch (error) {
                  showAlertDialog(context, 'Gagal', error.toString());
                } finally {
                  isButtonDisabled = false;
                  clearText();
                }
              } else {
                showAlertDialog(context, 'Gagal', 'Update password gagal / password tidak sama');
                clearText();
              }
            },
            child: Text("Submit",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12.0,
                )),
            ),
          ]
        ),
      ),
    );
  }
}