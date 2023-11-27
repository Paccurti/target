import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

import '../exceptions/http_exception.dart';
import '../utils/constants.dart';
import 'app_text.dart';

part 'app_text_list_mobx.g.dart';

class AppTextListMobx = _AppTextListMobx with _$AppTextListMobx;

abstract class _AppTextListMobx with Store {
  final String _token;

  _AppTextListMobx(this._token);

  ObservableList<AppText> _items = ObservableList<AppText>();

  @computed
  List<AppText> get items => List<AppText>.from(_items);

  @computed
  int get itemsCount => _items.length;

  @action
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
  }

  @action
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

  @action
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
  }

  @action
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
    }
  }

  @action
  Future<void> removeAppText(AppText appText) async {
    int index = _items.indexWhere((p) => p.id == appText.id);

    if (index >= 0) {
      final removedAppText = _items.removeAt(index);

      final response = await http.delete(
        Uri.parse('${Constants.appTextBaseUrl}/${appText.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, removedAppText);
        throw HttpException(
          msg: 'Não foi possível excluir o texto.',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
