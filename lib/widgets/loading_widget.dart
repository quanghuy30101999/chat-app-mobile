import 'package:chat_app/provider/loading_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoadingWidget extends StatelessWidget {
  Widget child;
  LoadingWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var loadingProvider = Provider.of<LoadingProvider>(context);

    return Stack(
      children: [
        child,
        loadingProvider.isLoading
            ? const Opacity(
                opacity: 0.6,
                child: ModalBarrier(
                  dismissible: false,
                  color: Colors.grey,
                ),
              )
            : Container(),
        loadingProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(),
      ],
    );
  }
}
