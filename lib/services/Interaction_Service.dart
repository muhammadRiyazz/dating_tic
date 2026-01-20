import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class InteractionService {
  final String baseUrl = "https://tictechnologies.in/stage/weekend/user-interactions";

  Future<Map<String, dynamic>> postInteraction({
    required String fromUser,
    required String toUser,
    required String status,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'from_user': fromUser,
          'to_user': toUser,
          'status': status,
        },
      );
      log({
          'from_user': fromUser,
          'to_user': toUser,
          'status': status,
        }.toString());
log(response.body.toString());
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"status": "FAILED", "statusDesc": "Server Error"};
      }
    } catch (e) {
      return {"status": "FAILED", "statusDesc": e.toString()};
    }
  }
}