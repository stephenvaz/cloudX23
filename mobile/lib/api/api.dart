import 'package:dio/dio.dart';
import 'dart:math';

class Api {
  final Dio _dio = Dio();

  static var baseURL = "http://127.0.0.1:5000/";
  // static var baseURL = "https://tedo.serveo.net/";

  // endpoints:
  static final storiesCount = "${baseURL}get_story_count";
  static final getNstories = "${baseURL}get_n_stories";
  static final getFollowup = "${baseURL}get_followup";

  Future<int> getStoryCount() async {
    try {
      final response = await _dio.get(storiesCount);
      final Map data = response.data;
      return data['count'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<dynamic> getStory(int n) async {
    try {
      final response = await _dio.get("$getNstories?n=$n");
      final Map data = response.data;
      return data['stories'] ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getFollowupResponse({
    required int storyId,
    required String question,
  }) async {
    final sessionId = _generateRandomSessionId();
    try {
      final response = await _dio.get(
        getFollowup,
        queryParameters: {
          'session_id': sessionId,
          'story_id': storyId,
          'question': question,
        },
      );
      return response.data;
    } catch (e) {
      return {'response': '', 'audio': ''};
    }
  }

  int _generateRandomSessionId() {
    final random = Random();
    return random.nextInt(900000) + 100000; // Generates a 6-digit random number
  }
}
