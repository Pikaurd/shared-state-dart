import 'dart:async';
import 'dart:collection';

typedef StreamedStateItem = ({String k, dynamic v});

/// 共享状态存储, 用于全局数据存储
class SharedState {
  static final SharedState _singleton = SharedState._internal();
  final Map<String, dynamic> _store = <String, dynamic>{};
  late StreamController<StreamedStateItem> _streamController;

  /// 共享状态存储
  factory SharedState() {
    return _singleton;
  }

  SharedState._internal() {
    _streamController = StreamController.broadcast(sync: false);
  }

  /// 填充共享状态
  /// [key] key [value] 值 [withNotify] 是否通知共享状态变化
  /// 通知会通过 [onKeyChange] 监听
  void set<T>(String key, T value, {bool withNotify = true}) {
    _store[key] = value;
    if (withNotify) {
      _streamController.add((k: key, v: value));
    }
  }

  /// 根据[key]获取共享状态, 同时需指定类型 [T], 如果类型不匹配则抛出异常
  T? get<T>(String key) {
    final obj = _store[key];
    if (obj == null || obj is T) {
      return obj;
    }
    throw TypeError();
  }

  /// 根据[key]删除共享状态, 同时删除也会通知共享状态变化
  void invalid(String key) {
    _store.remove(key);
    _streamController.add((k: key, v: null));
  }

  /// 清空所有信息, 但不取消监听的注册且不触发[onKeyChange]
  void clear() {
    _store.clear();
  }

  /// 通知共享状态变化
  Stream<T?> onKeyChange<T>(String key) {
    return _streamController.stream.where((e) => e.k == key).map((e) => e.v);
  }

  /// 获取raw数据(除了测试应该没啥用)
  Map<String, dynamic> get store => UnmodifiableMapView(_store);
}
