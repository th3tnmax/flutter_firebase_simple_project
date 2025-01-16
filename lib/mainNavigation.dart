import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tp3/carsDealPage.dart';
import 'package:flutter_tp3/homePage.dart';
import 'package:flutter_tp3/login.dart';
import 'package:flutter_tp3/moviePage.dart';
import 'package:flutter_tp3/offerPage.dart';
import 'package:flutter_tp3/productDeals.dart';
import 'package:flutter_tp3/profilePage.dart';
import 'package:flutter_tp3/searchPage.dart';
import 'package:flutter_tp3/sign_up.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();

}
class _MainNavigationState extends State<MainNavigation>{
  int _page = 3;
  List<Widget> list = [
    Moviepage(),
    Productdeals(),
    Carsdealpage(),
    ProfilePage(),
  ];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome' ,
          style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.purple,

          //back arrow
          
          leading : Navigator.canPop(context)
           ? IconButton(
            icon: Icon(Icons.arrow_back ,
            color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous page
            },
          )
        : null,

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
          index: _page,
          backgroundColor: Color.fromRGBO(234, 218, 240, 1),
          items: [
            CurvedNavigationBarItem(
              child: Icon(Icons.movie_creation_rounded),
              label: 'Movies',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.production_quantity_limits),
              label: 'Product',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.local_offer_outlined),
              label: 'Offer',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.perm_identity),
              label: 'Profile',
            ),
          ],
        ));
  }
}