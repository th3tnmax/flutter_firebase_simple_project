import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tp3/productDetailsPage.dart';
import 'package:http/http.dart' as http;

class Productdeals extends StatefulWidget {
  const Productdeals({super.key});

  @override
  State<Productdeals> createState() => _ProductdealsState();
}

class _ProductdealsState extends State<Productdeals> {
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
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

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

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredOffers = offers
          .where((offer) => offer['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
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
      return Productdeals(); 
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search offers...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
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
              final offer = filteredOffers[index];  // Use filteredOffers instead of offers
              return OfferCard(
                title: offer['title'],
                image: offer['image'],
                price: offer['price'],
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

  const OfferCard({
    super.key,
    required this.title,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Product Details Page when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Productdetailspage(
              title: title,
              image: image,
              price: price,
            ),
          ),
        );
      },
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
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green, fontSize: 14),
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