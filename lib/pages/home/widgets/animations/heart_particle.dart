import 'package:flutter/material.dart';
import 'dart:math';
import 'package:dating/main.dart';

class HeartParticle extends StatefulWidget {
  final double angle;
  final double speed;
  final VoidCallback onComplete;
  
  const HeartParticle({
    super.key,
    required this.angle,
    required this.speed,
    required this.onComplete,
  });
  
  @override
  State<HeartParticle> createState() => _HeartParticleState();
}

class _HeartParticleState extends State<HeartParticle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward().then((_) => widget.onComplete());
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double dist = widget.speed * _animation.value;
        return Transform.translate(
          offset: Offset(dist * cos(widget.angle), dist * sin(widget.angle) - 50),
          child: Transform.scale(
            scale: 1.0 - _animation.value,
            child: Opacity(
              opacity: 1.0 - _animation.value,
              child: const Icon(Icons.favorite, color: AppColors.neonGold, size: 20),
            ),
          ),
        );
      },
    );
  }
}