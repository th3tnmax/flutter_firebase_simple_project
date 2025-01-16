import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tp3/AuthViewModel.dart';

import 'package:flutter_tp3/chatPage.dart';
import 'package:flutter_tp3/homePage.dart';
import 'package:flutter_tp3/login.dart';
import 'package:flutter_tp3/mainNavigation.dart';
import 'package:flutter_tp3/profilePage.dart';
import 'package:flutter_tp3/searchPage.dart';
import 'package:flutter_tp3/sign_up.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Authviewmodel()),
        ],
        child: MaterialApp(
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple)),
          // home: MainNavigation(),
          home: LoginPage(),

        ));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  List<Widget> list = [
    Homepage(),
    Searchpage(),
    ProfilePage(),
    Chatpage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Navigation'),
        ),
        backgroundColor: Color.fromRGBO(234, 218, 240, 1),
        body: IndexedStack(
          index: _page,
          children: list,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          backgroundColor: Color.fromRGBO(234, 218, 240, 1),
          items: [
            CurvedNavigationBarItem(
              child: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.search),
              label: 'Search',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.newspaper),
              label: 'Chat',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.perm_identity),
              label: 'Profile',
            ),
          ],
        ));
  }
}
