import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tp3/cardetails.dart';
import 'package:http/http.dart' as http;

class Carsdealpage extends StatefulWidget {
  const Carsdealpage({super.key});

  @override
  State<Carsdealpage> createState() => _CarsdealpageState();
}

class _CarsdealpageState extends State<Carsdealpage> {
  List<dynamic> offers = []; // To store the offers from the API
  List<dynamic> filteredOffers = []; // Offers filtered
  bool isLoading = true; // To handle the loading state
  String searchQuery = ''; // Current search

  @override
  void initState() {
    super.initState();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products?offset=0&limit=5'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          // Normalize price to double
          offers = data.map((offer) {
            return {
              ...offer,
              'price': (offer['price'] is int) ? (offer['price'] as int).toDouble() : offer['price'],
            };
          }).toList();
          filteredOffers = offers; // Initialize filteredOffers with all offers
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load offers');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching offers: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (filteredOffers.isEmpty) {
      // Instead of blocking the whole page, show a SnackBar with a message
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The product is not available at the moment.')),
        );
      });
      return Carsdealpage(); 
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          
        ),
        Expanded(
          child: CarouselSlider.builder(
            options: CarouselOptions(
              height: 200.0,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
            itemCount: filteredOffers.length,
            itemBuilder: (context, index, realIndex) {
              final offer = filteredOffers[index];
              double oldPrice = offer['price'] * 1.2;  // Use filteredOffers instead of offers
              return OfferCard(
                title: offer['title'],
                image: offer['image'],
                price: offer['price'],
                oldPrice: oldPrice, // Assuming original price is 20% more than current price
                onTap: () {
                  // Navigate to the ProductDetailsPage with the selected product data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cardetails(
                        title: offer['title'],
                        image: offer['image'],
                        price: offer['price'],
                        oldPrice: oldPrice,
                        
                        ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class OfferCard extends StatelessWidget {
  final String title;
  final String image;
  final double price;
  final double oldPrice;
  final VoidCallback onTap;

  const OfferCard({
    super.key,
    required this.title,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger onTap when the card is clicked
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // Show the old price with strikethrough
                  Text(
                    '\$${oldPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Show the new price in green and larger font
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}