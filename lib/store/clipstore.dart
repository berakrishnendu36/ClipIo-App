import 'package:clipio/utils/shared_prefs.dart';
import 'package:mobx/mobx.dart';

part 'clipstore.g.dart';

class ClipStore = _ClipStore with _$ClipStore;

abstract class _ClipStore with Store {
  @observable
  List<String> cacheList;

  @observable
  List<String> titleList;

  @action
  void loadCacheList() {
    cacheList = SharedPrefs().cache;
  }

  @action
  void loadTitleList() {
    titleList = SharedPrefs().title;
  }

  @action
  Future<bool> addCache(String clip, {String title = ""}) async {
    bool _res = await SharedPrefs().addToCache(clip);
    if (_res) {
      cacheList.insert(0, clip);
      titleList.insert(0, title);
      return true;
    } else {
      return false;
    }
  }

  @action
  Future<void> deleteCache(int index) async {
    cacheList.removeAt(index);
    titleList.removeAt(index);
    await SharedPrefs().removeFromCache(index);
  }

  @action
  Future<bool> updateCache(String clip, String title, int index) async {
    bool _res = await SharedPrefs().updateCache(clip, title, index);
    if (_res) {
      cacheList[index] = clip;
      titleList[index] = title;
    }
    return _res;
  }
}
