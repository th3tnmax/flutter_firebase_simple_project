import 'package:flutter/material.dart';

class Productdetailspage extends StatelessWidget {

  final String title;
  final String image;
  final double price;
  const Productdetailspage({
    Key? key,
    required this.title,
    required this.image,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(  // Make the body scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.network(image),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('\$${price.toStringAsFixed(2)}'),
              SizedBox(height: 16),
              Text(
                'Here are the details for the product. You can add more details as per your requirements.',
                textAlign: TextAlign.center,
              ),
              // Additional content can be added here
            ],
          ),
        ),
      ),
    );
  }
}