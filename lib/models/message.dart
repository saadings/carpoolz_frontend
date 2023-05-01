import '../providers/user_provider.dart';

class Message {
  final String userName;
  final Type user;
  final String text;

  Message(this.userName, this.text, this.user);
}
