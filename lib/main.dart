import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:role_based_login/login_page.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDH5y8gzB-Hqn8Fn9KLsQgZmDnZfB9G8D0",
        appId: "appId",
        messagingSenderId: "messagingSenderId",
        projectId: "rolebased-2e7ec"
    )

  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: SignInScreen(),
    );
  }
}
