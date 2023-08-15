import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story/components/storytile.dart';
import 'package:story/controllers/home_controller.dart';
import 'package:animated_gradient/animated_gradient.dart';

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
      body: AnimatedGradient(
        colors: colors,
        child: Obx(
          () {
            if (_controller.stories.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: _controller.stories.length,
                itemBuilder: (context, index) {
                  if (index == _controller.stories.length-1) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom:64.0),
                      child: StoryTile(
                      id: _controller.stories[index]['id'],
                      title: _controller.stories[index]['title'],
                      image: _controller.stories[index]['img'],
                      story: _controller.stories[index]['story'],
                                      ),
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
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 18),
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              onPressed: () async {
                // _controller.fetchData();
                // TODO: A dialog to get the text for story generation
              },
              child: const Text('Generate Story'),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
