import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dating/models/profile_model.dart';

class MatchesService {
  static const String _url = "https://tictechnologies.in/stage/weekend/matched-profiles-list";

  Future<List<Profile>> getMatches(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        body: {'userId': userId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == "SUCCESS") {
          List jsonList = data['data'];
          return jsonList.map((e) => Profile.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}