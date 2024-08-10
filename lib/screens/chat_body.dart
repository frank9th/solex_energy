import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solex/data.dart';
import '../componets/chat_bubble.dart';
import '../componets/chat_input_box.dart';
import '../model.dart';
import 'dart:async';

final List<String> prompts = [
  'Design a 1kva inverter system for me, consider cost effectiveness ',
  'How many panels do i need to fully charge a 12v, 200ah battery in 4hrs',
  'Calculate a system design to power 2 acs, 42inch tv, Refrigerator and other households'
];

class ChatBodyPart extends StatefulWidget {
  const ChatBodyPart({super.key});
  @override
  State<ChatBodyPart> createState() => _ChatBodyPartState();
}

class _ChatBodyPartState extends State<ChatBodyPart> {
  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final ScrollController scrollController = ScrollController();

    Color? containerColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.orange[600] // Dark theme color
        : Colors.orange[100];
    Color? cardHColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Dark theme color
        : Colors.black; // Light theme color// Light theme color
    Color? cardShColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white54 // Dark theme color
        : Colors.black;

    Widget buildEmptyState(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const HeroText(),
          const SizedBox(height: 30),
          SizedBox(
            height: 130.0, // Adjust container height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10.0),
              itemCount: prompts.length,
              itemBuilder: (context, index) {
                final text = prompts[index];
                return GestureDetector(
                  onTap: () {
                    chatProvider.updateInput(text);
                    chatProvider.sendMessage();
                  },
                  child: Card(
                    child: SizedBox(
                      width: 210.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            text,
                            softWrap: true,
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        // CHAT CONTENTS
        Column(
          children: [
            chatProvider.deviceRegisteredId.toString().isNotEmpty
                ? Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: db
                            .collection('chats')
                            .doc(chatProvider.deviceRegisteredId.toString())
                            .collection(chatProvider.uniqueChatId.toString())
                            .orderBy('createdAt', descending: false)
                            .snapshots(includeMetadataChanges: true),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Text('Processing...');
                          }

                          final documents = snapshot.data?.docs;
                          if (documents == null || documents.isEmpty) {
                            return buildEmptyState(context);
                          }

                          final List<Message> messageList = documents
                              .map((doc) {
                                final data = doc.data() as Map;
                                final userText = data['user'] ?? '';
                                final aiText = data['Ai'] ?? 'Typing';
                                final List<Message> messages = [Message(text: userText)];
                                if (aiText != null) {
                                  messages.add(Message(text: aiText, isUser: false, isRead: true));
                                }
                                return messages;
                              })
                              .expand((message) => message)
                              .toList();

                          // Scroll to the bottom after the widget builds
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (scrollController.hasClients) {
                              scrollController.jumpTo(scrollController.position.maxScrollExtent);
                            }
                          });

                          return ListView.builder(
                            controller: scrollController, //chatProvider.scrollController,
                            padding: const EdgeInsets.all(16.0),
                            itemCount: messageList.length,
                            shrinkWrap: true,
                            reverse: false,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final message = messageList[index];
                              return ChatBubble(
                                message: message.text,
                                isUserMessage: message.isUser,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 80,
            ),
          ],
        ),

        // PROMPTS SECTION
        chatProvider.isLoading
            ? const SizedBox.shrink()
            : chatProvider.messages.isEmpty
                ? Positioned(
                    bottom: 70.0, // Adjust bottom padding as needed
                    left: 0.0,
                    right: 0.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const HeroText(),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 130.0, // Adjust container height as needed
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(10.0),
                            itemCount: prompts.length,
                            itemBuilder: (context, index) {
                              String text = prompts[index];
                              return GestureDetector(
                                onTap: () {
                                  chatProvider.updateInput(text);
                                  chatProvider.sendMessage();
                                },
                                child: Card(
                                  child: SizedBox(
                                    width: 210.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          text,
                                          softWrap: true,
                                          style: TextStyle(
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (chatProvider.isLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 0,
                      child: Text(
                        'Processing...',
                        style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white54
                                : Colors.black45),
                      ),
                    ),
                  ),
                ChatInputBox(
                  //onClickCamera: () {},
                  onChange: (text) => chatProvider.updateInput(text),
                  controller: chatProvider.textController,
                  onSend: chatProvider.input.isNotEmpty
                      ? () {
                          chatProvider.sendMessage();
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HeroText extends StatefulWidget {
  const HeroText({super.key});

  @override
  _HeroTextState createState() => _HeroTextState();
}

class _HeroTextState extends State<HeroText> {
  final Random _random = Random();
  Color _color = Colors.blue;
  String _text = 'Sunshine \non your mind?';
  String _subText = ' Let\'s calculate your solar potential!';

  List<String> texts = [
    "Sunshine \non your mind",
    "Lighten your energy bill",
    "Power up your future",
    "Feeling watt-ish? ",
    'Ready to go green?',
    'Harness the sun\'s power!',
  ];
  List<String> subTexts = [
    'Let\'s calculate your solar potential!',
    'Let\'s calculate your solar savings.',
    'Explore how solar can save you money.',
    'Calculate your energy needs today!',
    'Find out if solar panels are right for you.',
    'Get started with your solar journey.',
  ];

  Timer? _colorTimer;
  Timer? _textTimer;

  @override
  void initState() {
    super.initState();
    _startColorTimer();
    _startTextTimer();
  }

  void _startColorTimer() {
    _colorTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _color = Color.fromRGBO(
          _random.nextInt(256),
          _random.nextInt(256),
          _random.nextInt(256),
          1,
        );
      });
    });
  }

  void _startTextTimer() {
    _textTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _random.nextInt(256);
        _text = texts[_random.nextInt(texts.length)];
        _subText = subTexts[_random.nextInt(subTexts.length)];
      });
    });
  }

  @override
  void dispose() {
    _colorTimer?.cancel();
    _textTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Hero(
        tag: 'hero-text',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 10),
              // padding: const EdgeInsets.all(16.0),
              child: Text(
                _text,
                textScaler: const TextScaler.linear(1.2),
                style: TextStyle(fontSize: 38, color: _color, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              '-$_subText-',
              style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}

final List<String> messages = [
  'Sunshine on your mind?  Let\'s calculate your solar potential!',
  'Power up your future!  Explore how solar can save you money.',
  'Ready to go green?  Find out if solar panels are right for you.',
  'Lighten your energy bill!  Let\'s calculate your solar savings.',
  'Harness the sun\'s power!  Get started with your solar journey.',
  'Feeling watt-ish?  Calculate your energy needs today!',
];
