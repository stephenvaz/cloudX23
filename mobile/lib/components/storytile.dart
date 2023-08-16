import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:story/api/api.dart';
import 'package:story/components/storyplayer.dart';

class StoryTile extends StatefulWidget {
  final int id;
  final String title;
  List? image;
  final String story;

  StoryTile({
    Key? key,
    required this.id,
    required this.title,
    this.image,
    required this.story,
  }) : super(key: key);

  @override
  _StoryTileState createState() => _StoryTileState();
}

class _StoryTileState extends State<StoryTile> {
  Color? backgroundColor;
  Color? textColor;
  String rImage = '';

  List listImgs = [];

  final FlipCardController _flipCardController = FlipCardController();

  @override
  void initState() {
    super.initState();
    // print("id: ${widget.id}");
    listImgs = widget.image ?? [];
    // rImage = widget.image.replaceAll("http://127.0.0.1:5000/", Api.baseURL);
    for (var i = 0; i < listImgs.length; i++) {
      print("image: ${listImgs[i]}");
      listImgs[i] =
          listImgs[i].replaceAll("http://127.0.0.1:5000/", Api.baseURL);
    }
    print("image: ${listImgs}");

    // choose a random image from the list
    // get a random number between 0 and length of the list
    // final int random = Random().nextInt(widget.image.length);
    // rImage = widget.image[random];
    final int random = Random().nextInt(listImgs.length);
    rImage = listImgs[random];
    _extractImageColor();
  }

  Future<void> _extractImageColor() async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      // NetworkImage(widget.image),
      NetworkImage(rImage),
    );
    if (!mounted) return;
    setState(() {
      backgroundColor = paletteGenerator.dominantColor?.color;
      if (backgroundColor != null) {
        textColor = backgroundColor!.computeLuminance() > 0.8
            ? Colors.black
            : Colors.white;
      } else {
        textColor = Colors.black;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return FlipCard(
    //     frontWidget: frontCard(),
    //     backWidget: backCard(),
    //     controller: _flipCardController,
    //     rotateSide: RotateSide.right);
    return storyCard();
  }

  Widget storyCard() {
    return GestureDetector(
      onTap: () {
        // open a bottom sheet with the story
        storyTeller();
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          // color: backgroundColor?.withOpacity(0.5),
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          // boxShadow: [
          //   BoxShadow(
          //     // color: backgroundColor != null
          //     //     ? backgroundColor!.withOpacity(0.5)
          //     //     : Colors.grey.withOpacity(0.5),
          //     color: Colors.grey.withOpacity(0.4),
          //     blurRadius: 2,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 120,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(16)),
                child: Image.network(
                  rImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          // Truncate the story and display a part of it
                          // widget.story.substring(0, 250) + '...',
                          widget.story,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 8,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget frontCard() {
  //   return GestureDetector(
  //     onTap: () {
  //       // open a bottom sheet with the story
  //       storyTeller();
  //     },
  //     child: Container(
  //       height: 200,
  //       decoration: BoxDecoration(
  //         color: backgroundColor,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: backgroundColor != null
  //                 ? backgroundColor!.withOpacity(0.5)
  //                 : Colors.grey.withOpacity(0.5),
  //             blurRadius: 6,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(16),
  //         child: Stack(
  //           children: [
  //             Image.network(
  //               rImage,
  //               fit: BoxFit.cover,
  //               width: double.infinity,
  //               height: 200, // Adjust the height to make the image bigger
  //             ),
  //             Positioned.fill(
  //               child: BackdropFilter(
  //                 filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
  //                 child: Container(
  //                   color: Colors.black.withOpacity(0.3),
  //                 ),
  //               ),
  //             ),
  //             ListTile(
  //               onTap: () {
  //                 // TODO: Add navigation to the story page
  //               },
  //               leading: ClipRRect(
  //                 borderRadius: BorderRadius.circular(4),
  //                 child: Image.network(
  //                   rImage,
  //                   width: 80,
  //                   height: 80,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               title: Text(
  //                 widget.title,
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 18,
  //                   fontFamily: 'KidsFont',
  //                   color: textColor,
  //                 ),
  //               ),
  //             ),
  //             // Positioned(
  //             //   bottom: 8,
  //             //   right: 8,
  //             //   child: CircleAvatar(
  //             //     backgroundColor: Colors.teal.shade200.withOpacity(0.5),
  //             //     child: IconButton(
  //             //       onPressed: () {
  //             //         _flipCardController.flipcard();
  //             //       },
  //             //       icon: const Icon(Icons.flip),
  //             //     ),
  //             //   ),
  //             // ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<dynamic> storyTeller() {
    return showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.black87,
      // anchorPoint: Offset(0, 0),
      
      builder: (context) {
        return StoryPlayer(
            widget: widget, textColor: textColor, images: listImgs);
      },
    );
  }

  Widget backCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor != null
                ? backgroundColor!.withOpacity(0.5)
                : Colors.grey.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.network(
              rImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200, // Adjust the height to make the image bigger
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.story}...',
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'KidsFont',
                      color: Colors.white, // Use a playful text color
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: backgroundColor?.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          // TODO: Navigate to the next screen
                        },
                        child: Text(
                          'Read More',
                          style: TextStyle(
                            color: textColor, // Use an appealing button color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _flipCardController.flipcard();
                        },
                        icon: Icon(
                          Icons.flip,
                          color: textColor, // Use an appealing button color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
