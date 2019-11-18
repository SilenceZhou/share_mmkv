import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_mmkv/share_mmkv.dart';

void main() {
  const MethodChannel channel = MethodChannel('share_mmkv');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
