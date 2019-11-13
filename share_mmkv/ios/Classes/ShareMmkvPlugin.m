#import "ShareMmkvPlugin.h"
#import "MMKV.h"

static NSString *const CHANNEL_NAME = @"com.silencezhou.sharemmkv";
#define ID @"id"
#define CRYPT @"crypt"
#define KEY @"key"
#define VALUE @"value"


static inline BOOL isEmpty(id thing) {
    return thing == nil
    || [thing isKindOfClass:[NSNull class]]
    || ([thing isKindOfClass:[NSData class]] && [(NSData *)thing length] == 0)
    || ([thing isKindOfClass:[NSArray class]] && [(NSArray *)thing count] == 0);
}

@implementation ShareMmkvPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME
                                                                binaryMessenger:[registrar messenger]];
    ShareMmkvPlugin* instance = [[ShareMmkvPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *method = [call method];
    NSDictionary *arguments = [call arguments];
    NSString *key = arguments[KEY];
    NSObject *value = arguments[VALUE];
    
    MMKV *mmkv = [MMKV defaultMMKV];
    if (isEmpty(mmkv)) {
        result([FlutterError errorWithCode:@"MMKVException"
                                   message:@"MMKV is null."
                                   details:nil]);
        return;
    }
    
    if ([method isEqualToString:@"setBool"]) {
        result([NSNumber numberWithBool:[mmkv setBool:((NSNumber*)value).boolValue forKey:key]]);
    } else if ([method isEqualToString:@"getBool"]) {
        if ([mmkv containsKey:key]) {
            result([NSNumber numberWithBool:[mmkv getBoolForKey:key]]);
        } else {
            result(nil);
        }
    } else if ([method isEqualToString:@"setInt"]) {
        result([NSNumber numberWithBool:[mmkv setInt64:((NSNumber*)value).longValue forKey:key]]);
        
    } else if ([method isEqualToString:@"getInt"]) {
        if ([mmkv containsKey:key]) {
            result([NSNumber numberWithLong:[mmkv getInt64ForKey:key]]);
        } else {
            result(nil);
        }
    } else if ([method isEqualToString:@"setDouble"]) {
        result([NSNumber numberWithBool:[mmkv setDouble:((NSNumber*)value).doubleValue forKey:key]]);
    } else if ([method isEqualToString:@"getDouble"]) {
        if ([mmkv containsKey:key]) {
            result([NSNumber numberWithDouble:[mmkv getDoubleForKey:key]]);
        } else {
            result(nil);
        }
    } else if ([method isEqualToString:@"setString"]) {
        
        result([NSNumber numberWithBool:[mmkv setString:(NSString*)value forKey:key]]);
        
    } else if ([method isEqualToString:@"getString"]) {
        
        result([mmkv getStringForKey:key]);
        
    } else if ([method isEqualToString:@"contains"]) {
        result([NSNumber numberWithBool:[mmkv containsKey:key]]);
    } else if ([method isEqualToString:@"remove"]) {
        [mmkv removeValueForKey:key];
        result(@YES);
    } else if ([method isEqualToString:@"clear"]) {
        [mmkv clearAll];
        result(@YES);
    } else if ([method isEqualToString:@"allKeys"]) {
        result([mmkv allKeys]);
    }  else if ([method isEqualToString:@"count"]) {
        result([NSNumber numberWithLong:[mmkv count]]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
