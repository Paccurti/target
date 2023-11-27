// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../utils/constants.dart';
import 'app_text.dart';

class AppTextList with ChangeNotifier {
  final String _token;
  List<AppText> _items = [];

  List<AppText> get items => [..._items];

  AppTextList(this._token, this._items);

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadAppTexts() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.appTextBaseUrl}.json?auth=$_token'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((appTextId, appTextData) {
      _items.add(
        AppText(
          id: appTextId,
          appText: appTextData['appText'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveAppText(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final appText = AppText(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      appText: data['appText'] as String,
    );

    if (hasId) {
      return updateAppText(appText);
    } else {
      return addAppText(appText);
    }
  }

  Future<void> addAppText(AppText appText) async {
    final response = await http.post(
      Uri.parse('${Constants.appTextBaseUrl}.json?auth=$_token'),
      body: jsonEncode(
        {
          "appText": appText.appText,
        },
      ),
    );
    final id = jsonDecode(response.body)['name'];
    _items.add(AppText(
      id: id,
      appText: appText.appText,
    ));
    notifyListeners();
  }

  Future<void> updateAppText(AppText appText) async {
    int index = _items.indexWhere((p) => p.id == appText.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.appTextBaseUrl}/${appText.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "appText": appText.appText,
          },
        ),
      );

      _items[index] = appText;
      notifyListeners();
    }
  }

  Future<void> removeAppText(AppText appText) async {
    int index = _items.indexWhere((p) => p.id == appText.id);

    if (index >= 0) {
      final appText = _items[index];
      _items.remove(appText);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('${Constants.appTextBaseUrl}/${appText.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, appText);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o texto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
