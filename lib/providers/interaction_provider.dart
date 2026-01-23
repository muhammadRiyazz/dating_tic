import 'dart:developer';

import 'package:dating/pages/maches/Match_Success_Screen.dart';
import 'package:flutter/material.dart';
import 'package:dating/services/interaction_service.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui';
import 'package:dating/main.dart';
// providers/interaction_provider.dart
class InteractionProvider with ChangeNotifier {
  final InteractionService _service = InteractionService();

  Future<void> handleAction({
    required BuildContext context,
    required String fromUser,
    required String toUser,
    required String status,
    required String matchedUserImg,
        required String matchedfromUserImg,

    required VoidCallback onComplete,
  }) async {

    
    log("handleAction started for status: $status");

    // 1. Call API FIRST (or store a reference to the Navigator)
    // We capture the navigator state before the widget might get disposed
    final navigator = Navigator.of(context);

    // 2. Optimistically remove the card UI
    onComplete();

    try {
      final result = await _service.postInteraction(
        fromUser: fromUser,
        toUser: toUser,
        status: status,
      );

      log("API Response: $result");

      if (result['status'] == "SUCCESS" && result['data'] != null) {
        // Safe way to check for both Boolean or String "true"
        var isMatchData = result['data']['isMatch'];
        bool isMatch = isMatchData == true || isMatchData.toString() == "true";
        
        log("Is Match: $isMatch");

        if (isMatch) {
          log("Navigating to MatchSuccessScreen...");
          
          // Use the captured navigator to avoid "context unmounted" errors
          navigator.push(
            MaterialPageRoute(
              builder: (context) => MatchSuccessScreen(
                fromuserImg: matchedfromUserImg,
                touserImg: matchedUserImg,
              ),
            ),
          );
        }
      } else {
        log("Operation successful but no match or failed status");
      }
    } catch (e) {
      log("Error in handleAction: $e");
    }
  }
}