import 'package:flutter/material.dart';
import 'package:story/api/api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // list of stories
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () async {
                  // show loading screen
                  int count = await Api().getStoryCount();
                  var data = await Api().getStory(count);
                  // print(data);

                  // once ready append the story to the list of stories
                },
                child: const Text('Generate Story'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
