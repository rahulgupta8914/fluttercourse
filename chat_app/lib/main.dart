import 'package:chat_app/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              textTheme: ButtonTextTheme.primary)),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong!'),
            );
          }
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ChatScreen();
                }
                return AuthScreen();
              },
              stream: FirebaseAuth.instance.authStateChanges(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
