import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Widgets/ChatBubble.dart';
import '../Widgets/ChatBubbleForFriend.dart';
import '../constant.dart';

// ignore: must_be_immutable
class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static String id = 'ChatPage';
  TextEditingController controller = TextEditingController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kCollectionRefrence);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreateAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    kLogo,
                    height: 65,
                  ),
                  const Text(
                    'Chat',
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 1,
                    child: Image.asset(
                      kImageChatPage,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        controller: scrollController,
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          return messageList[index].id == email
                              ? ChatBubble(
                                  message: messageList[index],
                                )
                              : ChatBubbleForFriend(
                                  message: messageList[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: controller,
                        onSubmitted: (data) {
                          messages.add({
                            kFieldText: data,
                            kCreateAt: DateTime.now(),
                            'id': email,
                          });
                          controller.clear();
                          scrollController.animateTo(
                            0,
                            duration: Duration(seconds: 1),
                            curve: Curves.easeIn,
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Send Message',
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                messages.add({
                                  kFieldText: controller.text,
                                  kCreateAt: DateTime.now(),
                                  'id': email,
                                });
                                controller.clear();
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: kPrimaryColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: kPrimaryColor),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Center(
              child: Text(
            'Loading..',
            style: TextStyle(fontSize: 15),
          ));
        }
      },
    );
  }
}
