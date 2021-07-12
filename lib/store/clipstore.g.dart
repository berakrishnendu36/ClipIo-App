// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipstore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ClipStore on _ClipStore, Store {
  final _$cacheListAtom = Atom(name: '_ClipStore.cacheList');

  @override
  List<String> get cacheList {
    _$cacheListAtom.reportRead();
    return super.cacheList;
  }

  @override
  set cacheList(List<String> value) {
    _$cacheListAtom.reportWrite(value, super.cacheList, () {
      super.cacheList = value;
    });
  }

  final _$titleListAtom = Atom(name: '_ClipStore.titleList');

  @override
  List<String> get titleList {
    _$titleListAtom.reportRead();
    return super.titleList;
  }

  @override
  set titleList(List<String> value) {
    _$titleListAtom.reportWrite(value, super.titleList, () {
      super.titleList = value;
    });
  }

  final _$addCacheAsyncAction = AsyncAction('_ClipStore.addCache');

  @override
  Future<bool> addCache(String clip, {String title = ""}) {
    return _$addCacheAsyncAction.run(() => super.addCache(clip, title: title));
  }

  final _$deleteCacheAsyncAction = AsyncAction('_ClipStore.deleteCache');

  @override
  Future<void> deleteCache(int index) {
    return _$deleteCacheAsyncAction.run(() => super.deleteCache(index));
  }

  final _$updateCacheAsyncAction = AsyncAction('_ClipStore.updateCache');

  @override
  Future<bool> updateCache(String clip, String title, int index) {
    return _$updateCacheAsyncAction
        .run(() => super.updateCache(clip, title, index));
  }

  final _$_ClipStoreActionController = ActionController(name: '_ClipStore');

  @override
  void loadCacheList() {
    final _$actionInfo = _$_ClipStoreActionController.startAction(
        name: '_ClipStore.loadCacheList');
    try {
      return super.loadCacheList();
    } finally {
      _$_ClipStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadTitleList() {
    final _$actionInfo = _$_ClipStoreActionController.startAction(
        name: '_ClipStore.loadTitleList');
    try {
      return super.loadTitleList();
    } finally {
      _$_ClipStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cacheList: ${cacheList},
titleList: ${titleList}
    ''';
  }
}
