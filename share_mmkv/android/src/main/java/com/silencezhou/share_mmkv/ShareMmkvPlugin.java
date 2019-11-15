package com.silencezhou.share_mmkv;

import android.content.Context;

import com.tencent.mmkv.MMKV;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** ShareMmkvPlugin */
public class ShareMmkvPlugin implements MethodCallHandler {

  public static final String KEY = "key";
  public static final String KEYS = "keys";
  public static final String VALUE = "value";

  public static final String ValueTypeString = "string";
  public static final String ValueTypeBool = "bool";
  public static final String ValueTypeInt = "int";
  public static final String ValueTypeDouble = "double";
  public static final String VALUETYPE = "valueType";
  public static final String MAP = "map";


  public ShareMmkvPlugin(Context context) {
    MMKV.initialize(context);
  }
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.silencezhou.sharemmkv");
    channel.setMethodCallHandler(new ShareMmkvPlugin(registrar.context()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {

    String method = call.method;
    Map<String, Object> arguments = (Map<String, Object>) call.arguments;

    if (arguments == null) {
      arguments = new HashMap<>();
    }

    String key = (String) arguments.get(KEY);
    List<String> keysParams = (List<String>) arguments.get(KEYS);
    Object value = arguments.get(VALUE);
    String valueType = (String) arguments.get(VALUETYPE);
    Map<String, Object> map = (Map<String, Object>) arguments.get(MAP);

    MMKV mmkv = MMKV.defaultMMKV();

    if (mmkv == null) {
      result.error("MMKVException", "MMKV is null.", null);
      return;
    }

    try {
      switch (method) {
        case "setSameValueMapWithMap":
          result.success(setSameValueMap(map, valueType, mmkv));
        break;

        case "getSameValueMapWithListKey":
          if (keysParams != null && (keysParams instanceof List) && keysParams.size() > 0 ) {
            result.success(getMap(keysParams,valueType, mmkv));
          } else {
            result.error("keys is Null", call.method, null);
          }
          break;

        case "setBool":
          boolean setBoolStatus = mmkv.encode(key, (boolean) value);
          result.success(setBoolStatus);
          break;
        case "getBool":
          if (mmkv.contains(key)) {
            boolean getBoolStatus = mmkv.decodeBool(key);
            result.success(getBoolStatus);
          } else {
            result.success(null);
          }
          break;
        case "setInt":
          boolean setIntStatus;
          if (value instanceof Long) {
            setIntStatus = mmkv.encode(key, (long) value);
          } else {
            setIntStatus = mmkv.encode(key, (int) value);
          }
          result.success(setIntStatus);
          break;
        case "getInt":
          if (mmkv.contains(key)) {
            long getLongStatus = mmkv.decodeLong(key);
            result.success(getLongStatus);
          } else {
            result.success(null);
          }
          break;
        case "setDouble":
          boolean setDoubleStatus = mmkv.encode(key, (double) value);
          result.success(setDoubleStatus);
          break;
        case "getDouble":
          if (mmkv.contains(key)) {
            double getDoubleStatus = mmkv.decodeDouble(key);
            result.success(getDoubleStatus);
          } else {
            result.success(null);
          }
          break;
        case "setString":
          boolean setStringStatus = mmkv.encode(key, (String) value);
          result.success(setStringStatus);
          break;
        case "getString":
          String getStringStatus = mmkv.decodeString(key);
          result.success(getStringStatus);
          break;
        case "remove":
          mmkv.removeValueForKey(key);
          result.success(true);
          break;
        case "clear":
          mmkv.clearAll();
          result.success(true);
          break;
        case "count":
          result.success(mmkv.count());
          break;
        case "allKeys":
          String[] keys = mmkv.allKeys();
          if (keys == null) {
            result.success(null);
          } else {
            result.success(Arrays.asList(keys));
          }
          break;
        default:
          result.notImplemented();
          break;
      }

    } catch (Exception e) {
      result.error("Exception encountered", call.method, e);
    }
  }


  private Map<String, Object> getMap(List<String> keys, String valueType, MMKV mmkv) {

    Map<String, Object> map = new HashMap<>();

    for (String key : keys) {

      if (!mmkv.contains(key)) continue;

      Object value = null;

      if (ValueTypeString.equals(valueType)) {
        value =  mmkv.getString(key, null);
      } else if (ValueTypeBool.equals(valueType)) {
        value =  mmkv.getBoolean(key, false);
      } else if (ValueTypeInt.equals(valueType)) {
        value =  mmkv.getLong(key, 0);
      } else if (ValueTypeDouble.equals(valueType)) {
        value =  mmkv.getFloat(key, 0.0f);
      }
      map.put(key, value);
    }
    return map;
  }


  private boolean setSameValueMap(Map<String, Object> map, String valueType, MMKV mmkv) {
    //setSameValueMap(map: , valueType: , mmkv : )
    boolean isSuccess = true;
    Set<Map.Entry<String, Object>> set  = map.entrySet();
    Iterator<Map.Entry<String, Object>> iterator = set.iterator();

    while (iterator.hasNext()) {
      Map.Entry<String, Object> e = iterator.next();
      String key = e.getKey();
      Object value = e.getValue();

      boolean tmpSuccess = true;
      switch (valueType) {
        case ValueTypeString:
          tmpSuccess = mmkv.encode(key, (String) value);
          break;
        case ValueTypeBool:
          tmpSuccess = mmkv.encode(key, (boolean) value);
          break;
        case ValueTypeInt:
          if (value instanceof Long) {
            tmpSuccess = mmkv.encode(key, (long) value);
          } else {
            tmpSuccess = mmkv.encode(key, (int) value);
          }
          break;
        case ValueTypeDouble:
          tmpSuccess = mmkv.encode(key, (double) value);
          break;
      }
      if (!tmpSuccess) {
        isSuccess = false;
      }
    }
    return isSuccess;
  }


}
