import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TypingIndicator extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: const SpinKitThreeBounce(
        color: Colors.grey, // Màu sắc của hiệu ứng
        size: 20.0, // Kích thước của hiệu ứng
      ),
      // const Row(
      //   children: [
      //     CircleAvatar(
      //       // Hiển thị avatar hoặc icon người dùng
      //       // Nếu bạn có thông tin về người dùng đang nhập liệu
      //       // Ví dụ: backgroundImage: NetworkImage('URL_AVATAR')
      //       child: Icon(Icons.person),
      //     ),
      //     SizedBox(width: 5),
      //     Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(
      //           'is typing...',
      //           style: TextStyle(fontWeight: FontWeight.bold),
      //         ),
      //         SizedBox(height: 2),
      //         Text('Typing...', style: TextStyle(fontSize: 12)),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
