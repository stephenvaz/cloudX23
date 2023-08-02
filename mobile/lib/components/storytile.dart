import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:palette_generator/palette_generator.dart';

class StoryTile extends StatefulWidget {
  final String title;
  final String image;
  final String story;

  const StoryTile({
    Key? key,
    required this.title,
    required this.image,
    required this.story,
  }) : super(key: key);

  @override
  _StoryTileState createState() => _StoryTileState();
}

class _StoryTileState extends State<StoryTile> {
  Color? backgroundColor;
  Color? textColor;

  final FlipCardController _flipCardController = FlipCardController();

  @override
  void initState() {
    super.initState();
    _extractImageColor();
  }

  Future<void> _extractImageColor() async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(widget.image),
    );
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
    return FlipCard(
        frontWidget: frontCard(),
        backWidget: backCard(),
        controller: _flipCardController,
        rotateSide: RotateSide.right);
  }

  Widget frontCard() {
    return GestureDetector(
      onTap: () {
        _flipCardController.flipcard();
      },
      child: Container(
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
                widget.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200, // Adjust the height to make the image bigger
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.3), // Adjust the blur opacity as needed
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  // TODO: Add navigation to the story page
                },
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    widget.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'KidsFont',
                    color: textColor,
                  ),
                ),
                // subtitle: Text(
                //   '${widget.story.substring(0, 150)}...',
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontFamily: 'KidsFont',
                //     color: textColor,
                //   ),
                // ),
                // trailing: Icon(
                //   Icons.arrow_forward,
                //   color: textColor,
                //   size: 30,
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget backCard() {
    return GestureDetector(
      onTap: () {
        _flipCardController.flipcard();
      },
      child: Container(
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
                widget.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200, // Adjust the height to make the image bigger
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.3), // Adjust the blur opacity as needed
                  ),
                ),
              ),
              // ListTile(
              //   onTap: () {
              //     // TODO: Add navigation to the story page
              //   },
              //   leading: ClipRRect(
              //     borderRadius: BorderRadius.circular(4),
              //     child: Image.network(
              //       widget.image,
              //       width: 80,
              //       height: 80,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              //   title: Text(
              //     widget.title,
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 18,
              //       fontFamily: 'KidsFont',
              //       color: textColor,
              //     ),
              //   ),
              //   // subtitle: Text(
              //   //   '${widget.story.substring(0, 150)}...',
              //   //   maxLines: 2,
              //   //   overflow: TextOverflow.ellipsis,
              //   //   style: TextStyle(
              //   //     fontSize: 14,
              //   //     fontFamily: 'KidsFont',
              //   //     color: textColor,
              //   //   ),
              //   // ),
              //   // trailing: Icon(
              //   //   Icons.arrow_forward,
              //   //   color: textColor,
              //   //   size: 30,
              //   // ),
              // ),
    
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${widget.story}...',
                  maxLines: 6,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'KidsFont',
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
