import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MatchesShimmer extends StatelessWidget {
  const MatchesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Shimmer.fromColors(
            baseColor: Colors.white.withOpacity(0.05),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 280,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          childCount: 3,
        ),
      ),
    );
  }
}