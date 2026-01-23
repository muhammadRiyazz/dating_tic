import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dating/models/profile_model.dart';

class LikedService {
  static const String _baseUrl = "https://tictechnologies.in/stage/weekend/liked-profiles-list";

  Future<List<Profile>> getLikedProfiles(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
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