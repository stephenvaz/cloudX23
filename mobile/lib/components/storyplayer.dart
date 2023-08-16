import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:story/api/api.dart';
import 'package:story/components/storytile.dart';
import 'package:lottie/lottie.dart';

class StoryPlayer extends StatefulWidget {
  const StoryPlayer(
      {Key? key,
      required this.widget,
      required this.textColor,
      required this.images})
      : super(key: key);

  final StoryTile widget;
  final ui.Color? textColor;
  final List<dynamic> images;

  @override
  State<StoryPlayer> createState() => _StoryPlayerState();
}

class _StoryPlayerState extends State<StoryPlayer>
    with TickerProviderStateMixin {
  FlutterTts flutterTts = FlutterTts();
  List<String> storyParagraphs = [];
  int currentParagraphIndex = 0;
  int currentImageIndex = 0;
  double opacity = 1.0;
  bool isPlaying = true;

  late AnimationController _animationController;

  bool isChatOverlayVisible = false;
  TextEditingController textController = TextEditingController();
  List<String> chatMessages = [];

  void toggleChatOverlay() {
    setState(() {
      isChatOverlayVisible = !isChatOverlayVisible;
    });
  }

  void closeChatOverlay() {
    setState(() {
      isChatOverlayVisible = false;
    });
  }

  void sendMessage() async {
    String message = textController.text;
    textController.clear();
    setState(() {
      chatMessages.insert(0, 'You: $message');
    });

    // Start typing indicator
    toggleBotTyping(true);

    // Make the API request and get the response
    final response = await Api().getFollowupResponse(
      storyId: widget.widget.id,
      question: message,
    );

    // Stop typing indicator
    toggleBotTyping(false);

    setState(() {
      chatMessages.insert(0, 'AI: ${response['response']}');
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    storyParagraphs = widget.widget.story.split('\n\n');
    initSetup();
    speakParagraph(currentParagraphIndex);
    _animationController.forward();
  }

  void initSetup() async {
    // await flutterTts.setVoice({"name": "Junior", "locale": "en-US"});
    await flutterTts.awaitSpeakCompletion(true);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void speakParagraph(int index) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.speak(storyParagraphs[index]);

    if (index < storyParagraphs.length - 1) {
      if (!mounted) return;
      setState(() {
        currentParagraphIndex = index + 1;
        currentImageIndex =
            (currentImageIndex + 1) % widget.widget.image!.length;
      });
      _animationController.reset();
      await _animationController.forward();
      await Future.delayed(const Duration(milliseconds: 500));
      speakParagraph(currentParagraphIndex);
    } else {
      if (!mounted) return;
      setState(() {
        isPlaying = false;
      });
    }
  }

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        speakParagraph(currentParagraphIndex);
      } else {
        flutterTts.pause();
      }
    });
  }

  void replayStory() async {
    await flutterTts.stop();
    setState(() {
      currentParagraphIndex = 0;
      currentImageIndex = 0;
      isPlaying = true;
    });
    speakParagraph(currentParagraphIndex);
  }

  bool isBotTyping = false;

  void toggleBotTyping(bool typing) {
    setState(() {
      isBotTyping = typing;
    });
  }

  void clearChat() {
    setState(() {
      chatMessages.clear();
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        extendBody: true,
        
        body: Align(
          alignment: Alignment.bottomLeft,
          child: Stack(
            // alignment: AlignmentDirectional.topStart,
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.80,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.images[currentImageIndex],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            storyParagraphs[currentParagraphIndex],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'KidsFont',
                              color: widget.textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                toggleChatOverlay();
                              },
                              icon: const Icon(Icons.search,
                                  color: Colors.white, size: 36),
                            ),
                            IconButton(
                              onPressed: togglePlayPause,
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: replayStory,
                              icon: const Icon(Icons.replay,
                                  color: Colors.white, size: 36),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isChatOverlayVisible) ChatOverlay(parentState: this),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatOverlay extends StatefulWidget {
  final _StoryPlayerState parentState;

  ChatOverlay({super.key, required this.parentState});

  @override
  State<ChatOverlay> createState() => _ChatOverlayState();
}

class _ChatOverlayState extends State<ChatOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation when the chat overlay is shown
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff32393d).withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    widget.parentState.clearChat();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    _animationController.reverse();
                    await Future.delayed(const Duration(milliseconds: 300));
                    widget.parentState.closeChatOverlay();
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            if (widget.parentState.chatMessages.isEmpty)
              // print("empty");
              // a chat bubble to indicate that you can ask any question related to the story
              const ChatBubble(
                  message: 'Ask me anything about the story!',
                  isUser: false,
                  isCenter: true),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: widget.parentState.chatMessages.length,
                itemBuilder: (context, index) {
                  // print(parentState.chatMessages.length);
                  // if (parentState.chatMessages.isEmpty) {
                  //   print("empty");
                  //   // a chat bubble to indicate that you can ask any question related to the story
                  //   return const ChatBubble(
                  //       message: 'Ask me anything!', isUser: false);
                  // }
                  final message = widget.parentState.chatMessages[index];
                  final isUser = message.startsWith('You:');
                  return ChatBubble(message: message, isUser: isUser);
                },
              ),
            ),
            if (widget.parentState.isBotTyping)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                child: Row(
                  children: [
                    const Text('AI: ', style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Lottie.asset('assets/typing_indicator.json'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            TextField(
              controller: widget.parentState.textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    widget.parentState.sendMessage();
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool? isCenter;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isUser,
    this.isCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: (isCenter ?? false)
          ? Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            )
          : Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
    );
  }
}
