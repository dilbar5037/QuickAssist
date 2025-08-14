import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final bool orientation;

  StarRating({required this.rating,this.orientation=true});

  @override
  Widget build(BuildContext context) {
    return orientation==true?Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    ):
    Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    )
    ;
  }
}
