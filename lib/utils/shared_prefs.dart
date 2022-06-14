import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get uid => _sharedPrefs.getString("uid") ?? "";
  String get name => _sharedPrefs.getString("name") ?? "";
  String get token => _sharedPrefs.getString("token") ?? "";

  List<String> get cache {
    List<String> _cacheList = _sharedPrefs.getStringList("cache");
    if (_cacheList == null) {
      return [];
    } else {
      return _cacheList;
    }
  }

  List<String> get title {
    List<String> _titleList = _sharedPrefs.getStringList("title");
    if (_titleList == null) {
      return [];
    } else {
      return _titleList;
    }
  }

  Future<bool> addToCache(String value, {String title = ""}) async {
    List<String> _cacheList = _sharedPrefs.getStringList("cache");
    List<String> _titleList = _sharedPrefs.getStringList("title");
    if (_cacheList != null && _cacheList.length >= 10) {
      return false;
    }
    if (_cacheList == null) {
      _cacheList = List<String>.empty(growable: true);
      _titleList = List<String>.empty(growable: true);
      _cacheList.add(value);
      _titleList.add(title);
    } else if (!_cacheList.contains(value)) {
      _cacheList = [value, ..._cacheList];
      _titleList = [title, ..._titleList];
    } else {
      return false;
    }
    bool _res1 = await _sharedPrefs.setStringList("cache", _cacheList);
    bool _res2 = await _sharedPrefs.setStringList("title", _titleList);
    return _res1 && _res2;
  }

  Future<bool> updateCache(String value, String title, int index) async {
    List<String> _cacheList = _sharedPrefs.getStringList("cache");
    List<String> _titleList = _sharedPrefs.getStringList("title");
    _cacheList[index] = value;
    _titleList[index] = title;
    bool _res1 = await _sharedPrefs.setStringList("cache", _cacheList);
    bool _res2 = await _sharedPrefs.setStringList("title", _titleList);
    return _res1 && _res2;
  }

  Future<bool> removeFromCache(int index) async {
    List<String> _cacheList = _sharedPrefs.getStringList("cache");
    _cacheList.removeAt(index);
    List<String> _titleList = _sharedPrefs.getStringList("title");
    _titleList.removeAt(index);
    bool _res1 = await _sharedPrefs.setStringList("cache", _cacheList);
    bool _res2 = await _sharedPrefs.setStringList("title", _titleList);
    return _res1 && _res2;
  }

  Future<bool> clearCache() async {
    await _sharedPrefs.setStringList("cache", []);
    await _sharedPrefs.setStringList("title", []);
    return true;
  }

  set uid(String value) {
    _sharedPrefs.setString("uid", value);
  }

  set name(String value) {
    _sharedPrefs.setString("name", value);
  }

  set token(String value) {
    _sharedPrefs.setString("token", value);
  }
}
