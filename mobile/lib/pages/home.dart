import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story/components/storytile.dart';
import 'package:story/controllers/home_controller.dart';
import 'package:animated_gradient/animated_gradient.dart';

class Home extends StatelessWidget {
  final HomeController _controller = Get.put<HomeController>(HomeController());

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradient(
            colors:  [ 
              const Color.fromARGB(255, 118, 203, 189),
              const Color(0xFFeec5ce),
              const Color.fromARGB(255, 235, 207, 189),
            ],
          
    
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
                  return StoryTile(
                    title: _controller.stories[index]['title'],
                    image: _controller.stories[index]['img'][0],
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
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            onPressed: () async {
              _controller.fetchData();
            },
            child: const Text('Generate Story'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
