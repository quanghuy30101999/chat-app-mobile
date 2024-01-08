import 'package:chat_app/models/message.dart';

class Constants {
  static const url = 'https://chatapp24.com';
  static const statuses = <MessageStatus, String>{
    MessageStatus.none: 'Gửi',
    MessageStatus.sending: 'Đang gửi',
    MessageStatus.sent: 'Đã gửi',
    MessageStatus.received: 'Đã nhận',
    MessageStatus.viewed: 'Đã xem'
  };
}
