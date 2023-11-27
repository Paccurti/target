// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_text_list_mobx.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppTextListMobx on _AppTextListMobx, Store {
  Computed<List<AppText>>? _$itemsComputed;

  @override
  List<AppText> get items =>
      (_$itemsComputed ??= Computed<List<AppText>>(() => super.items,
              name: '_AppTextListMobx.items'))
          .value;
  Computed<int>? _$itemsCountComputed;

  @override
  int get itemsCount =>
      (_$itemsCountComputed ??= Computed<int>(() => super.itemsCount,
              name: '_AppTextListMobx.itemsCount'))
          .value;

  late final _$loadAppTextsAsyncAction =
      AsyncAction('_AppTextListMobx.loadAppTexts', context: context);

  @override
  Future<void> loadAppTexts() {
    return _$loadAppTextsAsyncAction.run(() => super.loadAppTexts());
  }

  late final _$addAppTextAsyncAction =
      AsyncAction('_AppTextListMobx.addAppText', context: context);

  @override
  Future<void> addAppText(AppText appText) {
    return _$addAppTextAsyncAction.run(() => super.addAppText(appText));
  }

  late final _$updateAppTextAsyncAction =
      AsyncAction('_AppTextListMobx.updateAppText', context: context);

  @override
  Future<void> updateAppText(AppText appText) {
    return _$updateAppTextAsyncAction.run(() => super.updateAppText(appText));
  }

  late final _$removeAppTextAsyncAction =
      AsyncAction('_AppTextListMobx.removeAppText', context: context);

  @override
  Future<void> removeAppText(AppText appText) {
    return _$removeAppTextAsyncAction.run(() => super.removeAppText(appText));
  }

  late final _$_AppTextListMobxActionController =
      ActionController(name: '_AppTextListMobx', context: context);

  @override
  Future<void> saveAppText(Map<String, Object> data) {
    final _$actionInfo = _$_AppTextListMobxActionController.startAction(
        name: '_AppTextListMobx.saveAppText');
    try {
      return super.saveAppText(data);
    } finally {
      _$_AppTextListMobxActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
items: ${items},
itemsCount: ${itemsCount}
    ''';
  }
}
