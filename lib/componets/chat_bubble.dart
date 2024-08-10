import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'dart:async';

import '../screens/ai_response_model.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isUserMessage;

  const ChatBubble({super.key, required this.message, this.isUserMessage = false});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  Timer? _timer;
  bool _isLoading = false;
  String _message = "";

  @override
  void initState() {
    //_makeNetworkRequest();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _makeNetworkRequest() async {
    if (widget.message == 'Typing') {
      setState(() {
        _isLoading = true;
        _message = "Processing ...";
      });
      // Start the timer
      _timer = Timer(const Duration(seconds: 35), () {
        setState(() {
          _message = "Delayed response";
          _isLoading = false;
        });
      });

      try {
        if (widget.message != 'Typing') {
          _timer?.cancel(); // Cancel the timer
          setState(() {
            _message = "Processing response";
            _isLoading = false;
          });
        }
      } catch (e) {
        // Handle errors
        setState(() {
          _message = "Error: $e";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? containerColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade200.withOpacity(0.3) // Dark theme color
        : Colors.orange[50];
    Color? cardHColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Dark theme color
        : Colors.black; // Light theme color// Light theme color

    Color? cardShColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Dark theme color
        : Colors.black;
    return widget.isUserMessage
        ? BubbleSpecialOne(
            text: widget.message,
            isSender: widget.isUserMessage ? true : false,
            color: widget.isUserMessage ? containerColor! : Colors.grey.shade200.withOpacity(0.0),
            textStyle: TextStyle(
              fontSize: 14,
              color: cardShColor,
              fontStyle: widget.isUserMessage ? FontStyle.italic : null,
            ),
          )
        : widget.message == 'Typing'
            ? const Row(
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              )
            : widget.isUserMessage
                ? BubbleSpecialOne(
                    text: widget.message,
                    isSender: widget.isUserMessage ? true : false,
                    color: widget.isUserMessage
                        ? containerColor!
                        : Colors.grey.shade200.withOpacity(0.0),
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: cardShColor,
                      fontStyle: widget.isUserMessage ? FontStyle.italic : null,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: TextStyle(
                            color: cardShColor,
                          ),
                          children: parseResponse(widget.message),
                        ),
                      ),
                    ),
                  );

    /*

      Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.grey.shade200 : Colors.amber.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 14,
            color: isUserMessage ? Colors.black : cardShColor,
          ),
        ),
      ),
    );

     */
  }
}

class TypingEffectChatBubble extends StatelessWidget {
  final String message;
  final Color color;

  const TypingEffectChatBubble({super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 16.0,
          color: color,
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              message,
              speed: const Duration(milliseconds: 10),
            ),
          ],
          totalRepeatCount: 1,
          pause: const Duration(milliseconds: 300),
          displayFullTextOnTap: true,
        ),
      ),
    );
  }
}

List<TextSpan> parseResponse(String response) {
  List<TextSpan> spans = [];
  List<String> parts = response.split(RegExp(r'(\\|\*)'));

  bool isBold = false;
  bool isBullet = false;

  for (var part in parts) {
    if (part == '') {
      isBold = !isBold;
    } else if (part == '*') {
      isBullet = true;
    } else {
      if (isBullet) {
        spans.add(TextSpan(
          text: "• $part\n",
          style: const TextStyle(fontSize: 15),
        ));
        isBullet = false;
      } else {
        spans.add(TextSpan(
          text: part,
          style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 15),
        ));
      }
    }
  }

  return spans;
}
