// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_target/models/app_text.dart';
import 'package:teste_target/models/app_text_list.dart';

class NewAppText extends StatefulWidget {
  NewAppText({
    Key? key,
  }) : super(key: key);

  @override
  State<NewAppText> createState() => _NewAppTextState();
}

class _NewAppTextState extends State<NewAppText> {
  final _appTextController = TextEditingController();

  Future<void> _addAppText() async {
    final AppText appText = AppText(id: '', appText: _appTextController.text);
    await Provider.of<AppTextList>(context, listen: false).addAppText(appText);
    _appTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: TextField(
        controller: _appTextController,
        onSubmitted: (value) {
          if (_appTextController.text.trim().isNotEmpty) {
            _addAppText();
          }
        },
        onChanged: (value) {},
        decoration: const InputDecoration(
          label: Center(
            child: Text(
              'Digite seu texto',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
