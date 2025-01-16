import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OfferPage extends StatelessWidget {
  const OfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
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
          scrollDirection: Axis.horizontal),
      items: [
        Image.network(
            "https://a.storyblok.com/f/112937/568x464/f5d7f01e64/13-strange-and-thrilling-facts-about-halloween_568x464.png/m/620x0/filters:quality(70)/"),
        Image.network(
            "https://assets.editorial.aetnd.com/uploads/2009/11/halloween-gettyimages-1424736925.jpg")
      ],
    );
  }
}
