import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LikersShimmer extends StatelessWidget {
  const LikersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Center(
        child: Container(
          height: 520,
          width: MediaQuery.of(context).size.width * 0.78,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(38),
          ),
        ),
      ),
    );
  }
}