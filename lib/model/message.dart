import '../constant.dart';

class Message {
  final String text;
  final String id;
  Message(this.id, {required this.text});

  factory Message.fromJson(json) {
    return Message(text: json[kFieldText], json['id']);
  }
}
