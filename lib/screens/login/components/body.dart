import 'package:chat_app/helpers/validatior.dart';
import 'package:chat_app/provider/loading_provider.dart';
import 'package:chat_app/provider/login_provider.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Body extends StatefulWidget {
  GlobalKey<FormState> formKey;
  Body({super.key, required this.formKey});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController _textEditingController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    var loadingProvider = Provider.of<LoadingProvider>(context);
    var loginProvider = Provider.of<LoginProvider>(context);
    return Column(
      children: [
        TextFormField(
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
          controller: _textEditingController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: "Username",
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: _errorMessage,
          ),
          onEditingComplete: () => FocusScope.of(context).unfocus(),
          validator: Validator.validateText,
        ),
        const SizedBox(height: 60),
        Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                if (widget.formKey.currentState?.validate() ?? false) {
                  _errorMessage = null;
                  loadingProvider.setLoading(true);
                  loginProvider.login(
                      userId: _textEditingController.text,
                      onSuccess: () {
                        loadingProvider.setLoading(false);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                      onError: (message) {
                        _errorMessage = message;
                        loadingProvider.setLoading(false);
                      });
                }
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ],
    );
  }
}
