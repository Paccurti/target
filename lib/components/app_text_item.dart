// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teste_target/models/app_text.dart';
import 'package:teste_target/models/app_text_list.dart';

class AppTextItem extends StatefulWidget {
  const AppTextItem({
    super.key,
    required this.appText,
  });

  final AppText appText;

  @override
  State<AppTextItem> createState() => _AppTextItemState();
}

class _AppTextItemState extends State<AppTextItem> {
  TextEditingController editTextController = TextEditingController();

  void _showEditDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar texto'),
        content: TextFormField(
          controller: editTextController,
          decoration: InputDecoration(labelText: msg),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final appText = AppText(
                  id: widget.appText.id, appText: editTextController.text);
              await Provider.of<AppTextList>(context, listen: false)
                  .updateAppText(appText);
              editTextController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Confirmar'),
          ),
          TextButton(
            onPressed: () {
              editTextController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover texto?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Provider.of<AppTextList>(context, listen: false)
                  .removeAppText(widget.appText);
            },
            child: const Text('Confirmar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.appText.appText),
            )),
            IconButton(
              onPressed: () {
                _showEditDialog(widget.appText.appText);
              },
              icon: const Icon(
                Icons.edit,
              ),
            ),
            IconButton(
              onPressed: () async {
                _showDeleteDialog();
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
