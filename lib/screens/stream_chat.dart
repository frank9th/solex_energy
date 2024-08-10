import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

/*
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
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
            return _buildEmptyState(context);
          }

          final List<Message> messageList = [];
          for (var doc in documents) {
            final data = doc.data() as Map;
            final userText = data['user'] ?? '';
            final aiText = data['Ai'];

            messageList.add(Message(text: userText));
            if (aiText != null) {
              messageList.add(Message(text: aiText, isUser: false));
            }
          }

          // Scroll to the bottom after the widget builds
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (chatProvider.scrollController.hasClients) {
              chatProvider.scrollController
                  .jumpTo(chatProvider.scrollController.position.maxScrollExtent);
            }
          });

          return ListView.builder(
            controller: chatProvider.scrollController,
            padding: const EdgeInsets.all(16.0),
            itemCount: messageList.length,
            shrinkWrap: true,
            reverse: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final message = messageList[index];
              return message.isUser
                  ? ChatBubble(
                      message: message.text,
                      isUserMessage: true,
                    )
                  : TypingEffectChatBubble(message: message.text);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
}

 */

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, this.isUser = true});
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUserMessage;

  ChatBubble({required this.message, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(message),
    );
  }
}

class TypingEffectChatBubble extends StatelessWidget {
  final String message;

  const TypingEffectChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 16.0,
          //color: Colors.black,
        ),
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              message,
              speed: const Duration(milliseconds: 50),
            ),
          ],
          totalRepeatCount: 1,
          pause: const Duration(milliseconds: 1000),
          displayFullTextOnTap: true,
          onNext: (val, b) {
            if (b == true) {
              chatProvider.scrollToBottom();
            }
          },
        ),
      ),
    );
  }
}

class HeroText extends StatelessWidget {
  const HeroText();

  @override
  Widget build(BuildContext context) {
    return Text('Hero Text');
  }
}

class ChatProvider with ChangeNotifier {
  final String deviceRegisteredId = 'deviceID';
  final String uniqueChatId = 'chatID';
  final ScrollController scrollController = ScrollController();

  void updateInput(String text) {
    // Your updateInput implementation
  }

  void sendMessage() {
    // Your sendMessage implementation
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

final chatProvider = ChatProvider();

final List<String> prompts = ['Prompt 1', 'Prompt 2', 'Prompt 3'];
