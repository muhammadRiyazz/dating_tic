import 'dart:convert';
import 'package:dating/core/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/plan_model.dart';

class SubscriptionService {
  
  // List of dummy background images
  static final List<String> _backgroundImages = [
    'https://images.unsplash.com/photo-1566759996874-04d713cc224a?q=80&w=774&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.pexels.com/photos/4873585/pexels-photo-4873585.jpeg',
    'https://images.unsplash.com/photo-1511519620772-8ce30462884f?q=80&w=774&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.pexels.com/photos/3171204/pexels-photo-3171204.jpeg',
    'https://images.pexels.com/photos/4873585/pexels-photo-4873585.jpeg',
    'https://images.pexels.com/photos/3171204/pexels-photo-3171204.jpeg',
    'https://images.pexels.com/photos/4873585/pexels-photo-4873585.jpeg',
    'https://images.pexels.com/photos/6579000/pexels-photo-6579000.jpeg',
    'https://images.pexels.com/photos/3171204/pexels-photo-3171204.jpeg',
    'https://images.pexels.com/photos/4873585/pexels-photo-4873585.jpeg',
  ];

  static String getRandomBackgroundImage(int index) {
    return _backgroundImages[index % _backgroundImages.length];
  }

  static Future<List<SubscriptionPlanModel>> fetchPlans({required String userId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/plans'),
     
        body: {
          'userId': userId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'SUCCESS') {
          final plansData = data['data'] as List;
          return plansData.map((planJson) => SubscriptionPlanModel.fromJson(planJson)).toList();
        } else {
          throw Exception('Failed to fetch plans: ${data['statusDesc']}');
        }
      } else {
        throw Exception('Failed to load plans. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
// subscription_service.dart

static Future<Map<String, dynamic>> upgradePlan({
  required String userId,
  required String planPriceId,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/upgrade-plan'),
      body: {
        'userId': userId,
        'planPriceId': planPriceId,
      },
    );

    final data = json.decode(response.body);
    return data; // Return the full map to handle success/failure in provider
  } catch (e) {
    return {
      "status": "FAILED",
      "statusDesc": "Connection error: $e"
    };
  }
}
  // Get icon based on plan name
  static String getIconForPlan(String planName) {
    switch (planName.toLowerCase()) {
      case 'gold':
        return '👑';
      case 'silver':
        return '⚡';
      case 'basic':
        return '🚀';
      default:
        return '⭐';
    }
  }

  // Get gradient colors based on plan

}