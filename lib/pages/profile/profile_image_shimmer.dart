import 'package:flutter/material.dart';

class ProfileImageShimmer extends StatelessWidget {
  final double size;
  final bool showName;
  final bool showSubtitle;
  
  const ProfileImageShimmer({
    super.key,
    this.size = 150,
    this.showName = true,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Circular image shimmer
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
          ),
          child: Center(
            child: Container(
              width: size * 0.9,
              height: size * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
        ),
        
        if (showName) ...[
          const SizedBox(height: 20),
          // Name shimmer
          Container(
            width: 120,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
        
        if (showSubtitle) ...[
          const SizedBox(height: 8),
          // Subtitle shimmer
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ],
    );
  }
}