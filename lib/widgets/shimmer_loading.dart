// lib/widgets/shimmer_loading.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    Key? key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;
    
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[800]!,
      highlightColor: highlightColor ?? Colors.grey[600]!,
      child: child,
    );
  }
}

// Shimmer for list items
class ListItemShimmer extends StatelessWidget {
  final double height;
  final double? width;

  const ListItemShimmer({
    Key? key,
    this.height = 60,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

// Shimmer for grid items
class GridItemShimmer extends StatelessWidget {
  final double height;
  final double width;

  const GridItemShimmer({
    Key? key,
    this.height = 80,
    this.width = 160,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}