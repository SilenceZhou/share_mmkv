import 'dart:async';
import 'package:flutter/services.dart';

class ShareMmkv {
  static const String _prefix = 'flutter.';
  static const String CHANNEL_NAME = "com.silencezhou.sharemmkv";
  static const MethodChannel _channel = const MethodChannel(CHANNEL_NAME);

  ShareMmkv._();
  static Completer<ShareMmkv> _completer;
  static Future<ShareMmkv> getInstance() {
    if (_completer == null) {
      _completer = Completer<ShareMmkv>();
    }
    return _completer.future;
  }

  /// Get
  Future<bool> getBool(String key) => _getValue("Bool", key);

  Future<int> getInt(String key) => _getValue("Int", key);

  Future<double> getDouble(String key) => _getValue("Double", key);

  Future<bool> getString(String key) => _getValue("String", key);

  Future<List<String>> getStringList(String key) =>
      _getValue("StringList", key);

  Future<Object> _getValue(String valueType, String key) {
    final Map<String, dynamic> params = <String, dynamic>{
      'key': '$_prefix$key',
    };
    if (key == null) {
      return Future.value(null);
    } else {
      return _channel
          .invokeMethod<bool>('get$valueType', params)
          .then<bool>((dynamic result) => result);
    }
  }

  /// Set
  ///  If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setBool(String key, bool value) => _setValue("Bool", key, value);

  Future<bool> setInt(String key, int value) => _setValue("Int", key, value);

  Future<bool> setDouble(String key, double value) =>
      _setValue("Double", key, value);

  Future<bool> setString(String key, String value) =>
      _setValue("String", key, value);

  Future<bool> setStringList(String key, List<String> value) =>
      _setValue("String", key, value);

  Future<bool> _setValue(String valueType, String key, Object value) {
    final Map<String, dynamic> params = <String, dynamic>{
      'key': '$_prefix$key',
    };
    if (value == null) {
      return _channel
          .invokeMethod<bool>("remove", params)
          .then<bool>((dynamic result) => result);
    } else {
      params['value'] = value;
      return _channel
          .invokeMethod<bool>('set$valueType', params)
          .then<bool>((dynamic result) => result);
    }
  }

  /// removeForKey
  Future<bool> remove(String key) => _setValue(null, key, null);

  /// clear
  Future<bool> clear() => _channel.invokeMethod('clear');

  /// count
  Future<int> count() => _channel.invokeMethod('count');

  ///
}
