import 'dart:async';
import 'package:flutter/services.dart';

class ShareMmkv {
  static const String _prefix = 'flutter.';
  static const String CHANNEL_NAME = "com.silencezhou.sharemmkv";
  static const MethodChannel _channel = const MethodChannel(CHANNEL_NAME);

  static ShareMmkv _instance;

  factory ShareMmkv() => _sharedInstance();

  ShareMmkv._();

  static ShareMmkv _sharedInstance() {
    if (_instance == null) {
      _instance = ShareMmkv._();
    }
    return _instance;
  }

  /// Get
  Future<bool> getBool(String key) => _getValue("Bool", key);

  Future<int> getInt(String key) => _getValue("Int", key);

  Future<double> getDouble(String key) => _getValue("Double", key);

  Future<String> getString(String key) => _getValue("String", key);


  Future<Map<dynamic, dynamic>> getSameValueMapWithListKey(
      List<String> keys, String valueType) {
    final Map<String, dynamic> params = <String, dynamic>{
      'keys': keys,
      'valueType': valueType,
    };
    if (keys == null) {
      return Future.value(null);
    } else {
      return _channel
          .invokeMethod<Map<dynamic, dynamic>>(
              'getSameValueMapWithListKey', params)
          .then<Map<dynamic, dynamic>>((dynamic result) => result);
    }
  }

  Future<T> _getValue<T>(String valueType, String key) {
    final Map<String, dynamic> params = <String, dynamic>{
      'key': '$_prefix$key',
    };
    if (key == null) {
      return Future.value(null);
    } else {
      return _channel
          .invokeMethod<T>('get$valueType', params)
          .then<T>((dynamic result) => result);
    }
  }

  /// Set
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setBool(String key, bool value) => _setValue("Bool", key, value);

  Future<bool> setInt(String key, int value) => _setValue("Int", key, value);

  Future<bool> setDouble(String key, double value) =>
      _setValue("Double", key, value);

  Future<bool> setString(String key, String value) =>
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

  Future<bool> setSameValueMapWithMap(
      Map<String, dynamic> map, String valueType) {
    final Map<String, dynamic> params = <String, dynamic>{
      'map': map,
      'valueType': valueType
    };

    if (map == null) {
      return Future.value(null);
    } else {
      return _channel
          .invokeMethod<bool>('setSameValueMapWithMap', params)
          .then<bool>((dynamic result) => result);
    }
  }

  /// removeForKey
  Future<bool> remove(String key) => _setValue(null, key, null);

  /// clear
  Future<bool> clear() => _channel.invokeMethod('clear');

  /// count
  Future<int> count() => _channel.invokeMethod('count');
}
