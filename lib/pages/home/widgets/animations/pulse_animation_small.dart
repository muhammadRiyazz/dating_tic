import 'package:flutter/material.dart';

class PulseAnimationSmall extends StatefulWidget {
  const PulseAnimationSmall({super.key});
  
  @override
  State<PulseAnimationSmall> createState() => _PulseAnimationSmallState();
}

class _PulseAnimationSmallState extends State<PulseAnimationSmall> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green.withOpacity(1 - _controller.value),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }
}