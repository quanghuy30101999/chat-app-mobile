import 'dart:async';
import 'dart:typed_data';

import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../../helpers/event_bus.dart';

class AssetEntityImageScreen extends StatefulWidget {
  final AssetEntity asset;

  const AssetEntityImageScreen({Key? key, required this.asset})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AssetEntityImageScreenState createState() => _AssetEntityImageScreenState();
}

class _AssetEntityImageScreenState extends State<AssetEntityImageScreen> {
  late double _progressValue;
  late bool _isLoading;
  // late Timer _timer;
  // late ValueNotifier<double> _progressNotifier;
  late StreamSubscription<dynamic> subscription;

  @override
  void initState() {
    super.initState();
    _progressValue = 0;
    _isLoading = true;
    // _progressNotifier = ValueNotifier<double>(_progressValue);
    // if (mounted) _startSimulation();
    subscription = EventBus().on('eventName').listen((data) {
      if (!mounted) return;
      Message oldMessage = data["oldMessage"];
      Provider.of<ConversationProVider>(context, listen: false)
          .updateMessage(data["conversationId"], oldMessage);
      if (oldMessage.asset?.id == widget.asset.id) {
        setState(() {
          _progressValue = 1;
          _isLoading = false;
        });
        // _timer.cancel();
        print("Done");
      }
    });
  }

  // void _startSimulation() {
  //   const duration = Duration(milliseconds: 500);
  //   int count = 0;

  //   _timer = Timer.periodic(duration, (timer) {
  //     if (count < 100) {
  //       _progressValue = count / 100;
  //       _progressNotifier.value = _progressValue;
  //       if (count == 99) return;
  //       count++;
  //     }
  //   });
  // }

  @override
  void dispose() {
    // _timer.cancel();
    // _progressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: widget.asset.thumbnailData,
      builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return ImageWithLoadingIndicator(
            imageBytes: snapshot.data!,
            progressNotifier: _progressValue,
            isLoading: _isLoading,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ImageWithLoadingIndicator extends StatelessWidget {
  final Uint8List imageBytes;
  final double progressNotifier;
  final bool isLoading;

  const ImageWithLoadingIndicator({
    Key? key,
    required this.imageBytes,
    required this.progressNotifier,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.memory(
              imageBytes,
              fit: BoxFit.contain,
            )),
        // if (value > 0 && value < 1)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isLoading
                  ? Colors.black.withOpacity(0.5)
                  : Colors.transparent,
            ),
            child: Center(
              child: isLoading
                  ? const Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        // Text(
                        //   '${(value * 100).toInt()}%', // Hiển thị phần trăm
                        //   style: const TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                      ],
                    )
                  : Container(),
            ),
          ),
        ),
      ],
    );
  }
}
