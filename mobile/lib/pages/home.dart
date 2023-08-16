import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story/api/api.dart';
import 'package:story/components/loadingtile.dart';
import 'package:story/components/storytile.dart';
import 'package:story/controllers/home_controller.dart';
// import 'package:animated_gradient/animated_gradient.dart';

class Home extends StatelessWidget {
  final HomeController _controller = Get.put<HomeController>(HomeController());
  final List<Color> colors = [
    const Color.fromARGB(255, 118, 203, 189),
    const Color.fromARGB(255, 98, 88, 168),
    const Color.fromARGB(255, 245, 202, 111),
  ];
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: AnimatedGradient(
      // colors: colors,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.gif'), fit: BoxFit.cover)),
        child: Obx(
          () {
            print("Loading: ${_controller.isLoading.value}");
            print("Stories: ${_controller.stories.length}");
            if (_controller.stories.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: _controller.stories.length,
                itemBuilder: (context, index) {
                  if (index == 0 && _controller.isLoading.value) {
                    return Column(
                      children: [
                        LoadingTile(),
                        StoryTile(
                          id: _controller.stories[index]['id'],
                          title: _controller.stories[index]['title'],
                          image: _controller.stories[index]['img'],
                          story: _controller.stories[index]['story'],
                        ),
                      ],
                    );
                  }
                  if (index == _controller.stories.length - 1) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 64.0),
                      child: StoryTile(
                        id: _controller.stories[index]['id'],
                        title: _controller.stories[index]['title'],
                        image: _controller.stories[index]['img'],
                        story: _controller.stories[index]['story'],
                      ),
                      // LoadingTile()
                    );
                  }
                  return StoryTile(
                    id: _controller.stories[index]['id'],
                    title: _controller.stories[index]['title'],
                    image: _controller.stories[index]['img'],
                    story: _controller.stories[index]['story'],
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: SizedBox(
          // width: double.infinity,
          height: 64,
          child: ElevatedButton(
            // style: ElevatedButton.styleFrom(
            //   // primary: Color(0xffF5F5F5),
            //   // backgroundColor: Color.fromARGB(255, 39, 33, 33),
            //   shadowColor: Colors.white,

            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(32),
            //   ),
            // ),
            onLongPress: () {
              myDialog();
            },
            onPressed: () async {
              // TODO: A dialog to get the text for story generation

              Get.dialog(
                AlertDialog(
                  title: const Text('Enter a story topic'),
                  content: TextFormField(
                    controller: _controller.topicController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a topic',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _controller
                            .createStory(_controller.topicController.text);
                        // _controller.isLoading.value =
                        //     !_controller.isLoading.value;
                        Get.back();
                      },
                      child: const Text('Generate'),
                    ),
                  ],
                ),
              );
            },
            child: const Text(
              'Generate Story',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                // color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  myDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Update BASE URL'),
        content: TextFormField(
          controller: _controller.urlController,
          decoration: const InputDecoration(
            hintText: 'https://example.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // _controller.createStory(_controller.urlController.text);
              // Api().baseUrl = _controller.urlController.text;
              Api().setBaseURL(_controller.urlController.text);
              // _controller.isLoading.value =
              //     !_controller.isLoading.value;
              Get.back();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
