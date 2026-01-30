// import 'dart:developer';

// import 'package:dating/pages/maches/Match_Success_Screen.dart';
// import 'package:flutter/material.dart';
// import 'package:dating/services/interaction_service.dart';
// import 'package:iconsax/iconsax.dart';
// import 'dart:ui';
// import 'package:dating/main.dart';
// // providers/interaction_provider.dart
// class InteractionProvider with ChangeNotifier {
//   final InteractionService _service = InteractionService();

//   Future<void> handleAction({
//     required BuildContext context,
//     required String fromUser,
//     required String toUser,
//     required String status,
//     required String matchedUserImg,
//         required String matchedfromUserImg,

//     required VoidCallback onComplete,
//   }) async {

    
//     log("handleAction started for status: $status");

//     // 1. Call API FIRST (or store a reference to the Navigator)
//     // We capture the navigator state before the widget might get disposed
//     final navigator = Navigator.of(context);

//     // 2. Optimistically remove the card UI
//     onComplete();

//     try {
//       final result = await _service.postInteraction(
//         fromUser: fromUser,
//         toUser: toUser,
//         status: status,
//       );

//       log("API Response: $result");

//       if (result['status'] == "SUCCESS" && result['data'] != null) {
//         // Safe way to check for both Boolean or String "true"
//         var isMatchData = result['data']['isMatch'];
//         bool isMatch = isMatchData == true || isMatchData.toString() == "true";
        
//         log("Is Match: $isMatch");

//         if (isMatch) {
//           log("Navigating to MatchSuccessScreen...");
          
//           // Use the captured navigator to avoid "context unmounted" errors
//           navigator.push(
//             MaterialPageRoute(
//               builder: (context) => MatchSuccessScreen(
//                 fromuserImg: matchedfromUserImg,
//                 touserImg: matchedUserImg,
//               ),
//             ),
//           );
//         }
//       } else {
//         log("Operation successful but no match or failed status");
//       }
//     } catch (e) {
//       log("Error in handleAction: $e");
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:dating/pages/maches/Match_Success_Screen.dart';
import 'package:flutter/material.dart';
import 'package:dating/services/interaction_service.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui';
import 'package:dating/main.dart';
import 'package:dating/providers/permission_provider.dart';






// providers/interaction_provider.dart
class InteractionProvider with ChangeNotifier {
  final InteractionService _service = InteractionService();

  Future<Map<String, dynamic>> handleAction({
    required BuildContext context,
    required String fromUser,
    required String toUser,
    required String status,
    required String matchedUserImg,
    required String matchedfromUserImg,
    required VoidCallback onComplete,
  }) async {
    log("handleAction started for status: $status");

    try {
      // 1. Call API
      final result = await _service.postInteraction(
        fromUser: fromUser,
        toUser: toUser,
        status: status,
      );

      log("API Response: $result");

      // 2. Check if the action was successful
      if (result['status'] == "SUCCESS") {
        // 3. Optimistically remove the card UI
        onComplete();

        // 4. Check for match
        if (result['data'] != null) {
          var isMatchData = result['data']['isMatch'];
          bool isMatch = isMatchData == true || isMatchData.toString() == "true";
          
          log("Is Match: $isMatch");

          // 5. Handle match
          if (isMatch) {
            log("Navigating to MatchSuccessScreen...");
            
            // Use Future.microtask to ensure navigation happens after current frame
            Future.microtask(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MatchSuccessScreen(
                    fromuserImg: matchedfromUserImg,
                    touserImg: matchedUserImg,
                  ),
                ),
              );
            });
          }
        }

        // 6. Return success result
        return {
          'success': true,
          'message': status == 'like' ? 'Liked successfully!' : 'Profile passed',
          'isMatch': result['data']?['isMatch'] ?? false,
        };
      } else {
        // 7. Handle API failure
        final message = result['statusDesc'] ?? 'Action failed';
        
        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );

        return {
          'success': false,
          'message': message,
          'isMatch': false,
        };
      }
    } catch (e) {
      log("Error in handleAction: $e");
      
      // 8. Handle network/other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Network error. Please check your connection.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );

      return {
        'success': false,
        'message': 'Network error: $e',
        'isMatch': false,
      };
    }
  }

  // New method to check permission before liking
  Future<Map<String, dynamic>> checkAndLike({
    required BuildContext context,
    required String fromUser,
    required String toUser,
    required String matchedUserImg,
    required String matchedfromUserImg,
    required VoidCallback onComplete,
    required PermissionProvider permissionProvider,
  }) async {
    // Check if user can like (permissions are checked in UI)
    if (!permissionProvider.canLike) {
      return {
        'success': false,
        'message': 'Daily like limit reached',
        'requiresUpgrade': true,
        'isMatch': false,
      };
    }

    // Call the handleAction method
    return await handleAction(
      context: context,
      fromUser: fromUser,
      toUser: toUser,
      status: 'like',
      matchedUserImg: matchedUserImg,
      matchedfromUserImg: matchedfromUserImg,
      onComplete: onComplete,
    );
  }

  // Method to pass (no permission check needed)
  Future<Map<String, dynamic>> passProfile({
    required BuildContext context,
    required String fromUser,
    required String toUser,
    required String matchedUserImg,
    required String matchedfromUserImg,
    required VoidCallback onComplete,
  }) async {
    return await handleAction(
      context: context,
      fromUser: fromUser,
      toUser: toUser,
      status: 'pass',
      matchedUserImg: matchedUserImg,
      matchedfromUserImg: matchedfromUserImg,
      onComplete: onComplete,
    );
  }

}
