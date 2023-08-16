import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:story/api/api.dart';

class HomeController extends GetxController {
  RxList stories = RxList([]);
  TextEditingController topicController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  RxBool isLoading = false.obs;
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
    print("fdata $data");
    // iterate through the list and in the imgs array of every object replace the url with the base url
    // for (var i = 0; i < data.length; i++) {
    //   for (var j = 0; j < data[i]["imgs"].length; j++) {
    //     // data[i]["imgs"][j] = Api.baseURL + data[i]["imgs"][j];

    //     // Replace http://127.0.0.1:5000/ with base url
    //     // data[i]["imgs"][j] = data[i]["imgs"][j].replaceAll("http://
    //   }

    // }
    stories.assignAll([]);
    stories.assignAll(data);
    // stories = stories.reversed.toList().obs;
  }

  void createStory(String topic) async {
    isLoading.value = true;
    try {
      await _api.createStory(topic: topic);
      fetchData();
    } catch (e) {
      print("error $e");
    } finally {
      isLoading.value = false;
    }

    // final data = await _api.createStory(topic: topic);
    // print("create story $data");
    // stories.add(data);

    // isLoading.value = false;
    // reveres the list
  }
}
