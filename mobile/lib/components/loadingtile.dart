import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingTile extends StatefulWidget {
  const LoadingTile({super.key});

  @override
  State<LoadingTile> createState() => _LoadingTileState();
}

class _LoadingTileState extends State<LoadingTile> {
  @override
  Widget build(BuildContext context) {
    return shimmerTile();
  }

  Widget shimmerTile() {
    return SizedBox(
      // width: 200.0,
      height: 200.0,
      child: Shimmer.fromColors(
        baseColor:  Colors.grey,
        highlightColor: Colors.white.withOpacity(0.5),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),

          height: 200,
        ),

        // child: const Text(
        //   'Shimmer',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontSize: 40.0,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
    );
  }

  Widget storyCard() {
    return GestureDetector(
      onTap: () {
        // open a bottom sheet with the story
        // storyTeller();
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
            const SizedBox(
              width: 120,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(16)),
                // child: Image.network(
                //   rImage,
                //   fit: BoxFit.cover,
                //   width: double.infinity,
                // ),
                child: Placeholder(),
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
                      // child: Text(
                      //   widget.title,
                      //   style: const TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 16,
                      //     color: Colors.white,
                      //   ),
                      // ),
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
                        // child: Text(
                        //   // Truncate the story and display a part of it
                        //   // widget.story.substring(0, 250) + '...',
                        //   widget.story,
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 8,
                        //   style: const TextStyle(
                        //     fontSize: 13,
                        //     color: Colors.white,
                        //   ),
                        // ),
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
}
