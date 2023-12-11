import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Search extends StatefulWidget {
  Function(bool) focus;
  Function(String?) onChangeText;
  Search({super.key, required this.focus, required this.onChangeText});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isFocus = false;
  bool setColor = false;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _focusNode.addListener(_handleFocusChange);
    super.initState();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        isFocus = true;
        setColor = true;
      });
      widget.focus(isFocus);
    } else {
      setState(() {
        setColor = false;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleOnTap() {
    setState(() {
      isFocus = false;
    });
    widget.focus(isFocus);
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: isFocus ? _handleOnTap : () => _focusNode.requestFocus(),
            child: Icon(
              isFocus ? Icons.arrow_back : Icons.search,
              color: const Color.fromARGB(255, 152, 108, 108),
              size: 25,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              width: 350.0,
              height: 40.0,
              child: TextField(
                controller: _textEditingController,
                onChanged: (text) {
                  widget.onChangeText(text);
                },
                focusNode: _focusNode,
                style: const TextStyle(fontSize: 16.0),
                cursorHeight: 20.0,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: setColor ? Colors.grey.shade300 : Colors.white,
                  contentPadding: const EdgeInsets.only(top: 10, left: 12),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.grey)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
