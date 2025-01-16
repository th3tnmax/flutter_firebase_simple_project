import 'package:flutter/material.dart';

class Cardetails extends StatelessWidget {

  final String title;
  final String image;
  final double price;
  final double oldPrice;

  const Cardetails({
    Key? key,
    required this.title,
    required this.image,
    required this.price,
    required this.oldPrice,
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
              // Display the old price with strikethrough
              Text(
                '\$${oldPrice.toStringAsFixed(2)}', // old price
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(height: 4),
              // Display the new price
              Text(
                '\$${price.toStringAsFixed(2)}', // new price
                style: TextStyle(color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Product Description
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