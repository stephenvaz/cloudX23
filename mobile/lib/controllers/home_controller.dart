import 'package:get/state_manager.dart';
import 'package:story/api/api.dart';

class HomeController extends GetxController {
  RxList stories = RxList([]);

  late Api _api;

  @override
  void onInit() {
    _api = Api();
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    final int count = await _api.getStoryCount();
    final data = await _api.getStory(count);
    stories.assignAll(data);
  }
}
