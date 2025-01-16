import 'package:flutter/material.dart';
import 'package:flutter_tp3/item_home.dart';
import 'package:flutter_tp3/offerPage.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          OfferPage(),
          Expanded(
            child: ListView(
              children: [
                ItemHome(),
                ItemHome(),
                ItemHome(),
                ItemHome(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
