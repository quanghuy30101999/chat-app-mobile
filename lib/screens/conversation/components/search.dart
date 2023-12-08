import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Search extends StatefulWidget {
  Function(bool) focus;
  Search({super.key, required this.focus});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: isFocus
                ? () {
                    setState(() {
                      isFocus = false;
                    });
                    widget.focus(isFocus);
                    _textEditingController.clear();
                  }
                : () {
                    _focusNode.requestFocus();
                  },
            child: Icon(
              isFocus ? Icons.arrow_back : Icons.search,
              color: const Color.fromARGB(255, 152, 108, 108),
              size: 30,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: setColor ? Colors.grey.shade300 : Colors.white,
                contentPadding:
                    const EdgeInsets.fromLTRB(12.0, 25.0, 12.0, 12.0),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
