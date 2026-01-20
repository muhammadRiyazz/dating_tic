import 'package:flutter/material.dart';
import 'package:dating/services/interaction_service.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui';
import 'package:dating/main.dart';

class InteractionProvider with ChangeNotifier {
  final InteractionService _service = InteractionService();

  Future<void> handleAction({
    required BuildContext context,
    required String fromUser,
    required String toUser,
    required String status,
    required VoidCallback onComplete,
  }) async {
    // Optimistically remove the card for smooth UI
    onComplete();

    final result = await _service.postInteraction(
      fromUser: fromUser,
      toUser: toUser,
      status: status,
    );

    if (result['status'] == "SUCCESS") {
      if (result['data'] != null && result['data']['isMatch'] == true) {
        _showMatchOverlay(context);
      }
    } else {
      // If failed, you could potentially show a toast or undo the removal
      debugPrint("Interaction Failed: ${result['statusDesc']}");
    }
  }

  void _showMatchOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF121212).withOpacity(0.9),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: AppColors.neonGold.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Iconsax.lovely5, color: AppColors.neonGold, size: 80),
                const SizedBox(height: 20),
                const Text("IT'S A MATCH!", 
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2)),
                const SizedBox(height: 12),
                const Text("You both liked each other! Start the conversation now.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonGold,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("SAY HELLO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Keep Browsing", style: TextStyle(color: Colors.white54)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}