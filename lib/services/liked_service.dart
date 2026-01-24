import 'dart:convert';
import 'dart:developer';
import 'package:dating/core/url.dart';
import 'package:http/http.dart' as http;
import 'package:dating/models/profile_model.dart';

class LikedService {

  Future<List<Profile>> getLikedProfiles(String userId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/liked-profiles-list"),
        body: {'userId': userId},
      );

    log(userId);
     log(response.body.toString());
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == "SUCCESS") {
          List jsonList = data['data'];
          return jsonList.map((e) => Profile.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}