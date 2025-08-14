import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(

              ),
              title: Container(
                height: 20,
                width: 200,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 20,
                width: 200,
                color: Colors.white,
              ),
            );
          }),
    );
  }
}