import 'package:dio/dio.dart';

class Api {
  final Dio _dio = Dio();

  static var baseURL = "http://127.0.0.1:5000/";

  // endpoints:
  static final storiesCount = "${baseURL}get_story_count";
  static final getNstories = "${baseURL}get_n_stories";
  

  Future<int> getStoryCount() async {
    try {
      final response = await _dio.get(storiesCount);
      final Map data = response.data;
      return data['count'] ?? 0;
    } catch (e) {
      // print(e);
      return 0;
    }
  }

  Future<dynamic> getStory(int n) async {
    try {
      final response = await _dio.get("$getNstories?n=$n");
      final Map data = response.data;
      // print(data);
      return data['stories'] ?? [];
    } catch (e) {
      // debugPrint(e);
      return [];
    }
  }
}
