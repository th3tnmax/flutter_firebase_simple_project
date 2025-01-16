import 'package:flutter/material.dart';

class ItemHome extends StatelessWidget {
  const ItemHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text("500 dt par mois"),
          subtitle: Text("s+1, 50m"),
          trailing: Icon(Icons.favorite_outline),
        ),
        Container(child: Image.asset("assets/home.jpeg")),
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(
              "Nous vous proposons à la location une magnifique maison de 50 m², située dans un quartier calme et résidentiel, à seulement 10 minutes à pied du centre-ville."),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: OverflowBar(overflowAlignment: OverflowBarAlignment.end,
          children: [TextButton(onPressed: ()=>{}, child: Text("verifier dispo")),TextButton(onPressed: ()=>{}, child: Text("contacter nous")),],),
        )
      ]),
    ); 
  }
}