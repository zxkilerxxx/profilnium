import 'dart:async';
import 'package:profilnium/services/firebase_auth_service.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';
import 'package:profilnium/menu.dart';
import 'package:profilnium/services/utility_service.dart';

void main() {
  FirebaseAuth.initialize(DefaultFirebaseOptions.currentPlatform.apiKey, VolatileStore());
  Firestore.initialize(DefaultFirebaseOptions.currentPlatform.projectId);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var logger = Logger();
  final UtilityService _utilityService = UtilityService();
  bool _isOnline = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  checkConnection() {
    _utilityService.checkConnectivity().then((value) => {
      if (value != _isOnline)
        {
          setState(() {
            _isOnline = value;
          })
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profilnium',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0080FF)),
      ),
      home: _isOnline
        ? LoginScreen()
        : Scaffold(
          body: Center(
            child: Column(
              children: [
                LoadingAnimationWidget.staggeredDotsWave(
                  color: Theme.of(context).colorScheme.primary,
                  size: 50.0,
                ),
                SizedBox(height: 50),
                Text("Tidak ada koneksi internet")
              ]
            )
          )
        )
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final query = Firestore.instance.collection("user");
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  Future<bool> loginUser(
      {required String userName, required String password}) async {
    try {
      var querySnapshot =
        await query.where("username", isEqualTo: userName).get();
      for (var docSnapshot in querySnapshot) {
        if (password == docSnapshot["password"].toString()) {
          if (userName == "admin") {
            _firebaseAuthService.signOut();
            await _firebaseAuthService.signIn("admin@admin.com", "abcabc123");
          } else if (userName == "user") {
            _firebaseAuthService.signOut();
            await _firebaseAuthService.signIn(
                "karyawan@karyawan.com", "abcabc123");
          }
          return true;
        } else {
          showAboutDialog(context: context);
          return false;
        }
      }
      return false;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _firebaseAuthService.signIn("aplikasi@aplikasi.com", "abcabc123");
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showAlertDialog(BuildContext context, String title, String message) {
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profilnium",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Login to your app",
              style: TextStyle(
                color: Colors.black,
                fontSize: 44.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 44.0,
            ),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: "Username",
                prefixIcon: Icon(Icons.person, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 26.0,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Text(
              "Lupa password?",
              style: TextStyle(color: Colors.blue),
            ),
            const SizedBox(
              height: 88.0,
            ),
            SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: const Color(0xFF0069FE),
                elevation: 0.0,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                onPressed: () async {
                  if (await loginUser(
                      userName: emailController.text,
                      password: passwordController.text)) {
                        Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MenuScreen()));
                  } else {
                    showAlertDialog(context, 'Gagal', 'Username/password salah');
                  }
                },
                child: const Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}