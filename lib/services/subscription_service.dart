import 'dart:convert';
import 'package:dating/models/plan_model.dart';
import 'package:http/http.dart' as http;

class SubscriptionService {
  static const String _baseUrl = "https://tictechnologies.in/stage/weekend/plans";

  Future<List<SubscriptionPlanModel>> fetchPlans(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {"userId": userId},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == "SUCCESS") {
          return (data['data'] as List)
              .map((json) => SubscriptionPlanModel.fromJson(json))
              .toList();
        } else {
          throw data['statusDesc'] ?? "Failed to load plans";
        }
      } else {
        throw "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}