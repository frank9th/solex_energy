import 'package:flutter/material.dart';

class ChatInputBox extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend, onClickCamera;
  final void Function(String)? onChange;

  const ChatInputBox({
    super.key,
    this.controller,
    this.onSend,
    this.onClickCamera,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (onClickCamera != null)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                  onPressed: onClickCamera,
                  color: Theme.of(context).colorScheme.onSecondary,
                  icon: const Icon(Icons.file_copy_rounded)),
            ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 6,
              cursorColor: Theme.of(context).colorScheme.inversePrimary,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              onChanged: onChange,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                hintText: 'Enter appliances here...',
                border: InputBorder.none,
              ),
              onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(4),
            child: FloatingActionButton.small(
              elevation: 0,
              backgroundColor: controller!.text.isNotEmpty ? Colors.green : Colors.grey,
              onPressed: onSend,
              child: Icon(
                Icons.send_rounded,
                color: controller!.text.isNotEmpty ? Colors.white : Colors.black45,
              ),
            ),
          )
        ],
      ),
    );
  }
}
