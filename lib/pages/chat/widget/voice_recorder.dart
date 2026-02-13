import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';

class VoiceRecorder extends StatelessWidget {
  final Duration duration;
  final VoidCallback onStop;
  final VoidCallback onCancel;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final bool isPaused;

  const VoiceRecorder({
    super.key,
    required this.duration,
    required this.onStop,
    required this.onCancel,
    required this.onPause,
    required this.onResume,
    this.isPaused = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF4D67), Color(0xFFFFD700)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF4D67).withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(38),
        ),
        child: Row(
          children: [
            // Cancel button
            _buildControlButton(
              icon: Iconsax.close_circle,
              color: Colors.red,
              onTap: onCancel,
            ),
            
            // Recording indicator and timer
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated recording indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Timer
                  Text(
                    _formatDuration(duration),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Recording waves animation
                  SizedBox(
                    width: 40,
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 4,
                          height: 10 + (index * 5) + (duration.inSeconds % 3 * 2),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF4D67), Color(0xFFFFD700)],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ).animate(
                          onPlay: (controller) => controller.repeat(reverse: true),
                        ).moveY(
                          begin: 0,
                          end: -3,
                          duration: 500.ms,
                          delay: (index * 100).ms,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            
            // Pause/Resume button
            _buildControlButton(
              icon: isPaused ? Iconsax.play : Iconsax.pause,
              color: const Color(0xFFFFD700),
              onTap: isPaused ? onResume : onPause,
            ),
            
            // Send button
            _buildControlButton(
              icon: Iconsax.send_1,
              color: const Color(0xFFFF4D67),
              onTap: onStop,
              isSendButton: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isSendButton = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSendButton
              ? const Color(0xFFFF4D67).withOpacity(0.2)
              : color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: isSendButton ? 24 : 20,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}